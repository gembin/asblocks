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

package org.teotigraphix.as3nodes.api
{

/**
 * TODO DOCME
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public interface IAS3Project
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
	 * The native output path for compilation writting.
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
	 * The Vector of String class path roots.
	 * 
	 * <p>These locations allow resolution of imports and dependencies.</p>
	 */
	function get classPaths():Vector.<String>;
	
	//----------------------------------
	//  sourceFiles
	//----------------------------------
	
	/**
	 * The Vector of source files held in the project.
	 */
	function get sourceFiles():Vector.<ISourceFile>;
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Adds a classPath root to the project.
	 * 
	 * @param classPath A String classPath root to add.
	 */
	function addClassPath(classPath:String):void;
	
	/**
	 * Removes a classPath root from the project.
	 * 
	 * @param classPath A String classPath root to reomve.
	 */
	function removeClassPath(classPath:String):void;
	
	/**
	 * Adds an <code>ISourceFile</code> to the project.
	 * 
	 * @param file A <code>ISourceFile</code> node to add.
	 */
	function addSourceFile(file:ISourceFile):void;
	
	/**
	 * Removes an <code>ISourceFile</code> from the project.
	 * 
	 * @param file A <code>ISourceFile</cocodepde> node to remove.
	 */
	function removeSourceFile(file:ISourceFile):void;
	
	/**
	 * Writes all <code>ICompilationNode</code> instances to the 
	 * <code>output</code> location.
	 */
	function write():void;
	
	/**
	 * Creates and returns a new <code>ISourceFile</code> instance.
	 * 
	 * <p>The instance will have the <code>packageNode</code> set to an
	 * <code>IPackageNode</code> and the <code>typeNode</code> set to an
	 * <code>IClassTypeNode</code>.</p>
	 * 
	 * <p>If the qualifiedName is <code>my.domain.Class</code>, the node during
	 * writ will be written to <code>project/my/domain/Class.as</code> 
	 * location.</p>
	 * 
	 * @param qualifiedName A String indicating the full name of the class.
	 * IE <code>my.domain.Class</code>.
	 */
	function newClass(qualifiedName:String):ISourceFile
	
	/**
	 * Creates and returns a new <code>ISourceFile</code> instance.
	 * 
	 * <p>The instance will have the <code>packageNode</code> set to an
	 * <code>IPackageNode</code> and the <code>typeNode</code> set to an
	 * <code>IInterfaceTypeNode</code>.</p>
	 * 
	 * <p>If the qualifiedName is <code>my.domain.IInterface</code>, the node during
	 * writ will be written to <code>project/my/domain/IInterface.as</code> 
	 * location.</p>
	 * 
	 * @param qualifiedName A String indicating the full name of the class.
	 * IE <code>my.domain.IInterface</code>.
	 */
	function newInterface(qualifiedName:String):ISourceFile
}
}