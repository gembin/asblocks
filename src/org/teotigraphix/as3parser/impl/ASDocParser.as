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
import org.teotigraphix.as3parser.core.Node;

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
	//  Public :: Constants
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
	//  Public :: Constants
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private var _rightSideOfAtrix:Boolean = false;
	
	/**
	 * @private
	 */
	private var _shortListFound:Boolean = false;
	
	/**
	 * @private
	 */
	private var _longListFound:Boolean = false;
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function ASDocParser()
	{
		super();
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
		var result:Node =
			Node.create(ASDocNodeKind.COMPILATION_UNIT, -1, -1);
		
		nextToken();
		if (token.text == "/") // didn't find /** just /*
		{
			return result; // is the AS3Parser really saving /* comments? check
		}
		
		consume(ML_COMMENT_START);
		
		result.addChild(parseContent());
		
		consume(ML_COMMENT_END);
		
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
			_rightSideOfAtrix = true;
		}
		
		if (token.text == NL || token.text == DOT_NL)
		{
			_rightSideOfAtrix = false;
		}
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
		return new ASDocScanner();
	}
	
	/**
	 * @private
	 */
	override protected function initialize():void
	{
		_shortListFound = false;
		_longListFound = false;
		_rightSideOfAtrix = false;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Internal Parse :: Methods
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  content
	//----------------------------------
	
	/**
	 * @private
	 */
	internal function parseContent():Node
	{
		// token /**
		
		var result:Node =
			Node.create(ASDocNodeKind.CONTENT,
				token.line,
				token.column);
		
		while (!tokIs(ML_COMMENT_END))
		{
			if (token.text == AT)
			{
				_shortListFound = true;
				_longListFound = true;
				
				result.addChild(parseDocTagList());
			}
			else if (!_shortListFound)
			{
				result.addChild(parseShortList());
			}
			else if (!_longListFound)
			{
				result.addChild(parseLongList());
			}
			else
			{
				nextToken();
			}
		}
		
		return result;
	}
	
	
	//----------------------------------
	//  short-list
	//----------------------------------
	
	/**
	 * @private
	 */
	internal function parseShortList():Node
	{
		nextTokenEatRight();
		
		var result:Node =
			Node.create(ASDocNodeKind.SHORT_LIST,
				token.line,
				token.column);
		
		while (!tokIs(DOT_NL) && !tokIs(AT) && !tokIs(ML_COMMENT_END))
		{
			if (tokIsValid())
			{
				// TODO temp <listing
				if (token.text== "<code")
				{
					result.addChild(parseCodeText());
					
					if (!_shortListFound && tokIs(DOT_NL))
					{
						result.addChild(Node.create(ASDocNodeKind.TEXT,
							token.line,
							token.column,
							DOT));
						_shortListFound = true;
						break;
					}
				}
				else if (token.text == "<listing")
				{
					result.addChild(parsePreText("listing"));
				}
				else
				{
					result.addChild(parseText());
					
					if (!_shortListFound && tokIs(AT))
					{
						_shortListFound = true;
						break;
					}
				}
			}
			else
			{
				nextTokenEatRight();
			}
		}
		
		if (result.numChildren == 0)
		{
			return null;
		}
		
		// the "/**" or "@" happens when a short ends with a ". "
		if (!tokIs(ML_COMMENT_END) && !tokIs(AT))
		{
			consume(DOT_NL);
		}
		
		return result;
	}
	
	//----------------------------------
	//  long-list
	//----------------------------------
	
	/**
	 * @private
	 */
	internal function parseLongList():Node
	{
		nextTokenEatRight();
		
		var result:Node =
			Node.create(ASDocNodeKind.LONG_LIST,
				token.line,
				token.column);
		
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
				nextTokenEatRight();
			}
		}
		
		if (result.numChildren == 0)
		{
			return null;
		}
		
		_longListFound = true;
		
		return result;
	}
	
	/**
	 * @private
	 */
	internal function parseText():Node
	{
		var line:int = token.line;
		var column:int = token.column;
		
		var text:String = "";
		
		while (!tokIs(ML_COMMENT_END) && !tokIs(AT) && !tokIs("<code")
			&& !tokIs("<pre") && !tokIs("<listing"))
		{
			if (tokIsValid() && !tokIs(ASTRIX))
			{
				text += token.text;
			}
			
			nextToken();
			
			if (!_shortListFound && tokIs(DOT_NL))
			{
				text += DOT;
				_shortListFound = true;
				break;
			}
		}
		
		if (StringUtil.trim(text).length == 0)
		{
			return null;
		}
		
		var result:Node =
			Node.create(ASDocNodeKind.TEXT, line, column, text);
		
		return result;
	}
	
	//----------------------------------
	//  code-text
	//----------------------------------
	
	/**
	 * @private
	 */
	internal function parseCodeText():Node
	{
		var line:int = token.line;
		var column:int = token.column;
		
		var text:String = "";
		
		consume("<code");
		consume(">");
		
		// token : <code
		while (!tokIs(DOT_NL) && !tokIs("</") && !tokIs(ML_COMMENT_END))
		{
			text += token.text;
			nextToken();
		}
		
		consume("</");
		consume("code");
		consume(">");
		
		var result:Node =
			Node.create(ASDocNodeKind.CODE_TEXT,
				line,
				column,
				text);
		
		return result;
	}
	
	//----------------------------------
	//  pre-text
	//----------------------------------
	
	/**
	 * @private
	 */
	internal function parsePreText(name:String):Node
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
		
		// token : <pre
		while (!tokIs("</") && !tokIs(ML_COMMENT_END))
		{
			if (_rightSideOfAtrix || tokIs(NL))
			{
				text += token.text;
			}
			
			nextTokenEatRightPre();
		}
		
		consume("</");
		consume(name);
		consume(">");
		
		var result:Node =
			Node.create(ASDocNodeKind.PRE_TEXT,
				line,
				column,
				text);
		
		return result;
	}
	
	//----------------------------------
	//  doctag-list
	//----------------------------------
	
	/**
	 * @private
	 */
	internal function parseDocTagList():Node
	{
		// token @
		var result:Node =
			Node.create(ASDocNodeKind.DOCTAG_LIST,
				token.line,
				token.column);
		
		while (!tokIs(ML_COMMENT_END) && !tokIs("__END__"))
		{
			result.addChild(parseDocTag());
		}
		
		return result;
	}
	
	//----------------------------------
	//  doctag
	//----------------------------------
	
	/**
	 * @private
	 */
	internal function parseDocTag():Node
	{
		var result:Node =
			Node.create(ASDocNodeKind.DOCTAG,
				token.line,
				token.column);
		
		consume(AT);
		
		while (!tokIs(AT) && !tokIs(ML_COMMENT_END))
		{
			if (tokIsValid())
			{
				result.addChild(parseDocTagName());
				var body:Node = parseDocTagBody();
				if (body != null)
				{
					result.addChild(body);
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
	//  doctag-name
	//----------------------------------
	
	/**
	 * @private
	 */
	internal function parseDocTagName():Node
	{
		var result:Node =
			Node.create(ASDocNodeKind.NAME,
				token.line,
				token.column,
				token.text);
		
		nextToken(); // the doctag name
		
		return result;
	}
	
	//----------------------------------
	//  doctag-body
	//----------------------------------
	
	/**
	 * @private
	 */
	internal function parseDocTagBody():Node
	{
		var result:Node =
			Node.create(ASDocNodeKind.BODY, 
				token.line, 
				token.column);
		
		while (!tokIs(AT) && !tokIs(ML_COMMENT_END))
		{
			if (token.text == "<code")
			{
				result.addChild(parseCodeText());
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
		
		if (result.numChildren == 0)
		{
			return null;
		}
		
		return result;
	}
	
	/**
	 * @private
	 */
	private function nextTokenEatRight():void
	{
		var spaceFound:Boolean = false;
		
		do
		{
			nextToken();
			
			if (tokIs(ML_COMMENT_END))
			{
				break;
			}
			
			if (token.text == ASTRIX)
			{
				_rightSideOfAtrix = true;
				spaceFound = false;
			}
			
			if (_rightSideOfAtrix && token.text == SPACE)
			{
				nextToken(); // clear the " "
				spaceFound = true;
			}
			
			if (token.text == NL || token.text == DOT_NL)
			{
				_rightSideOfAtrix = false;
			}
			
			if (isIdentifierCharacter(token.text))
			{
				_rightSideOfAtrix = true;
				break;
			}
		}
		while (!_rightSideOfAtrix
			|| ((_rightSideOfAtrix && token.text == ASTRIX) || (!spaceFound)));
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
				_rightSideOfAtrix = false;
				break; // <pre> needs newlines
			}
			
			if (!_rightSideOfAtrix)
			{
				if (token.text == ASTRIX)
				{
					nextToken(); // " "
					_rightSideOfAtrix = true;
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
		while (!_rightSideOfAtrix);
	}
	
	/**
	 * @private
	 */
	protected function tokIsValid():Boolean
	{
		return _rightSideOfAtrix;
	}
	
	protected function isIdentifierCharacter(currentCharacter:String):Boolean
	{
		return (currentCharacter != " " && currentCharacter != "*"
			&& currentCharacter != ".\n"  && currentCharacter != "\n");
	}
}
}