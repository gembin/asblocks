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
import org.teotigraphix.as3nodes.api.IClassTypeNode;
import org.teotigraphix.as3nodes.api.IConstantNode;
import org.teotigraphix.as3nodes.api.IIdentifierNode;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3nodes.api.Modifier;
import org.teotigraphix.as3nodes.utils.ASTNodeUtil;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;

/**
 * The class found in the package node.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class ClassTypeNode extends TypeNode implements IClassTypeNode
{
	//--------------------------------------------------------------------------
	//
	//  IClassTypeNode API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  isFinal
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IClassTypeNode#isFinal
	 */
	public function get isFinal():Boolean
	{
		return hasModifier(Modifier.FINAL);
	}
	
	/**
	 * @private
	 */	
	public function set isFinal(value:Boolean):void
	{
		if (hasModifier(Modifier.FINAL))
			return;
		
		addModifier(Modifier.FINAL);
	}
	
	//----------------------------------
	//  isDynamic
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IClassTypeNode#isDynamic
	 */
	public function get isDynamic():Boolean
	{
		return hasModifier(Modifier.DYNAMIC);
	}
	
	/**
	 * @private
	 */	
	public function set isDynamic(value:Boolean):void
	{
		if (hasModifier(Modifier.DYNAMIC))
			return;
		
		addModifier(Modifier.DYNAMIC);
	}
	
	//----------------------------------
	//  superClass
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _superClass:IIdentifierNode;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IClassTypeNode#superType
	 */
	public function get superClass():IIdentifierNode
	{
		return _superClass;
	}
	
	public function set superClass(value:IIdentifierNode):void
	{
		_superClass = value;
		
		ASTNodeUtil.setSuperClass(this, _superClass);
	}
	
	//----------------------------------
	//  isSubType
	//----------------------------------
	
	/**
	 * @private
	 */
	override public function get isSubType():Boolean
	{
		return _superClass != null;
	}
	
	//----------------------------------
	//  implementList
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _implementList:Vector.<IIdentifierNode>;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IClassTypeNode#implementList
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
	//  hasImplementations
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IClassTypeNode#hasImplementations
	 */
	public function get hasImplementations():Boolean
	{
		return _implementList && _implementList.length > 0;
	}
	
	//----------------------------------
	//  constants
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _constants:Vector.<IConstantNode>;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IClassTypeNode#constants
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
	 * @copy org.teotigraphix.as3nodes.api.IClassTypeNode#attributes
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
	public function ClassTypeNode(node:IParserNode, parent:INode)
	{
		super(node, parent);
	}
	
	//--------------------------------------------------------------------------
	//
	//  IClassNode API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IClassTypeNode#addImplementation()
	 */
	public function addImplementation(implementation:IIdentifierNode):void
	{
		if (hasImplementation(implementation))
			return;
		
		_implementList.push(implementation);
		
		ASTNodeUtil.addImplementation(this, implementation);
	}
	
	public function hasImplementation(implementation:IIdentifierNode):Boolean
	{
		for each (var element:IIdentifierNode in _implementList)
		{
			if (element.qualifiedName == implementation.qualifiedName)
				return true;
		}
		return false;
	}
	
	//----------------------------------
	//  IConstantNode
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IClassTypeNode#hasConstant()
	 */
	public function hasConstant(name:String):Boolean
	{
		var len:int = constants.length;
		for (var i:int = 0; i < len; i++)
		{
			if (constants[i].name == name)
				return true;
		}
		return false;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IClassTypeNode#addConstant()
	 */
	public function addConstant(child:IConstantNode):IConstantNode
	{
		if (hasConstant(child.name))
			return null;
		
		constants.push(child);
		
		dispatchAddChange(AS3NodeKind.CONST_LIST, child);
		
		return child;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IClassTypeNode#removeConstant()
	 */
	public function removeConstant(child:IConstantNode):IConstantNode
	{
		var len:int = constants.length;
		for (var i:int = 0; i < len; i++)
		{
			var element:IConstantNode = constants[i] as IConstantNode;
			if (element.name == child.name)
			{
				constants.splice(i, 1);
				dispatchRemoveChange(AS3NodeKind.CONST_LIST, child);
				return element;
			}
		}
		return null;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IClassTypeNode#getConstant()
	 */
	public function getConstant(name:String):IConstantNode
	{
		var len:int = constants.length;
		for (var i:int = 0; i < len; i++)
		{
			if (constants[i].name == name)
				return constants[i];
		}
		return null;
	}
	
	/**
	 * @see org.teotigraphix.as3nodes.api.IClassTypeNode#newConstant()
	 */
	public function newConstant(name:String, 
								visibility:Modifier, 
								type:IIdentifierNode,
								primary:String):IConstantNode
	{
		return as3Factory.newConstant(this, name, visibility, type, primary);
	}
	
	//----------------------------------
	//  IAttributeNode
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IClassTypeNode#hasAttribute()
	 */
	public function hasAttribute(name:String):Boolean
	{
		var len:int = attributes.length;
		for (var i:int = 0; i < len; i++)
		{
			if (attributes[i].name == name)
				return true;
		}
		return false;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IClassTypeNode#addAttribute()
	 */
	public function addAttribute(child:IAttributeNode):IAttributeNode
	{
		if (hasAttribute(child.name))
			return null;
		
		attributes.push(child);
		
		dispatchAddChange(AS3NodeKind.VAR_LIST, child);
		
		return child;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IClassTypeNode#removeAttribute()
	 */
	public function removeAttribute(child:IAttributeNode):IAttributeNode
	{
		var len:int = attributes.length;
		for (var i:int = 0; i < len; i++)
		{
			var element:IAttributeNode = attributes[i] as IAttributeNode;
			if (element.name == child.name)
			{
				attributes.splice(i, 1);
				dispatchRemoveChange(AS3NodeKind.VAR_LIST, child);
				return element;
			}
		}
		return null;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IClassTypeNode#getAttribute()
	 */
	public function getAttribute(name:String):IAttributeNode
	{
		var len:int = attributes.length;
		for (var i:int = 0; i < len; i++)
		{
			if (attributes[i].name == name)
				return attributes[i];
		}
		return null;
	}
	
	/**
	 * @see org.teotigraphix.as3nodes.api.IClassTypeNode#newAttribute()
	 */
	public function newAttribute(name:String, 
								 visibility:Modifier, 
								 type:IIdentifierNode,
								 primary:String = null):IAttributeNode
	{
		return as3Factory.newAttribute(this, name, visibility, type, primary);
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
	 * Computes the <code>superType</code> and <code>superTypes</code>.
	 * 
	 * @param typeContent An ITypeNode node.
	 */
	protected function computeExtends(typeContent:IParserNode):void
	{
		_superClass = NodeFactory.instance.createIdentifier(typeContent, this);
	}
	
	/**
	 * Computes the <code>implementsList</code>.
	 * 
	 * @param typeContent An IClassNode node.
	 */
	protected function computeImplementsList(typeContent:IParserNode):void
	{
		if (!typeContent || typeContent.numChildren == 0)
			return;
		
		var len:int = typeContent.children.length;
		for (var i:int = 0; i < len; i++)
		{
			implementList.push(NodeFactory.instance.
				createIdentifier(typeContent.children[i], this));
		}
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