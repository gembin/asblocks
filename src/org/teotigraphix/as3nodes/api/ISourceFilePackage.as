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
 * The <strong>ISourceFilePackage</strong> API is a container for
 * </code>ISourceFile</code> instances.
 * 
 * <p>The <code>classPath</code> points to the base file path of all the
 * source files contained within the collection. This means all source files
 * share the same folder.</p>
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public interface ISourceFilePackage extends INode, INameAware, ISeeLinkAware
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  classPath
	//----------------------------------
	
	/**
	 * The collections base class path.
	 * 
	 * <p>The class path is the base directory of the package excluding the
	 * package's name IE <code>[/home/dev/proj/src]/my/domain/core.</p>
	 */
	function get classPath():String;
	
	//----------------------------------
	//  directoryPath
	//----------------------------------
	
	/**
	 * The collections directory class path.
	 * 
	 * <p>The directory path is the full directory of the package, including the
	 * package's name IE <code>/home/dev/proj/src[/my/domain/core]</code>.</p>
	 */
	function get directoryPath():String;
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Adds an <code>ISourceFile</code> to the package.
	 * 
	 * @param sourceFile An <code>ISourceFile</code> instance.
	 */
	function addSourceFile(sourceFile:ISourceFile):void;
}
}