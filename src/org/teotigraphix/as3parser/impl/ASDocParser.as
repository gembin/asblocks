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

import mx.utils.StringUtil;

import org.teotigraphix.as3parser.api.ASDocNodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.api.IScanner;
import org.teotigraphix.as3parser.core.ASDocLinkedListTreeAdaptor;
import org.teotigraphix.as3parser.core.LinkedListToken;
import org.teotigraphix.as3parser.core.TokenNode;

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
	public static const ML_COMMENT_START:String = "/**";
	
	/**
	 * @private
	 */
	public static const ML_COMMENT_END:String = "*/";
	
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
	
	/**
	 * @private
	 */
	public static const DOT_NL:String = ".\n";
	
	//--------------------------------------------------------------------------
	//
	// Public :: Constants
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private var _consumingRight:Boolean = false;
	
	/**
	 * @private
	 */
	//private var _shortListFound:Boolean = false;
	
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
		
		adapter = new ASDocLinkedListTreeAdaptor();
	}
	
	override protected function consumeWhitespace(node:TokenNode):Boolean
	{
		return false;
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
		_consumingRight = false;
		
		consume(ML_COMMENT_START, result);
		result.addChild(parseContent());
		consume(ML_COMMENT_END, result);
		
		// HACK
		// */ " " /n
		result.stopToken.previous.previous.channel = "hidden";
		
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
			_consumingRight = true;
		}
		
		if (token.text == NL || token.text == DOT_NL)
		{
			_consumingRight = false;
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
		_consumingRight = false;
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
	internal function parseContent():TokenNode
	{
		var result:TokenNode = adapter.empty(ASDocNodeKind.CONTENT, token);
		// token after /**
		// if the token is not valid, move to next valid token
		// this should just advance the parser to the first identifier right of
		// the astrix, or if just a single line comment, make the next token
		// valid by setting _rightSideOfAtrix = true
		if (!tokIsValid())
			consumeRight(result);
		
		while (!tokIs(ML_COMMENT_END))
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
		
		return result;
	}
	
	private function nextTokenAppend(node:TokenNode):void
	{
		var token:LinkedListToken = adapter.createToken(
			token.text, token.text,
			token.line, token.column);
		
		if (!spaceFound)
			token.channel = "hidden";
		else
			token.channel = "real";
		
		node.appendToken(token);
		
		nextToken();
	}
	
	//----------------------------------
	// body
	//----------------------------------
	
	/**
	 * @private
	 */
	internal function parseBody():TokenNode
	{
		var result:TokenNode = adapter.empty(ASDocNodeKind.BODY, token);
		
		if (!tokIsValid())
			consumeRight(result);
		
		while (!tokIs(AT) && !tokIs(ML_COMMENT_END))
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
	internal function parseText():TokenNode
	{
		var line:int = token.line;
		var column:int = token.column;
		
		var text:String = "";
		
		var result:TokenNode = adapter.create(ASDocNodeKind.TEXT, null, line, column);
		
		
		while (!tokIs(ML_COMMENT_END) && !tokIs(AT) && !tokIs("<code")
			&& !tokIs("<pre") && !tokIs("<listing"))
		{
			if (tokIsValid() && !tokIs(ASTRIX))
			{
				text += token.text;
			}
			
			if (tokIs(NL))
			{
				nextTokenAppend(result);
				consumeRight(result);
			}
			else
			{
				nextTokenAppend(result);
			}
		}
		
		if (StringUtil.trim(text).length == 0)
		{
			return null;
		}
		
		return result;
	}
	
	//----------------------------------
	// code-text
	//----------------------------------
	
	/**
	 * @private
	 */
	internal function parseCodeText():TokenNode
	{
		var line:int = token.line;
		var column:int = token.column;
		var result:TokenNode = adapter.create(ASDocNodeKind.CODE_TEXT, text, line, column);
		var text:String = "";
		
		consume("<code", result);
		consume(">", result);
		
		// token : <code
		while (!tokIs(DOT_NL) && !tokIs("</") && !tokIs(ML_COMMENT_END))
		{
			text += token.text;
			nextTokenAppend(result);
		}
		
		consume("</", result);
		consume("code", result);
		consume(">", result);
		
		return result;
	}
	
	//----------------------------------
	// pre-text
	//----------------------------------
	
	/**
	 * @private
	 */
	internal function parsePreText(name:String):TokenNode
	{
		var line:int = token.line;
		var column:int = token.column;
		
		var text:String = "";
		
		consume("<" + name);
		
		// eat attributes
		while (!tokIs(">"))
		{
			nextToken();
		}
		
		consume(">");
		
		var skip:Boolean = false;
		
		// token : <pre
		while (!tokIs(ML_COMMENT_END))
		{
			if (tokIs("</"))
			{
				consume("</");
				if (tokIs(name))
				{
					skip = true;
					break;
				}
				else
				{
					text += token.text;
				}
			}
			
			if (_consumingRight || tokIs(NL))
			{
				text += token.text;
			}
			
			nextTokenEatRightPre();
		}
		
		if (!skip)
		{
			consume("</");
		}
		
		consume(name);
		consume(">");
		
		var result:TokenNode = adapter.create(ASDocNodeKind.PRE_TEXT, text, line, column);
		
		return result;
	}
	
	//----------------------------------
	// doctag-list
	//----------------------------------
	
	/**
	 * @private
	 */
	internal function parseDocTagList():TokenNode
	{
		// token @
		var result:TokenNode = adapter.empty(ASDocNodeKind.DOCTAG_LIST, token);

		while (!tokIs(ML_COMMENT_END) && !tokIs("__END__"))
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
	internal function parseDocTag():TokenNode
	{
		var result:TokenNode = adapter.empty(ASDocNodeKind.DOCTAG, token);
		
		consume(AT, result);
		
		while (!tokIs(AT) && !tokIs(ML_COMMENT_END))
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
					consumeRight(result);
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
	internal function parseDocTagName():TokenNode
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
	internal function parseDocTagBody():TokenNode
	{
		var result:TokenNode = adapter.empty(ASDocNodeKind.BODY, token);
		
		while (!tokIs(AT) && !tokIs(ML_COMMENT_END))
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
		
		//if (result.numChildren == 0)
		//{
		//	return null;
		//}
		
		return result;
		
	}
	
	private var spaceFound:Boolean = false;
	
	/**
	 * @private
	 */
	private function consumeRight(node:TokenNode):void
	{
		spaceFound = false;
		
		do
		{
			if (tokIs(ML_COMMENT_END))
			{
				break;
			}
			
			if (token.text == ASTRIX)
			{
				_consumingRight = true;
				spaceFound = false;
			}
			
			if (_consumingRight && token.text == SPACE)
			{
				spaceFound = true;
				break;
			}
			
			if (token.text == NL)
			{
				_consumingRight = false;
			}
			
			if (isIdentifierCharacter(token.text))
			{
				_consumingRight = true;
				break;
			}
			
			nextTokenAppend(node);
		}
		while (!_consumingRight
			|| ((_consumingRight && token.text == ASTRIX) || !spaceFound));
	}
	
	/**
	 * @private
	 */
	private function nextTokenEatRightPre():void
	{
		do
		{
			nextToken();
			
			if (tokIs("</"))
			{
				break; // Special case where the pre ends the comment
			}
			
			if (token.text == NL || token.text == DOT_NL)
			{
				_consumingRight = false;
				break; // <pre> needs newlines
			}
			
			if (!_consumingRight)
			{
				if (token.text == ASTRIX)
				{
					nextToken(); // " "
					_consumingRight = true;
					if (tokIs(SPACE))
					{
						nextToken(); // start of pre text on the newline
						// specail case where there is an empty line under
						if (token.text == NL)
						{
							break;
						}
					}
				}
			}
		}
		while (!_consumingRight);
	}
	
	/**
	 * @private
	 */
	protected function tokIsValid():Boolean
	{
		if (!_consumingRight && isIdentifierCharacter(token.text))
			_consumingRight = true;
		
		return _consumingRight;
	}
	
	protected function isIdentifierCharacter(currentCharacter:String):Boolean
	{
		return (currentCharacter != " " && currentCharacter != "*"
			&& currentCharacter != ".\n" && currentCharacter != "\n");
	}
}
}