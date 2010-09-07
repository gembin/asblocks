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

import org.teotigraphix.asblocks.api.IExpression;
import org.teotigraphix.asblocks.api.IPostfixExpression;
import org.teotigraphix.asblocks.api.PostfixOperator;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.core.TokenNode;

/**
 * The <code>IPostfixExpression</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class PostfixExpressionNode extends ExpressionNode 
	implements IPostfixExpression
{
	//--------------------------------------------------------------------------
	//
	//  IPostfixExpression API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  expression
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IPostfixExpression#expression
	 */
	public function get expression():IExpression
	{
		return ExpressionBuilder.build(node.getFirstChild());
	}
	
	/**
	 * @private
	 */	
	public function set expression(value:IExpression):void
	{
		node.setChildAt(value.node, 0);
	}
	
	//----------------------------------
	//  operator
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IPostfixExpression#operator
	 */
	public function get operator():PostfixOperator
	{
		return PostfixOperator.opFromKind(node.kind);
	}
	
	/**
	 * @private
	 */
	public function set operator(value:PostfixOperator):void
	{
		PostfixOperator.initializeFromOp(value, TokenNode(node).token);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function PostfixExpressionNode(node:IParserNode)
	{
		super(node);
	}
}
}