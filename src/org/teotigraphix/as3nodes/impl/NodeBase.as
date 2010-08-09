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

import org.teotigraphix.as3nodes.api.INestedNode;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3parser.api.IParserNode;

/**
 * The base node decorator of an ast parser node.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class NodeBase implements INode
{
	//--------------------------------------------------------------------------
	//
	//  INode API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  node
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _node:IParserNode;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.INode#node
	 */
	public function get node():IParserNode
	{
		return _node;
	}
	
	/**
	 * @private
	 */	
	public function set node(value:IParserNode):void
	{
		if (!value || value == _node)
			return;
		
		_node = value;
		
		compute();
	}
	
	//--------------------------------------------------------------------------
	//
	//  INestedNode API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  parent
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _parent:INode;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.INestedNode#parent
	 */
	public function get parent():INode
	{
		return _parent;
	}
	
	/**
	 * @private
	 */	
	public function set parent(value:INode):void
	{
		_parent = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function NodeBase(node:IParserNode, parent:INode)
	{
		this.node = node;
		this.parent = parent;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Proteced :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Computes the nodes children, override in subclasses.
	 */
	protected function compute():void
	{
	}
}
}