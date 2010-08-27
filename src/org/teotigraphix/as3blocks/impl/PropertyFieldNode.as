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

import org.teotigraphix.as3blocks.api.IExpressionNode;
import org.teotigraphix.as3blocks.api.IPropertyFieldNode;
import org.teotigraphix.as3parser.api.IParserNode;

/**
 * The <code>IFieldNode</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class PropertyFieldNode extends ScriptFragmentNode 
	implements IPropertyFieldNode
{
	//--------------------------------------------------------------------------
	//
	//  IArrayLiteralNode API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  name
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3blocks.api.IPropertyFieldNode#name
	 */
	public function get name():String
	{
		return node.getFirstChild().stringValue;
	}
	
	//----------------------------------
	//  value
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3blocks.api.IPropertyFieldNode#value
	 */
	public function get value():IExpressionNode
	{
		return ExpressionBuilder.build(node.getLastChild());
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function PropertyFieldNode(node:IParserNode)
	{
		super(node);
	}
}
}