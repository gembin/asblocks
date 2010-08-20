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

package org.teotigraphix.as3parser.api
{

/**
 * TODO DOCME
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public interface ISourceCode
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  code
	//----------------------------------
	
	/**
	 * The String data.
	 */
	function get code():String;
	
	/**
	 * @private
	 */
	function set code(value:String):void;
	
	//----------------------------------
	//  name
	//----------------------------------
	
	/**
	 * The String name identifier.
	 */
	function get name():String;
	
	//----------------------------------
	//  packageName
	//----------------------------------
	
	/**
	 * The String packageName identifier.
	 */
	function get packageName():String;
	
	//----------------------------------
	//  qualifiedName
	//----------------------------------
	
	/**
	 * The String qualifiedName identifier.
	 */
	function get qualifiedName():String;
	
	//----------------------------------
	//  fileName
	//----------------------------------
	
	/**
	 * The String file name identifier.
	 */
	function get filePath():String;
	
	/**
	 * @private
	 */
	function set filePath(value:String):void;
	
	//----------------------------------
	//  classPath
	//----------------------------------
	
	/**
	 * The String file classPath identifier.
	 */
	function get classPath():String;
	
	/**
	 * @private
	 */
	function set classPath(value:String):void;
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Returns a slice of source code.
	 * 
	 * @param startLine The start line.
	 * @param endLine The end line.
	 * @return A String slice between the startLine and endLine.
	 */
	function getSlice(startLine:int, endLine:int):String;
}
}