package org.teotigraphix.as3parser.impl
{

import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.api.IScanner;
import org.teotigraphix.as3parser.api.ISourceCodeScanner;
import org.teotigraphix.as3parser.api.KeyWords;
import org.teotigraphix.as3parser.api.Operators;
import org.teotigraphix.as3parser.core.LinkedListTreeAdaptor;
import org.teotigraphix.as3parser.core.Node;
import org.teotigraphix.as3parser.core.Token;
import org.teotigraphix.as3parser.core.TokenNode;

// remember, all nextToken() calls are now nextTokenConsumeWhitespace(result);

public class AS3Parser2 extends ParserBase
{
	//--------------------------------------------------------------------------
	//
	//  Private :: Constants
	//
	//--------------------------------------------------------------------------
	
	public static const MULTIPLE_LINES_COMMENT:String = "/*";
	
	public static const SINGLE_LINE_COMMENT:String = "//";
	
	public static const NEW_LINE:String = "\n";
	
	private static const VECTOR:String = "Vector";
	
	//--------------------------------------------------------------------------
	//
	//  Private :: Variables
	//
	//--------------------------------------------------------------------------
	
	private var currentAsDoc:TokenNode;
	
	private var braceCount:int;
	
	private var isInFor:Boolean = false;
	
	private var qualifiedNameEnd:int = -1;
	
	
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function AS3Parser2()
	{
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden Protected :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	override protected function createScanner():IScanner
	{
		var scanner:AS3Scanner = new AS3Scanner();
		scanner.allowWhiteSpace = true;
		return scanner;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden Public :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	override public function parseCompilationUnit():IParserNode
	{
		var result:TokenNode = adapter.create(AS3NodeKind.COMPILATION_UNIT);
		
		nextTokenIgnoringAsDoc(result);
		if (tokIs(KeyWords.PACKAGE))
		{
			result.addChild(parsePackage());
		}
		//		result.addChild(parsePackageContent());
		
		result.appendToken(adapter.createToken("__END__"));
		
		return result;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Internal :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * token is package
	 * 
	 * @throws UnExpectedTokenException
	 */
	internal function parsePackage():TokenNode
	{
		var end:int = -1;
		
		var result:TokenNode = adapter.create(
			AS3NodeKind.PACKAGE,
			KeyWords.PACKAGE, 
			token.line, 
			token.column);
		
		result.start = scanner.offset;
		
		consume(KeyWords.PACKAGE, result);
		
		// FIXME impl append
//		consumeComment();// added 
		
		var line:int = token.line;
		var column:int = token.column;
		
		var start:int = scanner.offset - token.text.length;
		
		qualifiedNameEnd = scanner.offset;
		var qualifiedName:String = "";
		
		if (!tokIs(Operators.LEFT_CURLY_BRACKET))
		{
			qualifiedName = parseQualifiedName();
		}
		
		var name:TokenNode = adapter.create(
			AS3NodeKind.NAME,
			qualifiedName, 
			line, 
			column);
		name.start = start;
		name.end = qualifiedNameEnd;
		
		result.addChild(name);
		
		consume(Operators.LEFT_CURLY_BRACKET, result);
		result.addChild(parsePackageContent());
		consume(Operators.RIGHT_CURLY_BRACKET, result);
		
		result.end = scanner.offset;
		
		return result;
	}
	
	private function parseQualifiedName():String
	{
		var buffer:String = "";
		
		buffer += token.text;
		nextToken();
		while (tokIs(Operators.DOT) || tokIs(Operators.DOUBLE_COLUMN))
		{
			buffer += token.text;
			nextToken();
			buffer += token.text;
			qualifiedNameEnd = scanner.offset;
			nextToken(); // name
		}
		return buffer;
	}
	
	internal function parsePackageContent():IParserNode
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.CONTENT,
			null, 
			token.line, 
			token.column);
		
		result.start = scanner.offset;
		
		var modifiers:TokenNode = adapter.create(
			AS3NodeKind.MOD_LIST,
			null, 
			token.line, 
			token.column);
		
		var meta:Vector.<TokenNode> = new Vector.<TokenNode>();
		
		while (!tokIs(Operators.RIGHT_CURLY_BRACKET)
			&& !tokIs(KeyWords.EOF))
		{
			if (tokIs(KeyWords.IMPORT))
			{
				result.addChild(parseImport());
			}
			else if (tokIs(KeyWords.INCLUDE))
			{
//				result.addChild(parseIncludeExpression());
			}
			else if (tokIs(KeyWords.USE))
			{
				result.addChild(parseUse());
			}
			else if (tokIs(Operators.LEFT_SQUARE_BRACKET))
			{
				meta.push(parseMetaData());
			}
			else if (tokIs(KeyWords.CLASS))
			{
				result.addChild(parseClass(meta, modifiers));
				
				meta.length = 0;
				//modifiers.length = 0;
			}
			else if (tokIs(KeyWords.INTERFACE))
			{
//				result.addChild(parseInterface(meta, modifiers));
				
//				meta.length = 0;
//				modifiers.length = 0;
			}
			else if (tokIs(KeyWords.FUNCTION))
			{
//				parseClassFunctions(result, modifiers, meta);
			}
			else if (tokenStartsWith("/**"))
			{
				currentAsDoc = createASDoc();
				nextTokenConsumeWhitespace(currentAsDoc);
			}
			//else if (tokenStartsWith("/*")) // junk comment
			//{
			//	nextTokenConsumeWhitespace(result);
			//}
			else
			{
				modifiers.addChild(adapter.create(
					AS3NodeKind.MODIFIER,
					token.text, 
					token.line, 
					token.column));
				nextTokenIgnoringAsDoc(modifiers);
			}
		}
		
		result.end = scanner.offset;
		
		return result;
	}
	
	private function parseImport():TokenNode
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.IMPORT,
			KeyWords.IMPORT, 
			token.line, 
			token.column);
		
		consume(KeyWords.IMPORT, result);
		
		var name:TokenNode = adapter.create(
			AS3NodeKind.NAME,
			parseImportName(), 
			token.line, 
			token.column);
		
		result.addChild(name);
		
		skip(Operators.SEMI_COLUMN, result);
		
		return result;
	}
	
	private function parseImportName():String
	{
		var result:String = "";
		
		result += token.text;
		nextToken();
		while (tokIs(Operators.DOT))
		{
			result += Operators.DOT;
			nextToken(); // .
			result += token.text;
			nextToken(); // part of name
		}
		return result.toString();
	}
	/*
	private function parseIncludeExpression():IParserNode
	{
		var result:Node = Node.create(AS3NodeKind.INCLUDE,
			token.line,
			token.column);
		consume(KeyWords.INCLUDE);
		result.addChild(parseExpression());
		return result;
	}
	*/
	
	private function parseUse():TokenNode
	{
		consume(KeyWords.USE);
		
		var result:TokenNode = adapter.create(
			AS3NodeKind.USE,
			KeyWords.USE, 
			token.line, 
			token.column);
		
		consume(KeyWords.NAMESPACE, result);
		
		var name:TokenNode = adapter.create(
			AS3NodeKind.NAME,
			parseNamespaceName(), 
			token.line, 
			token.column);
		// TODO put in arg above; test
		result.addChild(name);
		
		skip(Operators.SEMI_COLUMN, result);
		
		return result;
	}
	
	private function parseNamespaceName():String
	{
		var name:String = token.text;
		nextToken(); // simple name for now
		return name;
	}
	
	private function parseMetaData():Node
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.META,
			null, 
			token.line, 
			token.column);
		
		addAsDoc(result);
		
		consume(Operators.LEFT_SQUARE_BRACKET, result);
		
		result.addChild(adapter.create(
			AS3NodeKind.NAME,
			token.text, 
			token.line, 
			token.column));
		
		nextTokenConsumeWhitespace(result); // name
		
		if (tokIs(Operators.LEFT_PARENTHESIS))
		{
			result.addChild(parseMetaDataParameterList())
		}
		
		consume(Operators.RIGHT_SQUARE_BRACKET, result);
		
		return result;
	}
	
	private function parseMetaDataParameterList():Node
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.PARAMETER_LIST,
			null, 
			token.line, 
			token.column);
		
		consume(Operators.LEFT_PARENTHESIS, result);
		
		while (!tokIs(Operators.RIGHT_PARENTHESIS))
		{
			result.addChild(parseMetaDataParameter());
			if (tokIs(Operators.COMMA))
			{
				result.appendToken(
					adapter.createToken(",", ",",
						token.line, token.column));
				nextTokenConsumeWhitespace(result);
			}
			else
			{
				break;
			}
		}
		
		consume(Operators.RIGHT_PARENTHESIS, result);
		
		return result;
	}
	
	private function parseMetaDataParameter():Node
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.PARAMETER,
			null, 
			token.line, 
			token.column);
		
		result.addChild(adapter.create(
			AS3NodeKind.NAME,
			token.text, 
			token.line, 
			token.column));
		
		nextTokenConsumeWhitespace(result); // = or , or ]
		
		if (tokIs(Operators.EQUAL))
		{
			consume(Operators.EQUAL, result);
			
			result.addChild(adapter.create(
				AS3NodeKind.VALUE,
				token.text, 
				token.line, 
				token.column));
			
			nextTokenConsumeWhitespace(result); // , or ]
		}
		
		return result;
	}
	
	private function parseClass(metas:Vector.<TokenNode>, 
								modifiers:TokenNode):Node
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.CLASS,
			null, 
			token.line, 
			token.column);
		
		result.addChild(convertMeta(metas));
		
		addAsDoc(result);
		
		result.addChild(modifiers);
		
		consume(KeyWords.CLASS, result);
		// FIXME impl append
//		consumeComment();
		
		result.addChild(adapter.create(
			AS3NodeKind.NAME,
			token.text, 
			token.line, 
			token.column));
		
		nextTokenConsumeWhitespace(result); // name
		// FIXME impl append
//		consumeComment();
		
		while (!tokIs(Operators.LEFT_CURLY_BRACKET))
		{
			if (tokIs(KeyWords.EXTENDS))
			{
				consume(KeyWords.EXTENDS, result);
				
				result.addChild(adapter.create(
					AS3NodeKind.EXTENDS,
					parseQualifiedName(), 
					token.line, 
					token.column));
			}
			else if (tokIs(KeyWords.IMPLEMENTS))
			{
				result.addChild(parseImplementsList());
			}
			else if (tokenStartsWith("/*")) // junk comment
			{
				// TODO can I move this below to else?
				nextTokenConsumeWhitespace(result);
			}
			else
			{
				nextTokenConsumeWhitespace(result);
			}
		}
		
		consume(Operators.LEFT_CURLY_BRACKET, result);
		result.addChild(parseClassContent());
		consume(Operators.RIGHT_CURLY_BRACKET, result);
		
		return result;
	}
	
	private function parseImplementsList():Node
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.IMPLEMENTS_LIST,
			null, 
			token.line, 
			token.column);
		
		consume(KeyWords.IMPLEMENTS, result);
		
		result.addChild(adapter.create(
			AS3NodeKind.IMPLEMENTS,
			parseQualifiedName(), 
			token.line, 
			token.column));
		
		while (tokIs(Operators.COMMA))
		{
			nextTokenConsumeWhitespace(result);
			result.addChild(adapter.create(
				AS3NodeKind.IMPLEMENTS,
				parseQualifiedName(), 
				token.line, 
				token.column));
		}
		
		return result;
	}
	
	internal function parseClassContent():TokenNode
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.CONTENT,
			null, 
			token.line, 
			token.column);
		
		var modifiers:TokenNode = adapter.create(
			AS3NodeKind.MOD_LIST,
			null, 
			token.line, 
			token.column);
		
		var meta:Vector.<TokenNode> = new Vector.<TokenNode>();
		
		while (!tokIs(Operators.RIGHT_CURLY_BRACKET))
		{
			if (tokIs(Operators.LEFT_CURLY_BRACKET))
			{
//				result.addChild(parseBlock());
			}
			if (tokIs(Operators.LEFT_SQUARE_BRACKET))
			{
				meta.push(parseMetaData());
			}
			else if (tokIs(KeyWords.VAR))
			{
//				parseClassField(result, modifiers, meta);
			}
			else if (tokIs(KeyWords.CONST))
			{
				parseClassConstant(result, modifiers, meta);
			}
			else if (tokIs(KeyWords.IMPORT))
			{
				result.addChild(parseImport());
			}
			else if (tokIs(KeyWords.INCLUDE))
			{
//				result.addChild(parseIncludeExpression());
			}
			else if (tokIs(KeyWords.FUNCTION))
			{
//				parseClassFunctions(result, modifiers, meta);
			}
			else if (tokenStartsWith("/**"))
			{
				currentAsDoc = createASDoc();
				nextToken();
			}
			else if (tokenStartsWith("/*")) // junk comment
			{
				nextTokenConsumeWhitespace(result);
			}
			else
			{
				modifiers.addChild(adapter.create(
					AS3NodeKind.MODIFIER,
					token.text, 
					token.line, 
					token.column));
				nextTokenIgnoringAsDoc(modifiers);
			}
		}
		
		return result;
	}
	
	private function parseClassConstant(result:TokenNode, 
										modifiers:TokenNode, 
										meta:Vector.<TokenNode>):void
	{
		result.addChild(parseConstList(modifiers, meta));
		skip(Operators.SEMI_COLUMN, result);
		
		meta.length = 0;
	}
	
	private function parseConstList(modifiers:TokenNode, 
									meta:Vector.<TokenNode>):Node
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.CONST_LIST,
			null, 
			token.line, 
			token.column);
		
		result.addChild(convertMeta(meta));
		
		addAsDoc(result);
		
		result.addChild(modifiers);
		
		consume(KeyWords.CONST, result);
		
		collectVarListContent(result);
		
		return result;
	}
	
	private function collectVarListContent(result:TokenNode):TokenNode
	{
		result.addChild(parseNameTypeInit());
		while (tokIs(Operators.COMMA))
		{
			nextTokenConsumeWhitespace(result);
			result.addChild(parseNameTypeInit());
		}
		return result;
	}
	
	private function parseNameTypeInit():TokenNode
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.NAME_TYPE_INIT,
			null, 
			token.line, 
			token.column);
		
		result.addChild(adapter.create(
			AS3NodeKind.NAME,
			token.text,
			token.line,
			token.column));
		
		nextTokenConsumeWhitespace(result); // name
		
		result.addChild(parseOptionalType(result));
		nextTokenConsumeWhitespace(result);
		result.addChild(parseOptionalInit(result));
		
		return result;
	}
	
	private function parseOptionalType(node:TokenNode):TokenNode
	{
		var result:TokenNode;
		
		if (tokIs(Operators.COLUMN))
		{
			consume(":", node); // :
			result = parseType();
		}
		
		// FIXME should be nextTokenIgnoringAsdoc(), test
		if (tokenStartsWith("/*"))
		{
			nextTokenConsumeWhitespace(result); // garbage
		}
		
		return result;
	}
	
	private function parseType():TokenNode
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.TYPE,
			parseQualifiedName(), 
			token.line, 
			token.column);
		
		if (token.text == VECTOR)
		{
			result = parseVector();
		}
		
		return result;
	}
	
	private function parseVector():TokenNode
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.VECTOR,
			null, 
			token.line, 
			token.column);
		
		nextTokenConsumeWhitespace(result);
		consume(Operators.VECTOR_START, result);
		
		result.addChild(parseType());
		
		consume(Operators.SUPERIOR, result);
		
		return result;
	}
	
	private function parseOptionalInit(node:TokenNode):TokenNode
	{
		var result:TokenNode = null;
		if (tokenStartsWith("/*"))
		{
			nextTokenConsumeWhitespace(node); // garbage
		}
		if (tokIs(Operators.EQUAL))
		{
			consume(Operators.EQUAL, node);
			//result = adapter.create(
			//	AS3NodeKind.INIT,
			//	null, 
			//	token.line, 
			//	token.column);
			result = adapter.create(
				AS3NodeKind.INIT,
				null, 
				token.line, 
				token.column,
				parseExpression());
		}
		return result;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	

	internal function parseExpression():IParserNode
	{
		return parseAssignmentExpression();
	}
	
	
	private function parseAssignmentExpression():IParserNode
	{
		//var result:Node = Node.createChild(AS3NodeKind.ASSIGN,
		//	token.line,
		//	token.column,
		//	parseConditionalExpression());
		var result:TokenNode = adapter.create(
			AS3NodeKind.ASSIGN,
			Operators.EQUAL, 
			token.line, 
			token.column);
		result.addChild(parseConditionalExpression());
		while (tokIs(Operators.EQUAL)
			|| tokIs(Operators.PLUS_EQUAL) || tokIs(Operators.MINUS_EQUAL)
			|| tokIs(Operators.TIMES_EQUAL) || tokIs(Operators.DIVIDED_EQUAL)
			|| tokIs(Operators.MODULO_EQUAL) || tokIs(Operators.AND_EQUAL) 
			|| tokIs(Operators.OR_EQUAL) || tokIs(Operators.XOR_EQUAL))
		{
			//result.addChild(Node.create(AS3NodeKind.OP,
			//	token.line,
			//	token.column,
			//	token.text));
			result.addChild(adapter.create(
				AS3NodeKind.OP,
				token.text, 
				token.line, 
				token.column));
			nextTokenConsumeWhitespace(result);
			result.addChild(parseExpression());
		}
		return result.numChildren > 1 ? result : result.getChild(0);
	}
	
	private function parseConditionalExpression():TokenNode
	{
		var result:TokenNode = parseOrExpression() as TokenNode;
		if (tokIs(Operators.QUESTION_MARK))
		{
			//var conditional:Node = Node.createChild(AS3NodeKind.CONDITIONAL,
			//	token.line,
			//	token.column,
			//	result);
			var conditional:TokenNode = adapter.create(
				AS3NodeKind.CONDITIONAL,
				null, 
				token.line, 
				token.column,
				result);
			nextTokenConsumeWhitespace(conditional); // ?
			conditional.addChild(parseExpression());
			nextTokenConsumeWhitespace(conditional); // :
			conditional.addChild(parseExpression());
			
			return conditional;
		}
		return result;
	}
	
	
	private function parseOrExpression():IParserNode
	{
		//var result:Node = Node.createChild(AS3NodeKind.OR,
		//	token.line,
		//	token.column,
		//	parseAndExpression());
		var result:TokenNode = adapter.create(
			AS3NodeKind.OR,
			null, 
			token.line, 
			token.column,
			parseAndExpression());
		while (tokIs(Operators.LOGICAL_OR))
		{
			result.addChild(adapter.create(
				AS3NodeKind.OP,
				token.text,
				token.line, 
				token.column));
			nextTokenConsumeWhitespace(result);
			result.addChild(parseAndExpression());
		}
		return result.numChildren > 1 ? result : result.getChild(0);
	}
	
	private function parseAndExpression():IParserNode
	{
		//var result:Node = Node.createChild(AS3NodeKind.AND,
		//	token.line,
		//	token.column,
		//	parseBitwiseOrExpression());
		var result:TokenNode = adapter.create(
			AS3NodeKind.AND,
			null, 
			token.line, 
			token.column,
			parseBitwiseOrExpression());
		while (tokIs(Operators.AND))
		{
			//result.addChild(Node.create(AS3NodeKind.OP,
			//	token.line,
			//	token.column,
			//	token.text));
			result.addChild(adapter.create(
				AS3NodeKind.OP,
				token.text,
				token.line, 
				token.column));
			nextTokenConsumeWhitespace(result);
			result.addChild(parseBitwiseOrExpression());
		}
		return result.numChildren > 1 ? result : result.getChild(0);
	}
	
	private function parseBitwiseOrExpression():IParserNode
	{
		//var result:Node = Node.createChild(AS3NodeKind.B_OR,
		//	token.line,
		//	token.column,
		//	parseBitwiseXorExpression());
		var result:TokenNode = adapter.create(
			AS3NodeKind.B_OR,
			null, 
			token.line, 
			token.column,
			parseBitwiseXorExpression());
		while (tokIs(Operators.B_OR))
		{
			//result.addChild(Node.create(AS3NodeKind.OP,
			//	token.line,
			//	token.column,
			//	token.text));
			result.addChild(adapter.create(
				AS3NodeKind.OP,
				token.text,
				token.line, 
				token.column));
			nextTokenConsumeWhitespace(result);
			result.addChild(parseBitwiseXorExpression());
		}
		return result.numChildren > 1 ? result : result.getChild(0);
	}
	
	private function parseBitwiseXorExpression():IParserNode
	{
		//var result:Node = Node.createChild(AS3NodeKind.B_XOR,
		//	token.line,
		//	token.column,
		//	parseBitwiseAndExpression());
		var result:TokenNode = adapter.create(
			AS3NodeKind.B_XOR,
			null, 
			token.line, 
			token.column,
			parseBitwiseAndExpression());
		while (tokIs(Operators.B_XOR))
		{
			//result.addChild(Node.create(AS3NodeKind.OP,
			//	token.line,
			//	token.column,
			//	token.text));
			result.addChild(adapter.create(
				AS3NodeKind.OP,
				token.text,
				token.line, 
				token.column));
			nextTokenConsumeWhitespace(result);
			result.addChild(parseBitwiseAndExpression());
		}
		return result.numChildren > 1 ? result : result.getChild(0);
	}
	
	private function parseBitwiseAndExpression():IParserNode
	{
		//var result:Node = Node.createChild(AS3NodeKind.B_AND,
		//	token.line,
		//	token.column,
		//	parseEqualityExpression());
		var result:TokenNode = adapter.create(
			AS3NodeKind.B_AND,
			null, 
			token.line, 
			token.column,
			parseEqualityExpression());
		while (tokIs(Operators.B_AND))
		{
			//result.addChild(Node.create(AS3NodeKind.OP,
			//	token.line,
			//	token.column,
			//	token.text));
			result.addChild(adapter.create(
				AS3NodeKind.OP,
				token.text,
				token.line, 
				token.column));
			nextTokenConsumeWhitespace(result);
			result.addChild(parseEqualityExpression());
		}
		return result.numChildren > 1 ? result : result.getChild(0);
	}
	
	private function parseEqualityExpression():IParserNode
	{
		//var result:Node = Node.createChild(AS3NodeKind.EQUALITY,
		//	token.line,
		//	token.column,
		//	parseRelationalExpression());
		var result:TokenNode = adapter.create(
			AS3NodeKind.EQUALITY,
			null, 
			token.line, 
			token.column,
			parseRelationalExpression());
		while (tokIs(Operators.DOUBLE_EQUAL)
			|| tokIs(Operators.STRICTLY_EQUAL) || tokIs(Operators.NON_EQUAL)
			|| tokIs(Operators.NON_STRICTLY_EQUAL))
		{
			//result.addChild(Node.create(AS3NodeKind.OP,
			//	token.line,
			//	token.column,
			//	token.text));
			result.addChild(adapter.create(
				AS3NodeKind.OP,
				token.text,
				token.line, 
				token.column));
			nextTokenConsumeWhitespace(result);
			result.addChild(parseRelationalExpression());
		}
		return result.numChildren > 1 ? result : result.getChild(0);
	}
	
	private function parseRelationalExpression():IParserNode
	{
		//var result:Node = Node.createChild(AS3NodeKind.RELATION,
		//	token.line,
		//	token.column,
		//	parseShiftExpression());
		var result:TokenNode = adapter.create(
			AS3NodeKind.RELATION,
			null, 
			token.line, 
			token.column,
			parseShiftExpression());
		while (tokIs(Operators.INFERIOR )
			|| tokIs(Operators.INFERIOR_OR_EQUAL) || tokIs(Operators.SUPERIOR)
			|| tokIs(Operators.SUPERIOR_OR_EQUAL) || tokIs(KeyWords.IS) || tokIs(KeyWords.IN)
			&& !isInFor || tokIs( KeyWords.AS) || tokIs(KeyWords.INSTANCE_OF))
		{
			//result.addChild(Node.create(AS3NodeKind.OP,
			//	token.line,
			//	token.column,
			//	token.text));
			result.addChild(adapter.create(
				AS3NodeKind.OP,
				token.text,
				token.line, 
				token.column));
			nextTokenConsumeWhitespace(result);
			result.addChild(parseShiftExpression());
		}
		return result.numChildren > 1 ? result : result.getChild(0);
	}
	
	private function parseShiftExpression():IParserNode
	{
		//var result:Node = Node.createChild(AS3NodeKind.SHIFT,
		//	token.line,
		//	token.column,
		//	parseAdditiveExpression());
		var result:TokenNode = adapter.create(
			AS3NodeKind.SHIFT,
			null, 
			token.line, 
			token.column,
			parseAdditiveExpression());
		while (tokIs(Operators.DOUBLE_SHIFT_LEFT)
			|| tokIs(Operators.DOUBLE_SHIFT_RIGHT)
			|| tokIs(Operators.TRIPLE_SHIFT_LEFT)
			|| tokIs(Operators.TRIPLE_SHIFT_RIGHT))
		{
			//result.addChild(Node.create(AS3NodeKind.OP,
			//	token.line,
			//	token.column,
			//	token.text));
			result.addChild(adapter.create(
				AS3NodeKind.OP,
				token.text,
				token.line, 
				token.column));
			nextTokenConsumeWhitespace(result);
			result.addChild(parseAdditiveExpression());
		}
		return result.numChildren > 1 ? result : result.getChild(0);
	}
	
	private function parseAdditiveExpression():IParserNode
	{
		//var result:Node = Node.createChild(AS3NodeKind.ADD,
		//	token.line,
		//	token.column,
		//	parseMultiplicativeExpression());
		var result:TokenNode = adapter.create(
			AS3NodeKind.ADD,
			null, 
			token.line, 
			token.column,
			parseMultiplicativeExpression());
		while (tokIs(Operators.PLUS)
			|| tokIs(Operators.MINUS))
		{
			//result.addChild(Node.create(AS3NodeKind.OP,
			//	token.line,
			//	token.column,
			//	token.text));
			result.addChild(adapter.create(
				AS3NodeKind.OP,
				token.text,
				token.line, 
				token.column));
			nextTokenConsumeWhitespace(result);
			result.addChild(parseMultiplicativeExpression());
		}
		return result.numChildren > 1 ? result : result.getChild(0);
	}
	
	private function parseMultiplicativeExpression():IParserNode
	{
		//var result:Node = Node.createChild(AS3NodeKind.MULTIPLICATION,
		//	token.line,
		//	token.column,
		//	parseUnaryExpression());
		var result:TokenNode = adapter.create(
			AS3NodeKind.MULTIPLICATION,
			null, 
			token.line, 
			token.column);
		result.addChild(parseUnaryExpression(result));
		while (tokIs(Operators.TIMES)
			|| tokIs(Operators.SLASH) 
			|| tokIs(Operators.MODULO))
		{
			//result.addChild(Node.create(AS3NodeKind.OP,
			//	token.line,
			//	token.column,
			//	token.text));
			result.addChild(adapter.create(
				AS3NodeKind.OP,
				token.text,
				token.line, 
				token.column));
			nextTokenConsumeWhitespace(result);
			result.addChild(parseUnaryExpression(result));
		}
		return result.numChildren > 1 ? result : result.getChild(0);
	}
	
	// FIXME!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	
	internal function parseUnaryExpression(node:TokenNode):IParserNode
	{
		var result:TokenNode;
		if (tokIs(Operators.INCREMENT))
		{
			nextTokenConsumeWhitespace(node);
			result = adapter.create(
				AS3NodeKind.PRE_INC,
				Operators.INCREMENT, 
				token.line, 
				token.column,
				parseUnaryExpression(node));
		}
		else if (tokIs(Operators.DECREMENT))
		{
			nextTokenConsumeWhitespace(node);
			result = adapter.create(
				AS3NodeKind.PRE_DEC,
				Operators.DECREMENT, 
				token.line, 
				token.column,
				parseUnaryExpression(node));
		}
		else if (tokIs(Operators.MINUS))
		{
			nextTokenConsumeWhitespace(node);
			result = adapter.create(
				AS3NodeKind.MINUS,
				Operators.MINUS, 
				token.line, 
				token.column,
				parseUnaryExpression(node));
		}
		else if (tokIs(Operators.PLUS))
		{
			nextTokenConsumeWhitespace(node);
			result = adapter.create(
				AS3NodeKind.PLUS,
				Operators.PLUS, 
				token.line, 
				token.column,
				parseUnaryExpression(node));
		}
		else
		{
			result = parseUnaryExpressionNotPlusMinus(node);
		}
		return result;
	}
	
	
	private function parseUnaryExpressionNotPlusMinus(node:TokenNode):TokenNode
	{
		var result:TokenNode;
		if (tokIs(KeyWords.DELETE))
		{
			nextTokenConsumeWhitespace(node);
			result = adapter.create(
				AS3NodeKind.DELETE,
				KeyWords.DELETE, 
				token.line, 
				token.column,
				parseExpression());
		}
		else if (tokIs(KeyWords.VOID))
		{
			nextTokenConsumeWhitespace(node);
			result = adapter.create(
				AS3NodeKind.VOID,
				KeyWords.VOID, 
				token.line, 
				token.column,
				parseExpression());
		}
		else if (tokIs(KeyWords.TYPEOF))
		{
			nextTokenConsumeWhitespace(node);
			result = adapter.create(
				AS3NodeKind.TYPEOF,
				KeyWords.TYPEOF, 
				token.line, 
				token.column,
				parseExpression());
		}
		else if (tokIs("!"))
		{
			nextTokenConsumeWhitespace(node);
			result = adapter.create(
				AS3NodeKind.NOT,
				"!", 
				token.line, 
				token.column,
				parseExpression());
		}
		else if (tokIs("~" ))
		{
			nextTokenConsumeWhitespace(node);
			result = adapter.create(
				AS3NodeKind.B_NOT,
				"~", 
				token.line, 
				token.column,
				parseExpression());
		}
		else
		{
			result = parseUnaryPostfixExpression(node);
		}
		
		return result;
	}
	
	private function parseUnaryPostfixExpression(node:TokenNode):TokenNode
	{
		var result:TokenNode = parsePrimaryExpression();
		
		if (tokIs(Operators.LEFT_SQUARE_BRACKET))
		{
//			result = parseArrayAccessor(result);
		}
		else if (tokIs(Operators.LEFT_PARENTHESIS))
		{
//			result = parseFunctionCall(result);
		}
		if (tokIs(Operators.INCREMENT))
		{
//			result = parseIncrement(result);
		}
		else if (tokIs(Operators.DECREMENT))
		{
//			result = parseDecrement(result);
		}
		else if (tokIs(Operators.DOT)
			|| tokIs(Operators.DOUBLE_COLUMN)
			|| tokIs(Operators.DOUBLE_DOT))
		{
//			result = parseDot(result);
		}
		
		return result;
	}
	
	internal function parsePrimaryExpression():TokenNode
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.PRIMARY,
			token.text, 
			token.line, 
			token.column);
		
		if (tokIs(Operators.LEFT_SQUARE_BRACKET))
		{
//			result.addChild(parseArrayLiteral());
		}
		else if (tokIs(Operators.LEFT_CURLY_BRACKET))
		{
//			result.addChild(parseObjectLiteral());
		}
		else if (tokIs(KeyWords.FUNCTION))
		{
//			result.addChild(parseLambdaExpression());
		}
		else if (tokIs(KeyWords.NEW))
		{
//			result = parseNewExpression();
		}
		else if (tokIs(Operators.LEFT_PARENTHESIS))
		{
//			result.addChild(parseEncapsulatedExpression());
		}
			// else if ( token.isNum()
			// || tokIs( KeyWords.TRUE ) || tokIs( KeyWords.FALSE ) || tokIs(
			// KeyWords.NULL )
			// || token.text.startsWith( Operators.DOUBLE_QUOTE.toString() )
			// || token.text.startsWith( Operators.SIMPLE_QUOTE.toString() )
			// || token.text.startsWith( Operators.SLASH.toString() )
			// || token.text.startsWith( Operators.INFERIOR.toString() ) || tokIs(
			// KeyWords.UNDEFINED ) )
			// {
			// nextToken();
			// }
		else
		{
			nextTokenConsumeWhitespace(result);
		}
		return result;
	}
	
	/**
	 * token is [
	 */
	private function parseArrayLiteral():IParserNode
	{
		var result:Node = Node.create(AS3NodeKind.ARRAY,
			token.line,
			token.column);
		consume(Operators.LEFT_SQUARE_BRACKET);
		while (!tokIs(Operators.RIGHT_SQUARE_BRACKET))
		{
			result.addChild(parseExpression());
			skip(Operators.COMMA);
		}
		consume(Operators.RIGHT_SQUARE_BRACKET);
		return result;
	}
	
	/**
	 * token is {
	 */
	private function parseObjectLiteral():Node
	{
		var result:Node = Node.create(AS3NodeKind.OBJECT,
			token.line,
			token.column);
		consume(Operators.LEFT_CURLY_BRACKET);
		while (!tokIs(Operators.RIGHT_CURLY_BRACKET))
		{
			result.addChild(parseObjectLiteralPropertyDeclaration());
			skip(Operators.COMMA);
		}
		consume(Operators.RIGHT_CURLY_BRACKET);
		return result;
	}
	
	/*
	* token is name
	*/
	private function parseObjectLiteralPropertyDeclaration():Node
	{
		var result:Node = Node.create(AS3NodeKind.PROP,
			token.line,
			token.column);
		var name:Node = Node.create(AS3NodeKind.NAME,
			token.line,
			token.column,
			token.text);
		result.addChild(name);
		nextToken(); // name
		consume(Operators.COLUMN);
		result.addChild(Node.createChild(AS3NodeKind.VALUE,
			token.line,
			token.column,
			parseExpression()));
		return result;
	}
	
	/**
	 * token is function
	 * 
	 * @throws TokenException
	 */
	private function parseLambdaExpression():Node
	{
		consume(KeyWords.FUNCTION);
		var result:Node = Node.create(AS3NodeKind.LAMBDA,
			token.line,
			token.column);
		// FIXME
//		result.addChild(parseParameterList());
//		result.addChild(parseOptionalType());
//		result.addChild(parseBlock());
		return result;
	}
	
	private function parseNewExpression():Node
	{
		consume(KeyWords.NEW);
		
		var result:Node = Node.create(AS3NodeKind.NEW,
			token.line,
			token.column);
		result.addChild(parseExpression()); // name
		
		// TODO this should go into the AST, what should it be?
		// take care of vector int
		if (tokIs(".<"))
		{
			consume(".<");
			nextToken(); // Vector type declaration on new
			consume(">");
		}
		
		if (tokIs(Operators.LEFT_PARENTHESIS))
		{
// FIXME			result.addChild(parseArgumentList());
		}
		return result;
	}
	
	private function parseEncapsulatedExpression():Node
	{
		consume(Operators.LEFT_PARENTHESIS);
		var result:Node = Node.create(AS3NodeKind.ENCAPSULATED,
			token.line,
			token.column);
		// FIXME		result.addChild(parseExpressionList());
		
		consume(Operators.RIGHT_PARENTHESIS);
		
		return result;
	}
	
	private function parseArrayAccessor(node:Node):Node
	{
		var result:Node = Node.create(AS3NodeKind.ARRAY_ACCESSOR,
			token.line,
			token.column);
		result.addChild(node);
		while (tokIs(Operators.LEFT_SQUARE_BRACKET))
		{
			nextToken(); // [
			result.addChild(parseExpression());
			consume(Operators.RIGHT_SQUARE_BRACKET);
		}
		return result;
	}
	
	private function parseFunctionCall(node:Node):Node
	{
		var result:Node = Node.create(AS3NodeKind.CALL,
			token.line,
			token.column);
		result.addChild(node);
		while (tokIs(Operators.LEFT_PARENTHESIS))
		{
			// FIXME			result.addChild(parseArgumentList());
		}
		while (tokIs(Operators.LEFT_SQUARE_BRACKET))
		{
			result.addChild(parseArrayLiteral());
		}
		
		return result;
	}
	
	private function parseIncrement(node:Node):Node
	{
		nextToken();
		var result:Node = Node.create(AS3NodeKind.POST_INC,
			token.line,
			token.column);
		result.addChild(node);
		return result;
	}
	
	private function parseDecrement(node:Node):Node
	{
		nextToken();
		var result:Node = Node.create(AS3NodeKind.POST_DEC,
			token.line,
			token.column);
		result.addChild(node);
		return result;
	}
	
	private function parseDot(node:Node):Node
	{
		var result:Node;
		if (tokIs(Operators.DOUBLE_DOT))
		{
			nextToken();
			result = Node.create(AS3NodeKind.E4X_DESCENDENT,
				token.line,
				token.column);
			result.addChild(node);
			result.addChild(parseExpression());
			return result;
		}
		nextToken();
		if (tokIs(Operators.LEFT_PARENTHESIS))
		{
			nextToken();
			result = Node.create(AS3NodeKind.E4X_FILTER,
				token.line,
				token.column);
			result.addChild(node);
			result.addChild(parseExpression());
			consume(Operators.RIGHT_PARENTHESIS);
			return result;
		}
		else if (tokIs(Operators.TIMES))
		{
			result = Node.create(AS3NodeKind.E4X_STAR,
				token.line,
				token.column);
			result.addChild(node);
			return result;
		}
		else if (tokIs(Operators.AT))
		{
			result = Node.create(AS3NodeKind.DOT,
				token.line,
				token.column);
			result.addChild(node);
			result.addChild(parseE4XAttributeIdentifier());
			return result;
		}
		result = Node.create(AS3NodeKind.DOT,
			token.line,
			token.column);
		result.addChild(node);
		result.addChild(parseExpression());
		return result;
	}
	
	private function parseE4XAttributeIdentifier():Node
	{
		consume(Operators.AT);
		
		var result:Node = Node.create(AS3NodeKind.E4X_ATTR,
			token.line,
			token.column);
		if (tokIs(Operators.LEFT_SQUARE_BRACKET))
		{
			nextToken();
			result.addChild(parseExpression());
			consume(Operators.RIGHT_SQUARE_BRACKET);
		}
		else if (tokIs(Operators.TIMES))
		{
			nextToken();
			result.addChild(Node.create(AS3NodeKind.STAR,
				token.line,
				token.column));
		}
		else
		{
			result.addChild(Node.create(AS3NodeKind.NAME,
				token.line,
				token.column,
				parseQualifiedName()));
		}
		
		return result;
	}
	
	
	//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	override public function nextToken():void
	{
		super.nextToken();
		
		if (tokIs(" ") || tokIs("\t") || tokIs("{") || tokIs("}"))
		{
			
		}
	}
	
	private function nextTokenIgnoringAsDoc(node:TokenNode):void
	{
		do
		{
			nextToken();
			if (tokIs(" "))
			{
				appendSpace(node);
			}
			else if (tokIs("\t"))
			{
				appendTab(node);
			}
		}
		while (tokenStartsWith(MULTIPLE_LINES_COMMENT));
	}
	
	
	
	private function createASDoc():TokenNode
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.AS_DOC,
			token.text, 
			ISourceCodeScanner(scanner).commentLine,
			ISourceCodeScanner(scanner).commentColumn);
		ISourceCodeScanner(scanner).commentLine = -1;
		ISourceCodeScanner(scanner).commentColumn = -1;
		result.start = scanner.offset - token.text.length;
		result.end = scanner.offset;
		return result;
	}
	
	private function addAsDoc(node:TokenNode):void
	{
		if (currentAsDoc != null)
		{
			node.addChild(currentAsDoc);
			currentAsDoc = null;
		}
	}
	
	//private function consumeComment():void
	//{
	//	while (tokenStartsWith(MULTIPLE_LINES_COMMENT))
	//	{
	//		nextToken();
	//	}
	//}
	
	
	private function convertMeta(metas:Vector.<TokenNode>):TokenNode
	{
		if (metas == null || metas.length == 0)
		{
			return null;
		}
		
		var meta:Node = metas[0];
		
		var result:TokenNode = adapter.create(
			AS3NodeKind.META_LIST,
			null, 
			meta.line, 
			meta.column);
		
		var len:int = metas.length;
		for (var i:int = 0; i < metas.length; i++)
		{
			result.addChild(metas[i]);
		}
		
		return result;
	}	
	
	private function convertModifiers(modifiers:Vector.<Token>):Node
	{
		if (modifiers == null || modifiers.length == 0)
		{
			return null;
		}
		
		var mod:Token = modifiers[0];
		
		var result:TokenNode = adapter.create(
			AS3NodeKind.MOD_LIST,
			null, 
			mod.line, 
			mod.column);
		
		var len:int = modifiers.length;
		for (var i:int = 0; i < modifiers.length; i++)
		{
			mod = modifiers[i];
			
			result.addChild(adapter.create(
				AS3NodeKind.MODIFIER,
				mod.text, 
				mod.line, 
				mod.column));
		}
		
		return result;
	}
}
}