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

package org.as3commons.asblocks.impl
{

import org.as3commons.asblocks.parser.core.SourceCode;
import org.as3commons.asblocks.ASFactory;
import org.as3commons.asblocks.IASProject;
import org.as3commons.asblocks.api.IClassPathEntry;
import org.as3commons.asblocks.api.ICompilationUnit;
import org.as3commons.asblocks.utils.FileUtil;

/**
 * The default implementation of the <code>IASProject</code> API.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class ASProject implements IASProject
{
	//--------------------------------------------------------------------------
	//
	//  Private :: Variables
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
	
	/**
	 * @private
	 */
	protected var _compilationUnits:Vector.<ICompilationUnit> = new Vector.<ICompilationUnit>();
	
	/**
	 * @copy org.as3commons.asblocks.IASProject#compilationUnits
	 */
	public function get compilationUnits():Vector.<ICompilationUnit>
	{
		var result:Vector.<ICompilationUnit> = new Vector.<ICompilationUnit>();
		var len:int = _compilationUnits.length;
		for (var i:int = 0; i < len; i++)
		{
			result.push(_compilationUnits[i]);
			
		}
		return result;
	}
	
	/**
	 * @private
	 */
	protected var _classPathEntries:Vector.<IClassPathEntry> = new Vector.<IClassPathEntry>();
	
	/**
	 * @copy org.as3commons.asblocks.IASProject#classPathEntries
	 */
	public function get classPathEntries():Vector.<IClassPathEntry>
	{
		var result:Vector.<IClassPathEntry> = new Vector.<IClassPathEntry>();
		var len:int = _classPathEntries.length;
		for (var i:int = 0; i < len; i++)
		{
			result.push(_classPathEntries[i]);
			
		}
		return result;
	}
	
	//----------------------------------
	//  outputLocation
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _outputLocation:String;
	
	/**
	 * @copy org.as3commons.asblocks.IASProject#outputLocation
	 */
	public function get outputLocation():String
	{
		return _outputLocation;
	}
	
	/**
	 * @private
	 */	
	public function set outputLocation(value:String):void
	{
		_outputLocation = value;
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
		this.factory = factory;
	}
	
	//--------------------------------------------------------------------------
	//
	//  IASProject API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.as3commons.asblocks.IASProject#newClass()
	 */
	public function newClass(qualifiedName:String):ICompilationUnit
	{
		var cu:ICompilationUnit = factory.newClass(qualifiedName);
		addCompilationUnit(cu);
		return cu;
	}
	
	/**
	 * @copy org.as3commons.asblocks.IASProject#newInterface()
	 */
	public function newInterface(qualifiedName:String):ICompilationUnit
	{
		var cu:ICompilationUnit = factory.newInterface(qualifiedName);
		addCompilationUnit(cu);
		return cu;
	}
	
	/**
	 * @copy org.as3commons.asblocks.IASProject#newApplication()
	 */
	public function newApplication(qualifiedName:String, 
								   superQualifiedName:String):ICompilationUnit
	{
		var cu:ICompilationUnit = factory.newApplication(qualifiedName, superQualifiedName);
		addCompilationUnit(cu);
		return cu;
	}
	
	/**
	 * @copy org.as3commons.asblocks.IASProject#addCompilationUnit()
	 */
	public function addCompilationUnit(unit:ICompilationUnit):Boolean
	{
		if (_compilationUnits.indexOf(unit) != -1)
		{
			return false;
		}
		
		_compilationUnits.push(unit);
		return true;
	}
	
	/**
	 * @copy org.as3commons.asblocks.IASProject#removeCompilationUnit()
	 */
	public function removeCompilationUnit(unit:ICompilationUnit):Boolean
	{
		var len:int = _compilationUnits.length;
		for (var i:int = 0; i < len; i++)
		{
			var element:ICompilationUnit = _compilationUnits[i] as ICompilationUnit;
			if (element === unit)
			{
				_compilationUnits.splice(i, 1);
				return true;
			}	
		}
		return false;
	}
	
	/**
	 * @copy org.as3commons.asblocks.IASProject#addClassPath()
	 */
	public function addClassPath(classPath:String):IClassPathEntry
	{
		var entry:IClassPathEntry;
		
		for each (entry in _classPathEntries) 
		{
			if (entry.filePath == classPath)
			{
				return null;
			}
		}
		
		entry = new ClassPathEntry(classPath);
		_classPathEntries.push(entry);
		return entry;
	}
	
	/**
	 * @copy org.as3commons.asblocks.IASProject#removeClassPath()
	 */
	public function removeClassPath(classPath:String):Boolean
	{
		var len:int = _classPathEntries.length;
		for (var i:int = 0; i < len; i++)
		{
			var element:IClassPathEntry = _classPathEntries[i] as IClassPathEntry;
			if (element.filePath == classPath)
			{
				_classPathEntries.splice(i, 1);
				return true;
			}	
		}
		return false;
	}
	
	/**
	 * @copy org.as3commons.asblocks.IASProject#writeAll()
	 */
	public function writeAll():void
	{
		clearBuffer();
		
		var len:int = compilationUnits.length;
		for (var i:int = 0; i < len; i++)
		{
			var element:ICompilationUnit = compilationUnits[i] as ICompilationUnit;
			write(outputLocation, element);
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//  Protected :: Methods
	//
	//--------------------------------------------------------------------------
	
	private var _sourceCodeList:Array = [];
	
	public function get sourceCodeList():Array
	{
		return _sourceCodeList;
	}
	
	/**
	 * @private
	 */
	protected function clearBuffer():void
	{
		_sourceCodeList = [];
	}
	
	/**
	 * @private
	 */
	protected function write(location:String, unit:ICompilationUnit):void
	{
		var fileName:String = FileUtil.fileNameFor(unit);
		
		// subclass for new implementation
		var code:SourceCode = new SourceCode(null, fileName);
		factory.newWriter().write(code, unit);
		
		_sourceCodeList.push(code);
	}
}
}