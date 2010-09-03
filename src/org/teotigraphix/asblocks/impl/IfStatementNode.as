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

import org.teotigraphix.asblocks.api.IBlockNode;
import org.teotigraphix.asblocks.api.IExpressionNode;
import org.teotigraphix.asblocks.api.IIfStatementNode;
import org.teotigraphix.asblocks.api.IStatementContainer;
import org.teotigraphix.asblocks.api.IStatementNode;
import org.teotigraphix.asblocks.utils.ASTUtil;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;

/**
 * The <code>IIfStatementNode</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class IfStatementNode extends ContainerDelegate 
	implements IIfStatementNode
{
	//--------------------------------------------------------------------------
	//
	//  IIfStatementNode API :: Properties
	//
	//--------------------------------------------------------------------------
	
	private function get thenClause():IParserNode
	{
		return node.getChild(1);
	}
	
	override protected function get statementContainer():IStatementContainer
	{
		var child:IParserNode = thenClause;
		if (!child.isKind(AS3NodeKind.BLOCK))
		{
			throw new Error("statement is not a block"); // SyntaxError
		}
		return new StatementList(child);
	}
	
	//----------------------------------
	//  elseBlock
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _elseBlock:IBlockNode;
	
	/**
	 * doc
	 */
	public function get elseBlock():IBlockNode
	{
		var eclause:IParserNode = elseClause;
		if (!eclause)
		{
			var indent:String = ASTUtil.findIndent(node);
			eclause = ASTUtil.newAST(AS3NodeKind.ELSE, "else");
			node.appendToken(TokenBuilder.newSpace());
			node.addChild(eclause);
			eclause.appendToken(TokenBuilder.newSpace());
			var block:IParserNode = ASTBuilder.newBlock();
			eclause.addChild(block);
			ASTUtil.increaseIndentAfterFirstLine(block, indent);
		}
		
		var stmt:IStatementNode = StatementBuilder.build(eclause.getFirstChild());
		if (!(stmt is IBlockNode))
		{
			throw new Error("Expected a block"); // SyntaxError
		}
		
		return stmt as IBlockNode;
	}
	
	/**
	 * @private
	 */	
	public function set elseBlock(value:IBlockNode):void
	{
		if (_elseBlock == value)
			return;
		
		_elseBlock = value;
	}
	
	
	/**
	 * @private
	 */	
	public function set thenStatement(value:IStatementNode):void
	{
		var thenAST:IParserNode = value.node;
		node.setChildAt(thenAST, 1);
		var indent:String = ASTUtil.findIndent(node);
		ASTUtil.increaseIndentAfterFirstLine(thenAST, indent);
	}
	
	//----------------------------------
	//  condition
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _condition:IExpressionNode;
	
	private function get elseClause():IParserNode
	{
		return node.getChild(2);
	}
	
	private function get conditionNode():IParserNode
	{
		return node.getFirstChild();
	}
	
	/**
	 * doc
	 */
	public function get condition():IExpressionNode
	{
		return ExpressionBuilder.build(conditionNode.getFirstChild());
	}
	
	/**
	 * @private
	 */	
	public function set condition(value:IExpressionNode):void
	{
		conditionNode.setChildAt(value.node, 0);
	}
	
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function IfStatementNode(node:IParserNode)
	{
		super(node);
	}
}
}