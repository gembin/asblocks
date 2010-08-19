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

// TODO add includes Vector and implementation
// TODO add uses Vector and implementation

/**
 * The <strong>IPackageNode</strong> is the toplevel public element in an
 * <code>ICompilationNode</code> container.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public interface IPackageNode extends INode, INameAware, IIdentifierAware
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  typeNode
	//----------------------------------
	
	/**
	 * The <code>IClassTypeNode</code>, <code>IInterfaceTypeNode</code> or
	 * <code>IFunctionTypeNode</code> found within this public package definition.
	 */
	function get typeNode():ITypeNode;
	
	/**
	 * @private
	 */
	function set typeNode(value:ITypeNode):void;
	
	//----------------------------------
	//  qualifiedName
	//----------------------------------
	
	/**
	 * The qualifiedName of the child <code>typeNode</code> element.
	 * 
	 * <p>If the child <code>typeNode</code> was a <code>IClassTypeNode</code>
	 * this value could be <strong>my.domain.TestClass</strong>.</p>
	 */
	function get qualifiedName():String;
	
	//----------------------------------
	//  imports
	//----------------------------------
	
	/**
	 * The package imports, imports found withing the class or interface will
	 * be merged into this Vector during proccessing.
	 */
	function get imports():Vector.<IIdentifierNode>;
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	function hasImport(qualifiedName:String):Boolean;
	
	/**
	 * Adds an import node to the package node.
	 * 
	 * @param node The <code>IIdentifierNode</code> node.
	 */
	function addImport(node:IIdentifierNode):IIdentifierNode;
	
	/**
	 * Removes an import node from the package node.
	 * 
	 * @param node The <code>IIdentifierNode</code> node.
	 */
	function removeImport(node:IIdentifierNode):IIdentifierNode;
	
	function getImport(qualifiedName:String):IIdentifierNode;
	
	function newImport(name:String):IIdentifierNode;
	
	//----------------------------------
	//  Factory
	//----------------------------------
	
	function newClass(name:String):IClassTypeNode;
	
}
}