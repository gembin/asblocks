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

public class ASProject implements IASProject
{
	private var factory:ASFactory;
	
	public function ASProject(factory:ASFactory)
	{
		this.factory = factory;
	}
	
	public function newClass(qualifiedName:String):ICompilationUnit
	{
		var cu:ICompilationUnit = factory.newClass(qualifiedName);
		addCompilationUnit(cu);
		return cu;
	}
	
	public function newInterface(qualifiedName:String):ICompilationUnit
	{
		var cu:ICompilationUnit = factory.newInterface(qualifiedName);
		addCompilationUnit(cu);
		return cu;
	}
	
	//----------------------------------
	//  compilationUnits
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _compilationUnits:Vector.<ICompilationUnit>;
	
	/**
	 * doc
	 */
	public function get compilationUnits():Vector.<ICompilationUnit>
	{
		return _compilationUnits;
	}
	
	
	public function addCompilationUnit(unit:ICompilationUnit):void
	{
		if (!_compilationUnits)
		{
			_compilationUnits = new Vector.<ICompilationUnit>();
		}
		
		_compilationUnits.push(unit);
	}
	
	public function removeCompilationUnit(unit:ICompilationUnit):void
	{
		
	}
}
}