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
	private var _basePath:String;
	
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
	 * @copy org.teotigraphix.as3parser.api.ISourceCode#code
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
	 * @copy org.teotigraphix.as3parser.api.ISourceCode#extension
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
	 * @copy org.teotigraphix.as3parser.api.ISourceCode#name
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
	 * @copy org.teotigraphix.as3parser.api.ISourceCode#packageName
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
	 * @copy org.teotigraphix.as3parser.api.ISourceCode#qualifiedName
	 */
	public function get qualifiedName():String
	{
		return _qualifiedName;
	}
	
	//----------------------------------
	//  filePath
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _filePath:String;
	
	/**
	 * @copy org.teotigraphix.as3parser.api.ISourceCode#filePath
	 */
	public function get filePath():String
	{
		return _filePath;
	}
	
	/**
	 * @private
	 */	
	public function set filePath(value:String):void
	{
		_filePath = value;
	}
	
	//----------------------------------
	//  classPath
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _classPath:String;
	
	/**
	 * @copy org.teotigraphix.as3parser.api.ISourceCode#classPath
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
	 * @param filePath The String file name identifier.
	 * @param classPath The String file classPath identifier.
	 */
	public function SourceCode(code:String, 
							   filePath:String = null, 
							   classPath:String = null)
	{
		_code = cleanCode(code);
		// /home/user/src/my/domain/Test.as
		_filePath = cleanPath(filePath);
		// /home/user/src
		_classPath = cleanPath(classPath);
		
		compute();
	}
	
	//--------------------------------------------------------------------------
	//
	//  ISourceCode API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ISourceCode#getSlice()
	 */
	public function getSlice(startLine:int, endLine:int):String
	{
		// TODO implement getSlice()
		if (code == null)
			return null;
		
		return null;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Protected :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Computes the file pieces.
	 */
	protected function compute():void
	{
		// PS I hate string mangling, anyone have better ideas, let me know
		if (_filePath && _classPath)
		{
			// /my/domain/Test.as
			_basePath = _filePath.replace(_classPath, "");
		}
		else
		{
			_basePath = "";
		}
		
		if (_filePath)
		{
			var split:Array = (_basePath == "") 
				? _filePath.split(".") 
				: _basePath.split(".");
			_extension = split.pop();
			
			// /my/domain/Test
			_qualifiedName = split.pop();
			// remove first slash
			if (_qualifiedName.indexOf("/") == 0)
				_qualifiedName = _qualifiedName.substring(1, _qualifiedName.length);
			
			if (_qualifiedName)
			{
				_packageName = ""; // toplevel
				// my.domain.Test
				_qualifiedName = _qualifiedName.split("/").join(".");
				
				var dot:int = _qualifiedName.lastIndexOf(".");
				if (dot != -1)
				{
					_packageName = _qualifiedName.substring(0, dot);
				}
			}
			
			var last:int = _qualifiedName.lastIndexOf(".");
			if (last != -1)
			{
				_name = _qualifiedName.substring(last + 1, _qualifiedName.length);
			}
			else
			{
				_name = _qualifiedName;
			}
		}
	}
	
	/**
	 * Cleans the code by default, removes the \r\n and replaces them with \n.
	 * 
	 * @param code A String to clean.
	 * @return The cleaned String.
	 */
	protected function cleanCode(code:String):String
	{
		if (!code)
			return null;
		
		return code.replace(/\r\n/g, "\n");
	}
	
	/**
	 * Cleans a path by default, removes the \ and replaces them with /.
	 * 
	 * @param path A String to clean.
	 * @return The cleaned String.
	 */
	protected function cleanPath(path:String):String
	{
		if (path == null)
			return null;
		
		return path.replace(/\\/g, "/");
	}
}
}