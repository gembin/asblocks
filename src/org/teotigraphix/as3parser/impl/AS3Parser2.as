package org.teotigraphix.as3parser.impl
{

import org.teotigraphix.as3blocks.utils.ASTUtil2;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.api.IScanner;
import org.teotigraphix.as3parser.api.ISourceCodeScanner;
import org.teotigraphix.as3parser.api.KeyWords;
import org.teotigraphix.as3parser.api.Operators;
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
	
	//----------------------------------
	//  parseBlocks
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _parseBlocks:Boolean = true;
	
	/**
	 * doc
	 */
	public function get parseBlocks():Boolean
	{
		return _parseBlocks;
	}
	
	/**
	 * @private
	 */	
	public function set parseBlocks(value:Boolean):void
	{
		_parseBlocks = value;
	}
	
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
		result.addChild(parsePackageContent());
		
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
			null, 
			token.line, 
			token.column);
		
		result.start = scanner.offset;
		
		consume(KeyWords.PACKAGE, result);
		
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
				result.addChild(parseIncludeExpression());
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
				result.addChild(parseInterface(meta, modifiers));
				
				meta.length = 0;
				//				modifiers.length = 0;
			}
			else if (tokIs(KeyWords.FUNCTION))
			{
				//parseClassFunctions(result, modifiers, meta);
			}
			else if (tokenStartsWith("/**"))
			{
				currentAsDoc = createASDoc();
				nextNonWSToken(currentAsDoc);
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
	
	private function parseIncludeExpression():TokenNode
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.INCLUDE,
			null, 
			token.line, 
			token.column);
		
		consume(KeyWords.INCLUDE, result);
		result.addChild(parseExpression());
		return result;
	}
	
	private function parseImport():TokenNode
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.IMPORT,
			null, 
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
		
		nextNonWSToken(result); // name
		
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
				nextNonWSToken(result);
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
		
		nextNonWSToken(result); // = or , or ]
		
		if (tokIs(Operators.EQUAL))
		{
			consume(Operators.EQUAL, result);
			
			result.addChild(adapter.create(
				AS3NodeKind.VALUE,
				token.text, 
				token.line, 
				token.column));
			
			nextNonWSToken(result); // , or ]
		}
		
		return result;
	}
	
	private function parseClass(metas:Vector.<TokenNode>, 
								modifiers:TokenNode):TokenNode
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
		
		nextNonWSToken(result); // name
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
				nextNonWSToken(result);
			}
			else
			{
				nextNonWSToken(result);
			}
		}
		
		consume(Operators.LEFT_CURLY_BRACKET, result);
		result.addChild(parseClassContent());
		consume(Operators.RIGHT_CURLY_BRACKET, result);
		
		return result;
	}
	
	private function parseInterface(metas:Vector.<TokenNode>, 
									modifiers:TokenNode):TokenNode
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.INTERFACE,
			null, 
			token.line, 
			token.column);
		
		result.addChild(convertMeta(metas));
		
		addAsDoc(result);
		
		result.addChild(modifiers);
		
		consume(KeyWords.INTERFACE, result);
		
		result.addChild(adapter.create(
			AS3NodeKind.NAME,
			token.text, 
			token.line, 
			token.column));
		
		nextNonWSToken(result); // name
		
		if (tokIs(KeyWords.EXTENDS))
		{
			consume(KeyWords.EXTENDS, result);
			result.addChild(adapter.create(
				AS3NodeKind.EXTENDS,
				parseQualifiedName(), 
				token.line, 
				token.column));
		}
		while (tokIs(Operators.COMMA))
		{
			consume(Operators.COMMA, result);
			result.addChild(adapter.create(
				AS3NodeKind.EXTENDS,
				parseQualifiedName(), 
				token.line, 
				token.column));
		}
		consume(Operators.LEFT_CURLY_BRACKET, result);
		result.addChild(parseInterfaceContent());
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
			nextNonWSToken(result);
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
				result.addChild(parseBlock());
			}
			if (tokIs(Operators.LEFT_SQUARE_BRACKET))
			{
				meta.push(parseMetaData());
			}
			else if (tokIs(KeyWords.VAR))
			{
				//parseClassField(result, modifiers, meta);
				
				modifiers = adapter.create(
					AS3NodeKind.MOD_LIST,
					null, 
					token.line, 
					token.column);
			}
			else if (tokIs(KeyWords.CONST))
			{
				parseClassConstant(result, modifiers, meta);
				
				modifiers = adapter.create(
					AS3NodeKind.MOD_LIST,
					null, 
					token.line, 
					token.column);
			}
			else if (tokIs(KeyWords.IMPORT))
			{
				result.addChild(parseImport());
			}
			else if (tokIs(KeyWords.INCLUDE))
			{
				result.addChild(parseIncludeExpression());
			}
			else if (tokIs(KeyWords.FUNCTION))
			{
				modifiers = adapter.create(
					AS3NodeKind.MOD_LIST,
					null, 
					token.line, 
					token.column);
				//parseClassFunctions(result, modifiers, meta);
			}
			else if (tokenStartsWith("/**"))
			{
				currentAsDoc = createASDoc();
				nextToken();
			}
			else if (tokenStartsWith("/*")) // junk comment
			{
				nextNonWSToken(result);
			}
			else
			{
				if (!tokIsWhitespace())
				{
					modifiers.addChild(adapter.create(
						AS3NodeKind.MODIFIER,
						token.text, 
						token.line, 
						token.column));
				}
				else
				{
					modifiers.appendToken(
						adapter.createToken(token.text, token.text));
				}
				
				nextTokenIgnoringAsDoc(modifiers);
			}
		}
		
		return result;
	}
	
	internal function parseInterfaceContent():IParserNode
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
			if (tokIs(Operators.LEFT_SQUARE_BRACKET))
			{
				meta.push(parseMetaData());
			}
			else if (tokIs(KeyWords.IMPORT))
			{
				result.addChild(parseImport());
			}
			else if (tokIs(KeyWords.FUNCTION))
			{
				//var func:Node = parseFunctionSignature();
				//func.addChild(convertMeta(meta));
				//result.addChild(func);
				//meta.length = 0;
			}
			else if (tokIs(KeyWords.INCLUDE))
			{
				result.addChild(parseIncludeExpression());
			}
			else if (tokenStartsWith("/**"))
			{
				currentAsDoc = createASDoc();
				nextToken();
			}
			else
			{
				if (!tokIsWhitespace())
				{
					modifiers.addChild(adapter.create(
						AS3NodeKind.MODIFIER,
						token.text, 
						token.line, 
						token.column));
				}
				else
				{
					modifiers.appendToken(
						adapter.createToken(token.text, token.text));
				}
				
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
									meta:Vector.<TokenNode>):TokenNode
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
			nextNonWSToken(result);
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
		
		nextNonWSToken(result); // name
		
		result.addChild(parseOptionalType(result));
		nextNonWSToken(result);
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
			nextNonWSToken(result); // garbage
		}
		
		return result;
	}
	
	internal function parseType():TokenNode
	{
		var line:int = token.line;
		var column:int = token.column;
		
		var result:TokenNode = adapter.create(
			AS3NodeKind.TYPE,
			parseQualifiedName(), 
			line, 
			column);
		
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
		
		nextNonWSToken(result);
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
			nextNonWSToken(node); // garbage
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
			null, 
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
			nextNonWSToken(result);
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
			nextNonWSToken(conditional); // ?
			conditional.addChild(parseExpression());
			nextNonWSToken(conditional); // :
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
			nextNonWSToken(result);
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
			nextNonWSToken(result);
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
			nextNonWSToken(result);
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
			nextNonWSToken(result);
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
			nextNonWSToken(result);
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
			nextNonWSToken(result);
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
			nextNonWSToken(result);
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
			nextNonWSToken(result);
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
			nextNonWSToken(result);
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
			nextNonWSToken(result);
			result.addChild(parseUnaryExpression(result));
		}
		return result.numChildren > 1 ? result : result.getChild(0);
	}
	
	// FIXME!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	
	internal function parseUnaryExpression(node:TokenNode):IParserNode
	{
		var result:TokenNode;
		var line:int = token.line;
		var column:int = token.column;
		
		if (tokIs(Operators.INCREMENT))
		{
			nextNonWSToken(node);
			result = adapter.create(
				AS3NodeKind.PRE_INC,
				Operators.INCREMENT, 
				token.line, 
				token.column,
				parseUnaryExpression(node));
		}
		else if (tokIs(Operators.DECREMENT))
		{
			nextNonWSToken(node);
			result = adapter.create(
				AS3NodeKind.PRE_DEC,
				Operators.DECREMENT, 
				line, 
				column,
				parseUnaryExpression(node));
		}
		else if (tokIs(Operators.MINUS))
		{
			nextNonWSToken(node);
			result = adapter.create(
				AS3NodeKind.MINUS,
				Operators.MINUS, 
				token.line, 
				token.column,
				parseUnaryExpression(node));
		}
		else if (tokIs(Operators.PLUS))
		{
			nextNonWSToken(node);
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
			nextNonWSToken(node);
			result = adapter.create(
				AS3NodeKind.DELETE,
				KeyWords.DELETE, 
				token.line, 
				token.column,
				parseExpression());
		}
		else if (tokIs(KeyWords.VOID))
		{
			nextNonWSToken(node);
			result = adapter.create(
				AS3NodeKind.VOID,
				KeyWords.VOID, 
				token.line, 
				token.column,
				parseExpression());
		}
		else if (tokIs(KeyWords.TYPEOF))
		{
			nextNonWSToken(node);
			result = adapter.create(
				AS3NodeKind.TYPEOF,
				KeyWords.TYPEOF, 
				token.line, 
				token.column,
				parseExpression());
		}
		else if (tokIs("!"))
		{
			nextNonWSToken(node);
			result = adapter.create(
				AS3NodeKind.NOT,
				"!", 
				token.line, 
				token.column,
				parseExpression());
		}
		else if (tokIs("~" ))
		{
			nextNonWSToken(node);
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
			result = parseArrayAccessor(result);
		}
		else if (tokIs(Operators.LEFT_PARENTHESIS))
		{
			result = parseFunctionCall(result);
		}
		if (tokIs(Operators.INCREMENT))
		{
			result = parseIncrement(result);
		}
		else if (tokIs(Operators.DECREMENT))
		{
			result = parseDecrement(result);
		}
		else if (tokIs(Operators.DOT)
			|| tokIs(Operators.DOUBLE_COLUMN)
			|| tokIs(Operators.DOUBLE_DOT))
		{
			result = parseDot(result);
		}
		
		return result;
	}
	
	internal function parsePrimaryExpression():TokenNode
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.PRIMARY,
			null, 
			token.line, 
			token.column);
		
		if (tokIs(Operators.LEFT_SQUARE_BRACKET))
		{
			result.addChild(parseArrayLiteral());
		}
		else if (tokIs(Operators.LEFT_CURLY_BRACKET))
		{
			result.addChild(parseObjectLiteral());
		}
		else if (tokIs(KeyWords.FUNCTION))
		{
			result.addChild(parseLambdaExpression());
		}
		else if (tokIs(KeyWords.THROW))
		{
			result.addChild(parseThrowExpression());
		}
		else if (tokIs(KeyWords.NEW))
		{
			result = parseNewExpression();
		}
		else if (tokIs(Operators.LEFT_PARENTHESIS))
		{
			result.addChild(parseEncapsulatedExpression());
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
			// string literal, integer literal, primary
			if (token.text.indexOf("\"") == 0 
				|| token.text.indexOf("'") == 0)
			{
				result.kind = AS3NodeKind.STRING;
			}
			else if (!isNaN(parseInt(token.text)) 
				|| !isNaN(parseFloat(token.text)))
			{
				result.kind = AS3NodeKind.NUMBER;
			}
			else if (token.text.indexOf("/") == 0)
			{
				result.kind = AS3NodeKind.REG_EXP;
			}
			else
			{
				if (tokIs(KeyWords.TRUE))
				{
					result.kind = AS3NodeKind.TRUE;
				}
				else if (tokIs(KeyWords.FALSE))
				{
					result.kind = AS3NodeKind.FALSE;
				}
				else if (tokIs(KeyWords.NULL))
				{
					result.kind = AS3NodeKind.NULL;
				}
				else if (tokIs(KeyWords.UNDEFINED))
				{
					result.kind = AS3NodeKind.UNDEFINED;
				}
				// else it's PRIMARAY
			}
			
			result.stringValue = token.text;
			result.token.text = token.text;
			
			nextNonWSToken(result);
		}
		
		return result;
	}
	
	/**
	 * token is [
	 */
	private function parseArrayLiteral():TokenNode
	{
		var result:TokenNode = ASTUtil2.newParentheticAST(
			AS3NodeKind.ARRAY,
			AS3NodeKind.LBRACKET, "[",
			AS3NodeKind.RBRACKET, "]") as TokenNode;
		result.line = token.line;
		result.column = token.column;
		
		consumeWS(Operators.LEFT_SQUARE_BRACKET, result);
		while (!tokIs(Operators.RIGHT_SQUARE_BRACKET))
		{
			result.addChild(parseExpression());
			skip(Operators.COMMA, result);
		}
		consumeWS(Operators.RIGHT_SQUARE_BRACKET, result);
		
		return result;
	}
	
	/**
	 * token is {
	 */
	private function parseObjectLiteral():TokenNode
	{
		var result:TokenNode = ASTUtil2.newParentheticAST(
			AS3NodeKind.OBJECT,
			AS3NodeKind.LCURLY, "{",
			AS3NodeKind.RCURLY, "}") as TokenNode;
		result.line = token.line;
		result.column = token.column;
		
		consumeWS(Operators.LEFT_CURLY_BRACKET, result);
		while (!tokIs(Operators.RIGHT_CURLY_BRACKET))
		{
			result.addChild(parseObjectLiteralPropertyDeclaration());
			skip(Operators.COMMA, result);
		}
		consumeWS(Operators.RIGHT_CURLY_BRACKET, result);
		return result;
	}
	
	/*
	* token is name
	*/
	private function parseObjectLiteralPropertyDeclaration():TokenNode
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.PROP,
			null, 
			token.line, 
			token.column);
		
		var name:TokenNode = adapter.create(
			AS3NodeKind.NAME,
			token.text, 
			token.line, 
			token.column);
		
		result.addChild(name);
		nextNonWSToken(result); // name
		consume(Operators.COLUMN, result);
		result.addChild(adapter.create(
			AS3NodeKind.VALUE,
			null, 
			token.line, 
			token.column,
			parseExpression()));
		return result;
	}
	
	private function parseLambdaExpression():TokenNode
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.LAMBDA,
			null, 
			token.line, 
			token.column);
		
		consume(KeyWords.FUNCTION, result);
		
		result.addChild(parseParameterList());
		consumeWhitespace(result);
		var nti:TokenNode = adapter.create(
			AS3NodeKind.NAME_TYPE_INIT,
			null, 
			token.line, 
			token.column);
		nti.addChild(parseOptionalType(nti));
		result.addChild(nti);
		consumeWhitespace(result);
		result.addChild(parseBlock());
		return result;
	}
	
	private function parseThrowExpression():TokenNode
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.THROW,
			null, 
			token.line, 
			token.column);
		
		consume(KeyWords.THROW, result);
		
		result.addChild(parseExpression());
		
		return result;
	}
	
	private function parseParameterList():TokenNode
	{
		var result:TokenNode = ASTUtil2.newParentheticAST(
			AS3NodeKind.PARAMETER_LIST,
			AS3NodeKind.LPAREN, "(",
			AS3NodeKind.RPAREN, ")") as TokenNode;
		result.line = token.line;
		result.column = token.column;
		
		consumeWS(Operators.LEFT_PARENTHESIS, result);
		while (!tokIs(Operators.RIGHT_PARENTHESIS))
		{
			result.addChild(parseParameter());
			if (tokIs(Operators.COMMA))
			{
				nextNonWSToken(result);
			}
			else
			{
				break;
			}
		}
		consumeWS(Operators.RIGHT_PARENTHESIS, result);
		
		return result;
	}
	
	private function parseParameter():TokenNode
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.PARAMETER,
			null, 
			token.line, 
			token.column);
		
		if (tokIs(Operators.REST_PARAMETERS))
		{
			nextNonWSToken(result); // ...
			var rest:TokenNode = adapter.create(
				AS3NodeKind.REST,
				token.text, 
				token.line, 
				token.column);
			nextNonWSToken(result); // rest
			result.addChild(rest);
		}
		else
		{
			result.addChild(parseNameTypeInit());
		}
		return result;
	}
	
	private function parseBlock():TokenNode
	{
		var result:TokenNode = ASTUtil2.newParentheticAST(
			AS3NodeKind.BLOCK,
			AS3NodeKind.LCURLY, "{",
			AS3NodeKind.RCURLY, "}") as TokenNode;
		result.line = token.line;
		result.column = token.column;
		
		if (tokenStartsWith(MULTIPLE_LINES_COMMENT))
		{
			nextTokenIgnoringAsDoc(result); // /* ... */
		}
		
		consume(Operators.LEFT_CURLY_BRACKET, result);
		
		ISourceCodeScanner(scanner).inBlock = true;
		
		if (parseBlocks)
		{
			while (!tokIs(Operators.RIGHT_CURLY_BRACKET))
			{
				result.addChild(parseStatement());
			}
		}
		else
		{
			braceCount = 1;
			
			while (braceCount != 0)
			{
				if (tokIs("{"))
				{
					braceCount++;
				}
				if (tokIs("}"))
				{
					braceCount--;
				}
				
				if (braceCount == 0)
				{
					break;
				}
				
				nextTokenIgnoringAsDoc(result);
			}
		}
		
		consume(Operators.RIGHT_CURLY_BRACKET, result);
		
		ISourceCodeScanner(scanner).inBlock = false;
		
		return result;
	}
	
	private function parseNewExpression():TokenNode
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.NEW,
			null, 
			token.line, 
			token.column);
		
		consume(KeyWords.NEW, result);
		
		result.addChild(parseExpression()); // name
		
		// TODO this should go into the AST, what should it be?
		// take care of vector int
		if (tokIs(".<"))
		{
			consume(".<", result);
			nextNonWSToken(result); // Vector type declaration on new
			consume(">", result);
		}
		
		if (tokIs(Operators.LEFT_PARENTHESIS))
		{
			result.addChild(parseArgumentList());
		}
		return result;
	}
	
	private function parseEncapsulatedExpression():TokenNode
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.ENCAPSULATED,
			null, 
			token.line, 
			token.column);
		
		consume(Operators.LEFT_PARENTHESIS, result);
		result.addChild(parseExpressionList());
		consume(Operators.RIGHT_PARENTHESIS, result);
		
		return result;
	}
	
	private function parseArrayAccessor(node:TokenNode):TokenNode
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.ARRAY_ACCESSOR,
			null, 
			token.line, 
			token.column);
		
		result.addChild(node);
		while (tokIs(Operators.LEFT_SQUARE_BRACKET))
		{
			consume(Operators.LEFT_SQUARE_BRACKET, result); // [
			result.addChild(parseExpression());
			consume(Operators.RIGHT_SQUARE_BRACKET, result);
		}
		return result;
	}
	
	private function parseFunctionCall(node:TokenNode):TokenNode
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.CALL,
			null, 
			token.line, 
			token.column);
		result.addChild(node);
		while (tokIs(Operators.LEFT_PARENTHESIS))
		{
			result.addChild(parseArgumentList());
		}
		while (tokIs(Operators.LEFT_SQUARE_BRACKET))
		{
			result.addChild(parseArrayLiteral());
		}
		return result;
	}
	
	private function parseArgumentList():TokenNode
	{
		var result:TokenNode = ASTUtil2.newParentheticAST(
			AS3NodeKind.ARGUMENTS,
			AS3NodeKind.LPAREN, "(",
			AS3NodeKind.RPAREN, ")") as TokenNode;
		result.line = token.line;
		result.column = token.column;
		
		consumeWS(Operators.LEFT_PARENTHESIS, result);
		while (!tokIs(Operators.RIGHT_PARENTHESIS))
		{
			result.addChild(parseExpression());
			skip(Operators.COMMA, result);
		}
		consumeWS(Operators.RIGHT_PARENTHESIS, result);
		
		return result;
	}
	
	internal function parseExpressionStatement():IParserNode
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.EXPR_STMNT,
			null, 
			token.line, 
			token.column);
		
		result.addChild(parseAssignmentExpression());
		
		while (tokIs(Operators.COMMA))
		{
			nextNonWSToken(result);
			result.addChild(parseAssignmentExpression());
		}
		
		skip(Operators.SEMI_COLUMN, result);
		
		return result;
	}
	
	internal function parseExpressionList():IParserNode
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.EXPR_LIST,
			null, 
			token.line, 
			token.column);
		
		result.addChild(parseAssignmentExpression());
		
		while (tokIs(Operators.COMMA))
		{
			nextNonWSToken(result);
			result.addChild(parseAssignmentExpression());
		}
		return result.numChildren > 1 ? result : result.getChild(0);
	}
	
	private function parseIncrement(node:TokenNode):TokenNode
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.POST_INC,
			null, 
			token.line, 
			token.column);
		result.addChild(node);
		consume(Operators.INCREMENT, result);
		return result;
	}
	
	private function parseDecrement(node:TokenNode):TokenNode
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.POST_DEC,
			null, 
			token.line, 
			token.column);
		result.addChild(node);
		consume(Operators.DECREMENT, result);
		return result;
	}
	
	private function parseDot(node:TokenNode):TokenNode
	{
		var result:TokenNode;
		if (tokIs(Operators.DOUBLE_DOT))
		{
			result = adapter.create(
				AS3NodeKind.E4X_DESCENDENT,
				null, 
				token.line, 
				token.column);
			result.addChild(node);
			consume(Operators.DOUBLE_DOT, result);
			result.addChild(parseExpression());
			return result;
		}
		
		if (tokIs(Operators.LEFT_PARENTHESIS))
		{
			result = ASTUtil2.newParentheticAST(
				AS3NodeKind.E4X_FILTER,
				AS3NodeKind.LPAREN, "(",
				AS3NodeKind.RPAREN, ")") as TokenNode;
			result.line = token.line;
			result.column = token.column;
			consumeWS(Operators.LEFT_PARENTHESIS, result);
			result.addChild(node);
			result.addChild(parseExpression());
			consumeWS(Operators.RIGHT_PARENTHESIS, result);
			return result;
		}
		else if (tokIs(Operators.TIMES))
		{
			result = adapter.create(
				AS3NodeKind.E4X_STAR,
				null, 
				token.line, 
				token.column);
			result.addChild(node);
			return result;
		}
		else if (tokIs(Operators.AT))
		{
			result = adapter.create(
				AS3NodeKind.DOT,
				null, 
				token.line, 
				token.column);
			result.addChild(node);
			result.addChild(parseE4XAttributeIdentifier());
			return result;
		}
		result = adapter.create(
			AS3NodeKind.DOT,
			null, 
			token.line, 
			token.column);
		result.addChild(node);
		if (tokIs(Operators.DOT))
		{
			consume(Operators.DOT, result);
		}
		else if (tokIs(Operators.DOUBLE_COLUMN))
		{
			consume(Operators.DOUBLE_COLUMN, result);
		}
		result.addChild(parseExpression());
		return result;
	}
	
	private function parseE4XAttributeIdentifier():TokenNode
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.E4X_ATTR,
			null, 
			token.line, 
			token.column);
		
		consume(Operators.AT, result);
		
		if (tokIs(Operators.LEFT_SQUARE_BRACKET))
		{
			// TODO newParenAST()
			nextNonWSToken(result);
			result.addChild(parseExpression());
			consume(Operators.RIGHT_SQUARE_BRACKET, result);
		}
		else if (tokIs(Operators.TIMES))
		{
			nextNonWSToken(result);
			result.addChild(adapter.create(
				AS3NodeKind.STAR,
				null, 
				token.line, 
				token.column));
		}
		else
		{
			result.addChild(adapter.create(
				AS3NodeKind.NAME,
				parseQualifiedName(), 
				token.line, 
				token.column));
		}
		
		return result;
	}
	
	
	//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	
	
	
	
	
	
	
	//  ADDED statement impl
	
	internal function parseStatement():IParserNode
	{
		var result:TokenNode;
		
		if (tokIs(KeyWords.FOR))
		{
			result = parseFor();
		}
		else if (tokIs(KeyWords.IF))
		{
			result = parseIf();
		}
		else if (tokIs(KeyWords.SWITCH))
		{
			result = parseSwitch();
		}
		else if (tokIs(KeyWords.DO))
		{
			result = parseDo();
		}
		else if (tokIs(KeyWords.WHILE))
		{
			result = parseWhile();
		}
		else if (tokIs(KeyWords.TRY))
		{
			result = parseTry();
		}
		else if (tokIs(KeyWords.CATCH))
		{
			result = parseCatch();
		}
		else if (tokIs(KeyWords.FINALLY))
		{
			result = parseFinally();
		}
		else if (tokIs(Operators.LEFT_CURLY_BRACKET))
		{
			result = parseBlock();
		}
		else if (tokIs(KeyWords.VAR))
		{
			result = parseVar();
		}
		else if (tokIs(KeyWords.CONST))
		{
			result = parseConst();
		}
		else if (tokIs(KeyWords.RETURN))
		{
			result = parseReturnStatement();
		}
		else if (tokIs(Operators.SEMI_COLUMN))
		{
			result = parseEmptyStatement();
		}
		else
		{
			result = parseExpressionList() as TokenNode;
			skip(Operators.SEMI_COLUMN, result);
		}
		return result;
	}
	
	private function parseFor():TokenNode
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.FOR,
			null, 
			token.line, 
			token.column);
		
		consume(KeyWords.FOR, result);
		
		if (tokIs(KeyWords.EACH))
		{
			consume(KeyWords.EACH, result);
			return parseForEach(result);
		}
		else
		{
			return parseTraditionalFor(result);
		}
	}
	
	private function parseForEach(node:TokenNode):TokenNode
	{
		consume(Operators.LEFT_PARENTHESIS, node);
		
		if (tokIs(KeyWords.VAR))
		{
			var variable:TokenNode = adapter.create(
				AS3NodeKind.VAR,
				null, 
				token.line, 
				token.column);
			
			consume(KeyWords.VAR, node);
			variable.addChild(parseNameTypeInit());
			node.addChild(variable);
		}
		else
		{
			var name:TokenNode = adapter.create(
				AS3NodeKind.NAME,
				token.text, 
				token.line, 
				token.column);
			
			node.addChild(name);
			
			nextNonWSToken(node);
		}
		//result.addNodeChild(AS3NodeKind.IN,
		//	token.line,
		//	token.column,
		//	parseExpression());
		var ini:TokenNode = adapter.create(
			AS3NodeKind.IN,
			null, 
			token.line, 
			token.column);
		consume(KeyWords.IN, node);
		ini.addChild(parseExpression());
		node.addChild(ini);
		
		consume(Operators.RIGHT_PARENTHESIS, node);
		node.addChild(parseStatement());
		node.kind = AS3NodeKind.FOREACH;
		return node;
	}
	
	private function parseTraditionalFor(node:TokenNode):TokenNode
	{
		consume(Operators.LEFT_PARENTHESIS, node);
		
		var init:TokenNode;
		
		if (!tokIs(Operators.SEMI_COLUMN))
		{
			if (tokIs(KeyWords.VAR))
			{
				//result.addNodeChild(AS3NodeKind.INIT,
				//	token.line,
				//	token.column,
				//	parseVarList(null, null));
				init = adapter.create(
					AS3NodeKind.INIT,
					null, 
					token.line, 
					token.column);
				init.addChild(parseVarList(null, null));
				node.addChild(init);
			}
			else
			{
				isInFor = true;
				//result.addNodeChild(AS3NodeKind.INIT,
				//	token.line,
				//	token.column,
				//	parseExpression());
				init = adapter.create(
					AS3NodeKind.INIT,
					null, 
					token.line, 
					token.column);
				init.addChild(parseExpression());
				node.addChild(init);
				isInFor = false;
			}
			if (tokIs(AS3NodeKind.IN))
			{
				return parseForIn(node);
			}
		}
		consume(Operators.SEMI_COLUMN, node);
		if (!tokIs(Operators.SEMI_COLUMN))
		{
			//result.addNodeChild(AS3NodeKind.COND,
			//	token.line,
			//	token.column,
			//	parseExpression());
			var cond:TokenNode = adapter.create(
				AS3NodeKind.COND,
				null, 
				token.line, 
				token.column);
			cond.addChild(parseExpression());
			node.addChild(cond);
		}
		consume(Operators.SEMI_COLUMN, node);
		if (!tokIs(Operators.RIGHT_PARENTHESIS))
		{
			//result.addNodeChild(AS3NodeKind.ITER,
			//	token.line,
			//	token.column,
			//	parseExpressionList());
			var iter:TokenNode = adapter.create(
				AS3NodeKind.ITER,
				null, 
				token.line, 
				token.column);
			iter.addChild(parseExpressionList());
			node.addChild(iter);
		}
		consume(Operators.RIGHT_PARENTHESIS, node);
		node.addChild(parseStatement());
		node.kind = AS3NodeKind.FOR;
		return node;
	}
	
	private function parseForIn(node:TokenNode):TokenNode
	{
		
		//result.addNodeChild(AS3NodeKind.IN,
		//	token.line,
		//	token.column,
		//	parseExpression());
		var ini:TokenNode = adapter.create(
			AS3NodeKind.IN,
			null, 
			token.line, 
			token.column);
		consume(KeyWords.IN, node);
		ini.addChild(parseExpression());
		node.addChild(ini);
		node.kind = AS3NodeKind.FORIN;
		consume(Operators.RIGHT_PARENTHESIS, node);
		node.addChild(parseStatement());
		return node;
	}
	
	private function parseVarList(meta:Vector.<TokenNode>, 
								  modifiers:TokenNode):TokenNode
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.VAR_LIST,
			null, 
			token.line, 
			token.column);
		
		result.addChild(convertMeta(meta));
		
		result.addChild(modifiers);
		
		consume(KeyWords.VAR, result);
		
		collectVarListContent(result);
		
		return result;
	}
	
	private function parseIf():TokenNode
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.IF,
			null, 
			token.line, 
			token.column);
		
		consume(KeyWords.IF, result);
		result.addChild(parseCondition());
		//var result:Node = Node.createChild(AS3NodeKind.IF,
		//	token.line,
		//	token.column,
		//	parseCondition());
		
		result.addChild(parseStatement());
		if (tokIs(KeyWords.ELSE))
		{
			consume(KeyWords.ELSE, result);
			result.addChild(parseStatement());
		}
		return result;
	}
	
	internal function parseCondition():IParserNode
	{
		//var result:Node = Node.createChild(AS3NodeKind.CONDITION,
		//	token.line,
		//	token.column,
		//	parseExpression());
		var result:TokenNode = adapter.create(
			AS3NodeKind.CONDITION,
			null, 
			token.line, 
			token.column);
		consume(Operators.LEFT_PARENTHESIS, result);
		result.addChild(parseExpression());
		consume(Operators.RIGHT_PARENTHESIS, result);
		return result;
	}
	
	private function parseEmptyStatement():TokenNode
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.STMT_EMPTY,
			Operators.SEMI_COLUMN, 
			token.line, 
			token.column);
		
		consume(Operators.SEMI_COLUMN, result);
		return result;
	}
	
	private function parseReturnStatement():TokenNode
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.RETURN,
			null, 
			token.line, 
			token.column);
		
		consume(AS3NodeKind.RETURN, result);
		if (tokIs(NEW_LINE) || tokIs(Operators.SEMI_COLUMN))
		{
			result.stringValue = "";
			result.token.text = "";
		}
		else
		{
			result.addChild(parseExpression());
		}
		skip(Operators.SEMI_COLUMN, result);
		return result;
	}
	
	private function parseSwitch():TokenNode
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.SWITCH,
			null, 
			token.line, 
			token.column);
		
		consume(KeyWords.SWITCH, result);
		
		result.addChild(parseCondition());
		result.addChild(parseSwitchCases());
		
		//if (tokIs(Operators.LEFT_CURLY_BRACKET))
		//{
		//	consume(Operators.LEFT_CURLY_BRACKET, result);
		//	result.addChild(parseSwitchCases());
		//	consume(Operators.RIGHT_CURLY_BRACKET, result);
		//}
		return result;
	}
	
	private function parseSwitchCases():TokenNode
	{
		if (!tokIs(Operators.LEFT_CURLY_BRACKET))
		{
			return  null;
		}
		
		var caseNode:TokenNode;
		
		var result:TokenNode = adapter.create(
			AS3NodeKind.CASES,
			null, 
			token.line, 
			token.column);
		
		consume(Operators.LEFT_CURLY_BRACKET, result);
		
		for (;;)
		{
			if (tokIs(KeyWords.CASE))
			{
				caseNode = adapter.create(
					AS3NodeKind.CASE,
					null, 
					token.line, 
					token.column);
				
				consume(KeyWords.CASE, result);
				caseNode.addChild(parseExpression());
				
				consume(Operators.COLUMN, caseNode);
				
				caseNode.addChild(parseSwitchBlock());
				
				result.addChild(caseNode);
			}
			else if (tokIs(KeyWords.DEFAULT))
			{
				caseNode = adapter.create(
					AS3NodeKind.CASE,
					null, 
					token.line, 
					token.column);
				
				caseNode.addChild(
					adapter.create(
						AS3NodeKind.DEFAULT,
						null, 
						token.line, 
						token.column));
				
				consume(KeyWords.DEFAULT, result);
				consume(Operators.COLUMN, result);
				
				caseNode.addChild(parseSwitchBlock());
				
				result.addChild(caseNode);
			}
			else if (tokIs(Operators.RIGHT_CURLY_BRACKET))
			{
				break;
			}
		}
		
		consume(Operators.RIGHT_CURLY_BRACKET, result);
		
		return result;
	}
	
	private function parseSwitchBlock():TokenNode
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.SWITCH_BLOCK,
			null, 
			token.line, 
			token.column);
		
		while (!tokIs(KeyWords.CASE)
			&& !tokIs(KeyWords.DEFAULT) 
			&& !tokIs(Operators.RIGHT_CURLY_BRACKET))
		{
			result.addChild(parseStatement());
		}
		return result;
	}
	
	private function parseDo():TokenNode
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.DO,
			null, 
			token.line, 
			token.column);
		
		consume(KeyWords.DO, result);
		result.addChild(parseStatement());
		
		consume(KeyWords.WHILE, result);
		result.addChild(parseCondition());
		skip(Operators.SEMI_COLUMN, result);
		
		return result;
	}
	
	private function parseWhile():TokenNode
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.WHILE,
			null, 
			token.line, 
			token.column);
		
		consume(KeyWords.WHILE, result);
		result.addChild(parseCondition());
		result.addChild(parseStatement());
		return result;
	}
	
	private function parseTry():TokenNode
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.TRY,
			null, 
			token.line, 
			token.column);
		
		consume(KeyWords.TRY, result);
		result.addChild(parseBlock());
		return result;
	}
	
	private function parseCatch():TokenNode
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.CATCH,
			null, 
			token.line, 
			token.column);
		
		consume(KeyWords.CATCH, result);
		consume(Operators.LEFT_PARENTHESIS, result);
		
		result.addChild(adapter.create(
			AS3NodeKind.NAME,
			token.text, 
			token.line, 
			token.column))
		
		nextNonWSToken(result); // name
		
		if (tokIs(Operators.COLUMN))
		{
			consume(Operators.COLUMN, result);
			result.addChild(adapter.create(
				AS3NodeKind.TYPE,
				token.text, 
				token.line, 
				token.column));
			nextNonWSToken(result); // name
		}
		consume(Operators.RIGHT_PARENTHESIS, result);
		result.addChild(parseBlock());
		return result;
	}
	
	private function parseFinally():TokenNode
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.FINALLY,
			null, 
			token.line, 
			token.column);
		
		consume(KeyWords.FINALLY, result);
		result.addChild(parseBlock());
		
		return result;
	}
	
	private function parseVar():TokenNode
	{
		var result:TokenNode = parseVarList(null, null);
		skip(Operators.SEMI_COLUMN, result);
		return result;
	}
	
	private function parseConst():TokenNode
	{
		var result:TokenNode = parseConstList(null, null);
		skip(Operators.SEMI_COLUMN, result);
		return result;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
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