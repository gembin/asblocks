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

package org.teotigraphix.as3blocks.impl
{

import org.teotigraphix.as3blocks.api.INumberLiteralNode;
import org.teotigraphix.as3parser.api.IParserNode;

/**
 * The <code>INumberLiteralNode</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class NumberLiteralNode extends LiteralNode 
	implements INumberLiteralNode
{
	//--------------------------------------------------------------------------
	//
	//  ISimpleNameExpressionNode API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  value
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3blocks.api.INumberLiteralNode#value
	 */
	public function get value():Number
	{
		return parseInt(tokenText); // TODO hex
	}
	
	/**
	 * @private
	 */
	public function set value(value:Number):void
	{
		tokenText = value.toString(); // TODO hex
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function NumberLiteralNode(node:IParserNode)
	{
		super(node);
	}
}
}