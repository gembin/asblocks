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

import org.teotigraphix.as3nodes.api.IAccessorNode;
import org.teotigraphix.as3nodes.api.IAttributeNode;
import org.teotigraphix.as3nodes.api.IClassTypeNode;
import org.teotigraphix.as3nodes.api.IConstantNode;
import org.teotigraphix.as3nodes.api.IFunctionTypeNode;
import org.teotigraphix.as3nodes.api.IInterfaceTypeNode;
import org.teotigraphix.as3nodes.api.IMetaDataAware;
import org.teotigraphix.as3nodes.api.IMetaDataNode;
import org.teotigraphix.as3nodes.api.IMethodNode;
import org.teotigraphix.as3nodes.api.ISeeLink;
import org.teotigraphix.as3nodes.api.ISeeLinkAware;
import org.teotigraphix.as3nodes.api.ISourceFilePackage;
import org.teotigraphix.as3nodes.api.ITypeNode;
import org.teotigraphix.as3nodes.api.MetaData;
import org.teotigraphix.as3nodes.api.Modifier;

/**
 * The <strong>IAS3BookAccessor</strong> interface is used to access the
 * <code>IAS3Book</code> implementation with detailed knowledge
 * of modifiers, doctags etc that can affect collections.
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
	 * The <code>IAS3Book</code> implementation model.
	 */
	function get book():IAS3Book;
	
	/**
	 * @private
	 */
	function set book(value:IAS3Book):void;
	
	//----------------------------------
	//  sourceFilePackages
	//----------------------------------
	
	/**
	 * A <code>Vector</code> of <code>ISourceFilePackage</code> or 
	 * <code>null</code>.
	 */
	function get sourceFilePackages():Vector.<ISourceFilePackage>;
	
	//----------------------------------
	//  types
	//----------------------------------
	
	/**
	 * All <code>AS3NodeKind.CLASS</code>, <code>AS3NodeKind.INTERFACE</code>
	 * or <code>AS3NodeKind.FUNCTION</code> type elements.
	 */
	function get types():Vector.<ITypeNode>;
	
	//----------------------------------
	//  classTypes
	//----------------------------------
	
	/**
	 * All <code>AS3NodeKind.CLASS</code> type elements.
	 */
	function get classTypes():Vector.<IClassTypeNode>;
	
	//----------------------------------
	//  interfaceTypes
	//----------------------------------
	
	/**
	 * All <code>AS3NodeKind.INTERFACE</code> type elements.
	 */
	function get interfaceTypes():Vector.<IInterfaceTypeNode>;
	
	//----------------------------------
	//  functionTypes
	//----------------------------------
	
	/**
	 * All <code>AS3NodeKind.FUNCTION</code> type elements.
	 */
	function get functionTypes():Vector.<IFunctionTypeNode>;
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Returns an <code>ISeeLink</code> for the <code>ISeeLinkAware</code>.
	 * 
	 * @param node An <code>ISeeLinkAware</code>.
	 * @return A <code>ISeeLink</code> or <code>null</code>.
	 */
	function getLink(node:ISeeLinkAware):ISeeLink;
	
	/**
	 * Returns an <code>ISeeLink</code> for the String see link format.
	 * 
	 * @param linkID A String see link format.
	 * @return A <code>ISeeLink</code> or <code>null</code>.
	 */
	function getLinkByID(linkID:String):ISeeLink;
		
	/**
	 * Returns all collections found.
	 * 
	 * <p>The <code>ISourceFileCollection</code> is a container for
	 * <code>ISourceFile</code>s.</p>
	 * 
	 * @param name The String name like <code>my.domain.core</code>.
	 * @return A <code>ISourceFileCollection</code> or <code>null</code>.
	 */
	function getSourceFilePackage(packageName:String):ISourceFilePackage;
	
	/**
	 * Returns whether the book contains a source file package by the name
	 * packageName.
	 * 
	 * @param packageName The String package name IE <code>my.domain.core</code>.
	 * @return A Boolean indicating whether to book contains the package name.
	 */
	function hasSourceFilePackage(packageName:String):Boolean;
	
	/**
	 * Returns all <code>ITypeNode</code>s for the packageName, 
	 * if the qname does not exists, the method returns <code>null</code>.
	 * 
	 * @param qualifiedName The String qualifiedName.
	 * @return <code>ITypeNode</code> or <code>null</code>.
	 */
	function getTypes(packageName:String):Vector.<ITypeNode>;
	
	/**
	 * Returns an <code>ITypeNode</code> for the qualifiedName, 
	 * if the qname does not exists, the method returns <code>null</code>.
	 * 
	 * @param qualifiedName The String qualifiedName.
	 * @return <code>ITypeNode</code> or <code>null</code>.
	 */
	function findType(qualifiedName:String):ITypeNode;
	
	/**
	 * Uses <code>findType()</code>, if the method returns null, this method will
	 * create an <code>TypeNodePlaceholder</code> and return it.
	 * 
	 * @param qualifiedName The String qualifiedName.
	 * @return <code>ITypeNode</code> or <code>TypeNodePlaceholder</code>.
	 */
	function getType(qualifiedName:String):ITypeNode;
	
	/**
	 * Returns whether the book contains an <code>ITypeNode</code> instance
	 * matching the qualifiedName.
	 * 
	 * @param qualifiedName The String qualifiedName.
	 * @return A Boolean indicating whether the <code>ITypeNode</code> exists.
	 */
	function hasType(qualifiedName:String):Boolean;
	
	/**
	 * Returns an <code>IClassTypeNode</code> for the qualifiedName, 
	 * if the qualifiedName does not exist, the method returns <code>null</code>.
	 * 
	 * @param qualifiedName The String qualifiedName.
	 * @return <code>IClassTypeNode</code> or <code>null</code>.
	 */
	function findClassType(qualifiedName:String):IClassTypeNode;
	
	/**
	 * Returns an <code>IInterfaceTypeNode</code> for the qualifiedName, 
	 * if the qualifiedName does not exist, the method returns <code>null</code>.
	 * 
	 * @param qualifiedName The String qualifiedName.
	 * @return <code>IInterfaceTypeNode</code> or <code>null</code>.
	 */
	function findInterfaceType(qualifiedName:String):IInterfaceTypeNode;
	
	/**
	 * Returns an <code>IFunctionTypeNode</code> for the qualifiedName, 
	 * if the qualifiedName does not exist, the method returns <code>null</code>.
	 * 
	 * @param qualifiedName The String qualifiedName.
	 * @return <code>IFunctionTypeNode</code> or <code>null</code>.
	 */
	function findFunctionType(qualifiedName:String):IFunctionTypeNode;
	
	// function getInnerTypes(element:ICompilationNode):Vector.<ITypeNode>;
	
	//----------------------------------
	//  Class
	//----------------------------------
	
	/**
	 * Returns all superclasses of an <code>ITypeNode</code>.
	 * 
	 * @param node An <code>ITypeNode</code>.
	 * @return Vector of <code>ITypeNode</code> superclasses.
	 */
	function getSuperClasses(node:ITypeNode):Vector.<ITypeNode>;
	
	/**
	 * Returns all subclasses of an <code>ITypeNode</code>.
	 * 
	 * @param node An <code>ITypeNode</code>.
	 * @return Vector of <code>ITypeNode</code> subclasses.
	 */
	function getSubClasses(node:ITypeNode):Vector.<ITypeNode>;
	
	/**
	 * Returns all <code>ITypeNode</code> interface implementations.
	 * 
	 * @param node An <code>ITypeNode</code>.
	 * @return Vector of <code>ITypeNode</code> implementations.
	 */
	function getImplementedInterfaces(node:ITypeNode):Vector.<ITypeNode>;
	
	//----------------------------------
	//  Interface
	//----------------------------------
	
	/**
	 * Returns all <code>ITypeNode</code> interface implementations.
	 * 
	 * @param node An <code>ITypeNode</code>.
	 * @return Vector of <code>ITypeNode</code> implementations.
	 */
	function getInterfaceImplementors(node:ITypeNode):Vector.<ITypeNode>;
	
	/**
	 * Returns all <code>ITypeNode</code> superinterfaces.
	 * 
	 * @param node An <code>ITypeNode</code>.
	 * @return Vector of <code>ITypeNode</code> superinterfaces.
	 */
	function getSuperInterfaces(node:ITypeNode):Vector.<ITypeNode>;
	
	/**
	 * Returns all <code>ITypeNode</code> subinterfaces.
	 * 
	 * @param node An <code>ITypeNode</code>.
	 * @return Vector of <code>ITypeNode</code> subinterfaces.
	 */
	function getSubInterfaces(node:ITypeNode):Vector.<ITypeNode>;
	
	//----------------------------------
	//  Class members
	//----------------------------------
	
	/**
	 * Returns all <code>IConstantNode</code> for the given
	 * <code>IClassTypeNode</code>.
	 * 
	 * @param node The <code>IClassTypeNode</code> parent.
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
	
	/**
	 * Returns all <code>IAttributeNode</code> for the given
	 * <code>IClassTypeNode</code>.
	 * 
	 * @param node The <code>IClassTypeNode</code> parent.
	 * @param visibility The visibility of the member; <code>public</code>,
	 * <code>protected</code>, <code>private</code>, <code>internal</code>
	 * , or a custom name space.
	 * @param inherit A boolean indicating whether to return the full super list
	 * of members with no duplication.
	 * @return A <code>Vector</code> of <code>IAttributeNode</code> elements or
	 * an empty <code>Vector</code>.
	 */
	function getAttributes(node:IClassTypeNode, 
						   modifier:Modifier, 
						   inherit:Boolean):Vector.<IAttributeNode>;
	
	/**
	 * Returns all <code>IAccessorNode</code> for the given
	 * <code>ITypeNode</code>.
	 * 
	 * @param node The <code>ITypeNode</code> parent.
	 * @param visibility The visibility of the member; <code>public</code>,
	 * <code>protected</code>, <code>private</code>, <code>internal</code>
	 * , or a custom name space.
	 * @param inherit A boolean indicating whether to return the full super list
	 * of members with no duplication.
	 * @return A <code>Vector</code> of <code>IAccessorNode</code> elements or
	 * an empty <code>Vector</code>.
	 */
	function getAccessors(node:ITypeNode, 
						  modifier:Modifier, 
						  inherit:Boolean):Vector.<IAccessorNode>;
	
	/**
	 * Returns all <code>IMethodNode</code> for the given
	 * <code>ITypeNode</code>.
	 * 
	 * @param node The <code>ITypeNode</code> parent.
	 * @param visibility The visibility of the member; <code>public</code>,
	 * <code>protected</code>, <code>private</code>, <code>internal</code>
	 * , or a custom name space.
	 * @param inherit A boolean indicating whether to return the full super list
	 * of members with no duplication.
	 * @return A <code>Vector</code> of <code>IMethodNode</code> elements or
	 * an empty <code>Vector</code>.
	 */
	function getMethods(node:ITypeNode, 
						modifier:Modifier, 
						inherit:Boolean):Vector.<IMethodNode>;
	
	//----------------------------------
	//  Metadata
	//----------------------------------
	
	/**
	 * Returns all the metaData for the node by name.
	 * 
	 * @param node An <code>IMetaDataAware</code> to retrieve the metaData for.
	 * @param name A <code>MetaData</code> name.
	 * @return A Vector of <code>IMetaDataNode</code>.
	 */
	function getMetaData(node:IMetaDataAware, 
						 name:MetaData, 
						 inherit:Boolean):Vector.<IMetaDataNode>;
	
	/**
	 * Returns all the metaData in the book name.
	 * 
	 * @param name A <code>MetaData</code> name.
	 * @return A Vector of <code>IMetaDataNode</code>.
	 */
	function getAllMetaData(name:MetaData):Vector.<IMetaDataNode>;
	
	/**
	 * Returns all <strong>Style</strong> <code>IMetaDataNode</code> elements
	 * for the given <code>ITypeNode</code> parent.
	 * 
	 * @param node The parent <code>ITypeNode</code>.
	 * @param inherit A Boolean indicating whether to return the full super list
	 *        of members with no duplication.
	 * @return A <code>Vector</code> of <code>IMetaDataNode</code> elements or
	 *         an empty <code>Vector</code>.
	 */
	function getStyles(node:ITypeNode, inherit:Boolean):Vector.<IMetaDataNode>;
	
	/**
	 * Returns all <strong>Event</strong> <code>IMetaDataNode</code> elements
	 * for the given <code>ITypeNode</code> parent.
	 * 
	 * @param node The parent <code>ITypeNode</code>.
	 * @param inherit A Boolean indicating whether to return the full super list
	 *        of members with no duplication.
	 * @return A <code>Vector</code> of <code>IMetaDataNode</code> elements or
	 *         an empty <code>Vector</code>.
	 */
	function getEvents(node:ITypeNode, inherit:Boolean):Vector.<IMetaDataNode>;
	
	/**
	 * Returns all <strong>Effect</strong> <code>IMetaDataNode</code> elements
	 * for the given <code>ITypeNode</code> parent.
	 * 
	 * @param node The parent <code>ITypeNode</code>.
	 * @param inherit A Boolean indicating whether to return the full super list
	 *        of members with no duplication.
	 * @return A <code>Vector</code> of <code>IMetaDataNode</code> elements or
	 *         an empty <code>Vector</code>.
	 */
	function getEffects(node:ITypeNode, inherit:Boolean):Vector.<IMetaDataNode>;
	
	/**
	 * Returns all <strong>SkinState</strong> <code>IMetaDataNode</code> elements
	 * for the given <code>ITypeNode</code> parent.
	 * 
	 * @param node The parent <code>ITypeNode</code>.
	 * @param inherit A Boolean indicating whether to return the full super list
	 *        of members with no duplication.
	 * @return A <code>Vector</code> of <code>IMetaDataNode</code> elements or
	 *         an empty <code>Vector</code>.
	 */
	function getSkinStates(node:ITypeNode, inherit:Boolean):Vector.<IMetaDataNode>;
	
	/**
	 * Returns all <strong>SkinPart</strong> <code>IMetaDataNode</code> elements
	 * for the given <code>ITypeNode</code> parent.
	 * 
	 * @param node The parent <code>ITypeNode</code>.
	 * @param inherit A Boolean indicating whether to return the full super list
	 *        of members with no duplication.
	 * @return A <code>Vector</code> of <code>IMetaDataNode</code> elements or
	 *         an empty <code>Vector</code>.
	 */
	function getSkinParts(node:ITypeNode, inherit:Boolean):Vector.<IMetaDataNode>;
}
}