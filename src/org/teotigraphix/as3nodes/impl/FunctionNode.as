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

import org.teotigraphix.as3nodes.api.IFunctionNode;
import org.teotigraphix.as3nodes.api.IIdentifierNode;
import org.teotigraphix.as3nodes.api.INameAware;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3nodes.api.IParameterNode;
import org.teotigraphix.as3nodes.api.Modifier;
import org.teotigraphix.as3nodes.utils.NodeUtil;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;

/**
 * TODO DOCME
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class FunctionNode extends ScriptNode implements IFunctionNode
{
	//--------------------------------------------------------------------------
	//
	//  IFunctionNode API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  isConstructor
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IFunctionNode#isConstructor
	 */
	public function get isConstructor():Boolean
	{
		if (parent is INameAware)
			return INameAware(parent).name == name;
		return false;
	}
	
	//----------------------------------
	//  isOverride
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IFunctionNode#isOverride
	 */
	public function get isOverride():Boolean
	{
		return hasModifier(Modifier.OVERRIDE);
	}
	
	/**
	 * @private
	 */	
	public function set isOverride(value:Boolean):void
	{
		if (value && hasModifier(Modifier.OVERRIDE))
			return;
		
		if (value)
			addModifier(Modifier.OVERRIDE);
		else
			removeModifier(Modifier.OVERRIDE);
	}
	
	//----------------------------------
	//  isStatic
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _isStatic:Boolean;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IFunctionNode#isStatic
	 */
	public function get isStatic():Boolean
	{
		return hasModifier(Modifier.STATIC);
	}
	
	/**
	 * @private
	 */	
	public function set isStatic(value:Boolean):void
	{
		if (value && hasModifier(Modifier.STATIC))
			return;
		
		if (value)
			addModifier(Modifier.STATIC);
		else
			removeModifier(Modifier.STATIC);
	}
	
	//--------------------------------------------------------------------------
	//
	//  IParameterAware API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  parameters
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _parameters:Vector.<IParameterNode>;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IParameterAware#parameters
	 */
	public function get parameters():Vector.<IParameterNode>
	{
		return _parameters;
	}
	
	//----------------------------------
	//  hasParameters
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IParameterAware#hasParameters
	 */
	public function get hasParameters():Boolean
	{
		return _parameters && _parameters.length > 0;
	}
	
	//--------------------------------------------------------------------------
	//
	//  IFunctionNode API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  type
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _type:IIdentifierNode;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IFunctionNode#hasParameters
	 */
	public function get type():IIdentifierNode
	{
		return _type;
	}
	
	/**
	 * @private
	 */	
	public function set type(value:IIdentifierNode):void
	{
		if (_type)
			dispatchRemoveChange(AS3NodeKind.TYPE, _type);
		
		_type = value;
		
		if (_type)
			dispatchAddChange(AS3NodeKind.TYPE, _type);
	}
	
	//----------------------------------
	//  hasType
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IFunctionNode#hasType
	 */
	public function get hasType():Boolean
	{
		return type != null;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function FunctionNode(node:IParserNode, parent:INode)
	{
		super(node, parent);
	}
	
	//--------------------------------------------------------------------------
	//
	//  IParameterAware API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IFunctionNode#addReturnDescription()
	 */
	public function addReturnDescription(description:String):void
	{
		comment.newDocTag("return", description);
	}
	
	//--------------------------------------------------------------------------
	//
	//  IParameterAware API :: Methods
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  IParameterNode
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IFunctionNode#hasParameter()
	 */
	public function hasParameter(name:String):Boolean
	{
		var len:int = parameters.length;
		for (var i:int = 0; i < len; i++)
		{
			if (parameters[i].name == name)
				return true;
		}
		return false;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IFunctionNode#addParameter()
	 */
	public function addParameter(child:IParameterNode):IParameterNode
	{
		if (hasParameter(child.name))
			return null;
		
		parameters.push(child);
		
		dispatchAddChange(AS3NodeKind.PARAMETER, child);
		
		return child;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IFunctionNode#removeParameter()
	 */
	public function removeParameter(child:IParameterNode):IParameterNode
	{
		var len:int = parameters.length;
		for (var i:int = 0; i < len; i++)
		{
			var element:IParameterNode = parameters[i] as IParameterNode;
			if (element.name == child.name)
			{
				parameters.splice(i, 1);
				dispatchRemoveChange(AS3NodeKind.PARAMETER, child);
				return element;
			}
		}
		return null;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IFunctionNode#getParameter()
	 */
	public function getParameter(name:String):IParameterNode
	{
		var len:int = parameters.length;
		for (var i:int = 0; i < len; i++)
		{
			if (parameters[i].name == name)
				return parameters[i];
		}
		return null;
	}
	
	/**
	 * @see org.teotigraphix.as3nodes.api.IFunctionNode#newParameter()
	 */
	public function newParameter(name:String,
								 type:IIdentifierNode,
								 defaultValue:String = null):IParameterNode
	{
		return as3Factory.newParameter(this, name, type, defaultValue);
	}
	
	/**
	 * @see org.teotigraphix.as3nodes.api.IFunctionNode#newRestParameter()
	 */
	public function newRestParameter(name:String):IParameterNode
	{
		return as3Factory.newRestParameter(this, name);
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
		
		_parameters = new Vector.<IParameterNode>();
		
		if (node.numChildren == 0)
			return;
		
		for each (var child:IParserNode in node.children)
		{
			if (child.isKind(AS3NodeKind.PARAMETER_LIST))
			{
				computeParameterList(child);
			}
			else if (child.isKind(AS3NodeKind.TYPE))
			{
				computeType(child);
			}
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
	protected function computeParameterList(child:IParserNode):void
	{
		NodeUtil.computeParameterList(this, child);
	}
	
	/**
	 * @private
	 */
	protected function computeType(child:IParserNode):void
	{
		NodeUtil.computeReturnType(this, child);
	}
}
}