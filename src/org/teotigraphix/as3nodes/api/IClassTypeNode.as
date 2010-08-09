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
public interface IClassTypeNode extends ITypeNode
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  isFinal
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get isFinal():Boolean;
	
	/**
	 * @private
	 */
	function set isFinal(value:Boolean):void;
	
	//----------------------------------
	//  isDynamic
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get isDynamic():Boolean;
	
	/**
	 * @private
	 */
	function set isDynamic(value:Boolean):void;
	
	//----------------------------------
	//  superClass
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get superClass():IIdentifierNode;
	
	/**
	 * @private
	 */
	function set superClass(value:IIdentifierNode):void;
	
	//----------------------------------
	//  implements
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get implementList():Vector.<IIdentifierNode>;
	
	/**
	 * @private
	 */
	function set implementList(value:Vector.<IIdentifierNode>):void;
	
	//----------------------------------
	//  hasImplementations
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get hasImplementations():Boolean;
	
	//----------------------------------
	//  constants
	//----------------------------------
	
	/**
	 * The type's IConstantNode children.
	 */
	function get constants():Vector.<IConstantNode>;
	
	//----------------------------------
	//  attributes
	//----------------------------------
	
	/**
	 * The type's IAttributeNode children.
	 */
	function get attributes():Vector.<IAttributeNode>;
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * TODO Docme
	 */
	function addImplementation(implementation:IIdentifierNode):void;
	
	/**
	 * TODO Docme
	 */
	function hasImplementation(implementation:IIdentifierNode):Boolean;
}
}