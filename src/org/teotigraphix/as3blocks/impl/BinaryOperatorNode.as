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

import org.teotigraphix.as3blocks.api.BinaryOperator;
import org.teotigraphix.as3blocks.api.IBinaryExpressionNode;
import org.teotigraphix.as3blocks.api.IExpressionNode;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.core.TokenNode;

/**
 * The <code>IBinaryExpressionNode</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class BinaryOperatorNode extends ExpressionNode 
	implements IBinaryExpressionNode
{
	//--------------------------------------------------------------------------
	//
	//  ISimpleNameExpressionNode API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  leftExpression
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3blocks.api.IBinaryExpressionNode#leftExpression
	 */
	public function get leftExpression():IExpressionNode
	{
		return ExpressionBuilder.build(node.getFirstChild());
	}
	
	/**
	 * @private
	 */
	public function set leftExpression(value:IExpressionNode):void
	{
		setExpression(value, 0);
	}
	
	//----------------------------------
	//  rightExpression
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3blocks.api.IBinaryExpressionNode#rightExpression
	 */
	public function get rightExpression():IExpressionNode
	{
		return ExpressionBuilder.build(node.getLastChild());
	}
	
	/**
	 * @private
	 */
	public function set rightExpression(value:IExpressionNode):void
	{
		setExpression(value, 1);
	}
	
	//----------------------------------
	//  operator
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3blocks.api.IBinaryExpressionNode#operator
	 */
	public function get operator():BinaryOperator
	{
		// the parser gets op nodes and sets their string to the kind
		return BinaryOperator.find(node.stringValue);
	}
	
	/**
	 * @private
	 */
	public function set operator(value:BinaryOperator):void
	{
		BinaryOperator.initialize(value, TokenNode(node).token);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function BinaryOperatorNode(node:IParserNode)
	{
		super(node);
	}
	
	/**
	 * @private
	 */
	private function setExpression(expression:IExpressionNode, index:int):void
	{
		node.setChildAt(expression.node, index);
	}
}
}