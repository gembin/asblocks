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

package org.as3commons.asblocks.parser.impl
{

import org.as3commons.asblocks.parser.core.Token;

/**
 * A scanner that is (/~~ ~/) or (<!--- -->) asdoc domain aware.
 *
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class ASDocScanner extends ScannerBase
{
	//--------------------------------------------------------------------------
	//
	//  Internal :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	// isInShort
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _inShort:Boolean = false;
	
	/**
	 * @private
	 */
	internal function get isInShort():Boolean
	{
		return _inShort;
	}
	
	//----------------------------------
	// isInDocTag
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _inDocTag:Boolean = false;
	
	/**
	 * @private
	 */
	internal function get isInDocTag():Boolean
	{
		return _inDocTag;
	}
	
	//----------------------------------
	// isInInlineDocTag
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _inInlineDocTag:Boolean = false;
	
	/**
	 * @private
	 */
	internal function get isInInlineDocTag():Boolean
	{
		return _inInlineDocTag;
	}

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function ASDocScanner()
	{
		super();
		
		allowWhiteSpace = true;
	}
	
	//--------------------------------------------------------------------------
	//
	// Overridden Public :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	override public function setLines(lines:Vector.<String>):void
	{
		super.setLines(lines);
		
		_inShort = true;
		_inDocTag = false;
		_inInlineDocTag = false;
	}
	
	/**
	 * @private
	 */
	override public function nextToken():Token
	{
		var currentCharacter:String;
		
		// while we have lines and are not at the end
		if (lines != null && line < lines.length)
		{
			currentCharacter = nextChar();
		}
		else
		{
			// at the end, send the line terminator
			return new Token(END, line, column);
		}
		
		var token:Token;
		
		if (currentCharacter == '@' || currentCharacter == ' '
			|| currentCharacter == '\t' || currentCharacter == '\n'
			|| currentCharacter == '>')
		{
			if (currentCharacter == '@')
			{
				_inShort = false;
				_inDocTag = true;
			}
			
			return scanSingleCharacterToken(currentCharacter);
		}
		
		if (currentCharacter == '<')
		{
			token = scanCharacterSequence(currentCharacter, 
				["</", "<listing", "<pre", "<code"]);
			
			return token;
		}
		/*
		if (currentCharacter == '.' && _inShort)
		{
			token = scanCharacterSequence(currentCharacter, [".\n", ".\t"]);
			
			if (_inShort && token.text == ".\n"
				|| token.text == ".\t")
			{
				_inShort = false;
			}
			
			return token;
		}
		*/
		if (currentCharacter == '{')
		{
			token = scanCharacterSequence(currentCharacter, ["{@"]);
			
			if (!_inInlineDocTag && token.text == "{@")
			{
				_inInlineDocTag = true;
			}
			
			return token;
		}
		
		if (currentCharacter == '}')
		{
			_inInlineDocTag = false;
		}
		
		if (currentCharacter == '/')
		{
			return scanCharacterSequence(currentCharacter, ["/**", "/>"]);
		}
		
		if (currentCharacter == '*')
		{
			token = scanCharacterSequence(currentCharacter, ["*/"]);
			
			if (_inShort && token.text == "*/")
			{
				_inShort = false;
			}
			
			return token;
		}
		
		return scanWord(currentCharacter);
	}
}
}