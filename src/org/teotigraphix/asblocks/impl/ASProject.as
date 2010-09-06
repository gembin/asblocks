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

package org.teotigraphix.asblocks.impl
{

import org.teotigraphix.asblocks.ASFactory;
import org.teotigraphix.asblocks.IASProject;
import org.teotigraphix.asblocks.api.ICompilationUnit;

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
	private var factory:ASFactory;
	
	//--------------------------------------------------------------------------
	//
	//  IASProject API :: Properties
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private var _compilationUnits:Vector.<ICompilationUnit>;
	
	/**
	 * @copy org.teotigraphix.asblocks.IASProject#compilationUnits
	 */
	public function get compilationUnits():Vector.<ICompilationUnit>
	{
		return _compilationUnits;
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
	 * @copy org.teotigraphix.asblocks.IASProject#newClass()
	 */
	public function newClass(qualifiedName:String):ICompilationUnit
	{
		var cu:ICompilationUnit = factory.newClass(qualifiedName);
		addCompilationUnit(cu);
		return cu;
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.IASProject#newInterface()
	 */
	public function newInterface(qualifiedName:String):ICompilationUnit
	{
		var cu:ICompilationUnit = factory.newInterface(qualifiedName);
		addCompilationUnit(cu);
		return cu;
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.IASProject#addCompilationUnit()
	 */
	public function addCompilationUnit(unit:ICompilationUnit):void
	{
		if (!_compilationUnits)
		{
			_compilationUnits = new Vector.<ICompilationUnit>();
		}
		
		_compilationUnits.push(unit);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.IASProject#removeCompilationUnit()
	 */
	public function removeCompilationUnit(unit:ICompilationUnit):void
	{
		var len:int = _compilationUnits.length;
		for (var i:int = 0; i < len; i++)
		{
			var element:ICompilationUnit = _compilationUnits[i] as ICompilationUnit;
			if (element === unit)
			{
				_compilationUnits.splice(i, 1);
				break;
			}	
		}
	}
}
}