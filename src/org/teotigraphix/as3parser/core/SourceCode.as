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

import org.teotigraphix.as3parser.api.ISourceCode;

/**
 * A chunk of source code with file name identifier.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class SourceCode implements ISourceCode
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
	 * @copy org.teotigraphix.as3nodes.api.ISourceCode#code
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
	//  extension
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _extension:String;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ISourceCode#extension
	 */
	public function get extension():String
	{
		return _extension;
	}
	
	//----------------------------------
	//  name
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _name:String;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ISourceCode#name
	 */
	public function get name():String
	{
		return _name;
	}
	
	//----------------------------------
	//  packageName
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _packageName:String;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ISourceCode#packageName
	 */
	public function get packageName():String
	{
		return _packageName;
	}
	
	//----------------------------------
	//  qualifiedName
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _qualifiedName:String;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ISourceCode#qualifiedName
	 */
	public function get qualifiedName():String
	{
		return _qualifiedName;
	}
	
	//----------------------------------
	//  fileName
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _fileName:String;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ISourceCode#fileName
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
	
	//----------------------------------
	//  classPath
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _classPath:String;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ISourceCode#classPath
	 */
	public function get classPath():String
	{
		return _classPath;
	}
	
	/**
	 * @private
	 */	
	public function set classPath(value:String):void
	{
		_classPath = value;
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
	 * @param classPath The String file classPath identifier.
	 */
	public function SourceCode(code:String, fileName:String, classPath:String)
	{
		// for now this seems like a good place to normalize newlines
		// FIXME what a mess and stick in as3 file
		if (code)
			_code = code.replace(/\r\n/g, "\n");
		
		_fileName = fileName.replace(/\\/g, "/");
		
		if (!classPath)
			classPath = "";
		
		_classPath = classPath.replace(/\\/g, "/");
		
		var base:String = _fileName.replace(_classPath, "");
		
		var split:Array = base.split(".");
		_extension = split.pop();
		
		_qualifiedName = split[0];
		if (_qualifiedName)
		{
			_qualifiedName = _qualifiedName.replace(_classPath, "").split("/").join(".");
			if (_qualifiedName.charAt(0) == ".")
				_qualifiedName = _qualifiedName.substr(1, _qualifiedName.length);
			_packageName = _qualifiedName;
			var packageSplit:Array = _qualifiedName.split(".");
			if (packageSplit.length > 1)
			{
				packageSplit.pop();
				_packageName = packageSplit.join(".");
			}
			else
			{
				_packageName = "toplevel"; // toplevel
			}
		}
		
		if (split.length > 0)
			_name = split[0].split("/").pop();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Public :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ISourceCode#getSlice()
	 */
	public function getSlice(startLine:int, endLine:int):String
	{
		return null;
	}
}
}