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
import org.teotigraphix.asblocks.api.IBreakStatementNode;
import org.teotigraphix.asblocks.api.IContinueStatementNode;
import org.teotigraphix.asblocks.api.IDeclarationStatementNode;
import org.teotigraphix.asblocks.api.IDefaultXMLNamespaceStatementNode;
import org.teotigraphix.asblocks.api.IDoWhileStatementNode;
import org.teotigraphix.asblocks.api.IExpressionNode;
import org.teotigraphix.asblocks.api.IExpressionStatementNode;
import org.teotigraphix.asblocks.api.IIfStatementNode;
import org.teotigraphix.asblocks.api.IReturnStatementNode;
import org.teotigraphix.asblocks.api.IStatementContainer;
import org.teotigraphix.asblocks.api.IStatementNode;
import org.teotigraphix.asblocks.api.ISwitchStatementNode;
import org.teotigraphix.asblocks.api.IThrowStatementNode;
import org.teotigraphix.asblocks.utils.ASTUtil;
import org.teotigraphix.as3nodes.impl.AS3Factory;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.impl.AS3FragmentParser;

/**
 * The <code>IStatementContainer</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class StatementList extends ContainerDelegate implements IBlockNode
{
	override protected function get statementContainer():IStatementContainer
	{
		return null;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function StatementList(node:IParserNode)
	{
		super(node);
	}
	
	/**
	 * @private
	 */
	override public function addStatement(statement:String):IStatementNode
	{
		var stmt:IParserNode = AS3FragmentParser.parseExpressionStatement(statement);
		stmt.stopToken.next = null;
		_addStatement(stmt);
		return StatementBuilder.build(stmt);
	}
	
	/**
	 * @private
	 */
	override public function newBreak():IBreakStatementNode
	{
		var ast:IParserNode = ASTBuilder.newBreak();
		_addStatement(ast);
		return new BreakStatementNode(ast);
	}
	
	/**
	 * @private
	 */
	override public function newContinue():IContinueStatementNode
	{
		var ast:IParserNode = ASTBuilder.newContinue();
		_addStatement(ast);
		return new ContinueStatementNode(ast);
	}
	
	/**
	 * @private
	 */
	override public function newDeclaration(assignment:IExpressionNode):IDeclarationStatementNode
	{
		var ast:IParserNode = ASTBuilder.newDeclaration(assignment.node);
		_addStatement(ast);
		return new DeclarationStatementNode(ast);
	}
	
	/**
	 * @private
	 */
	override public function newDefaultXMLNamespace(namespace:String):IDefaultXMLNamespaceStatementNode
	{
		var ast:IParserNode = ASTBuilder.newDefaultXMLNamespace(
			AS3FragmentParser.parsePrimaryExpression(ASTBuilder.escapeString(namespace)));
		_addStatement(ast);
		return new DefaultXMLNamespaceStatementNode(ast);
	}
	
	/**
	 * @private
	 */
	override public function newDoWhile(condition:IExpressionNode):IDoWhileStatementNode
	{
		var ast:IParserNode = ASTBuilder.newDoWhile(condition.node);
		_addStatement(ast);
		return new DoWhileStatementNode(ast);
	}
	
	/**
	 * @private
	 */
	override public function newExpressionStatement(statement:String):IExpressionStatementNode
	{
		var ast:IParserNode = AS3FragmentParser.parseExpressionStatement(statement);
		_addStatement(ast);
		return new ExpressionStatementNode(ast);
	}
	
	/**
	 * @private
	 */
	override public function newIf(condition:IExpressionNode):IIfStatementNode
	{
		var ifStmt:IParserNode = ASTBuilder.newIf(condition.node);
		_addStatement(ifStmt);
		return new IfStatementNode(ifStmt);
	}
	
	/**
	 * @private
	 */
	override public function newReturn(expression:IExpressionNode = null):IReturnStatementNode
	{
		var result:IParserNode = ASTBuilder.newReturn((expression) ? expression.node : null);
		_addStatement(result);
		return new ReturnStatementNode(result);
	}
	
	/**
	 * @private
	 */
	override public function newSwitch(condition:IExpressionNode):ISwitchStatementNode
	{
		var result:IParserNode = ASTBuilder.newSwitch(condition.node);
		_addStatement(result);
		return new SwitchStatementNode(result);
	}
	
	/**
	 * @private
	 */
	override public function newThrow(expression:IExpressionNode):IThrowStatementNode
	{
		var result:IParserNode = ASTBuilder.newThrow(expression.node);
		_addStatement(result);
		return new ThrowStatementNode(result);
	}
	
	
	
	
	
	
	
	private function _addStatement(statement:IParserNode):void
	{
		ASTUtil.addChildWithIndentation(node, statement);
	}
}
}