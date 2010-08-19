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

import org.teotigraphix.as3nodes.api.IBlockCommentNode;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3parser.api.IParserNode;

/**
 * TODO DOCME
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class BlockCommentNode extends NodeBase implements IBlockCommentNode
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  description
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _description:String;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IBlockCommentNode#description
	 */
	public function get description():String
	{
		return _description;
	}
	
	/**
	 * @private
	 */	
	public function set description(value:String):void
	{
		_description = value;
	}
	
	//----------------------------------
	//  wrap
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _wrap:Boolean;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IBlockCommentNode#description
	 */
	public function get wrap():Boolean
	{
		return _wrap;
	}
	
	/**
	 * @private
	 */	
	public function set wrap(value:Boolean):void
	{
		_wrap = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function BlockCommentNode(node:IParserNode, parent:INode)
	{
		super(node, parent);
	}
	
	
	/**
	 * Computes the nodes children, override in subclasses.
	 */
	override protected function compute():void
	{
		_description = node.stringValue;
	}
}
}