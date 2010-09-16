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

import org.teotigraphix.as3parser.api.ASDocNodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.api.IScanner;
import org.teotigraphix.as3parser.api.KeyWords;
import org.teotigraphix.as3parser.core.LinkedListToken;
import org.teotigraphix.as3parser.core.LinkedListTreeAdaptor;
import org.teotigraphix.as3parser.core.TokenNode;
import org.teotigraphix.asblocks.impl.TokenBuilder;
import org.teotigraphix.asblocks.utils.ASTUtil;

/**
 * The default implementation of an asdoc comment parser.
 *
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class ASDocParser extends ParserBase
{
	//--------------------------------------------------------------------------
	//
	// Public :: Constants
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	public static const NL:String = "\n";
	
	/**
	 * @private
	 */
	public static const TAB:String = "\t";
	
	/**
	 * @private
	 */
	public static const SPACE:String = " ";
	
	/**
	 * @private
	 */
	public static const ML_START:String = "/**";
	
	/**
	 * @private
	 */
	public static const ML_END:String = "*/";
	
	/**
	 * @private
	 */
	public static const AT:String = "@";
	
	/**
	 * @private
	 */
	public static const ASTRIX:String = "*";
	
	/**
	 * @private
	 */
	public static const DOT:String = ".";
	
	//--------------------------------------------------------------------------
	//
	// Public :: Constants
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private var spaceFound:Boolean = false;
	
	/**
	 * @private
	 */
	private var _consumedLeft:Boolean = false;
	
	/**
	 * @private
	 */
	private var _bodyFound:Boolean = false;
	
	//--------------------------------------------------------------------------
	//
	// Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function ASDocParser()
	{
		super();
		
		adapter = new LinkedListTreeAdaptor();
	}
	
	//--------------------------------------------------------------------------
	//
	// Overridden Public :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	override public function parseCompilationUnit():IParserNode
	{
		var result:TokenNode = adapter.create(ASDocNodeKind.COMPILATION_UNIT);
		
		nextToken();
		if (token.text == "/") // didn't find /** just /*
		{
			return result; // is the AS3Parser really saving /* comments? check
		}
		
		_bodyFound = false;
		_consumedLeft = false;
		
		result.addChild(parseContent());
		
		return result;
	}
	
	/**
	 * @private
	 */
	override public function nextToken():void
	{
		super.nextToken();
		
		if (token.text == ASTRIX)
		{
			_consumedLeft = true;
		}
		
		if (token.text == NL)
		{
			_consumedLeft = false;
		}
	}
	
	//--------------------------------------------------------------------------
	//
	// Overridden Protected :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	override protected function createScanner():IScanner
	{
		return new ASDocScanner();
	}
	
	/**
	 * @private
	 */
	override protected function initialize():void
	{
		_bodyFound = false;
		_consumedLeft = false;
	}
	
	/**
	 * @private
	 */
	override protected function consumeWhitespace(node:TokenNode):Boolean
	{
		return false;
	}
	
	//--------------------------------------------------------------------------
	//
	// Internal Parse :: Methods
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	// content
	//----------------------------------
	
	/**
	 * @private
	 */
	public function parseContent():TokenNode
	{
		var result:TokenNode = ASTUtil.newParentheticAST(
			ASDocNodeKind.DESCRIPTION,
			ASDocNodeKind.ML_START, "/**", 
			ASDocNodeKind.ML_END, "*/") as TokenNode;
		
		consume(ML_START); // /**
		
		// token after /**
		// if the token is not valid, move to next valid token
		// this should just advance the parser to the first identifier right of
		// the astrix, or if just a single line comment, make the next token
		// valid by setting _consumedLeft = true
		if (!tokIsValid())
			consumeLeft(result);
		
		while (!tokIs(ML_END))
		{
			if (token.text == AT)
			{
				_bodyFound = true;
				
				result.addChild(parseDocTagList());
			}
			else if (!_bodyFound)
			{
				result.addChild(parseBody());
			}
			else
			{
				nextTokenAppend(result);
			}
		}
		
		consume(ML_END); // */
		
		// HACK
		// */ " " /n
		result.stopToken.previous.previous.channel = "hidden";
		
		return result;
	}
	
	//----------------------------------
	// body
	//----------------------------------
	
	/**
	 * @private
	 * TODO Make this internal
	 */
	public function parseBody():TokenNode
	{
		var result:TokenNode = adapter.empty(ASDocNodeKind.BODY, token);
		
		if (!tokIsValid())
			consumeLeft(result);
		
		while (!tokIs(KeyWords.EOF) && !tokIs(ML_END) && !tokIs(AT))
		{
			if (tokIsValid())
			{
				if (token.text == "<code")
				{
					result.addChild(parseCodeText());
				}
				else if (token.text == "<pre")
				{
					result.addChild(parsePreText("pre"));
				}
				else if (token.text == "<listing")
				{
					result.addChild(parsePreText("listing"));
				}
				else
				{
					result.addChild(parseText());
				}
			}
			else
			{
				nextTokenAppend(result);
			}
		}
		
		_bodyFound = true;
		
		return result;
	}
	
	/**
	 * @private
	 */
	private function parseText():TokenNode
	{
		var result:TokenNode = adapter.empty(ASDocNodeKind.TEXT_BLOCK, token);
		
		var text:String = "";
		
		while (!tokIs(KeyWords.EOF) && !tokIs(ML_END) && !tokIs(AT) 
			&& !tokIs("<code") && !tokIs("<pre") && !tokIs("<listing"))
		{
			if (tokIsValid() && !tokIs(ASTRIX))
			{
				text += token.text;
			}
			else
			{
				appendToken(result, ASDocNodeKind.TEXT, token.text);
			}
			
			nextToken();
			
			if (tokIs(NL))
			{
				if (text != "")
				{
					result.addChild(adapter.create(ASDocNodeKind.TEXT, text));
				}
				
				text = "";
				
				var nl:TokenNode = adapter.create("nl");
				nl.appendToken(TokenBuilder.newNewline())
				result.addChild(nl);
				
				nextToken();
				
				consumeLeft(result);
			}
		}
		
		if (text != "")
		{
			result.addChild(adapter.create(ASDocNodeKind.TEXT, text));
		}
		
		return result;
	}
	
	//----------------------------------
	// code-text
	//----------------------------------
	
	/**
	 * @private
	 */
	private function parseCodeText():TokenNode
	{
		var result:TokenNode = adapter.empty(ASDocNodeKind.CODE_BLOCK, token);
		
		var text:String = "";
		
		consume("<code");
		consume(">");
		
		appendToken(result, ASDocNodeKind.TEXT, "<code>");
		
		while (!tokIs(KeyWords.EOF) && !tokIs(ML_END) && !tokIs("</"))
		{
			text += token.text;
			nextToken();
		}
		
		if (text != "")
		{
			result.addChild(adapter.create(ASDocNodeKind.TEXT, text));
		}
		
		consume("</");
		consume("code");
		consume(">");
		
		appendToken(result, ASDocNodeKind.TEXT, "</code>");
		
		return result;
	}
	
	//----------------------------------
	// pre-text
	//----------------------------------
	
	/**
	 * @private
	 */
	private function parsePreText(name:String):TokenNode
	{
		var result:TokenNode = adapter.create("pre-block", 
			text, token.line, token.column);
		
		var text:String = "";
		
		var buffer:String = "<" + name;
		nextToken(); // <name
		
		// eat attributes
		while (!tokIs(">"))
		{
			buffer += token.text;
			nextToken();
		}
		
		buffer += ">";
		nextToken(); // >
		
		result.appendToken(TokenBuilder.newToken(ASDocNodeKind.TEXT, buffer));
		
		buffer = "";
		
		var skip:Boolean = false;
		
		// token : <pre
		while (!tokIs(ML_END))
		{
			if (tokIs("</"))
			{
				nextToken(); // </"
				if (tokIs(name))
				{
					buffer += "</";
					skip = true;
					break;
				}
				else
				{
					text += token.text;
				}
			}
			
			
			text += token.text;
			nextToken();
			
			//if (_consumedLeft || tokIs(NL))
			//{
			//	text += token.text;
			//}
			
			//consumeLeftPre(result);
		}
		
		if (text != "")
		{
			result.addChild(adapter.create(ASDocNodeKind.TEXT, text));
		}
		
		if (!skip)
		{
			buffer = "</";
			nextToken(); // </
		}
		
		nextToken(); // name
		nextToken(); // >
		buffer += name + ">";
		
		result.appendToken(TokenBuilder.newToken(ASDocNodeKind.TEXT, buffer));
		
		return result;
	}
	
	//----------------------------------
	// doctag-list
	//----------------------------------
	
	/**
	 * @private
	 */
	private function parseDocTagList():TokenNode
	{
		// token @
		var result:TokenNode = adapter.empty(ASDocNodeKind.DOCTAG_LIST, token);

		while (!tokIs(ML_END) && !tokIs("__END__"))
		{
			result.addChild(parseDocTag());
		}
		
		return result;
	}
	
	//----------------------------------
	// doctag
	//----------------------------------
	
	/**
	 * @private
	 */
	private function parseDocTag():TokenNode
	{
		var result:TokenNode = adapter.empty(ASDocNodeKind.DOCTAG, token);
		
		consume(AT, result);
		
		while (!tokIs(AT) && !tokIs(ML_END))
		{
			if (tokIsValid())
			{
				result.addChild(parseDocTagName());
				
				if (!tokIs(NL))
				{
					var body:TokenNode = parseDocTagBody();
					if (body != null)
					{
						result.addChild(body);
					}
				}
				else
				{
					consumeLeft(result);
				}
			}
			else
			{
				nextToken();
			}
		}
		
		return result;
	}
	
	//----------------------------------
	// doctag-name
	//----------------------------------
	
	/**
	 * @private
	 */
	private function parseDocTagName():TokenNode
	{
		var result:TokenNode = adapter.copy(ASDocNodeKind.NAME, token);
		
		nextToken(); // the doctag name
		
		return result;
	}
	
	//----------------------------------
	// doctag-body
	//----------------------------------
	
	/**
	 * @private
	 */
	private function parseDocTagBody():TokenNode
	{
		var result:TokenNode = adapter.empty(ASDocNodeKind.BODY, token);
		
		while (!tokIs(AT) && !tokIs(ML_END))
		{
			if (token.text == "<code")
			{
				result.addChild(parseCodeText());
			}
			else if (token.text == "<pre")
			{
				result.addChild(parsePreText("pre"));
			}
			else if (token.text == "<listing")
			{
				result.addChild(parsePreText("listing"));
			}
			else
			{
				result.addChild(parseText());
			}
		}
		
		return result;
		
	}
	
	/**
	 * @private
	 */
	private function consumeLeft(node:TokenNode):void
	{
		spaceFound = false;
		
		do
		{
			if (tokIs(ML_END) || tokIs(KeyWords.EOF))
			{
				break;
			}
			
			if (token.text == ASTRIX)
			{
				_consumedLeft = true;
				spaceFound = false;
			}
			
			if (_consumedLeft && token.text == SPACE)
			{
				spaceFound = true;
				break;
			}
			
			if (token.text == NL)
			{
				_consumedLeft = false;
			}
			
			if (isIdentifierCharacter(token.text))
			{
				_consumedLeft = true;
				break;
			}
			
			nextTokenAppend(node);
		}
		while (!_consumedLeft
			|| ((_consumedLeft && token.text == ASTRIX) || !spaceFound));
	}
	
	/**
	 * @private
	 */
	private function consumeLeftPre(node:TokenNode):void
	{
		do
		{
			nextToken();
			
			if (tokIs("</"))
			{
				break; // Special case where the pre ends the comment
			}
			
			if (token.text == NL)
			{
				_consumedLeft = false;
				break; // <pre> needs newlines
			}
			
			if (!_consumedLeft)
			{
				nextTokenAppend(node);
				if (token.text == ASTRIX)
				{
					//nextToken(); // " "
					//nextTokenAppend(node);
					_consumedLeft = true;
					if (tokIs(SPACE))
					{
						//nextToken(); // start of pre text on the newline
						// specail case where there is an empty line under
						if (token.text == NL)
						{
							break;
						}
					}
				}
			}
		}
		while (!_consumedLeft);
	}
	
	/**
	 * @private
	 */
	private function appendToken(node:TokenNode, kind:String, text:String):LinkedListToken
	{
		var token:LinkedListToken = adapter.createToken(
			kind, text,	token.line, token.column);
		
		node.appendToken(token);
		
		return token;
	}
	
	/**
	 * @private
	 */
	private function nextTokenAppend(node:TokenNode):void
	{
		var token:LinkedListToken = appendToken(node, token.text, token.text);
		
		if (!spaceFound)
			token.channel = "hidden";
		else
			token.channel = "real";
		
		nextToken();
	}
	
	/**
	 * @private
	 */
	protected function tokIsValid():Boolean
	{
		if (!_consumedLeft && isIdentifierCharacter(token.text))
			_consumedLeft = true;
		
		return _consumedLeft;
	}
	
	/**
	 * @private
	 */
	protected function isIdentifierCharacter(currentCharacter:String):Boolean
	{
		return (currentCharacter != " " && currentCharacter != "*"
			&& currentCharacter != ".\n" && currentCharacter != "\n"
			&& currentCharacter != "\t");
	}
}
}