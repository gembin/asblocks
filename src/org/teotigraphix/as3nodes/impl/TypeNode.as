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

import org.teotigraphix.as3nodes.api.IAccessorNode;
import org.teotigraphix.as3nodes.api.IIdentifierNode;
import org.teotigraphix.as3nodes.api.IMethodNode;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3nodes.api.ITypeNode;
import org.teotigraphix.as3nodes.api.Modifier;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;

/**
 * The class|interface|function found in the package node.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class TypeNode extends ScriptNode implements ITypeNode
{	
	//--------------------------------------------------------------------------
	//
	//  ITypeNode API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  isSubType
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ITypeNode#isSubType
	 */
	public function get isSubType():Boolean
	{
		return false;
	}
	
	//----------------------------------
	//  accessors
	//----------------------------------
	
	/**
	 * @private
	 */
	protected var _accessors:Vector.<IAccessorNode>;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ITypeNode#accessors
	 */
	public function get accessors():Vector.<IAccessorNode>
	{
		return _accessors;
	}
	
	//----------------------------------
	//  getters
	//----------------------------------
	
	/**
	 * @private
	 */
	protected var _getters:Vector.<IAccessorNode>;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ITypeNode#getters
	 */
	public function get getters():Vector.<IAccessorNode>
	{
		return _getters;
	}
	
	//----------------------------------
	//  setters
	//----------------------------------
	
	/**
	 * @private
	 */
	protected var _setters:Vector.<IAccessorNode>;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ITypeNode#setters
	 */
	public function get setters():Vector.<IAccessorNode>
	{
		return _setters;
	}
	
	//----------------------------------
	//  methods
	//----------------------------------
	
	/**
	 * @private
	 */
	protected var _methods:Vector.<IMethodNode>;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ITypeNode#methods
	 */
	public function get methods():Vector.<IMethodNode>
	{
		return _methods;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function TypeNode(node:IParserNode, parent:INode)
	{
		super(node, parent);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden Public :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	override public function toLink():String
	{
		return qualifiedName;
	}
	
	//--------------------------------------------------------------------------
	//
	//  ITypeNode API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ITypeNode#addAccessor()
	 */
	public function addAccessor(node:IAccessorNode):void
	{
		accessors.push(node);
	}
	
	//----------------------------------
	//  Methods
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ITypeNode#hasMethod()
	 */
	public function hasMethod(name:String):Boolean
	{
		var len:int = methods.length;
		for (var i:int = 0; i < len; i++)
		{
			if (methods[i].name == name)
				return true;
		}
		return false;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ITypeNode#addMethod()
	 */
	public function addMethod(node:IMethodNode):void
	{
		if (hasMethod(node.name))
			return;
		
		methods.push(node);
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ITypeNode#removeMethod()
	 */
	public function removeMethod(node:IMethodNode):IMethodNode
	{
		var len:int = methods.length;
		for (var i:int = 0; i < len; i++)
		{
			var element:IMethodNode = methods[i] as IMethodNode;
			if (element.name == node.name)
			{
				methods.splice(i, 1);
				return element;
			}
		}
		return null;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ITypeNode#getMethod()
	 */
	public function getMethod(name:String):IMethodNode
	{
		var len:int = methods.length;
		for (var i:int = 0; i < len; i++)
		{
			if (methods[i].name == name)
				return methods[i];
		}
		return null;
	}
	
	//----------------------------------
	//  Factory Methods
	//----------------------------------
	
	/**
	 * @see org.teotigraphix.as3nodes.api.IAS3Factory#newMethod()
	 */
	public function newMethod(name:String, 
							  visibility:Modifier, 
							  returnType:IIdentifierNode):IMethodNode
	{
		return factory.newMethod(this, name, visibility, returnType);
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
	}
	
	//--------------------------------------------------------------------------
	//
	//  Protected :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	override protected function computeContent(typeContent:IParserNode):void
	{
		// accessors get added during post proccessing of the whole
		// parsing session, there is no way of knowing if get and set match
		// without knowing superclasses
		_accessors = new Vector.<IAccessorNode>();
		
		// during this phase, getters and setters reflect reality
		_getters = new Vector.<IAccessorNode>();
		_setters = new Vector.<IAccessorNode>();
		
		_methods = new Vector.<IMethodNode>();
		
		if (!typeContent || typeContent.numChildren == 0)
			return;
		
		for each (var child:IParserNode in typeContent.children)
		{
			if (child.isKind(AS3NodeKind.GET))
			{
				computeGetter(child);
			}
			else if (child.isKind(AS3NodeKind.SET))
			{
				computeSetter(child);
			}
			else if (child.isKind(AS3NodeKind.FUNCTION))
			{
				computeMethod(child);
			}
		}
	}
	
	/**
	 * @private
	 */
	protected function computeGetter(child:IParserNode):void
	{
		getters.push(NodeFactory.instance.createAccessor(child, this));
	}
	
	/**
	 * @private
	 */
	protected function computeSetter(child:IParserNode):void
	{
		setters.push(NodeFactory.instance.createAccessor(child, this));
	}
	
	/**
	 * @private
	 */
	protected function computeMethod(child:IParserNode):void
	{
		methods.push(NodeFactory.instance.createMethod(child, this));
	}
}
}