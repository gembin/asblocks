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

import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.asblocks.ASBlocksSyntaxError;
import org.teotigraphix.asblocks.api.IBlock;
import org.teotigraphix.asblocks.api.IExpression;
import org.teotigraphix.asblocks.api.IIfStatement;
import org.teotigraphix.asblocks.api.IStatement;
import org.teotigraphix.asblocks.api.IStatementContainer;
import org.teotigraphix.asblocks.utils.ASTUtil;

/**
 * The <code>IIfStatement</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class IfStatementNode extends ContainerDelegate 
	implements IIfStatement
{
	//--------------------------------------------------------------------------
	//
	//  IIfStatement API :: Properties
	//
	//--------------------------------------------------------------------------
	
	private function findConditionNode():IParserNode
	{
		return node.getFirstChild();
	}
	
	private function findThenClause():IParserNode
	{
		return node.getChild(1);
	}
	
	private function findElseClause():IParserNode
	{
		return node.getChild(2);
	}
	
	override protected function get statementContainer():IStatementContainer
	{
		var ast:IParserNode = findThenClause();
		if (!ast.isKind(AS3NodeKind.BLOCK))
		{
			throw new ASBlocksSyntaxError("statement is not a block");
		}
		return new StatementList(ast);
	}
	
	//----------------------------------
	//  condition
	//----------------------------------
	
	/**
	 * copy org.teotigraphix.asblocks.api.IIfStatement#condition
	 */
	public function get condition():IExpression
	{
		return ExpressionBuilder.build(findConditionNode().getFirstChild());
	}
	
	/**
	 * @private
	 */	
	public function set condition(value:IExpression):void
	{
		findConditionNode().setChildAt(value.node, 0);
	}
	
	//----------------------------------
	//  thenStatement
	//----------------------------------
	
	/**
	 * @private
	 */	
	public function set thenStatement(value:IStatement):void
	{
		var ast:IParserNode = value.node;
		node.setChildAt(ast, 1);
		var indent:String = ASTUtil.findIndent(node);
		ASTUtil.increaseIndentAfterFirstLine(ast, indent);
	}
	
	//----------------------------------
	//  elseBlock
	//----------------------------------
	
	/**
	 * copy org.teotigraphix.asblocks.api.IIfStatement#elseBlock
	 */
	public function get elseBlock():IBlock
	{
		var ast:IParserNode = findElseClause();
		if (!ast)
		{
			var indent:String = ASTUtil.findIndent(node);
			ast = ASTUtil.newAST(AS3NodeKind.ELSE, "else");
			node.appendToken(TokenBuilder.newSpace());
			node.addChild(ast);
			ast.appendToken(TokenBuilder.newSpace());
			var block:IParserNode = ASTBuilder.newBlock();
			ast.addChild(block);
			ASTUtil.increaseIndentAfterFirstLine(block, indent);
		}
		
		var stmt:IStatement = StatementBuilder.build(ast.getFirstChild());
		if (!(stmt is IBlock))
		{
			throw new ASBlocksSyntaxError("Expected a block");
		}
		
		return stmt as IBlock;
	}
	
	/**
	 * @private
	 */	
	public function set elseBlock(value:IBlock):void
	{
		// TODO impl elseBlock
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