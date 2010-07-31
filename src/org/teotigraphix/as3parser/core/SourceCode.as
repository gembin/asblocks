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

package org.teotigraphix.as3parser.core
{

/**
 * A chunk of source code with file name identifier.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class SourceCode
{
	//--------------------------------------------------------------------------
	//
	//  Public :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  code
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _code:String;
	
	/**
	 * The String data.
	 */
	public function get code():String
	{
		return _code;
	}
	
	/**
	 * @private
	 */	
	public function set code(value:String):void
	{
		_code = value;
	}
	
	//----------------------------------
	//  fileName
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _fileName:String;
	
	/**
	 * The String file name identifier.
	 */
	public function get fileName():String
	{
		return _fileName;
	}
	
	/**
	 * @private
	 */	
	public function set fileName(value:String):void
	{
		_fileName = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 * 
	 * @param code The String data.
	 * @param fileName The String file name identifier.
	 */
	public function SourceCode(code:String, fileName:String)
	{
		_code = code;
		_fileName = fileName;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Public :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Returns a slice of source code.
	 * 
	 * @param startLine The start line.
	 * @param endLine The end line.
	 * @return A String slice between the startLine and endLine.
	 */
	public function getSlice(startLine:int, endLine:int):String
	{
		return null;
	}
}
}