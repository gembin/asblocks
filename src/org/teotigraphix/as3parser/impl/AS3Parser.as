////////////////////////////////////////////////////////////////////////////////
// Copyright 2010 Michael Schmalle - Teoti Graphix, LLC
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
// http://www.apache.org/licenses/LICENSE-2.0 
// 
// Unless required by applicable law or agreed to in writing, software 
// distributed under the License is distributed on an "AS IS" BASIS, 
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and 
// limitations under the License
// 
// Author: Michael Schmalle, Principal Architect
// mschmalle at teotigraphix dot com
////////////////////////////////////////////////////////////////////////////////

package org.teotigraphix.as3parser.impl
{

import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.api.IScanner;
import org.teotigraphix.as3parser.api.ISourceCodeScanner;
import org.teotigraphix.as3parser.api.KeyWords;
import org.teotigraphix.as3parser.api.Operators;
import org.teotigraphix.as3parser.core.LinkedListToken;
import org.teotigraphix.as3parser.core.LinkedListTreeAdaptor;
import org.teotigraphix.as3parser.core.Node;
import org.teotigraphix.as3parser.core.TokenNode;
import org.teotigraphix.asblocks.utils.ASTUtil;

/**
 * A port of the Java PMD de.bokelberg.flex.parser.AS3Parser.
 * 
 * <p>Initial Implementation; Adobe Systems, Incorporated</p>
 * 
 * @author Michael Schmalle LinkedList implementation
 */
public class AS3Parser extends ParserBase
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
	public function AS3Parser()
	{
		super();
		
		adapter = new LinkedListTreeAdaptor();
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
			result.addChild(parseASdoc());
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
		var result:TokenNode = ASTUtil.newParentheticAST(
			AS3NodeKind.CONTENT,
			AS3NodeKind.LCURLY, "{",
			AS3NodeKind.RCURLY, "}") as TokenNode;
		result.line = token.line;
		result.column = token.column;
		
		var internalParse:Boolean = tokIs("class") || tokIs("function");
		
		if (!internalParse)
		{
			consumeWS(Operators.LEFT_CURLY_BRACKET, result);
		}
		
		var pendingType:TokenNode = adapter.empty(AS3NodeKind.PRIMARY, token);
		/*
		Create placeholders
		compilation-unit
		  - package
		    - as-doc
		    - name
		    - content
		      
		      - class
		        - meta-list
		        - as-doc
		        - mod-list
		        - name
		        - extends
		        - implements
		        - content
		*/
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
				pendingType.addChild(parseMetaData());
			}
			else if (tokenStartsWith(ASDOC_COMMENT))
			{
				pendingType.appendToken(adapter.createToken(
					AS3NodeKind.AS_DOC, token.text));
				
				currentAsDoc = parseASdoc();
			}
			else if (tokIs(KeyWords.CLASS))
			{
				result.addChild(parseClass(pendingType));
			}
			else if (tokIs(KeyWords.INTERFACE))
			{
				result.addChild(parseInterface(pendingType));
			}
			else if (tokIs(KeyWords.FUNCTION))
			{
				result.addChild(parseClassFunction(pendingType));
			}
			else
			{
				if (!tokIsWhitespace())
				{
					pendingType.addChild(adapter.copy(
						AS3NodeKind.MODIFIER, token));
				}
				
				nextNonWhiteSpaceToken(pendingType);
			}
		}
		
		if (!internalParse)
		{
			consumeWS(Operators.RIGHT_CURLY_BRACKET, result, false);
		}
		
		return result;
	}
	
	/**
	 * @private
	 */
	private function parseClass(result:TokenNode):TokenNode
	{
		addAsDoc(result);
		
		result.kind = AS3NodeKind.CLASS;
		result.line = token.line;
		result.column = token.column;
		
		consume(KeyWords.CLASS, result);
		
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
		
		result.addChild(parseTypeContent());
		
		return result;
	}
	
	/**
	 * @private
	 */
	private function parseInterface(result:TokenNode):TokenNode
	{
		result.kind = AS3NodeKind.INTERFACE;
		result.line = token.line;
		result.column = token.column;
		
		consume(KeyWords.INTERFACE, result);
		
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
		
		result.addChild(parseTypeContent());
		
		return result;
	}
	
	/**
	 * @private
	 */
	internal function parseTypeContent():TokenNode
	{
		var result:TokenNode = ASTUtil.newParentheticAST(
			AS3NodeKind.CONTENT,
			AS3NodeKind.LCURLY, "{",
			AS3NodeKind.RCURLY, "}") as TokenNode;
		result.line = token.line;
		result.column = token.column;
		
		consumeWS(Operators.LEFT_CURLY_BRACKET, result);
		
		var pendingMember:TokenNode = adapter.empty(AS3NodeKind.PRIMARY, token);
		
		while (!tokIs(Operators.RIGHT_CURLY_BRACKET))
		{
			if (tokenStartsWith(ASDOC_COMMENT))
			{
				var current:TokenNode = (pendingMember) ? pendingMember : result;
				current.appendToken(adapter.createToken(
					AS3NodeKind.AS_DOC, token.text));
				currentAsDoc = parseASdoc();
				nextNonWhiteSpaceToken(current);
			}
			else if (tokIs(KeyWords.INCLUDE))
			{
				result.addChild(parseInclude());
			}
			else if (tokIs(KeyWords.IMPORT))
			{
				result.addChild(parseImport());
			}
			else if (tokIs(Operators.LEFT_SQUARE_BRACKET))
			{
				pendingMember.addChild(parseMetaData());
			}
			else if (tokIs(KeyWords.VAR))
			{
				result.addChild(parseClassField(pendingMember));
				pendingMember = null;
			}
			else if (tokIs(KeyWords.CONST))
			{
				result.addChild(parseClassConstant(pendingMember));
				pendingMember = null;
			}
			else if (tokIs(KeyWords.FUNCTION))
			{
				result.addChild(parseClassFunction(pendingMember));
				pendingMember = null;
			}
			else
			{
				var isWhitespace:Boolean = tokIsWhitespace();
				if (!isWhitespace)
				{
					if (!pendingMember)
					{
						pendingMember = adapter.empty(AS3NodeKind.PRIMARY, token);
					}
					
					addAsDoc(pendingMember);
					
					pendingMember.addChild(adapter.copy(
						AS3NodeKind.MODIFIER, token));
				}
				
				nextNonWhiteSpaceToken(pendingMember);
			}
		}
		
		consumeWS(Operators.RIGHT_CURLY_BRACKET, result, false);
		
		return result;
	}
	
	/**
	 * @private
	 */
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
	
	/**
	 * @private
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
		return buffer;
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
	internal function parseImport():TokenNode
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
	
	/**
	 * @private
	 */
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
	
	/**
	 * @private
	 */
	private function parseMetaDataParameterList():Node
	{
		var result:TokenNode = ASTUtil.newParentheticAST(
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
			}
			else
			{
				break;
			}
		}
		
		consumeWS(Operators.RIGHT_PARENTHESIS, result);
		
		return result;
	}
	
	/**
	 * @private
	 */
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
	
	/**
	 * @private
	 */
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
	
	/**
	 * @private
	 */
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
	
	/**
	 * @private
	 */
	private function parseClassField(result:TokenNode):TokenNode
	{
		result.kind = AS3NodeKind.VAR_LIST;
		var mod:LinkedListToken = findToken(result.token, AS3NodeKind.MODIFIER);
		if (mod)
		{
			result.line = mod.line;
			result.column = mod.column;
		}
		result = parseVarList(result);
		skip(Operators.SEMI_COLUMN, result);
		return result;
	}
	
	/**
	 * @private
	 */
	private function parseClassConstant(result:TokenNode):TokenNode
	{
		result.kind = AS3NodeKind.CONST_LIST;
		var mod:LinkedListToken = findToken(result.token, AS3NodeKind.MODIFIER);
		if (mod)
		{
			result.line = mod.line;
			result.column = mod.column;
		}
		result = parseConstList(result);
		skip(Operators.SEMI_COLUMN, result);
		return result;
	}
	
	/**
	 * @private
	 */
	private function parseClassFunction(result:TokenNode):TokenNode
	{
		if (!result)
		{
			result = adapter.copy(AS3NodeKind.FUNCTION, token);
		}
		
		result.kind = AS3NodeKind.FUNCTION;
		var mod:LinkedListToken = findToken(result.token, AS3NodeKind.MODIFIER);
		if (mod)
		{
			result.line = mod.line;
			result.column = mod.column;
		}
		
		consume(KeyWords.FUNCTION, result);
		parseFunction(result);
		
		return result;
	}
	
	/**
	 * @private
	 */
	private function parseConstList(result:TokenNode):TokenNode
	{
		if (!result)
		{
			result = adapter.copy(AS3NodeKind.CONST_LIST, token);
		}
		
		consume(KeyWords.CONST, result);
		collectVarListContent(result);
		
		return result;
	}
	
	/**
	 * @private
	 */
	private function parseVarList(result:TokenNode):TokenNode
	{
		if (!result)
		{
			result = adapter.copy(AS3NodeKind.VAR_LIST, token);
		}
		
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
					// FIXME 
				else if (!tokIs(Operators.COMMA)
					&& !tokIs(Operators.RIGHT_PARENTHESIS))
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
			result = parseType() as TokenNode;
		}
		
		return result;
	}
	
	/**
	 * @private
	 */
	internal function parseType():IParserNode
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
	internal function parseName():IParserNode
	{
		var result:TokenNode = adapter.create(
			AS3NodeKind.NAME, parseQualifiedName());
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
	
	/**
	 * @private
	 */
	private function findToken(token:LinkedListToken, kind:String):LinkedListToken
	{
		var next:LinkedListToken = token;
		while (next)
		{
			if (next.kind == kind)
				return next;
			
			next = next.next;
		}
		return null;
	}
	
	private function parseFunction(result:TokenNode):TokenNode
	{
		if (tokIs(KeyWords.GET) || tokIs(KeyWords.SET))
		{
			result.kind = token.text;
			consume(result.kind, result);
		}
		else
		{
			result.kind = AS3NodeKind.FUNCTION;
		}
		
		result.addChild(adapter.copy(AS3NodeKind.NAME, token));
		
		nextNonWhiteSpaceToken(result);
		
		result.addChild(parseParameterList());
		result.addChild(parseOptionalType(result));
		
		if (tokIs(Operators.SEMI_COLUMN))
		{
			consume(Operators.SEMI_COLUMN, result);
			return result;
		}
		
		nextNonWhiteSpaceToken(result);
		
		if (!tokIs(Operators.LEFT_CURLY_BRACKET))
		{
			return result;
		}
		
		result.addChild(parseBlock());
		
		// if not a package function, need this to exit package content
		if (!tokIs(Operators.RIGHT_CURLY_BRACKET))
		{
			nextNonWhiteSpaceToken(result);
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
				|| !isNaN(parseFloat(token.text))
				|| tokIs("NaN"))
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
		var result:TokenNode = ASTUtil.newParentheticAST(
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
		var result:TokenNode = ASTUtil.newParentheticAST(
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
		var result:TokenNode = ASTUtil.newParentheticAST(
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
		var result:TokenNode = ASTUtil.newParentheticAST(
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
			consume(Operators.REST_PARAMETERS, result);
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
			result = ASTUtil.newParentheticAST(
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
		var result:TokenNode = ASTUtil.newParentheticAST(
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
		else if (tokIs(KeyWords.BREAK))
		{
			result = parseBreakStatement();
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
				init.addChild(parseVarList(null));
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
		consumeWhitespace(result);
		result.addChild(parseStatement());
		consumeWhitespace(result);
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
		var result:TokenNode = ASTUtil.newParentheticAST(
			AS3NodeKind.CONDITION,
			AS3NodeKind.LPAREN, "(",
			AS3NodeKind.RPAREN, ")") as TokenNode;
		result.line = token.line;
		result.column = token.column;
		
		consumeWS(Operators.LEFT_PARENTHESIS, result);
		result.addChild(parseExpression());
		consumeWS(Operators.RIGHT_PARENTHESIS, result, false);
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
		
		consume(KeyWords.RETURN, result);
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
	private function parseBreakStatement():TokenNode
	{
		var result:TokenNode = adapter.empty(
			AS3NodeKind.BREAK, token);
		consume(KeyWords.BREAK, result);
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
		var result:TokenNode = adapter.empty(
			AS3NodeKind.SWITCH_BLOCK, token);
		
		while (!tokIs(KeyWords.CASE)
			&& !tokIs(KeyWords.DEFAULT) 
			&& !tokIs(Operators.RIGHT_CURLY_BRACKET))
		{
			result.addChild(parseStatement());
			consumeWhitespace(result);
		}
		return result;
	}
	
	/**
	 * @private
	 */
	private function parseDo():TokenNode
	{
		var result:TokenNode = adapter.empty(
			AS3NodeKind.DO, token);
		
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
		var result:TokenNode = adapter.empty(
			AS3NodeKind.WHILE, token);
		
		consume(KeyWords.WHILE, result);
		result.addChild(parseCondition());
		consumeWhitespace(result);
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
		var result:TokenNode = parseVarList(null);
		skip(Operators.SEMI_COLUMN, result);
		return result;
	}
	
	/**
	 * @private
	 */
	private function parseConst():TokenNode
	{
		var result:TokenNode = parseConstList(null);
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
		
		consume(token.text, null, false);
		
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
	
	internal function parseMetaDatas():IParserNode
	{
		return parseTypeContent();
	}
	
	internal function parseMembers(kind:String):IParserNode
	{
		return parseTypeContent();
	}
	
	internal function parseConstants():IParserNode
	{
		return parseMembers(AS3NodeKind.CONST);
	}
	
	internal function parseVariables():IParserNode
	{
		return parseMembers(AS3NodeKind.VAR);
	}
	
	internal function parseMethods():IParserNode
	{
		return parseMembers(AS3NodeKind.FUNCTION);
	}
}
}