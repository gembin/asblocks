/**
 *    Copyright (c) 2009, Adobe Systems, Incorporated
 *    All rights reserved.
 *
 *    Redistribution  and  use  in  source  and  binary  forms, with or without
 *    modification,  are  permitted  provided  that  the  following  conditions
 *    are met:
 *
 *      * Redistributions  of  source  code  must  retain  the  above copyright
 *        notice, this list of conditions and the following disclaimer.
 *      * Redistributions  in  binary  form  must reproduce the above copyright
 *        notice,  this  list  of  conditions  and  the following disclaimer in
 *        the    documentation   and/or   other  materials  provided  with  the
 *        distribution.
 *      * Neither the name of the Adobe Systems, Incorporated. nor the names of
 *        its  contributors  may be used to endorse or promote products derived
 *        from this software without specific prior written permission.
 *
 *    THIS  SOFTWARE  IS  PROVIDED  BY THE  COPYRIGHT  HOLDERS AND CONTRIBUTORS
 *    "AS IS"  AND  ANY  EXPRESS  OR  IMPLIED  WARRANTIES,  INCLUDING,  BUT NOT
 *    LIMITED  TO,  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 *    PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER
 *    OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,  INCIDENTAL,  SPECIAL,
 *    EXEMPLARY,  OR  CONSEQUENTIAL  DAMAGES  (INCLUDING,  BUT  NOT  LIMITED TO,
 *    PROCUREMENT  OF  SUBSTITUTE   GOODS  OR   SERVICES;  LOSS  OF  USE,  DATA,
 *    OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 *    LIABILITY,  WHETHER  IN  CONTRACT,  STRICT  LIABILITY, OR TORT (INCLUDING
 *    NEGLIGENCE  OR  OTHERWISE)  ARISING  IN  ANY  WAY  OUT OF THE USE OF THIS
 *    SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
package org.teotigraphix.as3parser.impl
{

import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.api.IScanner;
import org.teotigraphix.as3parser.api.ISourceCodeScanner;
import org.teotigraphix.as3parser.api.KeyWords;
import org.teotigraphix.as3parser.api.Operators;
import org.teotigraphix.as3parser.core.Node;
import org.teotigraphix.as3parser.core.Token;
import org.teotigraphix.as3parser.errors.NullTokenError;

/**
 * A port of the Java PMD de.bokelberg.flex.parser.AS3Parser.
 * 
 * <p>Initial Implementation; Adobe Systems, Incorporated</p>
 * 
 * @author Michael Schmalle
 */
public class AS3Parser extends ParserBase
{
	//--------------------------------------------------------------------------
	//
	//  Private :: Constants
	//
	//--------------------------------------------------------------------------
	
	private static const MULTIPLE_LINES_COMMENT:String = "/*";
	
	private static const SINGLE_LINE_COMMENT:String = "//";
	
	private static const NEW_LINE:String = "\n";
	
	private static const VECTOR:String = "Vector";
	
	//--------------------------------------------------------------------------
	//
	//  Private :: Variables
	//
	//--------------------------------------------------------------------------
	
	private var currentAsDoc:Node;
	
	private var braceCount:int;
	
	private var isInFor:Boolean = false;
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function AS3Parser()
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
		return new AS3Scanner();
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
		var result:Node = Node.create(AS3NodeKind.COMPILATION_UNIT, -1, -1);
		
		nextTokenIgnoringAsDoc();
		if (tokIs(KeyWords.PACKAGE))
		{
			result.addChild(parsePackage());
		}
		result.addChild(parsePackageContent());
		return result;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Private :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * tok is package
	 * 
	 * @throws UnExpectedTokenException
	 */
	private function parsePackage():Node
	{
		
		var end:int = -1;
		
		var result:Node = Node.create(
			AS3NodeKind.PACKAGE, 
			token.line, 
			token.column);
		result.start = scanner.offset;
		
		consume(KeyWords.PACKAGE);
		
		var line:int = token.line;
		var column:int = token.column;
		
		var start:int = scanner.offset - token.text.length;
		
		var qualifiedName:String = parseQualifiedName();
		
		var name:Node = Node.create(AS3NodeKind.NAME, line, column, qualifiedName);
		name.start = start;
		name.end = qualifiedNameEnd;
		
		result.addChild(name);
		
		consume(Operators.LEFT_CURLY_BRACKET);
		result.addChild(parsePackageContent());
		consume(Operators.RIGHT_CURLY_BRACKET);
		
		result.end = scanner.offset;
		
		return result;
	}
	
	/**
	 * tok is first token of content
	 * 
	 * @throws UnExpectedTokenException
	 */
	internal function parsePackageContent():Node
	{
		var result:Node = Node.create(AS3NodeKind.CONTENT, 
			token.line, token.column);
		result.start = scanner.offset;
		
		var modifiers:Vector.<Token> = new Vector.<Token>();
		var meta:Vector.<Node> = new Vector.<Node>();
		
		while (!tokIs(Operators.RIGHT_CURLY_BRACKET)
			&& !tokIs(KeyWords.EOF))
		{
			if (tokIs(KeyWords.IMPORT))
			{
				result.addChild(parseImport());
			}
				// added 05-30-10
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
				modifiers.length = 0;
			}
			else if (tokIs(KeyWords.INTERFACE))
			{
				result.addChild(parseInterface(meta, modifiers));
				
				meta.length = 0;
				modifiers.length = 0;
			}
			else if (tokIs(KeyWords.FUNCTION))
			{
				parseClassFunctions(result, modifiers, meta);
			}
			else if (tokenStartsWith("/**"))
			{
				currentAsDoc = Node.create(AS3NodeKind.AS_DOC,
					ISourceCodeScanner(scanner).asdocOffset,
					token.column,
					token.text);
				ISourceCodeScanner(scanner).asdocOffset = -1;
				currentAsDoc.start = scanner.offset - token.text.length;
				currentAsDoc.end = scanner.offset;
				nextToken();
			}
			else if (tokenStartsWith("/*")) // junk comment
			{
				nextToken();
			}
			else
			{
				modifiers.push(token);
				nextTokenIgnoringAsDoc();
			}
		}
		
		result.end = scanner.offset;
		
		return result;
	}
	
	/**
	 * tok is import
	 * 
	 * @throws TokenException
	 */
	private function parseImport():Node
	{
		consume(KeyWords.IMPORT);
		var result:Node = Node.create(AS3NodeKind.IMPORT, 
			token.line, token.column, parseImportName());
		skip(Operators.SEMI_COLUMN);
		return result;
	}
	
	/**
	 * tok is the first part of a name the last part can be a star exit tok is
	 * the first token, which doesn't belong to the name
	 * 
	 * @throws TokenException
	 */
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
	
	private function parseUse():Node
	{
		consume(KeyWords.USE);
		consume(KeyWords.NAMESPACE);
		var result:Node = Node.create(AS3NodeKind.USE,	
			token.line,token.column, parseNamespaceName());
		skip(Operators.SEMI_COLUMN);
		return result;
	}
	
	private function parseNamespaceName():String
	{
		var name:String = token.text;
		nextToken(); // simple name for now
		return name;
	}
	
	
	/**
	 * tok is [ [id] [id ("test")] [id (name="test",type="a.b.c.Event")] exit
	 * token is the first token after ]
	 * 
	 * @throws TokenException
	 */
	private function parseMetaData():Node
	{
		var buffer:String = "";
		
		var line:int = token.line;
		var column:int = token.column;
		
		consume(Operators.LEFT_SQUARE_BRACKET);
		while (!tokIs(Operators.RIGHT_SQUARE_BRACKET))
		{
			if (buffer.length > 0)
			{
				buffer += ' ';
			}
			buffer += token.text;
			nextToken();
		}
		skip(Operators.RIGHT_SQUARE_BRACKET);
		var metaDataNode:Node = Node.create(AS3NodeKind.META, 
			line, column, buffer);
		
		if (currentAsDoc != null)
		{
			metaDataNode.addChild(currentAsDoc);
			currentAsDoc = null;
		}
		
		return metaDataNode;
	}
	
	/**
	 * tok is class
	 * 
	 * @param meta Node
	 * @param modifier Token
	 * @throws TokenException
	 */
	private function parseClass(meta:Vector.<Node>, 
								modifier:Vector.<Token>):Node
	{
		consume(KeyWords.CLASS);
		
		var result:Node = Node.create(AS3NodeKind.CLASS, 
			token.line, token.column);
		
		if (currentAsDoc != null)
		{
			result.addChild(currentAsDoc);
			currentAsDoc = null;
		}
		result.addRawChild(AS3NodeKind.NAME, 
			token.line, token.column ,token.text);
		nextToken(); // name
		result.addChild(convertMeta(meta));
		result.addChild(convertModifiers(modifier));
		do
		{
			if (tokIs(KeyWords.EXTENDS))
			{
				nextToken(); // extends
				result.addRawChild(AS3NodeKind.EXTENDS,
					token.line,
					token.column,
					parseQualifiedName());
			}
			else if (tokIs(KeyWords.IMPLEMENTS))
			{
				result.addChild(parseImplementsList());
			}
		}
		while (!tokIs(Operators.LEFT_CURLY_BRACKET));
		consume(Operators.LEFT_CURLY_BRACKET);
		result.addChild(parseClassContent());
		consume(Operators.RIGHT_CURLY_BRACKET);
		return result;
	}
	
	
	/**
	 * tok is interface
	 * 
	 * @param meta
	 * @param modifier
	 * @throws TokenException
	 */
	private function parseInterface(meta:Vector.<Node>, 
									modifier:Vector.<Token>):Node
	{
		consume(KeyWords.INTERFACE);
		var result:Node = Node.create(AS3NodeKind.INTERFACE,
			token.line,
			token.column);
		
		if (currentAsDoc != null)
		{
			result.addChild(currentAsDoc);
			currentAsDoc = null;
		}
		result.addRawChild(AS3NodeKind.NAME,
			token.line,
			token.column,
			token.text);
		nextToken(); // name
		result.addChild(convertMeta(meta));
		result.addChild(convertModifiers(modifier));
		
		if (tokIs(KeyWords.EXTENDS))
		{
			nextToken(); // extends
			result.addRawChild(AS3NodeKind.EXTENDS,
				token.line,
				token.column,
				parseQualifiedName());
		}
		while (tokIs(Operators.COMMA))
		{
			nextToken(); // comma
			result.addRawChild(AS3NodeKind.EXTENDS,
				token.line,
				token.column,
				parseQualifiedName());
		}
		consume(Operators.LEFT_CURLY_BRACKET);
		result.addChild(parseInterfaceContent());
		consume(Operators.RIGHT_CURLY_BRACKET);
		return result;
	}
	
	
	private function convertMeta(metas:Vector.<Node>):Node
	{
		if (metas == null || metas.length == 0)
		{
			return null;
		}
		
		var result:Node = Node.create(AS3NodeKind.META_LIST, 
			token.line, token.column);
		
		var len:int = metas.length;
		for (var i:int = 0; i < metas.length; i++)
		{
			result.addChild(Node(metas[i]));
		}
		
		return result;
	}	
	
	private function convertModifiers(modifiers:Vector.<Token>):Node
	{
		if (modifiers == null || modifiers.length == 0)
		{
			return null;
		}
		
		var result:Node = Node.create(AS3NodeKind.MOD_LIST, 
			token.line, token.column);
		
		var len:int = modifiers.length;
		for (var i:int = 0; i < modifiers.length; i++)
		{
			result.addRawChild(AS3NodeKind.MODIFIER,
				token.line,
				token.column,
				modifiers[i].text);
		}
		
		return result;
	}
	
	private var qualifiedNameEnd:int = -1;
	
	/**
	 * tok is first part of the name exit tok is the first token after the name
	 * 
	 * @throws TokenException
	 */
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
		return buffer.toString();
	}
	
	/**
	 * tok is implements implements a,b,c exit tok is the first token after the
	 * list of qualfied names
	 * 
	 * @throws TokenException
	 */
	private function parseImplementsList():Node
	{
		consume(KeyWords.IMPLEMENTS);
		
		var result:Node = Node.create(AS3NodeKind.IMPLEMENTS_LIST, token.line, token.column);
		result.addRawChild(AS3NodeKind.IMPLEMENTS,
			token.line,
			token.column,
			parseQualifiedName());
		while (tokIs(Operators.COMMA))
		{
			nextToken();
			result.addRawChild(AS3NodeKind.IMPLEMENTS,
				token.line,
				token.column,
				parseQualifiedName() );
		}
		return result;
	}
	
	/**
	 * tok is first content token
	 * 
	 * @throws TokenException
	 */
	private function parseClassContent():Node
	{
		var result:Node = Node.create(AS3NodeKind.CONTENT,
			token.line,
			token.column);
		var modifiers:Vector.<Token> = new Vector.<Token>();
		var meta:Vector.<Node> = new Vector.<Node>();
		
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
				parseClassField(result, modifiers, meta);
			}
			else if (tokIs(KeyWords.CONST))
			{
				parseClassConstant(result, modifiers, meta);
			}
			else if (tokIs(KeyWords.IMPORT))
			{
				result.addChild(parseImport());
			}
			else if (tokIs(KeyWords.FUNCTION))
			{
				parseClassFunctions(result, modifiers, meta);
			}
			else if (tokenStartsWith("/**"))
			{
				currentAsDoc = Node.create(AS3NodeKind.AS_DOC,
					ISourceCodeScanner(scanner).asdocOffset,
					token.column,
					token.text);
				ISourceCodeScanner(scanner).asdocOffset = -1;
				currentAsDoc.start = scanner.offset - token.text.length;
				currentAsDoc.end = scanner.offset;
				nextToken();
			}
			else
			{
				modifiers.push(token);
				nextTokenIgnoringAsDoc();
			}
		}
		return result;
	}
	
	/**
	 * tok is first content token
	 * 
	 * @throws TokenException
	 */
	private function parseInterfaceContent():Node
	{
		var result:Node = Node.create(AS3NodeKind.CONTENT,
			token.line,
			token.column);
		while (!tokIs(Operators.RIGHT_CURLY_BRACKET))
		{
			if (tokIs(KeyWords.IMPORT))
			{
				result.addChild(parseImport());
			}
			else if (tokIs(KeyWords.FUNCTION))
			{
				result.addChild(parseFunctionSignature());
			}
			else if (tokIs(KeyWords.INCLUDE))
			{
				result.addChild(parseIncludeExpression());
			}
			else if (tokIs(Operators.LEFT_SQUARE_BRACKET))
			{
				while (!tokIs( Operators.RIGHT_SQUARE_BRACKET))
				{
					nextToken();
				}
				nextToken();
			}
			else if (tokenStartsWith("/**"))
			{
				currentAsDoc = Node.create(AS3NodeKind.AS_DOC,
					ISourceCodeScanner(scanner).asdocOffset,
					token.column,
					token.text);
				ISourceCodeScanner(scanner).asdocOffset = -1;
				currentAsDoc.start = scanner.offset - token.text.length;
				currentAsDoc.end = scanner.offset;
				nextToken();
			}
			else
			{
				nextTokenIgnoringAsDoc();
			}
		}
		return result;
	}	
	
	private function parseIncludeExpression():IParserNode
	{
		var result:Node = Node.create(AS3NodeKind.INCLUDE,
			token.line,
			token.column);
		consume(KeyWords.INCLUDE);
		result.addChild(parseExpression());
		return result;
	}
	
	/**
	 * tok is function exit tok is the first token after the optional ;
	 * 
	 * @throws TokenException
	 */
	private function parseFunctionSignature():Node
	{
		var signature:Array = doParseSignature();
		skip(Operators.SEMI_COLUMN);
		var result:Node = Node.create(findFunctionTypeFromSignature(signature),
			token.line,
			token.column,
			signature[0].stringValue);
		if (currentAsDoc != null)
		{
			result.addChild(currentAsDoc);
			currentAsDoc = null;
		}      
		result.addChild(signature[1]);
		result.addChild(signature[2]);
		result.addChild(signature[3]);
		return result;
	}
	
	/**
	 * tok is { exit tok is the first tok after }
	 * 
	 * @throws TokenException
	 */
	private function parseBlock():Node
	{
		// FIXME Hack
		if (tokenStartsWith(MULTIPLE_LINES_COMMENT))
		{
			nextTokenIgnoringAsDoc(); // /* ... */
		}
		
		consume(Operators.LEFT_CURLY_BRACKET);
		
		var result:Node = Node.create(AS3NodeKind.BLOCK,
			token.line,
			token.column);
		
		/*
		while ( !tokIs( Operators.RIGHT_CURLY_BRACKET ) )
		{
		result.addChild( parseStatement() );
		}
		
		consume( Operators.RIGHT_CURLY_BRACKET );
		*/
		
		///*
		ISourceCodeScanner(scanner).setInBlock(true);
		
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
			
			nextTokenIgnoringAsDoc();
		}
		//*/
		
		consume(Operators.RIGHT_CURLY_BRACKET);
		
		ISourceCodeScanner(scanner).setInBlock(false);
		
		return result;
	}
	
	private function parseClassField(result:Node, 
									 modifiers:Vector.<Token>, 
									 meta:Vector.<Node>):void
	{
		var varList:Node = parseVarList(meta, modifiers);
		result.addChild(varList);
		if (currentAsDoc != null)
		{
			varList.addChild(currentAsDoc);
			currentAsDoc = null;
		}
		if (tokenStartsWith("/*")) // FIXME
		{
			nextToken(); // /* .. bogus comment .. */
		}
		if (tokIs(Operators.SEMI_COLUMN))
		{
			nextToken();
		}
		meta.length = 0;
		modifiers.length = 0;
	}
	
	/**
	 * tok is var var x, y : String, z : int = 0;
	 * 
	 * @param modifiers
	 * @param meta
	 * @throws TokenException
	 */
	private function parseVarList(meta:Vector.<Node>, 
								  modifiers:Vector.<Token>):Node
	{
		consume(KeyWords.VAR);
		var result:Node = Node.create(AS3NodeKind.VAR_LIST,
			token.line,
			token.column);
		result.addChild(convertMeta(meta));
		result.addChild(convertModifiers(modifiers));
		collectVarListContent(result);
		return result;
	}
	
	private function collectVarListContent(result:Node):IParserNode
	{
		result.addChild(parseNameTypeInit());
		while (tokIs(Operators.COMMA))
		{
			nextToken();
			result.addChild(parseNameTypeInit());
		}
		return result;
	}
	
	private function parseNameTypeInit():Node
	{
		var result:Node = Node.create(AS3NodeKind.NAME_TYPE_INIT,
			token.line,
			token.column );
		result.addRawChild(AS3NodeKind.NAME,
			token.line,
			token.column,
			token.text);
		nextToken(); // name
		result.addChild(parseOptionalType());
		result.addChild(parseOptionalInit());
		return result;
	}
	
	/**
	 * if tok is ":" parse the type otherwise do nothing
	 * 
	 * @return
	 * @throws TokenException
	 */
	private function parseOptionalType():Node
	{
		var result:Node = Node.create(AS3NodeKind.TYPE,
			token.line,
			token.column,
			"");
		if (tokIs(Operators.COLUMN))
		{
			nextToken();
			result = parseType();
		}
		if (tokenStartsWith("/*"))
		{
			nextToken(); // garbage
		}		
		return result;
	}
	
	private function parseType():Node
	{
		var result:Node;
		if (token.text == VECTOR)
		{
			result = parseVector();
		}
		else
		{
			// type could be qualified
			var buffer:String = "";
			
			buffer += token.text;
			nextToken();
			while (tokIs(Operators.DOT) || tokIs(Operators.DOUBLE_COLUMN))
			{
				buffer += token.text;
				nextToken();
				buffer += token.text;
				nextToken(); // name
			}
			
			result = Node.create(AS3NodeKind.TYPE,
				token.line,
				token.column,
				buffer);
		}
		return result;
	}
	
	private function parseVector():Node
	{
		var result:Node = Node.create(AS3NodeKind.VECTOR,
			token.line,
			token.column,
			"");
		nextToken();
		consume(Operators.VECTOR_START);
		
		result.addChild(parseType());
		
		consume(Operators.SUPERIOR);
		
		return result;
	}
	
	/**
	 * if tok is "=" parse the expression otherwise do nothing
	 * 
	 * @return
	 */
	private function parseOptionalInit():Node
	{
		var result:Node = null;
		if (tokenStartsWith("/*"))
		{
			nextToken(); // garbage
		}
		if (tokIs(Operators.EQUAL))
		{
			nextToken();
			result = Node.createChild(AS3NodeKind.INIT,
				token.line,
				token.column,
				parseExpression());
		}
		return result;
	}
	
	private function parseExpression():IParserNode
	{
		return parseAssignmentExpression();
	}
	
	
	private function parseAssignmentExpression():IParserNode
	{
		var result:Node = Node.createChild(AS3NodeKind.ASSIGN,
			token.line,
			token.column,
			parseConditionalExpression());
		while (tokIs(Operators.EQUAL)
			|| tokIs(Operators.PLUS_EQUAL) || tokIs(Operators.MINUS_EQUAL)
			|| tokIs(Operators.TIMES_EQUAL) || tokIs(Operators.DIVIDED_EQUAL)
			|| tokIs(Operators.MODULO_EQUAL) || tokIs(Operators.AND_EQUAL) || tokIs(Operators.OR_EQUAL)
			|| tokIs(Operators.XOR_EQUAL))
		{
			result.addChild(Node.create(AS3NodeKind.OP,
				token.line,
				token.column,
				token.text));
			nextToken();
			result.addChild(parseExpression());
		}
		return result.numChildren > 1 ? result : result.getChild(0);
	}
	
	private function parseConditionalExpression():IParserNode
	{
		var result:IParserNode = parseOrExpression();
		if (tokIs(Operators.QUESTION_MARK))
		{
			var conditional:Node = Node.createChild(AS3NodeKind.CONDITIONAL,
				token.line,
				token.column,
				result);
			nextToken(); // ?
			conditional.addChild(parseExpression());
			nextToken(); // :
			conditional.addChild(parseExpression());
			
			return conditional;
		}
		return result;
	}
	
	private function parseOrExpression():IParserNode
	{
		var result:Node = Node.createChild(AS3NodeKind.OR,
			token.line,
			token.column,
			parseAndExpression());
		while (tokIs(Operators.LOGICAL_OR))
		{
			result.addChild(Node.create(AS3NodeKind.OP,
				token.line,
				token.column,
				token.text));
			nextToken();
			result.addChild(parseAndExpression());
		}
		return result.numChildren > 1 ? result : result.getChild(0);
	}
	
	private function parseAndExpression():IParserNode
	{
		var result:Node = Node.createChild(AS3NodeKind.AND,
			token.line,
			token.column,
			parseBitwiseOrExpression());
		while (tokIs(Operators.AND))
		{
			result.addChild(Node.create(AS3NodeKind.OP,
				token.line,
				token.column,
				token.text));
			nextToken();
			result.addChild(parseBitwiseOrExpression());
		}
		return result.numChildren > 1 ? result : result.getChild(0);
	}
	
	private function parseBitwiseOrExpression():IParserNode
	{
		var result:Node = Node.createChild(AS3NodeKind.B_OR,
			token.line,
			token.column,
			parseBitwiseXorExpression());
		while (tokIs(Operators.B_OR))
		{
			result.addChild(Node.create(AS3NodeKind.OP,
				token.line,
				token.column,
				token.text));
			nextToken();
			result.addChild(parseBitwiseXorExpression());
		}
		return result.numChildren > 1 ? result : result.getChild(0);
	}
	
	private function parseBitwiseXorExpression():IParserNode
	{
		var result:Node = Node.createChild(AS3NodeKind.B_XOR,
			token.line,
			token.column,
			parseBitwiseAndExpression());
		while (tokIs(Operators.B_XOR))
		{
			result.addChild(Node.create(AS3NodeKind.OP,
				token.line,
				token.column,
				token.text));
			nextToken();
			result.addChild(parseBitwiseAndExpression());
		}
		return result.numChildren > 1 ? result : result.getChild(0);
	}
	
	private function parseBitwiseAndExpression():IParserNode
	{
		var result:Node = Node.createChild(AS3NodeKind.B_AND,
			token.line,
			token.column,
			parseEqualityExpression());
		while (tokIs(Operators.B_AND))
		{
			result.addChild(Node.create(AS3NodeKind.OP,
				token.line,
				token.column,
				token.text));
			nextToken();
			result.addChild(parseEqualityExpression());
		}
		return result.numChildren > 1 ? result : result.getChild(0);
	}
	
	private function parseEqualityExpression():IParserNode
	{
		var result:Node = Node.createChild(AS3NodeKind.EQUALITY,
			token.line,
			token.column,
			parseRelationalExpression());
		while (tokIs(Operators.DOUBLE_EQUAL)
			|| tokIs(Operators.STRICTLY_EQUAL) || tokIs(Operators.NON_EQUAL)
			|| tokIs(Operators.NON_STRICTLY_EQUAL))
		{
			result.addChild(Node.create(AS3NodeKind.OP,
				token.line,
				token.column,
				token.text));
			nextToken();
			result.addChild(parseRelationalExpression());
		}
		return result.numChildren > 1 ? result : result.getChild(0);
	}
	
	private function parseRelationalExpression():IParserNode
	{
		var result:Node = Node.createChild(AS3NodeKind.RELATION,
			token.line,
			token.column,
			parseShiftExpression());
		while (tokIs(Operators.INFERIOR )
			|| tokIs(Operators.INFERIOR_OR_EQUAL) || tokIs(Operators.SUPERIOR)
			|| tokIs(Operators.SUPERIOR_OR_EQUAL) || tokIs(KeyWords.IS) || tokIs(KeyWords.IN)
			&& !isInFor || tokIs( KeyWords.AS) || tokIs(KeyWords.INSTANCE_OF))
		{
			result.addChild(Node.create(AS3NodeKind.OP,
				token.line,
				token.column,
				token.text));
			nextToken();
			result.addChild(parseShiftExpression());
		}
		return result.numChildren > 1 ? result : result.getChild(0);
	}
	
	private function parseShiftExpression():IParserNode
	{
		var result:Node = Node.createChild(AS3NodeKind.SHIFT,
			token.line,
			token.column,
			parseAdditiveExpression());
		while (tokIs(Operators.DOUBLE_SHIFT_LEFT)
			|| tokIs(Operators.TRIPLE_SHIFT_LEFT) || tokIs( Operators.DOUBLE_SHIFT_RIGHT)
			|| tokIs(Operators.TRIPLE_SHIFT_RIGHT))
		{
			result.addChild(Node.create(AS3NodeKind.OP,
				token.line,
				token.column,
				token.text));
			nextToken();
			result.addChild(parseAdditiveExpression());
		}
		return result.numChildren > 1 ? result : result.getChild(0);
	}
	
	private function parseAdditiveExpression():IParserNode
	{
		var result:Node = Node.createChild(AS3NodeKind.ADD,
			token.line,
			token.column,
			parseMultiplicativeExpression());
		while (tokIs(Operators.PLUS)
			|| tokIs(Operators.MINUS))
		{
			result.addChild(Node.create(AS3NodeKind.OP,
				token.line,
				token.column,
				token.text));
			nextToken();
			result.addChild(parseMultiplicativeExpression());
		}
		return result.numChildren > 1 ? result : result.getChild(0);
	}
	
	private function parseMultiplicativeExpression():IParserNode
	{
		var result:Node = Node.createChild(AS3NodeKind.MULTIPLICATION,
			token.line,
			token.column,
			parseUnaryExpression());
		while (tokIs(Operators.TIMES)
			|| tokIs(Operators.SLASH) || tokIs(Operators.MODULO))
		{
			result.addChild(Node.create(AS3NodeKind.OP,
				token.line,
				token.column,
				token.text));
			nextToken();
			result.addChild(parseUnaryExpression());
		}
		return result.numChildren > 1 ? result : result.getChild(0);
	}
	
	private function parseUnaryExpression():Node
	{
		var result:Node;
		if (tokIs(Operators.INCREMENT))
		{
			nextToken();
			result = Node.createChild(AS3NodeKind.PRE_INC,
				token.line,
				token.column,
				parseUnaryExpression());
		}
		else if (tokIs(Operators.DECREMENT))
		{
			nextToken();
			result = Node.createChild(AS3NodeKind.PRE_DEC,
				token.line,
				token.column,
				parseUnaryExpression());
		}
		else if (tokIs(Operators.MINUS))
		{
			nextToken();
			result = Node.createChild(AS3NodeKind.MINUS,
				token.line,
				token.column,
				parseUnaryExpression());
		}
		else if (tokIs(Operators.PLUS))
		{
			nextToken();
			result = Node.createChild(AS3NodeKind.PLUS,
				token.line,
				token.column,
				parseUnaryExpression());
		}
		else
		{
			result = parseUnaryExpressionNotPlusMinus();
		}
		return result;
	}
	
	private function parseUnaryExpressionNotPlusMinus():Node
	{
		var result:Node;
		if (tokIs(KeyWords.DELETE))
		{
			nextToken();
			result = Node.createChild(AS3NodeKind.DELETE,
				token.line,
				token.column,
				parseExpression());
		}
		else if (tokIs(KeyWords.VOID))
		{
			nextToken();
			result = Node.createChild(AS3NodeKind.VOID,
				token.line,
				token.column,
				parseExpression());
		}
		else if (tokIs(KeyWords.TYPEOF))
		{
			nextToken();
			result = Node.createChild(AS3NodeKind.TYPEOF,
				token.line,
				token.column,
				parseExpression());
		}
		else if (tokIs("!"))
		{
			nextToken();
			result = Node.createChild(AS3NodeKind.NOT,
				token.line,
				token.column,
				parseExpression());
		}
		else if (tokIs("~" ))
		{
			nextToken();
			result = Node.createChild(AS3NodeKind.B_NOT,
				token.line,
				token.column,
				parseExpression());
		}
		else
		{
			result = parseUnaryPostfixExpression();
		}
		return result;
	}
	
	private function parseUnaryPostfixExpression():Node
	{
		var node:Node = parsePrimaryExpression();
		
		if (tokIs(Operators.LEFT_SQUARE_BRACKET))
		{
			node = parseArrayAccessor(node);
		}
		else if (tokIs(Operators.LEFT_PARENTHESIS))
		{
			node = parseFunctionCall(node);
		}
		if (tokIs(Operators.INCREMENT))
		{
			node = parseIncrement(node);
		}
		else if (tokIs(Operators.DECREMENT))
		{
			node = parseDecrement(node);
		}
		else if (tokIs(Operators.DOT)
			|| tokIs( Operators.DOUBLE_COLUMN))
		{
			node = parseDot(node);
		}
		return node;
	}
	
	private function parsePrimaryExpression():Node
	{
		var result:Node = Node.create(AS3NodeKind.PRIMARY,
			token.line,
			token.column,
			token.text);
		
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
		else if (tokIs(KeyWords.NEW))
		{
			result = parseNewExpression();
		}
		else if (tokIs(Operators.LEFT_PARENTHESIS))
		{
			result.addChild(parseEncapsulatedExpression());
		}
			// else if ( tok.isNum()
			// || tokIs( KeyWords.TRUE ) || tokIs( KeyWords.FALSE ) || tokIs(
			// KeyWords.NULL )
			// || tok.text.startsWith( Operators.DOUBLE_QUOTE.toString() )
			// || tok.text.startsWith( Operators.SIMPLE_QUOTE.toString() )
			// || tok.text.startsWith( Operators.SLASH.toString() )
			// || tok.text.startsWith( Operators.INFERIOR.toString() ) || tokIs(
			// KeyWords.UNDEFINED ) )
			// {
			// nextToken();
			// }
		else
		{
			nextToken();
		}
		return result;
	}
	
	/**
	 * tok is [
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
	 * tok is {
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
	* tok is name
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
	 * tok is function
	 * 
	 * @throws TokenException
	 */
	private function parseLambdaExpression():Node
	{
		consume(KeyWords.FUNCTION);
		var result:Node = Node.create(AS3NodeKind.LAMBDA,
			token.line,
			token.column);
		result.addChild(parseParameterList());
		result.addChild(parseOptionalType());
		result.addChild(parseBlock());
		return result;
	}
	
	private function parseNewExpression():Node
	{
		consume(KeyWords.NEW);
		
		var result:Node = Node.create(AS3NodeKind.NEW,
			token.line,
			token.column);
		result.addChild(parseExpression()); // name
		if (tokIs(Operators.LEFT_PARENTHESIS))
		{
			result.addChild(parseArgumentList());
		}
		return result;
	}
	
	private function parseEncapsulatedExpression():Node
	{
		consume(Operators.LEFT_PARENTHESIS);
		var result:Node = Node.create(AS3NodeKind.ENCAPSULATED,
			token.line,
			token.column);
		result.addChild(parseExpressionList());
		
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
			result.addChild(parseArgumentList());
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
		// else if ( tokIs( Operators.AT ) )
		// {
		// return parseE4XAttributeIdentifier();
		// }
		result = Node.create(AS3NodeKind.DOT,
			token.line,
			token.column);
		result.addChild(node);
		result.addChild(parseExpression());
		return result;
	}
	
	/**
	 * tok is (
	 * 
	 * @throws TokenException
	 */
	private function parseParameterList():Node
	{
		consume(Operators.LEFT_PARENTHESIS);
		
		var result:Node = Node.create(AS3NodeKind.PARAMETER_LIST,
			token.line,
			token.column);
		while (!tokIs(Operators.RIGHT_PARENTHESIS))
		{
			result.addChild(parseParameter());
			if (tokIs(Operators.COMMA))
			{
				nextToken();
			}
			else
			{
				break;
			}
		}
		consume(Operators.RIGHT_PARENTHESIS);
		return result;
	}
	
	/**
	 * tok is the name of a parameter or ...
	 */
	private function parseParameter():Node
	{
		var result:Node = Node.create(AS3NodeKind.PARAMETER,
			token.line,
			token.column);
		if (tokIs(Operators.REST_PARAMETERS))
		{
			nextToken(); // ...
			var rest:Node = Node.create(AS3NodeKind.REST,
				token.line,
				token.column,
				token.text);
			nextToken(); // rest
			result.addChild(rest);
		}
		else
		{
			result.addChild(parseNameTypeInit());
		}
		return result;
	}
	
	/**
	 * tok is ( exit tok is first token after )
	 */
	private function parseArgumentList():Node
	{
		consume(Operators.LEFT_PARENTHESIS);
		var result:Node = Node.create(AS3NodeKind.ARGUMENTS,
			token.line,
			token.column);
		while (!tokIs(Operators.RIGHT_PARENTHESIS))
		{
			result.addChild(parseExpression());
			skip(Operators.COMMA);
		}
		consume(Operators.RIGHT_PARENTHESIS);
		return result;
	}
	
	private function parseExpressionList():IParserNode
	{
		var result:Node = Node.createChild(AS3NodeKind.EXPR_LIST,
			token.line,
			token.column,
			parseAssignmentExpression());
		while (tokIs(Operators.COMMA))
		{
			nextToken();
			result.addChild(parseAssignmentExpression());
		}
		return result.numChildren > 1 ? result : result.getChild(0);
	}
	
	private function parseClassConstant(result:Node, 
										modifiers:Vector.<Token>, 
										meta:Vector.<Node>):void
	{
		result.addChild(parseConstList(modifiers, meta));
		if (tokIs(Operators.SEMI_COLUMN))
		{
			nextToken();
		}
		meta.length = 0;
		modifiers.length = 0;
	}
	
	/**
	 * tok is const
	 * 
	 * @param modifiers
	 * @param meta
	 * @throws TokenException
	 */
	private function parseConstList(modifiers:Vector.<Token>, 
									meta:Vector.<Node>):Node
	{
		consume(KeyWords.CONST);
		var result:Node = Node.create(AS3NodeKind.CONST_LIST,
			token.line,
			token.column);
		result.addChild(convertMeta(meta));
		if (currentAsDoc != null)
		{
			result.addChild(currentAsDoc);
			currentAsDoc = null;
		}
		result.addChild(convertModifiers(modifiers));
		collectVarListContent(result);
		return result;
	}
	
	private function parseClassFunctions(result:Node, 
										 modifiers:Vector.<Token>, 
										 meta:Vector.<Node>):void
	{
		result.addChild(parseFunction(modifiers, meta));
		meta.length = 0;
		modifiers.length = 0;
	}
	
	/**
	 * tok is function
	 * 
	 * @param modifiers
	 * @param meta
	 * @throws TokenException
	 */
	private function parseFunction(modifiers:Vector.<Token>, 
								   meta:Vector.<Node>):Node
	{
		var signature:Array = doParseSignature(); // Node
		var result:Node = Node.create(findFunctionTypeFromSignature(signature),
			token.line,
			token.column,
			signature[0].stringValue);
		
		if (currentAsDoc != null)
		{
			result.addChild(currentAsDoc);
			currentAsDoc = null;
		}
		result.addChild(convertMeta(meta));
		result.addChild(convertModifiers( modifiers));
		result.addChild(signature[1]);
		result.addChild(signature[2]);
		result.addChild(signature[3]);
		result.addChild(parseBlock());
		return result;
	}
	
	private function doParseSignature():Array // Node
	{
		consume(KeyWords.FUNCTION);
		
		var type:Node = Node.create(AS3NodeKind.TYPE,
			token.line,
			token.column,
			KeyWords.FUNCTION);
		if (tokIs(KeyWords.SET) || tokIs(KeyWords.GET))
		{
			type = Node.create(AS3NodeKind.TYPE,
				token.line,
				token.column,
				token.text);
			nextToken(); // set or get
		}
		var name:Node = Node.create(AS3NodeKind.NAME,
			token.line,
			token.column,
			token.text);
		nextToken(); // name
		var params:Node = parseParameterList();
		var returnType:Node = parseOptionalType();
		
		return [type, name, params, returnType];
	}
	
	private function findFunctionTypeFromSignature(signature:Array):String // NodeKind
	{
		for each (var node:Node in signature)
		{
			if (node.isKind(AS3NodeKind.TYPE))
			{
				if (node.stringValue == "set")
				{
					return AS3NodeKind.SET;
				}
				if (node.stringValue == "get")
				{
					return AS3NodeKind.GET;
				}
				return AS3NodeKind.FUNCTION;
			}
		}
		return AS3NodeKind.FUNCTION;
	}
	
	/**
	 * Get the next token Skip comments and newlines for now In the end we want
	 * to keep them though.
	 * 
	 * @throws TokenException
	 */
	override public function nextToken():void
	{
		do
		{
			nextTokenAllowNewLine();
		}
		while (token.text == NEW_LINE);
	}	
	
	/**
	 * Get the next token Skip comments but keep newlines We need this method for
	 * beeing able to decide if a returnStatement has an expression
	 * 
	 * @throws NullTokenError
	 */
	private function nextTokenAllowNewLine():void
	{
		do
		{
			token = scanner.nextToken();
			
			if (token == null)
			{
				throw new NullTokenError(fileName);
			}
			if (token.text == null)
			{
				throw new NullTokenError(fileName);
			}
		}
		while (tokenStartsWith(SINGLE_LINE_COMMENT));
	}	
	
	private function nextTokenIgnoringAsDoc():void
	{
		do
		{
			nextToken();
		}
		while (tokenStartsWith(MULTIPLE_LINES_COMMENT));
	}
}
}