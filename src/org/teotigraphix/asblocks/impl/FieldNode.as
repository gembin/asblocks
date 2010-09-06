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

package org.teotigraphix.asblocks.impl
{

import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.asblocks.api.IExpressionNode;
import org.teotigraphix.asblocks.api.IFieldNode;

/**
 * The <code>IFieldNode</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class FieldNode extends MemberNode 
	implements IFieldNode
{
	//--------------------------------------------------------------------------
	//
	//  Private :: Variables
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  name
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IMemberNode#name
	 */
	override public function get name():String
	{
		return super.name; // TODO impl nti
	}
	
	/**
	 * @private
	 */	
	override public function set name(value:String):void
	{
		super.name = value; // TODO impl nti
	}
	
	//----------------------------------
	//  type
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IMemberNode#type
	 */
	override public function get type():String
	{
		return super.type; // TODO impl nti
	}
	
	/**
	 * @private
	 */	
	override public function set type(value:String):void
	{
		super.type = type; // TODO impl nti
	}
	
	//--------------------------------------------------------------------------
	//
	//  IFieldNode API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  isConstant
	//----------------------------------
	
	/**
	 * doc
	 */
	public function get isConstant():Boolean
	{
		return false;
	}
	
	/**
	 * @private
	 */	
	public function set isConstant(value:Boolean):void
	{
		
	}
	
	//----------------------------------
	//  initializer
	//----------------------------------
	
	/**
	 * doc
	 */
	public function get initializer():IExpressionNode
	{
		return null;
	}
	
	/**
	 * @private
	 */	
	public function set initializer(value:IExpressionNode):void
	{
		
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function FieldNode(node:IParserNode)
	{
		super(node);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Private :: Methods
	//
	//--------------------------------------------------------------------------
	
}
}