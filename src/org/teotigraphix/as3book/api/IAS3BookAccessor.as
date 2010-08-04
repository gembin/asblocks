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

package org.teotigraphix.as3book.api
{

import org.teotigraphix.as3nodes.api.IClassTypeNode;
import org.teotigraphix.as3nodes.api.IConstantNode;
import org.teotigraphix.as3nodes.api.IFunctionTypeNode;
import org.teotigraphix.as3nodes.api.IInterfaceTypeNode;
import org.teotigraphix.as3nodes.api.ISourceFileCollection;
import org.teotigraphix.as3nodes.api.ITypeNode;
import org.teotigraphix.as3nodes.api.Modifier;

/**
 * TODO DOCME
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public interface IAS3BookAccessor
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  book
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get book():IAS3Book;
	
	/**
	 * @private
	 */
	function set book(value:IAS3Book):void;
	
	function get sourceFileCollections():Vector.<ISourceFileCollection>;
	
	function get types():Vector.<ITypeNode>;
	
	function get classTypes():Vector.<IClassTypeNode>;
	
	function get interfaceTypes():Vector.<IInterfaceTypeNode>;
	
	function get functionTypes():Vector.<IFunctionTypeNode>;
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	function getSourceFileCollection(packageName:String):ISourceFileCollection;
	
	function getTypes(packageName:String):Vector.<ITypeNode>;
	
	function findType(qualifiedName:String):ITypeNode;
	
	function getType(qualifiedName:String):ITypeNode;
	
	function hasType(qualifiedName:String):Boolean;
	
	function findClassType(qualifiedName:String):IClassTypeNode;
	
	function findInterfaceType(qualifiedName:String):IInterfaceTypeNode;
	
	function findFunctionType(qualifiedName:String):IFunctionTypeNode;
	
	//----------------------------------
	//  Class
	//----------------------------------
	
	function getSuperClasses(node:ITypeNode):Vector.<ITypeNode>;
	
	function getSubClasses(node:ITypeNode):Vector.<ITypeNode>;
	
	function getImplementedInterfaces(node:ITypeNode):Vector.<ITypeNode>;
	
	function getInterfaceImplementors(node:ITypeNode):Vector.<ITypeNode>;
	
	function getSuperInterfaces(node:ITypeNode):Vector.<ITypeNode>;
	
	function getSubInterfaces(node:ITypeNode):Vector.<ITypeNode>;
	
	//----------------------------------
	//  Class members
	//----------------------------------
	
	/**
	 * Returns all <code>IConstantNode</code> for the given
	 * <code>IClassTypeNode</code>.
	 * 
	 * @param node The <code>ITypeElement</code> parent.
	 * @param visibility The visibility of the member; <code>public</code>,
	 * <code>protected</code>, <code>private</code>, <code>internal</code>
	 * , or a custom name space.
	 * @param inherit A boolean indicating whether to return the full super list
	 * of members with no duplication.
	 * @return A <code>Vector</code> of <code>IConstantNode</code> elements or
	 * an empty <code>Vector</code>.
	 */
	function getConstants(node:IClassTypeNode, 
						  modifier:Modifier, 
						  inherit:Boolean):Vector.<IConstantNode>;
	
	
	
}
}