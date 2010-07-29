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

package org.teotigraphix.as3dom.impl
{

import org.teotigraphix.as3dom.api.IASProject;
import org.teotigraphix.as3dom.api.ICompilationUnit;

/**
 * TODO DOCME
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class ASProject implements IASProject
{	
	//--------------------------------------------------------------------------
	//
	//  Protected :: Properties
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	protected var factory:ASFactory;
	
	//--------------------------------------------------------------------------
	//
	//  IASProject API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  output
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _output:String;
	
	/**
	 * @copy org.teotigraphix.as3dom.api.IASProject#output
	 */
	public function get output():String
	{
		return _output;
	}
	
	/**
	 * @private
	 */	
	public function set output(value:String):void
	{
		_output = value;
	}
	
	//----------------------------------
	//  classPaths
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _classPaths:Vector.<String>;
	
	/**
	 * @copy org.teotigraphix.as3dom.api.IASProject#classPaths
	 */
	public function get classPaths():Vector.<String>
	{
		return _classPaths;
	}
	
	/**
	 * @private
	 */	
	public function set classPaths(value:Vector.<String>):void
	{
		_classPaths = value;
	}
	
	//----------------------------------
	//  compilationUnits
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _compilationUnits:Vector.<ICompilationUnit>;
	
	/**
	 * @copy org.teotigraphix.as3dom.api.IASProject#compilationUnits
	 */
	public function get compilationUnits():Vector.<ICompilationUnit>
	{
		return _compilationUnits;
	}
	
	/**
	 * @private
	 */	
	public function set compilationUnits(value:Vector.<ICompilationUnit>):void
	{
		_compilationUnits = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function ASProject(factory:ASFactory)
	{
		super();
		
		this.factory = factory;
		
		_classPaths = new Vector.<String>();
	}
	
	//--------------------------------------------------------------------------
	//
	//  IASProject API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.teotigraphix.as3dom.api.IASProject#addClassPath()
	 */
	public function addClassPath(classPath:String):void
	{
		if (containsPath(classPath))
			return;
		
		_classPaths.push(classPath);
	}
	
	/**
	 * @copy org.teotigraphix.as3dom.api.IASProject#removeClassPath()
	 */
	public function removeClassPath(classPath:String):void
	{
		if (!containsPath(classPath))
			return;
		
		var index:int = getPathIndex(classPath);
		
		_classPaths.splice(index, 1);
	}
	
	/**
	 * @copy org.teotigraphix.as3dom.api.IASProject#addCompilationUnit()
	 */
	public function addCompilationUnit(compilationUnit:ICompilationUnit):void
	{
	}
	
	/**
	 * @copy org.teotigraphix.as3dom.api.IASProject#removeCompilationUnit()
	 */
	public function removeCompilationUnit(compilationUnit:ICompilationUnit):void
	{
	}
	
	/**
	 * @copy org.teotigraphix.as3dom.api.IASProject#newClass()
	 */
	public function newClass(qualifiedName:String):ICompilationUnit
	{
		return null;
	}
	
	/**
	 * @copy org.teotigraphix.as3dom.api.IASProject#newInterface()
	 */
	public function newInterface(qualifiedName:String):ICompilationUnit
	{
		return null;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Private :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private function containsPath(path:String):Boolean
	{
		var len:int = classPaths.length;
		for (var i:int = 0; i < len; i++)
		{
			if (path == classPaths[i])
				return true;
		}
		return false;
	}
	
	/**
	 * @private
	 */
	private function getPathIndex(path:String):int
	{
		var len:int = classPaths.length;
		for (var i:int = 0; i < len; i++)
		{
			if (path == classPaths[i])
				return i;
		}
		return -1;
	}
}
}