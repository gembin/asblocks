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
		
		//var modifiers:Vector.<Token> = new Vector.<Token>();
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
//				modifiers.push(token);
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
		
		var modifiers:Vector.<Token> = new Vector.<Token>();
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
//				parseClassConstant(result, modifiers, meta);
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
				modifiers.push(token);
				nextTokenIgnoringAsDoc(result);
			}
		}
		
		return result;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/*
	
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
			token.column,
			parseConditionalExpression());
		result.addChild(parseConditionalExpression());
		while (tokIs(Operators.EQUAL)
			|| tokIs(Operators.PLUS_EQUAL) || tokIs(Operators.MINUS_EQUAL)
			|| tokIs(Operators.TIMES_EQUAL) || tokIs(Operators.DIVIDED_EQUAL)
			|| tokIs(Operators.MODULO_EQUAL) || tokIs(Operators.AND_EQUAL) 
			|| tokIs(Operators.OR_EQUAL)
			|| tokIs(Operators.XOR_EQUAL))
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
			nextToken();
			result.addChild(parseExpression());
		}
		return result.numChildren > 1 ? result : result.getChild(0);
	}
	*/
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
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