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

import org.teotigraphix.asblocks.IASProject;
import org.teotigraphix.asblocks.IASVisitor;
import org.teotigraphix.asblocks.IASWalker;
import org.teotigraphix.asblocks.api.IClassType;
import org.teotigraphix.asblocks.api.ICompilationUnit;
import org.teotigraphix.asblocks.api.IField;
import org.teotigraphix.asblocks.api.IInterfaceType;
import org.teotigraphix.asblocks.api.IMember;
import org.teotigraphix.asblocks.api.IMethod;
import org.teotigraphix.asblocks.api.IPackage;
import org.teotigraphix.asblocks.api.IType;

/**
 * Default implementation of the <code>IASWalker</code> API.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class ASWalker implements IASWalker
{
	//--------------------------------------------------------------------------
	//
	//  Protected :: Variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	protected var visitor:IASVisitor;
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function ASWalker(visitor:IASVisitor)
	{
		this.visitor = visitor;
	}
	
	//--------------------------------------------------------------------------
	//
	//  IASWalker API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.IASWalker#walkProject()
	 */
	public function walkProject(element:IASProject):void
	{
		visitor.visitProject(element);
		
		var len:int = element.compilationUnits.length;
		for (var i:int = 0; i < len; i++)
		{
			var unit:ICompilationUnit = element.compilationUnits[i];
			walkCompilationUnit(unit);
		}
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.IASWalker#walkCompilationUnit()
	 */
	public function walkCompilationUnit(element:ICompilationUnit):void
	{
		visitor.visitCompilationUnit(element);
		walkPackage(element.packageNode);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.IASWalker#walkPackage()
	 */
	public function walkPackage(element:IPackage):void
	{
		visitor.visitPackage(element);
		walkType(element.typeNode);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.IASWalker#walkType()
	 */
	public function walkType(element:IType):void
	{
		visitor.visitType(element);
		if (element is IClassType) {
			walkClass(IClassType(element));
		}
		if (element is IInterfaceType) {
			walkInterface(IInterfaceType(element));
		}
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.IASWalker#walkClass()
	 */
	public function walkClass(element:IClassType):void
	{
		visitor.visitClass(element);
		var len:int;
		var i:int;
		
		var fields:Vector.<IField> = element.fields;
		len = fields.length;
		for (i = 0; i < len; i++)
		{
			var field:IField = fields[i];
			walkMember(field);
			walkField(field);
		}
		
		var methods:Vector.<IMethod> = element.methods;
		len = methods.length;
		for (i = 0; i < len; i++)
		{
			var method:IMethod = methods[i];
			walkMember(method);
			walkMethod(method);
		}
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.IASWalker#walkInterface()
	 */
	public function walkInterface(element:IInterfaceType):void
	{
		visitor.visitInterface(element);
		var len:int;
		var i:int;
		
		var methods:Vector.<IMethod> = element.methods;
		len = methods.length;
		for (i = 0; i < len; i++)
		{
			var method:IMethod = methods[i];
			walkMember(method);
			walkMethod(method);
		}
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.IASWalker#visitMember()
	 */
	public function walkMember(element:IMember):void
	{
		visitor.visitMember(element);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.IASWalker#visitMethod()
	 */
	public function walkMethod(element:IMethod):void
	{
		visitor.visitMethod(element);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.IASWalker#walkField()
	 */
	public function walkField(element:IField):void
	{
		visitor.visitField(element);
	}
}
}