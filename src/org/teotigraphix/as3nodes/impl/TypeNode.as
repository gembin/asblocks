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
import org.teotigraphix.as3nodes.utils.ASTNodeUtil;
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
	private var _accessors:Vector.<IAccessorNode>;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ITypeNode#accessors
	 */
	public function get accessors():Vector.<IAccessorNode>
	{
		return _accessors;
	}
	
	/**
	 * @private
	 */	
	public function set accessors(value:Vector.<IAccessorNode>):void
	{
		_accessors = value;
	}
	
	//----------------------------------
	//  getters
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _getters:Vector.<IAccessorNode>;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ITypeNode#getters
	 */
	public function get getters():Vector.<IAccessorNode>
	{
		return _getters;
	}
	
	/**
	 * @private
	 */	
	public function set getters(value:Vector.<IAccessorNode>):void
	{
		_getters = value;
	}
	
	//----------------------------------
	//  setters
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _setters:Vector.<IAccessorNode>;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ITypeNode#setters
	 */
	public function get setters():Vector.<IAccessorNode>
	{
		return _setters;
	}
	
	/**
	 * @private
	 */	
	public function set setters(value:Vector.<IAccessorNode>):void
	{
		_setters = value;
	}
	
	//----------------------------------
	//  methods
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _methods:Vector.<IMethodNode>;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ITypeNode#methods
	 */
	public function get methods():Vector.<IMethodNode>
	{
		return _methods;
	}
	
	/**
	 * @private
	 */	
	public function set methods(value:Vector.<IMethodNode>):void
	{
		_methods = value;
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
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ITypeNode#newMethod()
	 */
	public function newMethod(name:String, 
							  modifier:Modifier, 
							  type:IIdentifierNode):IMethodNode
	{
		var ast:IParserNode = ASTNodeUtil.createMethod(this, name, modifier, type);
		var method:IMethodNode = NodeFactory.instance.createMethod(ast, this);
		methods.push(method);
		return method;
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
		accessors = new Vector.<IAccessorNode>();
		
		// during this phase, getters and setters reflect reality
		getters = new Vector.<IAccessorNode>();
		setters = new Vector.<IAccessorNode>();
		
		methods = new Vector.<IMethodNode>();
		
		if (!typeContent || typeContent.numChildren == 0)
			return;
		
		for each (var child:IParserNode in typeContent.children)
		{
			detectAccessor(child);
			detectMethod(child);
		}
	}
	
	/**
	 * @private
	 */
	protected function detectAccessor(child:IParserNode):void
	{
		if (child.isKind(AS3NodeKind.GET))
		{
			getters.push(NodeFactory.instance.createAccessor(child, this));
		}
		else if (child.isKind(AS3NodeKind.SET))
		{
			setters.push(NodeFactory.instance.createAccessor(child, this));
		}
	}
	
	protected function detectMethod(child:IParserNode):void
	{
		if (child.isKind(AS3NodeKind.FUNCTION))
		{
			methods.push(NodeFactory.instance.createMethod(child, this));
		}
	}
}
}