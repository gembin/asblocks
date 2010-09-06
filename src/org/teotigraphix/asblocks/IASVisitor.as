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

import org.teotigraphix.asblocks.api.IClassType;
import org.teotigraphix.asblocks.api.ICompilationUnit;
import org.teotigraphix.asblocks.api.IField;
import org.teotigraphix.asblocks.api.IInterfaceType;
import org.teotigraphix.asblocks.api.IMember;
import org.teotigraphix.asblocks.api.IMethod;
import org.teotigraphix.asblocks.api.IPackage;
import org.teotigraphix.asblocks.api.IType;

/**
 * TODO DOCME
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public interface IASVisitor
{
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Visits an <code>IASProject</code> and recurses through all nodes
	 * in the AST tree.
	 * 
	 * @param element The <code>IASProject</code>.
	 */
	function visitProject(element:IASProject):void;
	
	/**
	 * Visits an <code>ICompilationUnit</code> of the <code>IASProject</code>.
	 * 
	 * @param element The <code>ICompilationUnit</code> of the 
	 * <code>IASProject</code>.
	 */
	function visitCompilationUnit(element:ICompilationUnit):void;
	
	/**
	 * Visits an <code>IPackage</code> of the <code>ICompilationUnit</code>.
	 * 
	 * @param element The <code>IPackage</code> of the 
	 * <code>ICompilationUnit</code>.
	 */
	function visitPackage(element:IPackage):void;
	
	/**
	 * Called just before <code>visitClass()</code> or 
	 * <code>visitInterface()</code>. 
	 * 
	 * @param element The <code>IType</code> of the 
	 * <code>ICompilationUnit</code>.
	 */
	function visitType(element:IType):void;
	
	/**
	 * Visits an <code>IClassType</code> of the <code>IPackage</code>.
	 * 
	 * @param element The <code>IClassType</code> of the 
	 * <code>IPackage</code>.
	 */
	function visitClass(element:IClassType):void;
	
	/**
	 * Visits an <code>IInterfaceType</code> of the <code>IPackage</code>.
	 * 
	 * @param element The <code>IInterfaceType</code> of the 
	 * <code>IPackage</code>.
	 */
	function visitInterface(element:IInterfaceType):void;
	
	/**
	 * Called just before <code>visitMethod()</code> or 
	 * <code>visitField()</code>. 
	 * 
	 * @param element The <code>IMember</code> of the 
	 * <code>IType</code>.
	 */
	function visitMember(element:IMember):void;
	
	/**
	 * Visits an <code>IMethod</code> of the <code>IType</code>.
	 * 
	 * @param element The <code>IMethod</code> of the 
	 * <code>IType</code>.
	 */
	function visitMethod(element:IMethod):void;
	
	/**
	 * Visits an <code>IField</code> of the <code>IType</code>.
	 * 
	 * @param element The <code>IField</code> of the 
	 * <code>IType</code>.
	 */
	function visitField(element:IField):void;
}
}