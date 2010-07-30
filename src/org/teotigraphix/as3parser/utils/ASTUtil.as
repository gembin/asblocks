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

package org.teotigraphix.as3parser.utils
{

import org.teotigraphix.as3parser.api.IParserNode;

/**
 * A utility class for dealing with scanners, parsers and parser node ast.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class ASTUtil
{
	//--------------------------------------------------------------------------
	//
	//  Public Class :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Converts a String Array into a String Vector.
	 * 
	 * @param list A String Array.
	 * @return A String Vector.
	 */
	public static function toVector(list:Array):Vector.<String>
	{
		return Vector.<String>(list);
	}
	
	/**
	 * Converts an <code>IParserNode</code> into a flat XML String.
	 * 
	 * @param ast The <code>IParserNode</code> to convert.
	 * @return A String XML representation of the <code>IParserNode</code>.
	 */
	public static function convert(ast:IParserNode):String
	{
		return visitNodes(ast, "", 0);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Private Class :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private static function visitNodes(ast:IParserNode, 
									   result:String, 
									   level:int):String
	{
		result += "<" + ast.kind + " line=\"" + 
			ast.line + "\" column=\"" + ast.column + "\">";
		
		var numChildren:int = ast.numChildren;
		if (numChildren > 0)
		{
			for (var i:int = 0; i < numChildren; i++)
			{
				result = visitNodes(ast.getChild(i), result, level + 1);
			}
		}
		else if (ast.stringValue != null)
		{
			result += escapeEntities(ast.stringValue);
		}
		
		result += "</" + ast.kind + ">";
		
		return result;
	}
	
	/**
	 * @private
	 */
	private static function escapeEntities(stringToEscape:String):String
	{
		var buffer:String = "";
		
		for (var i:int = 0; i < stringToEscape.length; i++)
		{
			var currentCharacter:String = stringToEscape.charAt(i);
			
			if (currentCharacter == '<')
			{
				buffer += "&lt;";
			}
			else if (currentCharacter == '>')
			{
				buffer += "&gt;";
			}
			else
			{
				buffer += currentCharacter;
			}
		}
		return buffer;
	}
}
}