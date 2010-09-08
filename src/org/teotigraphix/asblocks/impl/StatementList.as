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
import org.teotigraphix.as3parser.impl.AS3FragmentParser;
import org.teotigraphix.asblocks.api.IBlock;
import org.teotigraphix.asblocks.api.IBreakStatement;
import org.teotigraphix.asblocks.api.IContinueStatement;
import org.teotigraphix.asblocks.api.IDeclarationStatement;
import org.teotigraphix.asblocks.api.IDefaultXMLNamespaceStatement;
import org.teotigraphix.asblocks.api.IDoWhileStatement;
import org.teotigraphix.asblocks.api.IExpression;
import org.teotigraphix.asblocks.api.IExpressionStatement;
import org.teotigraphix.asblocks.api.IIfStatement;
import org.teotigraphix.asblocks.api.IReturnStatement;
import org.teotigraphix.asblocks.api.IStatement;
import org.teotigraphix.asblocks.api.IStatementContainer;
import org.teotigraphix.asblocks.api.ISwitchStatement;
import org.teotigraphix.asblocks.api.IThrowStatement;
import org.teotigraphix.asblocks.utils.ASTUtil;

/**
 * The <code>IStatementContainer</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class StatementList extends ContainerDelegate implements IBlock
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
	override public function addStatement(statement:String):IStatement
	{
		var stmt:IParserNode = AS3FragmentParser.parseStatement(statement);
		stmt.stopToken.next = null;
		if (stmt.parent && stmt.parent.isKind(AS3NodeKind.EXPR_LIST))
		{
			stmt = stmt.parent;
		}
		_addStatement(stmt);
		return StatementBuilder.build(stmt);
	}
	
	/**
	 * @private
	 */
	override public function newBreak():IBreakStatement
	{
		var ast:IParserNode = ASTBuilder.newBreak();
		_addStatement(ast);
		return new BreakStatementNode(ast);
	}
	
	/**
	 * @private
	 */
	override public function newContinue():IContinueStatement
	{
		var ast:IParserNode = ASTBuilder.newContinue();
		_addStatement(ast);
		return new ContinueStatementNode(ast);
	}
	
	/**
	 * @private
	 */
	override public function newDeclaration(assignment:IExpression):IDeclarationStatement
	{
		var ast:IParserNode = ASTBuilder.newDeclaration(assignment.node);
		_addStatement(ast);
		return new DeclarationStatementNode(ast);
	}
	
	/**
	 * @private
	 */
	override public function newDefaultXMLNamespace(namespace:String):IDefaultXMLNamespaceStatement
	{
		var ast:IParserNode = ASTBuilder.newDefaultXMLNamespace(
			AS3FragmentParser.parsePrimaryExpression(ASTBuilder.escapeString(namespace)));
		_addStatement(ast);
		return new DefaultXMLNamespaceStatementNode(ast);
	}
	
	/**
	 * @private
	 */
	override public function newDoWhile(condition:IExpression):IDoWhileStatement
	{
		var ast:IParserNode = ASTBuilder.newDoWhile(condition.node);
		_addStatement(ast);
		return new DoWhileStatementNode(ast);
	}
	
	/**
	 * @private
	 */
	override public function newExpressionStatement(statement:String):IExpressionStatement
	{
		var ast:IParserNode = AS3FragmentParser.parseExpressionStatement(statement);
		_addStatement(ast);
		return new ExpressionStatementNode(ast);
	}
	
	/**
	 * @private
	 */
	override public function newIf(condition:IExpression):IIfStatement
	{
		var ifStmt:IParserNode = ASTBuilder.newIf(condition.node);
		_addStatement(ifStmt);
		return new IfStatementNode(ifStmt);
	}
	
	/**
	 * @private
	 */
	override public function newReturn(expression:IExpression = null):IReturnStatement
	{
		var result:IParserNode = ASTBuilder.newReturn((expression) ? expression.node : null);
		_addStatement(result);
		return new ReturnStatementNode(result);
	}
	
	/**
	 * @private
	 */
	override public function newSwitch(condition:IExpression):ISwitchStatement
	{
		var result:IParserNode = ASTBuilder.newSwitch(condition.node);
		_addStatement(result);
		return new SwitchStatementNode(result);
	}
	
	/**
	 * @private
	 */
	override public function newThrow(expression:IExpression):IThrowStatement
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