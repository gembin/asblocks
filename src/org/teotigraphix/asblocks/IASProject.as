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

package org.teotigraphix.asblocks
{

import org.teotigraphix.asblocks.api.ICompilationUnit;

/**
 * TODO DOCME
 * 
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
	//  compilationUnits
	//----------------------------------
	
	/**
	 * TODO DOCME
	 */
	function get compilationUnits():Vector.<ICompilationUnit>;
	
	//----------------------------------
	//  classPathEntries
	//----------------------------------
	
	/**
	 * TODO DOCME
	 */
	//function get classPathEntries():Vector.<IClassPathEntry>;
	
	//----------------------------------
	//  outputLocation
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get outputLocation():String;
	
	/**
	 * @private
	 */
	function set outputLocation(value:String):void;
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * TODO DOCME
	 */
	function newClass(qualifiedName:String):ICompilationUnit;
	
	/**
	 * TODO DOCME
	 */
	function newInterface(qualifiedName:String):ICompilationUnit;
	
	/**
	 * TODO DOCME
	 */
	function addCompilationUnit(unit:ICompilationUnit):void;
	
	/**
	 * TODO DOCME
	 */
	function removeCompilationUnit(unit:ICompilationUnit):void;
	
	/**
	 * TODO DOCME
	 */
	//function addClassPath(classPath:String):void;
	
	/**
	 * TODO DOCME
	 */
	//function removeClassPath(classPath:String):void;
	
	/**
	 * TODO DOCME
	 */
	//function writeAll():void;
}
}