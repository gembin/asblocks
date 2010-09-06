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

import org.teotigraphix.asblocks.api.IAssignmentExpression;
import org.teotigraphix.asblocks.api.IExpression;
import org.teotigraphix.as3parser.api.IParserNode;

/**
 * The <code>IAssignmentExpression</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class AssignmentExpressionNode extends ExpressionNode 
	implements IAssignmentExpression
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
	 * @copy org.teotigraphix.asblocks.api.IAssignmentExpression#leftExpression
	 */
	public function get leftExpression():IExpression
	{
		return ExpressionBuilder.build(node.getFirstChild());
	}
	
	/**
	 * @private
	 */	
	public function set leftExpression(value:IExpression):void
	{
		setExpression(value, 0);
	}
	
	//----------------------------------
	//  operator
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _operator:String = "=";
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IAssignmentExpression#operator
	 */
	public function get operator():String
	{
		return _operator;
	}
	
	/**
	 * @private
	 */	
	public function set operator(value:String):void
	{
		_operator = value;
	}
	
	//----------------------------------
	//  rightExpression
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IAssignmentExpression#rightExpression
	 */
	public function get rightExpression():IExpression
	{
		return ExpressionBuilder.build(node.getLastChild());
	}
	
	/**
	 * @private
	 */	
	public function set rightExpression(value:IExpression):void
	{
		setExpression(value, 1);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function AssignmentExpressionNode(node:IParserNode)
	{
		super(node);
	}
	
	private function setExpression(expression:IExpression, index:int):void
	{
		var subAST:IParserNode = expression.node;
		//ASTBuilder.assertNoParent("expression", subExpr);
		// TODO: handle operator precedence issues
		node.setChildAt(subAST, index);
	}

}
}