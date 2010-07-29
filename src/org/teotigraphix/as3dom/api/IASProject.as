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

package org.teotigraphix.as3dom.api
{

/**
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public interface IASProject
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  output
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get output():String;
	
	/**
	 * @private
	 */
	function set output(value:String):void;
	
	//----------------------------------
	//  classPaths
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get classPaths():Vector.<String>;
	
	/**
	 * @private
	 */
	//function set classPaths(value:Vector.<String>):void;
	
	
	//----------------------------------
	//  compilationUnits
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get compilationUnits():Vector.<ICompilationUnit>;
	
	/**
	 * @private
	 */
	//function set compilationUnits(value:Vector.<ICompilationUnit>):void;
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Adds a classPath entry to the project.
	 * 
	 * @param classPath A String indicating the location of the classPath to add.
	 */
	function addClassPath(classPath:String):void;
	
	/**
	 * Removes a classPath entry from the project.
	 * 
	 * @param classPath A String indicating the location of the classPath to remove.
	 */
	function removeClassPath(classPath:String):void;
	
	/**
	 * TODO Docme
	 */
	function addCompilationUnit(compilationUnit:ICompilationUnit):void;
	
	/**
	 * TODO Docme
	 */
	function removeCompilationUnit(compilationUnit:ICompilationUnit):void;
	
	/**
	 * TODO Docme
	 */
	function newClass(qualifiedName:String):ICompilationUnit;
	
	/**
	 * TODO Docme
	 */
	function newInterface(qualifiedName:String):ICompilationUnit;
	
	//writeAll()
}
}