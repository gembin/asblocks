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

/**
 * 
 */
[Alternative(replacement="",since="")]

/**
 * 
 */
public class AS3Parser2 extends ParserBase
{
	//--------------------------------------------------------------------------
	//
	//  Private :: Constants
	//
	//--------------------------------------------------------------------------
	
	public static const ASDOC_COMMENT:String = "/**";
	
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
		var result:TokenNode = adapter.create(
			AS3NodeKind.COMPILATION_UNIT);
		
		// start the parse, eat whitespace up to a '/**' or 'package'
		nextNonWhiteSpaceToken(result);
		
		// if the package has a doc comment, save it
		if (tokenStartsWith(ASDOC_COMMENT))
		{
			result.addChild(createASDoc());
			nextNonWhiteSpaceToken(result);
		}
		
		// go into package
		if (tokIs(KeyWords.PACKAGE))
		{
			result.addChild(parsePackage());
		}
		
		nextNonWhiteSpaceToken(result);
		
		if (!tokIs(KeyWords.EOF))
		{
			// parse internal classes|functions
			result.addChild(parsePackageContent());
		}
		
		result.appendToken(adapter.createToken("__END__"));
		
		return result;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Internal :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	internal function parsePackage():TokenNode
	{
		var result:TokenNode = adapter.copy(
			AS3NodeKind.PACKAGE, token);
		
		consumeWS(KeyWords.PACKAGE, result);
		
		if (!tokIs(Operators.LEFT_CURLY_BRACKET))
		{
			result.addChild(parseTypeSpec(AS3NodeKind.NAME));
		}
		
		result.addChild(parsePackageContent());
		
		return result;
	}
	
	/**
	 * @private
	 */
	internal function parsePackageContent():IParserNode
	{
		var result:TokenNode = ASTUtil2.newParentheticAST(
			AS3NodeKind.CONTENT,
			AS3NodeKind.LCURLY, "{",
			AS3NodeKind.RCURLY, "}") as TokenNode;
		result.line = token.line;
		result.column = token.column;
		
		consumeWS(Operators.LEFT_CURLY_BRACKET, result);
		
		var pendingType:TokenNode = adapter.empty(AS3NodeKind.PRIMARY, token);
		
		while (!tokIs(Operators.RIGHT_CURLY_BRACKET)
			&& !tokIs(KeyWords.EOF))
		{
			if (tokIs(KeyWords.INCLUDE))
			{
				result.addChild(parseInclude());
			}
			else if (tokIs(KeyWords.IMPORT))
			{
				result.addChild(parseImport());
			}
			else if (tokIs(KeyWords.USE))
			{
				result.addChild(parseUse());
			}
			else if (tokIs(Operators.LEFT_SQUARE_BRACKET))
			{
				result.addChild(parseMetaData());
			}
			else if (tokenStartsWith(ASDOC_COMMENT))
			{
				currentAsDoc = parseASdoc();
				result.appendToken(adapter.createToken(
					AS3NodeKind.AS_DOC, currentAsDoc.token.text));
			}
			else if (tokIs(KeyWords.CLASS))
			{
				result.addChild(parseClass(pendingType));
			}
			else if (tokIs(KeyWords.INTERFACE))
			{
				result.addChild(parseInterface(pendingType));
			}
			else
			{
				if (!tokIsWhitespace())
				{
					result.addChild(adapter.copy(
						AS3NodeKind.MODIFIER, token));
				}
				
				nextNonWhiteSpaceToken(result);
			}
		}
	
		consumeWS(Operators.RIGHT_CURLY_BRACKET, result, false);
		
		return result;
	}
	
	/**
	 * @private
	 */
	private function parseClass(result:TokenNode):TokenNode
	{
		result.kind = AS3NodeKind.CLASS;
		result.stringValue = KeyWords.CLASS;
		result.line = token.line;
		result.column = token.column;
		
		addAsDoc(result);
		
		consumeWS(KeyWords.CLASS, result);
		
		result.addChild(adapter.copy(
			AS3NodeKind.NAME, token));
		
		nextNonWhiteSpaceToken(result);
		
		while (!tokIs(Operators.LEFT_CURLY_BRACKET))
		{
			if (tokIs(KeyWords.EXTENDS))
			{
				result.addChild(parseExtendsList());
			}
			else if (tokIs(KeyWords.IMPLEMENTS))
			{
				result.addChild(parseImplementsList());
			}
			else
			{
				nextNonWhiteSpaceToken(result);
			}
		}
		
		result.addChild(parseClassContent());
		
		return result;
	}
	
	/**
	 * @private
	 */
	private function parseInterface(result:TokenNode):TokenNode
	{
		result.kind = AS3NodeKind.INTERFACE;
		result.stringValue = KeyWords.INTERFACE;
		result.line = token.line;
		result.column = token.column;
		
		consumeWS(KeyWords.INTERFACE, result);
		
		result.addChild(adapter.copy(
			AS3NodeKind.NAME, token));
		
		nextNonWhiteSpaceToken(result);
		
		while (!tokIs(Operators.LEFT_CURLY_BRACKET))
		{
			if (tokIs(KeyWords.EXTENDS))
			{
				result.addChild(parseExtendsList());
			}
			else
			{
				nextNonWhiteSpaceToken(result);
			}
		}
		
		result.addChild(parseInterfaceContent());
		
		return result;
	}
	
	/**
	 * @private
	 */
	internal function parseClassContent():TokenNode
	{
		var result:TokenNode = ASTUtil2.newParentheticAST(
			AS3NodeKind.CONTENT,
			AS3NodeKind.LCURLY, "{",
			AS3NodeKind.RCURLY, "}") as TokenNode;
		result.line = token.line;
		result.column = token.column;
		
		consumeWS(Operators.LEFT_CURLY_BRACKET, result);
		
		while (!tokIs(Operators.RIGHT_CURLY_BRACKET))
		{
			if (tokenStartsWith(ASDOC_COMMENT))
			{
				currentAsDoc = parseASdoc();
				result.appendToken(adapter.createToken(
					AS3NodeKind.AS_DOC, currentAsDoc.token.text));
			}
			else
			{
				if (!tokIsWhitespace())
				{
					result.addChild(adapter.create(
						AS3NodeKind.MODIFIER,
						token.text, 
						token.line, 
						token.column));
				}
				
				nextNonWhiteSpaceToken(result);
			}
		}
		
		consumeWS(Operators.RIGHT_CURLY_BRACKET, result, false);
		
		return result;
	}
	
	/**
	 * @private
	 */
	internal function parseInterfaceContent():TokenNode
	{
		var result:TokenNode = ASTUtil2.newParentheticAST(
			AS3NodeKind.CONTENT,
			AS3NodeKind.LCURLY, "{",
			AS3NodeKind.RCURLY, "}") as TokenNode;
		result.line = token.line;
		result.column = token.column;
		
		consumeWS(Operators.LEFT_CURLY_BRACKET, result);
		
		while (!tokIs(Operators.RIGHT_CURLY_BRACKET))
		{
			if (tokenStartsWith(ASDOC_COMMENT))
			{
				currentAsDoc = parseASdoc();
				result.appendToken(adapter.createToken(
					AS3NodeKind.AS_DOC, currentAsDoc.token.text));
			}
			else
			{
				if (!tokIsWhitespace())
				{
					result.addChild(adapter.create(
						AS3NodeKind.MODIFIER,
						token.text, 
						token.line, 
						token.column));
				}
				
				nextNonWhiteSpaceToken(result);
			}
		}
		
		consumeWS(Operators.RIGHT_CURLY_BRACKET, result, false);
		
		return result;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

	
	
	
	
	
	
	private function parseTypeSpec(kind:String):TokenNode
	{
		var result:TokenNode = adapter.empty(
			kind, token);
		
		var buffer:String = "";
		consumeWhitespace(result);
		buffer += token.text;
		nextNonWhiteSpaceToken(result);
		while (tokIs(Operators.DOT) || tokIs(Operators.DOUBLE_COLUMN))
		{
			buffer += token.text;
			nextNonWhiteSpaceToken(result);
			buffer += token.text;
			nextNonWhiteSpaceToken(result);
		}
		
		result.stringValue = buffer;
		
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
	
	//private var pendingType:TokenNode;
	
	internal function __parsePackageContent():IParserNode
	{
		var result:TokenNode = adapter.empty(
			AS3NodeKind.CONTENT, token);
		
		result.addChild(adapter.empty(
			AS3NodeKind.META_LIST, token));
		result.addChild(adapter.empty(
			AS3NodeKind.AS_DOC, token));
		result.addChild(adapter.empty(
			AS3NodeKind.MOD_LIST, token));
		

		result.start = scanner.offset;
		
		while (!tokIs(Operators.RIGHT_CURLY_BRACKET)
			&& !tokIs(KeyWords.EOF))
		{
			if (tokIs(KeyWords.IMPORT))
			{
				result.addChild(parseImport());
			}
			else if (tokIs(KeyWords.INCLUDE))
			{
				result.addChild(parseInclude());
			}
			else if (tokIs(KeyWords.USE))
			{
				result.addChild(parseUse());
			}
			else if (tokIs(Operators.LEFT_SQUARE_BRACKET))
			{
				//var meta:IParserNode = 
				//	pendingType.getKind(AS3NodeKind.META_LIST);
				//meta.addChild(parseMetaData());
			}
			else if (tokIs(KeyWords.CLASS))
			{
				//pendingType.kind = AS3NodeKind.CLASS;
				//result.addChild(parseClass());
			}
			else if (tokIs(KeyWords.INTERFACE))
			{
				//result.addChild(parseInterface(meta, modifiers));
				
				//meta.length = 0;
				//				modifiers.length = 0;
			}
			else if (tokIs(KeyWords.FUNCTION))
			{
				//parseClassFunctions(result, modifiers, meta);
			}
			else if (tokenStartsWith("/**"))
			{
				currentAsDoc = createASDoc();
				nextNonWhiteSpaceToken(currentAsDoc);
			}
			else
			{
				//var modList:IParserNode = 
				//	pendingType.getKind(AS3NodeKind.MOD_LIST);
				
				//modList.addChild(adapter.create(
				//	AS3NodeKind.MODIFIER,
				//	token.text, 
				//	token.line, 
				//	token.column));
				
				nextNonWhiteSpaceToken(result);
			}
		}
		
		result.end = scanner.offset;
		
		return result;
	}
	
	/**
	 * @private
	 */
	private function parseInclude():TokenNode
	{
		var result:TokenNode = adapter.empty(
			AS3NodeKind.INCLUDE, token);
		
		consume(KeyWords.INCLUDE, result);
		result.addChild(parseExpression());
		
		return result;
	}
	
	/**
	 * @private
	 */
	private function parseImport():TokenNode
	{
		var result:TokenNode = adapter.empty(
			AS3NodeKind.IMPORT, token);
		
		consume(KeyWords.IMPORT, result);
		
		result.addChild(parseTypeSpec(AS3NodeKind.TYPE));
		
		skip(Operators.SEMI_COLUMN, result);
		
		return result;
	}
	
	/**
	 * @private
	 */
	private function parseUse():TokenNode
	{
		var result:TokenNode = adapter.empty(
			AS3NodeKind.USE, token);
		
		consume(KeyWords.USE, result);
		consume(KeyWords.NAMESPACE, result);
		
		result.addChild(parseTypeSpec(AS3NodeKind.NAME));
		
		skip(Operators.SEMI_COLUMN, result);
		
		return result;
	}
	
	private function parseMetaData():Node
	{
		var result:TokenNode = adapter.empty(
			AS3NodeKind.META, token);
		
		addAsDoc(result);
		
		consume(Operators.LEFT_SQUARE_BRACKET, result);
		
		result.addChild(adapter.copy(
			AS3NodeKind.NAME, token));
		
		nextNonWhiteSpaceToken(result); // name
		
		if (tokIs(Operators.LEFT_PARENTHESIS))
		{
			result.addChild(parseMetaDataParameterList())
		}
		
		consume(Operators.RIGHT_SQUARE_BRACKET, result);
		
		return result;
	}
	
	private function parseMetaDataParameterList():Node
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
			result.addChild(parseMetaDataParameter());
			if (tokIs(Operators.COMMA))
			{
				consume(Operators.COMMA, result);
				//nextNonWhiteSpaceToken(result);
			}
			else
			{
				break;
			}
		}
		
		consumeWS(Operators.RIGHT_PARENTHESIS, result);
		
		return result;
	}
	
	private function parseMetaDataParameter():Node
	{
		var result:TokenNode = adapter.empty(
			AS3NodeKind.PARAMETER, token);
		
		var nameOrValue:TokenNode = adapter.copy(AS3NodeKind.NAME, token);
		result.addChild(nameOrValue);
		
		nextNonWhiteSpaceToken(result); // = or , or ]
		
		if (tokIs(Operators.EQUAL))
		{
			consume(Operators.EQUAL, result);
			result.addChild(parseExpression());
		}
		else
		{
			nameOrValue.kind = AS3NodeKind.VALUE;
		}
		
		return result;
	}
	
	
	private function _parseInterface(metas:Vector.<TokenNode>, 
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
		
		nextNonWhiteSpaceToken(result); // name
		
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
	
	private function parseImplementsList():TokenNode
	{
		var result:TokenNode = adapter.empty(
			AS3NodeKind.IMPLEMENTS, token);
		
		consume(KeyWords.IMPLEMENTS, result);
		
		result.addChild(parseTypeSpec(AS3NodeKind.TYPE));
		
		while (tokIs(Operators.COMMA))
		{
			consume(Operators.COMMA, result);
			result.addChild(parseTypeSpec(AS3NodeKind.TYPE));
		}
		
		return result;
	}
	
	private function parseExtendsList():TokenNode
	{
		var result:TokenNode = adapter.empty(
			AS3NodeKind.EXTENDS, token);
		
		consume(KeyWords.EXTENDS, result);
		
		result.addChild(parseTypeSpec(AS3NodeKind.TYPE));
		
		while (tokIs(Operators.COMMA))
		{
			consume(Operators.COMMA, result);
			result.addChild(parseTypeSpec(AS3NodeKind.TYPE));
		}
		
		return result;
	}
	
	internal function _parseClassContent():TokenNode
	{
		var result:TokenNode = ASTUtil2.newParentheticAST(
			AS3NodeKind.CONTENT,
			AS3NodeKind.LCURLY, "{",
			AS3NodeKind.RCURLY, "}") as TokenNode;
		result.line = token.line;
		result.column = token.column;
		
		var modifiers:TokenNode = adapter.create(
			AS3NodeKind.MOD_LIST,
			null, 
			token.line, 
			token.column);
		
		consumeWS(Operators.LEFT_CURLY_BRACKET, result);
		
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
				result.addChild(parseInclude());
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
				nextNonWhiteSpaceToken(result);
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
		
		consumeWS(Operators.RIGHT_CURLY_BRACKET, result, false);
		
		return result;
	}
	
	internal function _parseInterfaceContent():IParserNode
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
				result.addChild(parseInclude());
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
	
	/**
	 * @private
	 */
	private function parseConstList(modifiers:TokenNode, 
									meta:Vector.<TokenNode>):TokenNode
	{
		var result:TokenNode = adapter.copy(
			AS3NodeKind.CONST_LIST, token);
		
		result.addChild(convertMeta(meta));
		addAsDoc(result);
		result.addChild(modifiers);
		
		consume(KeyWords.CONST, result);
		collectVarListContent(result);
		
		return result;
	}
	
	/**
	 * @private
	 */
	private function parseVarList(meta:Vector.<TokenNode>, 
								  modifiers:TokenNode):TokenNode
	{
		var result:TokenNode = adapter.copy(
			AS3NodeKind.VAR_LIST, token);
		
		result.addChild(convertMeta(meta));
		addAsDoc(result);
		result.addChild(modifiers);
		
		consume(KeyWords.VAR, result);
		collectVarListContent(result);
		
		return result;
	}
	
	/**
	 * @private
	 */
	private function collectVarListContent(result:TokenNode):TokenNode
	{
		result.addChild(parseNameTypeInit());
		while (tokIs(Operators.COMMA))
		{
			//nextNonWhiteSpaceToken(result);
			consume(Operators.COMMA, result);
			result.addChild(parseNameTypeInit());
		}
		return result;
	}
	
	/**
	 * @private
	 */
	private function parseNameTypeInit():TokenNode
	{
		var result:TokenNode = adapter.empty(
			AS3NodeKind.NAME_TYPE_INIT, token);
		
		result.addChild(adapter.copy(
			AS3NodeKind.NAME, token));
		
		nextNonWhiteSpaceToken(result);
		if (tokIs(Operators.COLUMN))
		{
			result.addChild(parseOptionalType(result));
			if (!tokIs(Operators.EQUAL))
			{
				if (tokIs(Operators.SEMI_COLUMN))
				{
					skip(Operators.SEMI_COLUMN, result);
				}
				else
				{
					nextNonWhiteSpaceToken(result);
				}
			}
			else
			{
				skip(Operators.SEMI_COLUMN, result);
			}
		}
		
		if (tokIs(Operators.EQUAL))
		{
			result.addChild(parseOptionalInit(result));
		}
		
		return result;
	}
	
	/**
	 * @private
	 */
	private function parseOptionalType(node:TokenNode):TokenNode
	{
		var result:TokenNode;
		
		if (tokIs(Operators.COLUMN))
		{		
			consume(Operators.COLUMN, node);
			result = parseType();
		}
		
		return result;
	}
	
	/**
	 * @private
	 */
	internal function parseType():TokenNode
	{
		var line:int = token.line;
		var column:int = token.column;
		
		var result:TokenNode = adapter.empty(
			AS3NodeKind.TYPE, token);
		
		if (token.text == VECTOR)
		{
			result = parseVector();
		}
		else
		{
			result.stringValue = parseQualifiedName();
		}
		
		return result;
	}
	
	/**
	 * @private
	 */
	private function parseVector():TokenNode
	{
		var result:TokenNode = adapter.empty(
			AS3NodeKind.VECTOR, token);
		
		consume("Vector", result);
		consume(Operators.VECTOR_START, result);
		
		result.addChild(parseType());
		
		consume(Operators.SUPERIOR, result);
		
		return result;
	}
	
	/**
	 * @private
	 */
	private function parseOptionalInit(node:TokenNode):TokenNode
	{
		var result:TokenNode = null;
		if (tokIs(Operators.EQUAL))
		{
			consume(Operators.EQUAL, node);
			result = adapter.empty(
				AS3NodeKind.INIT, token);
			result.addChild(parseExpression());
		}
		return result;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Expression :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	internal function parseExpression():IParserNode
	{
		return parseAssignmentExpression();
	}
	
	/**
	 * @private
	 */
	private function parseAssignmentExpression():IParserNode
	{
		var result:TokenNode = adapter.empty(
			AS3NodeKind.ASSIGN, token);
		
		result.addChild(parseConditionalExpression());
		while (tokIs(Operators.EQUAL)
			|| tokIs(Operators.PLUS_EQUAL) || tokIs(Operators.MINUS_EQUAL)
			|| tokIs(Operators.TIMES_EQUAL) || tokIs(Operators.DIVIDED_EQUAL)
			|| tokIs(Operators.MODULO_EQUAL) || tokIs(Operators.AND_EQUAL) 
			|| tokIs(Operators.OR_EQUAL) || tokIs(Operators.XOR_EQUAL))
		{
			result.addChild(adapter.copy(
				AS3NodeKind.OP, token));
			nextNonWhiteSpaceToken(result);
			result.addChild(parseExpression());
		}
		return result.numChildren > 1 ? result : result.getChild(0);
	}
	
	/**
	 * @private
	 */
	private function parseConditionalExpression():TokenNode
	{
		var result:TokenNode = parseOrExpression() as TokenNode;
		if (tokIs(Operators.QUESTION_MARK))
		{
			var conditional:TokenNode = adapter.empty(
				AS3NodeKind.CONDITIONAL, token, result);
			nextNonWhiteSpaceToken(conditional); // ?
			conditional.addChild(parseExpression());
			nextNonWhiteSpaceToken(conditional); // :
			conditional.addChild(parseExpression());
			
			return conditional;
		}
		return result;
	}
	
	/**
	 * @private
	 */
	private function parseOrExpression():IParserNode
	{
		var result:TokenNode = adapter.empty(
			AS3NodeKind.OR, token, parseAndExpression());
		
		while (tokIs(Operators.LOGICAL_OR))
		{
			result.addChild(adapter.copy(
				AS3NodeKind.OP, token));
			nextNonWhiteSpaceToken(result);
			result.addChild(parseAndExpression());
		}
		return result.numChildren > 1 ? result : result.getChild(0);
	}
	
	/**
	 * @private
	 */
	private function parseAndExpression():IParserNode
	{
		var result:TokenNode = adapter.empty(
			AS3NodeKind.AND, token, parseBitwiseOrExpression());
		
		while (tokIs(Operators.AND))
		{
			result.addChild(adapter.copy(
				AS3NodeKind.OP, token));
			nextNonWhiteSpaceToken(result);
			result.addChild(parseBitwiseOrExpression());
		}
		return result.numChildren > 1 ? result : result.getChild(0);
	}
	
	/**
	 * @private
	 */
	private function parseBitwiseOrExpression():IParserNode
	{
		var result:TokenNode = adapter.empty(
			AS3NodeKind.B_OR, token, parseBitwiseXorExpression());
		
		while (tokIs(Operators.B_OR))
		{
			result.addChild(adapter.copy(
				AS3NodeKind.OP, token));
			nextNonWhiteSpaceToken(result);
			result.addChild(parseBitwiseXorExpression());
		}
		return result.numChildren > 1 ? result : result.getChild(0);
	}
	
	/**
	 * @private
	 */
	private function parseBitwiseXorExpression():IParserNode
	{
		var result:TokenNode = adapter.empty(
			AS3NodeKind.B_XOR, token, parseBitwiseAndExpression());
		
		while (tokIs(Operators.B_XOR))
		{
			result.addChild(adapter.copy(
				AS3NodeKind.OP, token));
			nextNonWhiteSpaceToken(result);
			result.addChild(parseBitwiseAndExpression());
		}
		return result.numChildren > 1 ? result : result.getChild(0);
	}
	
	/**
	 * @private
	 */
	private function parseBitwiseAndExpression():IParserNode
	{
		var result:TokenNode = adapter.empty(
			AS3NodeKind.B_AND, token, parseEqualityExpression());
		
		while (tokIs(Operators.B_AND))
		{
			result.addChild(adapter.copy(
				AS3NodeKind.OP, token));
			nextNonWhiteSpaceToken(result);
			result.addChild(parseEqualityExpression());
		}
		return result.numChildren > 1 ? result : result.getChild(0);
	}
	
	/**
	 * @private
	 */
	private function parseEqualityExpression():IParserNode
	{
		var result:TokenNode = adapter.empty(
			AS3NodeKind.EQUALITY, token, parseRelationalExpression());
		
		while (tokIs(Operators.DOUBLE_EQUAL)
			|| tokIs(Operators.STRICTLY_EQUAL) || tokIs(Operators.NON_EQUAL)
			|| tokIs(Operators.NON_STRICTLY_EQUAL))
		{
			result.addChild(adapter.copy(
				AS3NodeKind.OP, token));
			nextNonWhiteSpaceToken(result);
			result.addChild(parseRelationalExpression());
		}
		return result.numChildren > 1 ? result : result.getChild(0);
	}
	
	/**
	 * @private
	 */
	private function parseRelationalExpression():IParserNode
	{
		var result:TokenNode = adapter.empty(
			AS3NodeKind.RELATION, token, parseShiftExpression());
		
		while (tokIs(Operators.INFERIOR )
			|| tokIs(Operators.INFERIOR_OR_EQUAL) || tokIs(Operators.SUPERIOR)
			|| tokIs(Operators.SUPERIOR_OR_EQUAL) || tokIs(KeyWords.IS) || tokIs(KeyWords.IN)
			&& !isInFor || tokIs( KeyWords.AS) || tokIs(KeyWords.INSTANCE_OF))
		{
			result.addChild(adapter.copy(
				AS3NodeKind.OP, token));
			nextNonWhiteSpaceToken(result);
			result.addChild(parseShiftExpression());
		}
		return result.numChildren > 1 ? result : result.getChild(0);
	}
	
	/**
	 * @private
	 */
	private function parseShiftExpression():IParserNode
	{
		var result:TokenNode = adapter.empty(
			AS3NodeKind.SHIFT, token, parseAdditiveExpression());
		
		while (tokIs(Operators.DOUBLE_SHIFT_LEFT)
			|| tokIs(Operators.DOUBLE_SHIFT_RIGHT)
			|| tokIs(Operators.TRIPLE_SHIFT_LEFT)
			|| tokIs(Operators.TRIPLE_SHIFT_RIGHT))
		{
			result.addChild(adapter.copy(
				AS3NodeKind.OP, token));
			nextNonWhiteSpaceToken(result);
			result.addChild(parseAdditiveExpression());
		}
		return result.numChildren > 1 ? result : result.getChild(0);
	}
	
	/**
	 * @private
	 */
	private function parseAdditiveExpression():IParserNode
	{
		var result:TokenNode = adapter.empty(
			AS3NodeKind.ADD, token, parseMultiplicativeExpression());
		
		while (tokIs(Operators.PLUS)
			|| tokIs(Operators.MINUS))
		{
			result.addChild(adapter.copy(
				AS3NodeKind.OP, token));
			nextNonWhiteSpaceToken(result);
			result.addChild(parseMultiplicativeExpression());
		}
		return result.numChildren > 1 ? result : result.getChild(0);
	}
	
	/**
	 * @private
	 */
	private function parseMultiplicativeExpression():IParserNode
	{
		var result:TokenNode = adapter.empty(
			AS3NodeKind.MULTIPLICATION, token);
		result.addChild(parseUnaryExpression(result));
		
		while (tokIs(Operators.TIMES)
			|| tokIs(Operators.SLASH) 
			|| tokIs(Operators.MODULO))
		{
			result.addChild(adapter.copy(
				AS3NodeKind.OP, token));
			nextNonWhiteSpaceToken(result);
			result.addChild(parseUnaryExpression(result));
		}
		return result.numChildren > 1 ? result : result.getChild(0);
	}
	
	/**
	 * @private
	 */
	internal function parseUnaryExpression(node:TokenNode):IParserNode
	{
		var result:TokenNode;
		var line:int = token.line;
		var column:int = token.column;
		
		if (tokIs(Operators.INCREMENT))
		{
			nextNonWhiteSpaceToken(node);
			result = adapter.create(
				AS3NodeKind.PRE_INC,
				Operators.INCREMENT, 
				token.line, 
				token.column,
				parseUnaryExpression(node));
		}
		else if (tokIs(Operators.DECREMENT))
		{
			nextNonWhiteSpaceToken(node);
			result = adapter.create(
				AS3NodeKind.PRE_DEC,
				Operators.DECREMENT, 
				line, 
				column,
				parseUnaryExpression(node));
		}
		else if (tokIs(Operators.MINUS))
		{
			nextNonWhiteSpaceToken(node);
			result = adapter.create(
				AS3NodeKind.MINUS,
				Operators.MINUS, 
				token.line, 
				token.column,
				parseUnaryExpression(node));
		}
		else if (tokIs(Operators.PLUS))
		{
			nextNonWhiteSpaceToken(node);
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
	
	/**
	 * @private
	 */
	private function parseUnaryExpressionNotPlusMinus(node:TokenNode):TokenNode
	{
		var result:TokenNode;
		if (tokIs(KeyWords.DELETE))
		{
			nextNonWhiteSpaceToken(node);
			result = adapter.create(
				AS3NodeKind.DELETE,
				KeyWords.DELETE, 
				token.line, 
				token.column,
				parseExpression());
		}
		else if (tokIs(KeyWords.VOID))
		{
			nextNonWhiteSpaceToken(node);
			result = adapter.create(
				AS3NodeKind.VOID,
				KeyWords.VOID, 
				token.line, 
				token.column,
				parseExpression());
		}
		else if (tokIs(KeyWords.TYPEOF))
		{
			nextNonWhiteSpaceToken(node);
			result = adapter.create(
				AS3NodeKind.TYPEOF,
				KeyWords.TYPEOF, 
				token.line, 
				token.column,
				parseExpression());
		}
		else if (tokIs("!"))
		{
			nextNonWhiteSpaceToken(node);
			result = adapter.create(
				AS3NodeKind.NOT,
				"!", 
				token.line, 
				token.column,
				parseExpression());
		}
		else if (tokIs("~"))
		{
			nextNonWhiteSpaceToken(node);
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
	
	/**
	 * @private
	 */
	internal function parsePrimaryExpression():TokenNode
	{
		var result:TokenNode = adapter.empty(
			AS3NodeKind.PRIMARY, token);
		
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
			result.addChild(parseNewExpression());
		}
		else if (tokIs(Operators.LEFT_PARENTHESIS))
		{
			result.addChild(parseEncapsulatedExpression());
		}
		else
		{
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
			else if (token.text.indexOf("<") == 0)
			{
				result.kind = AS3NodeKind.XML;
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
			}
			
			result.stringValue = token.text;
			result.token.text = token.text;
			
			nextNonWhiteSpaceToken(result);
		}
		
		return result;
	}
	
	
	/**
	 * @private
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
		consumeWS(Operators.RIGHT_SQUARE_BRACKET, result, false);
		
		return result;
	}
	
	/**
	 * @private
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
	
	/**
	 * @private
	 */
	private function parseObjectLiteralPropertyDeclaration():TokenNode
	{
		var result:TokenNode = adapter.empty(
			AS3NodeKind.PROP, token);
		
		result.addChild(adapter.copy(
			AS3NodeKind.NAME, token));
		
		nextNonWhiteSpaceToken(result);
		
		consume(Operators.COLUMN, result);
		var value:TokenNode = adapter.empty(
			AS3NodeKind.VALUE, token);
		value.addChild(parseExpression());
		result.addChild(value);
		
		return result;
	}
	
	/**
	 * @private
	 */
	private function parseLambdaExpression():TokenNode
	{
		var result:TokenNode = adapter.empty(
			AS3NodeKind.LAMBDA, token);
		
		consume(KeyWords.FUNCTION, result);
		
		result.addChild(parseParameterList());
		nextNonWhiteSpaceToken(result);
		result.addChild(parseOptionalType(result));
		nextNonWhiteSpaceToken(result);
		result.addChild(parseBlock());
		
		return result;
	}
	
	/**
	 * @private
	 */
	private function parseThrowExpression():TokenNode
	{
		var result:TokenNode = adapter.empty(
			AS3NodeKind.THROW, token);
		
		consume(KeyWords.THROW, result);
		
		result.addChild(parseExpression());
		
		return result;
	}
	
	/**
	 * @private
	 */
	private function parseNewExpression():TokenNode
	{
		var result:TokenNode = adapter.empty(
			AS3NodeKind.NEW, token);
		
		consume(KeyWords.NEW, result);
		
		result.addChild(parseExpression()); // name
		
		if (tokIs(Operators.VECTOR_START))
		{
			consume(Operators.VECTOR_START, result);
			consume(token.text, result);
			consume(Operators.SUPERIOR, result);
		}
		
		if (tokIs(Operators.LEFT_PARENTHESIS))
		{
			result.addChild(parseArgumentList());
		}
		
		return result;
	}
	
	/**
	 * @private
	 */
	private function parseEncapsulatedExpression():TokenNode
	{
		var result:TokenNode = adapter.empty(
			AS3NodeKind.ENCAPSULATED, token);
		
		consume(Operators.LEFT_PARENTHESIS, result);
		result.addChild(parseExpressionList());
		consume(Operators.RIGHT_PARENTHESIS, result);
		
		return result;
	}
	
	/**
	 * @private
	 */
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
		consumeWS(Operators.RIGHT_PARENTHESIS, result, false);
		
		return result;
	}
	
	/**
	 * @private
	 */
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
				consume(Operators.COMMA, result);
			}
		}
		consume(Operators.RIGHT_PARENTHESIS);
		
		return result;
	}
	
	/**
	 * @private
	 */
	private function parseParameter():TokenNode
	{
		var result:TokenNode = adapter.empty(
			AS3NodeKind.PARAMETER, token);
		
		if (tokIs(Operators.REST_PARAMETERS))
		{
			nextNonWhiteSpaceToken(result);
			var rest:TokenNode = adapter.copy(
				AS3NodeKind.REST, token);
			nextNonWhiteSpaceToken(result);
			result.addChild(rest);
		}
		else
		{
			result.addChild(parseNameTypeInit());
		}
		
		return result;
	}
	
	/**
	 * @private
	 */
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
	
	/**
	 * @private
	 */
	private function parseArrayAccessor(node:TokenNode):TokenNode
	{
		var result:TokenNode = adapter.empty(
			AS3NodeKind.ARRAY_ACCESSOR, token, node);
		
		while (tokIs(Operators.LEFT_SQUARE_BRACKET))
		{
			consume(Operators.LEFT_SQUARE_BRACKET, result); // [
			result.addChild(parseExpression());
			consume(Operators.RIGHT_SQUARE_BRACKET, result);
		}
		return result;
	}
	
	/**
	 * @private
	 */
	private function parseFunctionCall(node:TokenNode):TokenNode
	{
		var result:TokenNode = adapter.empty(
			AS3NodeKind.CALL, token, node);
		
		while (tokIs(Operators.LEFT_PARENTHESIS))
		{
			result.addChild(parseArgumentList());
			consumeWhitespace(result);
		}
		while (tokIs(Operators.LEFT_SQUARE_BRACKET))
		{
			result.addChild(parseArrayLiteral());
			consumeWhitespace(result);
		}
		return result;
	}
	
	/**
	 * @private
	 */
	private function parseIncrement(node:TokenNode):TokenNode
	{
		var result:TokenNode = adapter.empty(
			AS3NodeKind.POST_INC, token);
		
		result.addChild(node);
		consume(Operators.INCREMENT, result);
		return result;
	}
	
	/**
	 * @private
	 */
	private function parseDecrement(node:TokenNode):TokenNode
	{
		var result:TokenNode = adapter.empty(
			AS3NodeKind.POST_DEC, token);
		
		result.addChild(node);
		consume(Operators.DECREMENT, result);
		return result;
	}
	
	/**
	 * @private
	 */
	private function parseDot(node:TokenNode):TokenNode
	{
		var result:TokenNode = adapter.empty(
			AS3NodeKind.DOT, token, node);
		
		if (tokIs(Operators.DOUBLE_DOT))
		{
			result = adapter.empty(
				AS3NodeKind.E4X_DESCENDENT, token, node);
			consume(Operators.DOUBLE_DOT, result);
			result.addChild(parseExpression());
			return result;
		}
		
		if (tokIs(Operators.DOT))
		{
			consume(Operators.DOT, result);
		}
		else if (tokIs(Operators.DOUBLE_COLUMN))
		{
			consume(Operators.DOUBLE_COLUMN, result);
			result.kind = AS3NodeKind.DOUBLE_COLUMN;
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
			result = adapter.empty(
				AS3NodeKind.E4X_STAR, token, node);
			
			return result;
		}
		else if (tokIs(Operators.AT))
		{
			result.addChild(parseE4XAttributeIdentifier());
			return result;
		}
		
		result.addChild(parseExpression());
		
		return result;
	}
	
	/**
	 * @private
	 */
	private function parseE4XAttributeIdentifier():TokenNode
	{
		var result:TokenNode = adapter.empty(
			AS3NodeKind.E4X_ATTR, token);
		
		consume(Operators.AT, result);
		
		if (tokIs(Operators.LEFT_SQUARE_BRACKET))
		{
			nextNonWhiteSpaceToken(result);
			result.addChild(parseExpression());
			consume(Operators.RIGHT_SQUARE_BRACKET, result);
		}
		else if (tokIs(Operators.TIMES))
		{
			result.addChild(adapter.create(
				AS3NodeKind.STAR,
				token.text, 
				token.line, 
				token.column));
			consumeWS(Operators.TIMES, result);
		}
		else
		{
			result.addChild(adapter.create(
				AS3NodeKind.NAME,
				token.text, 
				token.line, 
				token.column));
		}
		
		return result;
	}
	
	/**
	 * @private
	 */
	private function parseBlock():TokenNode
	{
		var result:TokenNode = ASTUtil2.newParentheticAST(
			AS3NodeKind.BLOCK,
			AS3NodeKind.LCURLY, "{",
			AS3NodeKind.RCURLY, "}") as TokenNode;
		result.line = token.line;
		result.column = token.column;
		
		consumeWS(Operators.LEFT_CURLY_BRACKET, result);
		
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
		
		consumeWS(Operators.RIGHT_CURLY_BRACKET, result, false);
		
		ISourceCodeScanner(scanner).inBlock = false;
		
		return result;
	}
	
	/**
	 * @private
	 */
	internal function parseExpressionList():IParserNode
	{
		var result:TokenNode = adapter.empty(
			AS3NodeKind.EXPR_LIST, token);
		
		result.addChild(parseAssignmentExpression());
		
		while (tokIs(Operators.COMMA))
		{
			nextNonWhiteSpaceToken(result);
			result.addChild(parseAssignmentExpression());
		}
		return result.numChildren > 1 ? result : result.getChild(0);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Statement :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
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
	
	/**
	 * @private
	 */
	private function parseFor():TokenNode
	{
		var result:TokenNode = adapter.empty(
			AS3NodeKind.FOR, token);
		
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
	
	/**
	 * @private
	 */
	private function parseForEach(node:TokenNode):TokenNode
	{
		consume(Operators.LEFT_PARENTHESIS, node);
		
		if (tokIs(KeyWords.VAR))
		{
			var variable:TokenNode = adapter.empty(
				AS3NodeKind.VAR, token);
			
			consume(KeyWords.VAR, node);
			variable.addChild(parseNameTypeInit());
			node.addChild(variable);
		}
		else
		{
			var name:TokenNode = adapter.copy(
				AS3NodeKind.NAME, token);
			node.addChild(name);
			
			nextNonWhiteSpaceToken(node);
		}
		var ini:TokenNode = adapter.empty(
			AS3NodeKind.IN, token);
		
		consume(KeyWords.IN, node);
		ini.addChild(parseExpression());
		node.addChild(ini);
		
		consume(Operators.RIGHT_PARENTHESIS, node);
		node.addChild(parseStatement());
		node.kind = AS3NodeKind.FOREACH;
		return node;
	}
	
	/**
	 * @private
	 */
	private function parseTraditionalFor(node:TokenNode):TokenNode
	{
		consume(Operators.LEFT_PARENTHESIS, node);
		
		var init:TokenNode;
		
		if (!tokIs(Operators.SEMI_COLUMN))
		{
			if (tokIs(KeyWords.VAR))
			{
				init = adapter.empty(
					AS3NodeKind.INIT, token);
				init.addChild(parseVarList(null, null));
				node.addChild(init);
			}
			else
			{
				isInFor = true;
				init = adapter.empty(
					AS3NodeKind.INIT, token);
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
			var cond:TokenNode = adapter.empty(
				AS3NodeKind.COND, token);
			cond.addChild(parseExpression());
			node.addChild(cond);
		}
		consume(Operators.SEMI_COLUMN, node);
		if (!tokIs(Operators.RIGHT_PARENTHESIS))
		{
			var iter:TokenNode = adapter.empty(
				AS3NodeKind.ITER, token);
			iter.addChild(parseExpressionList());
			node.addChild(iter);
		}
		consume(Operators.RIGHT_PARENTHESIS, node);
		node.addChild(parseStatement());
		node.kind = AS3NodeKind.FOR;
		return node;
	}
	
	/**
	 * @private
	 */
	private function parseForIn(node:TokenNode):TokenNode
	{
		var ini:TokenNode = adapter.empty(
			AS3NodeKind.IN, token);
		
		consume(KeyWords.IN, node);
		ini.addChild(parseExpression());
		node.addChild(ini);
		node.kind = AS3NodeKind.FORIN;
		consume(Operators.RIGHT_PARENTHESIS, node);
		
		node.addChild(parseStatement());
		return node;
	}
	
	/**
	 * @private
	 */
	private function parseIf():TokenNode
	{
		var result:TokenNode = adapter.empty(
			AS3NodeKind.IF, token);
		
		consume(KeyWords.IF, result);
		result.addChild(parseCondition());
		result.addChild(parseStatement());
		nextNonWhiteSpaceToken(result);
		if (tokIs(KeyWords.ELSE))
		{
			consume(KeyWords.ELSE, result);
			result.addChild(parseStatement());
		}
		return result;
	}
	
	/**
	 * @private
	 */
	internal function parseCondition():IParserNode
	{
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
	
	/**
	 * @private
	 */
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
	
	/**
	 * @private
	 */
	private function parseReturnStatement():TokenNode
	{
		var result:TokenNode = adapter.empty(
			AS3NodeKind.RETURN, token);
		
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
	
	/**
	 * @private
	 */
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
		
		return result;
	}
	
	/**
	 * @private
	 */
	private function parseSwitchCases():TokenNode
	{
		if (!tokIs(Operators.LEFT_CURLY_BRACKET))
		{
			return null;
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
	
	/**
	 * @private
	 */
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
	
	/**
	 * @private
	 */
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
	
	/**
	 * @private
	 */
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
	
	/**
	 * @private
	 */
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
	
	/**
	 * @private
	 */
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
		
		nextNonWhiteSpaceToken(result); // name
		
		if (tokIs(Operators.COLUMN))
		{
			consume(Operators.COLUMN, result);
			result.addChild(adapter.create(
				AS3NodeKind.TYPE,
				token.text, 
				token.line, 
				token.column));
			nextNonWhiteSpaceToken(result); // name
		}
		consume(Operators.RIGHT_PARENTHESIS, result);
		result.addChild(parseBlock());
		return result;
	}
	
	/**
	 * @private
	 */
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
	
	/**
	 * @private
	 */
	private function parseVar():TokenNode
	{
		var result:TokenNode = parseVarList(null, null);
		skip(Operators.SEMI_COLUMN, result);
		return result;
	}
	
	/**
	 * @private
	 */
	private function parseConst():TokenNode
	{
		var result:TokenNode = parseConstList(null, null);
		skip(Operators.SEMI_COLUMN, result);
		return result;
	}
	
	/**
	 * @private
	 */
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
	
	
	/**
	 * @private
	 */
	private function parseASdoc():TokenNode
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
		consumeWS(token.text);
		return result;
	}
	
	/**
	 * @private
	 */
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
	
	/**
	 * @private
	 */
	private function addAsDoc(node:TokenNode):void
	{
		if (currentAsDoc)
		{
			currentAsDoc.token.text = "";
			node.addChild(currentAsDoc);
			currentAsDoc = null;
		}
	}
	
	/**
	 * @private
	 */
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
	
	/**
	 * @private
	 */
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
	
	// AS3FragmentParser
	/**
	 * @private
	 */
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
			nextNonWhiteSpaceToken(result);
			result.addChild(parseAssignmentExpression());
		}
		
		skip(Operators.SEMI_COLUMN, result);
		
		return result;
	}
}
}