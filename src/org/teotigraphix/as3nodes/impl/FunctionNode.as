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
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3nodes.api.IParameterNode;
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
	 * @private
	 */
	private var _isConstructor:Boolean;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IFunctionNode#isConstructor
	 */
	public function get isConstructor():Boolean
	{
		return _isConstructor;
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
	
	/**
	 * @private
	 */	
	public function set parameters(value:Vector.<IParameterNode>):void
	{
		_parameters = value;
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
	 * @copy org.teotigraphix.as3nodes.api.IParameterAware#getParameter()
	 */
	public function getParameter(name:String):IParameterNode
	{
		for each (var element:IParameterNode in parameters)
		{
			if (element.name == name)
				return element;
		}
		return null;
	}
}
}