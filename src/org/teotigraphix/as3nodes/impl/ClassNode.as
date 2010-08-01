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

package org.teotigraphix.as3nodes.impl
{

import org.teotigraphix.as3nodes.api.IAttributeNode;
import org.teotigraphix.as3nodes.api.IClassNode;
import org.teotigraphix.as3nodes.api.IConstantNode;
import org.teotigraphix.as3nodes.api.IIdentifierNode;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3nodes.utils.NodeUtil;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;

/**
 * The class found in the package node.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class ClassNode extends TypeNode implements IClassNode
{
	//--------------------------------------------------------------------------
	//
	//  IClassNode API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  superType
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _superType:IIdentifierNode;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IClassNode#superType
	 */
	public function get superType():IIdentifierNode
	{
		if (superTypeList && superTypeList.length == 1)
			return superTypeList[0];
		return null;
	}
	
	//----------------------------------
	//  implementList
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _implementList:Vector.<IIdentifierNode>;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IClassNode#implementList
	 */
	public function get implementList():Vector.<IIdentifierNode>
	{
		return _implementList;
	}
	
	/**
	 * @private
	 */	
	public function set implementList(value:Vector.<IIdentifierNode>):void
	{
		_implementList = value;
	}
	
	//----------------------------------
	//  constants
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _constants:Vector.<IConstantNode>;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IClassNode#constants
	 */
	public function get constants():Vector.<IConstantNode>
	{
		return _constants;
	}
	
	/**
	 * @private
	 */	
	public function set constants(value:Vector.<IConstantNode>):void
	{
		_constants = value;
	}
	
	//----------------------------------
	//  attributes
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _attributes:Vector.<IAttributeNode>;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IClassNode#attributes
	 */
	public function get attributes():Vector.<IAttributeNode>
	{
		return _attributes;
	}
	
	/**
	 * @private
	 */	
	public function set attributes(value:Vector.<IAttributeNode>):void
	{
		_attributes = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function ClassNode(node:IParserNode, parent:INode)
	{
		super(node, parent);
	}
	
	//--------------------------------------------------------------------------
	//
	//  IClassNode API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IClassNode#addImplementation()
	 */
	public function addImplementation(implementation:IIdentifierNode):void
	{
		_implementList.push(implementation);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden Protected :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	override protected function compute():void
	{
		super.compute();
		
		superTypeList = new Vector.<IIdentifierNode>();
		implementList = new Vector.<IIdentifierNode>();
		
		if (node.numChildren == 0)
			return;
		
		for each (var child:IParserNode in node.children)
		{
			if (child.isKind(AS3NodeKind.EXTENDS))
			{
				computeExtends(child);
			}
			else if (child.isKind(AS3NodeKind.IMPLEMENTS_LIST))
			{
				computeImplementsList(child);
			}
		}
	}
	
	/**
	 * @private
	 */
	override protected function computeContent(typeContent:IParserNode):void
	{
		super.computeContent(typeContent);
		
		constants = new Vector.<IConstantNode>();
		attributes = new Vector.<IAttributeNode>();
		
		if (typeContent.numChildren == 0)
			return;
		
		for each (var child:IParserNode in typeContent.children)
		{
			detectConstant(child);
			detectAttribute(child);
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//  Protected :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	protected function computeExtends(typeContent:IParserNode):void
	{
		NodeUtil.computeExtends(this, typeContent);
	}
	
	/**
	 * @private
	 */
	protected function computeImplementsList(typeContent:IParserNode):void
	{
		NodeUtil.computeImplementsList(this, typeContent);
	}
	
	/**
	 * @private
	 */
	protected function detectConstant(child:IParserNode):void
	{
		if (child.isKind(AS3NodeKind.CONST_LIST))
		{
			constants.push(NodeFactory.instance.createConstant(child, this));
		}
	}
	
	/**
	 * @private
	 */
	protected function detectAttribute(child:IParserNode):void
	{
		if (child.isKind(AS3NodeKind.VAR_LIST))
		{
			attributes.push(NodeFactory.instance.createAttribute(child, this));
		}
	}
}
}