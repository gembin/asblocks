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

package org.as3commons.asblocks
{

import flash.events.IEventDispatcher;

import org.as3commons.asblocks.api.IClassPathEntry;
import org.as3commons.asblocks.api.ICompilationUnit;
import org.as3commons.asblocks.impl.IResourceRoot;

/**
 * The <code>IASProject</code> API creates a root for a project 
 * dealing with actionscript source files and resources.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 * 
 * @see org.as3commons.asblocks.api.IClassPathEntry
 * @see org.as3commons.asblocks.api.ICompilationUnit
 * @see org.as3commons.asblocks.impl.IResourceRoot
 */
public interface IASProject extends IEventDispatcher
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  factory
	//----------------------------------
	
	/**
	 * The current <code>ASFactory</code> used within the project.
	 */
	function get factory():ASFactory;
	
	//----------------------------------
	//  compilationUnits
	//----------------------------------
	
	/**
	 * The <code>Vector</code> of <code>ICompilationUnit</code>.
	 * 
	 * <p>Note: Do not edit this vector, use the add and remove methods.</p>
	 * 
	 * @see #addCompilationUnit()
	 * @see #removeCompilationUnit()
	 */
	function get compilationUnits():Vector.<ICompilationUnit>;
	
	//----------------------------------
	//  classPathEntries
	//----------------------------------
	
	/**
	 * The <code>Vector</code> of <code>IClassPathEntry</code>.
	 * 
	 * <p>Note: Do not edit this vector, use the add and remove methods.</p>
	 * 
	 * @see #addClassPath()
	 * @see #removeClassPath()
	 */
	function get classPathEntries():Vector.<IClassPathEntry>;
	
	//----------------------------------
	//  outputLocation
	//----------------------------------
	
	/**
	 * The location where the source files are output.
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
	 * Adds an <code>ICompilationUnit</code> to the project.
	 * 
	 * @param unit The <code>ICompilationUnit</code> to add.
	 * @return A <code>Boolean</code> indicating whether the unit was
	 * added correctly.
	 * 
	 * @see #compilationUnits
	 */
	function addCompilationUnit(unit:ICompilationUnit):Boolean;
	
	/**
	 * Removes an <code>ICompilationUnit</code> from the project.
	 * 
	 * @param unit The <code>ICompilationUnit</code> to add.
	 * @return A <code>Boolean</code> indicating whether the unit was
	 * removed correctly.
	 * 
	 * @see #compilationUnits
	 */
	function removeCompilationUnit(unit:ICompilationUnit):Boolean;
	
	/**
	 * Adds a <code>IClassPathEntry</code> to the project.
	 * 
	 * @param classPath A <code>String</code> base path location 
	 * for source files.
	 * @return A <code>IClassPathEntry</code>.
	 */
	function addClassPath(classPath:String):IClassPathEntry;
	
	/**
	 * Removes a <code>IClassPathEntry</code> from the project.
	 * 
	 * @param classPath A <code>String</code> base path location 
	 * for source files.
	 * @return A <code>Boolean</code> indicating whether the path was
	 * removed successfully.
	 */
	function removeClassPath(classPath:String):Boolean;
	
	/**
	 * Adds a <code>IResourceRoot</code> to the project.
	 * 
	 * @param resource A <code>IResourceRoot</code> location for source 
	 * file definitions.
	 */
	function addResourceRoot(resource:IResourceRoot):void;
	
	/**
	 * Removes a <code>IResourceRoot</code> from the project.
	 * 
	 * @param resource A <code>IResourceRoot</code> location for source 
	 * file definitions.
	 */
	function removeResourceRoot(resource:IResourceRoot):void;
	
	/**
	 * Creates and returns a new public <code>class</code> by qualified name.
	 * 
	 * @param qualifiedName A <code>String</code> qualified name.
	 * @return A new class <code>ICompilationUnit</code>.
	 * 
	 * @see org.as3commons.asblocks.api.ICompilationUnit
	 * @see org.as3commons.asblocks.api.IClassType
	 */
	function newClass(qualifiedName:String):ICompilationUnit;
	
	/**
	 * Creates and returns a new public <code>interface</code> by qualified name.
	 * 
	 * @param qualifiedName A <code>String</code> qualified name.
	 * @return A new interface <code>ICompilationUnit</code>.
	 * 
	 * @see org.as3commons.asblocks.api.ICompilationUnit
	 * @see org.as3commons.asblocks.api.IInterfaceType
	 */
	function newInterface(qualifiedName:String):ICompilationUnit;
	
	/**
	 * Reads all class path entries and creates parsed 
	 * <code>ICompilationUnit</code>s synchronously.
	 */
	function readAll():void;
	
	/**
	 * Reads all class path entries and creates parsed 
	 * <code>ICompilationUnit</code>s asynchronously.
	 */
	function readAllAsync():void;
	
	/**
	 * Writes all <code>ICompilationUnit</code>s synchronously.
	 */
	function writeAll():void;
	
	/**
	 * Writes all <code>ICompilationUnit</code>s asynchronously.
	 */
	function writeAllAsync():void;
}
}