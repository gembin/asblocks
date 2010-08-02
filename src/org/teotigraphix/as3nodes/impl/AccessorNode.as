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
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3parser.api.IParserNode;

/**
 * TODO DOCME
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class AccessorNode extends FunctionNode implements IAccessorNode
{
	//--------------------------------------------------------------------------
	//
	//  IAccessorNode API :: Methods
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  access
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _access:String;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IAccessorNode#access
	 */
	public function get access():String
	{
		return _access;
	}
	
	/**
	 * @private
	 */	
	public function set access(value:String):void
	{
		_access = value;
	}
	
	//----------------------------------
	//  isReadWrite
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _isReadWrite:Boolean;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IAccessorNode#isReadWrite
	 */
	public function get isReadWrite():Boolean
	{
		return _isReadWrite;
	}
	
	//----------------------------------
	//  isReadOnly
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _isReadOnly:Boolean;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IAccessorNode#isReadOnly
	 */
	public function get isReadOnly():Boolean
	{
		return _isReadOnly;
	}
	
	//----------------------------------
	//  isWriteOnly
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _isWriteOnly:Boolean;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IAccessorNode#isWriteOnly
	 */
	public function get isWriteOnly():Boolean
	{
		return _isWriteOnly;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function AccessorNode(node:IParserNode, parent:INode)
	{
		super(node, parent);
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
		
		_access = node.kind;
	}
}
}