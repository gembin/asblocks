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

import org.teotigraphix.asblocks.api.IConditionalExpression;
import org.teotigraphix.asblocks.api.IExpression;
import org.teotigraphix.as3parser.api.IParserNode;

/**
 * The <code>IConditionalExpression</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class ConditionalExpressionNode extends ExpressionNode 
	implements IConditionalExpression
{
	//--------------------------------------------------------------------------
	//
	//  ISimpleNameExpressionNode API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  conditionalExpression
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IConditionalExpression#conditionExpression
	 */
	public function get conditionExpression():IExpression
	{
		return ExpressionBuilder.build(node.getFirstChild());
	}

	/**
	 * @private
	 */	
	public function set conditionExpression(value:IExpression):void
	{
		node.setChildAt(value.node, 0);
	}
	
	//----------------------------------
	//  thenExpression
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IConditionalExpression#thenExpression
	 */
	public function get thenExpression():IExpression
	{
		return ExpressionBuilder.build(node.getChild(1));
	}
	
	/**
	 * @private
	 */	
	public function set thenExpression(value:IExpression):void
	{
		node.setChildAt(value.node, 1);
	}
	
	//----------------------------------
	//  elseExpression
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IConditionalExpression#elseExpression
	 */
	public function get elseExpression():IExpression
	{
		return ExpressionBuilder.build(node.getLastChild());
	}
	
	/**
	 * @private
	 */	
	public function set elseExpression(value:IExpression):void
	{
		node.setChildAt(value.node, 2);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function ConditionalExpressionNode(node:IParserNode)
	{
		super(node);
	}
}
}