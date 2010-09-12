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
import org.teotigraphix.as3parser.api.IParser;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.api.IScanner;
import org.teotigraphix.as3parser.api.KeyWords;
import org.teotigraphix.as3parser.core.LinkedListToken;
import org.teotigraphix.as3parser.core.LinkedListTreeAdaptor;
import org.teotigraphix.as3parser.core.Token;
import org.teotigraphix.as3parser.core.TokenNode;
import org.teotigraphix.as3parser.errors.NullTokenError;
import org.teotigraphix.as3parser.errors.Position;
import org.teotigraphix.as3parser.errors.UnExpectedTokenError;
import org.teotigraphix.asblocks.utils.FileUtil;

/**
 * The default base implementation of the IParser interface.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class ParserBase implements IParser
{
	//--------------------------------------------------------------------------
	//
	//  Protected :: Variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 * The current <code>Token</code> scanned by the <code>scanner</code>.
	 */
	protected var token:Token;
	
	/**
	 * The adapter.
	 */
	protected var adapter:LinkedListTreeAdaptor;
	
	//--------------------------------------------------------------------------
	//
	//  Public :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  scanner
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _scanner:IScanner;
	
	/**
	 * The scanner the parser uses internally.
	 */
	public function get scanner():IScanner
	{
		return _scanner;
	}
	
	//----------------------------------
	//  fileName
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _fileName:String;
	
	/**
	 * The fileName being parsed (if any).
	 */
	public function get fileName():String
	{
		return _fileName;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function ParserBase()
	{
		_scanner = createScanner();
	}
	
	//--------------------------------------------------------------------------
	//
	//  IParser API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.teotigraphix.as3parser.api.IParser#buildFileAst()
	 */
	public function buildFileAst(fileName:String):IParserNode
	{
		var lines:Vector.<String>;
		try
		{
			lines = FileUtil.readLines(fileName);
		}
		catch (e:Error)
		{
			throw e; // TODO different error
		}
		
		return parseLines(lines, fileName);
	}
	
	/**
	 * @copy org.teotigraphix.as3parser.api.IParser#buildAst()
	 */
	public function buildAst(lines:Vector.<String>, 
							 fileName:String):IParserNode
	{
		return parseLines(lines, fileName);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Public :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Parses and returns the root <code>IParserNode</code>.
	 * 
	 * <p><em>Override in subclasses.</em></p>
	 * 
	 * @return The root <code>IParserNode</code>.
	 */
	public function parseCompilationUnit():IParserNode
	{
		return null;
	}
	
	/**
	 * Retrieves the next Token from the scanner.
	 */
	public function nextToken():void
	{
		moveToNextToken();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Protected :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Parses and returns the <code>IParserNode</code> base compilation element.
	 * 
	 * @param lines A Vector of String lines to be parsed into an AST.
	 * @param filePath A String indicating the location of the source.
	 */
	protected function parseLines(lines:Vector.<String>, 
								  fileName:String):IParserNode
	{		
		_scanner = createScanner();
		_scanner.setLines(lines);
		
		_fileName = fileName;
		token = null;
		
		initialize();
		
		return parseCompilationUnit();
	}
	
	/**
	 * Creates the <code>IScanner</code> for the parser.
	 * 
	 * <p><em>Override in subclasses.</em></p>
	 * 
	 * @return An <code>IScanner</code> instance.
	 */
	protected function createScanner():IScanner
	{
		throw new Error("Must create IScanner by overridding ParserBase.createScanner()");
		return null;
	}
	
	/**
	 * Initializes the parser session.
	 * 
	 * <p><em>Override in subclasses.</em></p>
	 */
	protected function initialize():void
	{
	}
	
	/**
	 * Moves the parser's <code>token</code> to the next scanner Token.
	 * 
	 * <p>This method can be overridden in a subclass to enhance 
	 * functionality. The default behavior is to call 
	 * <code>scanner.nextToken()</code></p>
	 * 
	 * @throws NullTokenError
	 */
	protected function moveToNextToken():void
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
	
	/**
	 * Moves the parser's <code>token</code> to the next scanner Token that
	 * is not considered whitespace or a comment.
	 * 
	 * <p>If the node is not null, the parser will append those whitespace
	 * tokens to the node.</p>
	 * 
	 * @param node A TokenNode to add whitespace tokens to.
	 * @see #tokIsWhitespace()
	 */
	protected function nextNonWhiteSpaceToken(node:TokenNode):void
	{
		if (!consumeWhitespace(node))
		{
			nextToken();
			
			if (tokIs(" ") || tokIs("\t") || tokIs("\n") || tokenStartsWith("//")
				|| (tokenStartsWith("/*") && !tokenStartsWith("/**")))
			{
				nextNonWhiteSpaceToken(node);
			}
		}
	}
	
	/**
	 * Allows whitespace tokens to be retireved from the scanner.
	 * 
	 * @see #moveToNextToken()
	 */
	protected function nextTokenAllowWhiteSpace():void
	{
		scanner.allowWhiteSpace = true;
		moveToNextToken();
		scanner.allowWhiteSpace = false;
	}
	
	/**
	 * Skips the token if the <code>token.text</code> equals <code>text</code>.
	 * 
	 * @param text The String to skip.
	 */
	protected function skip(text:String, node:TokenNode = null):void
	{
		consumeWhitespace(node);
		
		if (tokIs(text))
		{
			if (node && node.stringValue != text)
			{
				append(node);
			}
			
			nextToken();
		}
		
		consumeWhitespace(node);
	}
	
	/**
	 * Returns whether the current parser token is whitespace.
	 * 
	 * @return A Boolean indicating if the current token is whitespace.
	 */
	protected function tokIsWhitespace():Boolean
	{
		return token.text == "\n" || token.text == "\t" || token.text == " "
			|| tokenStartsWith("/*") || tokenStartsWith("//");
	}
	
	/**
	 * Consumes the current text.
	 * 
	 * <p>If the current token's text does not equal text, an UnExpectedTokenError 
	 * is thrown.</p>
	 * 
	 * <p>If the token is consumed, the parser advances to the next token.</p>
	 * 
	 * @param text The text String to consume.
	 * @param node A TokenNode to append tokens to.
	 * @throws UnExpectedTokenError
	 */
	protected function consume(text:String, 
							   node:TokenNode = null, 
							   trim:Boolean = true):LinkedListToken
	{
		var consumed:LinkedListToken;
		
		consumeWhitespace(node);
		
		if (!tokIs(text))
		{
			throw new UnExpectedTokenError(
				text, 
				token.text, 
				new Position(token.line, token.column, -1), 
				fileName);
		}
		
		if (node && node.stringValue != text)
		{
			consumed = append(node);
		}
		
		nextToken();
		
		if (trim)
		{
			consumeWhitespace(node);
		}
		
		return consumed;
	}
	
	/**
	 * Checks for token equality and only appends whitespace tokens.
	 * 
	 * @param node A TokenNode to append whitespace tokens to.
	 */
	protected function consumeWS(text:String, 
								 node:TokenNode = null, 
								 trim:Boolean = true):void
	{
		consumeWhitespace(node);
		
		if (!tokIs(text))
		{
			throw new UnExpectedTokenError(
				text, 
				token.text, 
				new Position(token.line, token.column, -1), 
				fileName);
		}
		
		nextToken();
		
		if (trim)
		{
			consumeWhitespace(node);
		}
	}
	
	/**
	 * Consumes all whitespace up to a non whitespace token.
	 * 
	 * @param node A TokenNode to add whitespace tokens to.
	 * @return A Boolean indicating if whitespace was consumed.
	 */
	protected function consumeWhitespace(node:TokenNode):Boolean
	{
		if (!node || !token)
		{
			return false;
		}
		
		var advanced:Boolean = false;
		
		while (tokIs(" ") || tokIs("\t") || tokIs("\n") || tokenStartsWith("//")
			|| (tokenStartsWith("/*") && ! tokenStartsWith("/**")))
		{
			if (tokIs(" "))
			{
				appendSpace(node);
			}
			else if (tokIs("\t"))
			{
				appendTab(node);
			}
			else if (tokIs("\n"))
			{
				appendNewline(node);
			}
			else if (tokenStartsWith("//") 
				|| (tokenStartsWith("/*") && ! tokenStartsWith("/**")))
			{
				appendComment(node);
			}
			
			advanced = true;
		}
		
		return advanced;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Protected Final :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Compare the current <code>token.text</code> to <code>text</code>.
	 * 
	 * @param text A String to compare.
	 * @return A Boolean true, if token's text property equals the parameter.
	 */
	final protected function tokIs(text:String):Boolean
	{
		return token.text == text;
	}
	
	/**
	 * Returns whether the token starts with the String value.
	 * 
	 * @param value A String to test.
	 * @return A Boolean indicating whether the token's text starts with the
	 * value.
	 */
	final protected function tokenStartsWith(value:String):Boolean
	{
		return token.text.indexOf(value) == 0;
	}
	
	/**
	 * Trims quotes off a String.
	 * 
	 * @param value A String quoted.
	 * @return A new String with start and end trimmed.
	 */
	final protected function trimQuotes(value:String):String
	{
		return value.slice(1, value.length - 1);
	}
	
	/**
	 * @private
	 */
	protected function append(node:TokenNode):LinkedListToken
	{
		if (!node)
			return null;
		
		var token:LinkedListToken = adapter.createToken(
			token.text, token.text,
			token.line, token.column);
		
		node.appendToken(token);
		
		return token;
	}
	
	/**
	 * @private
	 */
	protected function appendSpace(node:TokenNode):void
	{
		if (!node || !scanner.allowWhiteSpace)
			return;
		
		if (node)
		{
			node.appendToken(
				adapter.createToken(AS3NodeKind.SPACE, " ",
					token.line, token.column));
		}
		
		nextToken();
	}
	
	/**
	 * @private
	 */
	protected function appendTab(node:TokenNode):void
	{
		if (!node || !scanner.allowWhiteSpace)
			return;
		
		if (node)
		{
			node.appendToken(
				adapter.createToken(AS3NodeKind.TAB, "\t",
					token.line, token.column));
		}
		
		nextToken();
	}
	
	/**
	 * @private
	 */
	protected function appendNewline(node:TokenNode):void
	{
		if (!node || !scanner.allowWhiteSpace)
			return;
		
		var tok:LinkedListToken;
		
		if (node)
		{
			tok = adapter.createToken("ws", "\n", 
				token.line, token.column);
		}
		
		nextToken();
		
		if (tok && !tokIs("__END__"))
		{
			node.appendToken(tok);
		}
	}
	
	/**
	 * @private
	 */
	protected function appendComment(node:TokenNode):void
	{
		if (!node)
			return;
		
		if (node)
		{
			node.appendToken(
				adapter.createToken(AS3NodeKind.COMMENT, token.text,
					token.line, token.column));
		}
		
		nextToken();
	}
}
}