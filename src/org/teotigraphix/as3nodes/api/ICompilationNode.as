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
 * The <strong>ICompilationNode</strong> is at the top of the compilation
 * parse tree.
 * 
 * <p>The <strong>ICompilationNode</strong> contains the public package 
 * and a reference to the type (class|interface) declared in the 
 * public package.</p>
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public interface ICompilationNode extends INode
{
	//--------------------------------------------------------------------------
	//
	//  ICompilationNode API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  packageNode
	//----------------------------------
	
	/**
	 * The public package found in this compilation node.
	 */
	function get packageNode():IPackageNode;
	
	//----------------------------------
	//  packageName
	//----------------------------------
	
	/**
	 * The package name of the compilation node.
	 */
	function get packageName():String;
	
	//----------------------------------
	//  typeNode
	//----------------------------------
	
	/**
	 * The public type found in this compilation node, either class or interface.
	 */
	function get typeNode():ITypeNode;
}
}