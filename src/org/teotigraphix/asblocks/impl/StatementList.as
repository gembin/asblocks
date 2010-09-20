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
import org.teotigraphix.as3parser.api.IToken;
import org.teotigraphix.as3parser.impl.AS3FragmentParser;
import org.teotigraphix.as3parser.impl.AS3Parser;
import org.teotigraphix.as3parser.impl.ASTIterator;
import org.teotigraphix.asblocks.api.IArgument;
import org.teotigraphix.asblocks.api.IBlock;
import org.teotigraphix.asblocks.api.IBreakStatement;
import org.teotigraphix.asblocks.api.IContinueStatement;
import org.teotigraphix.asblocks.api.IDeclarationStatement;
import org.teotigraphix.asblocks.api.IDefaultXMLNamespaceStatement;
import org.teotigraphix.asblocks.api.IDoWhileStatement;
import org.teotigraphix.asblocks.api.IExpression;
import org.teotigraphix.asblocks.api.IExpressionStatement;
import org.teotigraphix.asblocks.api.IForEachInStatement;
import org.teotigraphix.asblocks.api.IForInStatement;
import org.teotigraphix.asblocks.api.IForStatement;
import org.teotigraphix.asblocks.api.IIfStatement;
import org.teotigraphix.asblocks.api.ILabelStatement;
import org.teotigraphix.asblocks.api.IReturnStatement;
import org.teotigraphix.asblocks.api.IScriptNode;
import org.teotigraphix.asblocks.api.IStatement;
import org.teotigraphix.asblocks.api.IStatementContainer;
import org.teotigraphix.asblocks.api.ISuperStatement;
import org.teotigraphix.asblocks.api.ISwitchStatement;
import org.teotigraphix.asblocks.api.IThrowStatement;
import org.teotigraphix.asblocks.api.ITryStatement;
import org.teotigraphix.asblocks.api.IWhileStatement;
import org.teotigraphix.asblocks.api.IWithStatement;
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
	//  IStatementContainer API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  hasCode
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	override public function get hasCode():Boolean
	{
		return node.getFirstChild() != null;
	}
	
	//----------------------------------
	//  statements
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	override public function get statements():Vector.<IStatement>
	{
		var result:Vector.<IStatement> = new Vector.<IStatement>();
		var i:ASTIterator = new ASTIterator(node);
		while (i.hasNext())
		{
			result.push(StatementBuilder.build(i.next()));
		}
		return result;
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
	override public function addComment(text:String):IToken
	{
		return ASTBuilder.newComment(node, text);
	}
	
	/**
	 * @private
	 */
	override public function removeComment(statement:IStatement):IToken
	{
		return ASTUtil.removeComment(statement.node);
	}
	
	/**
	 * @private
	 */
	override public function addStatement(statement:String):IStatement
	{
		var stmt:IParserNode = AS3FragmentParser.parseStatement(statement);
		//stmt.stopToken.next = null;
		// if the statement is a simple expression, the parser returns
		// the first child, but the stmt was actually an expr-list
		// FIXME !!! Have to implement expr-statement in parser
		stmt.parent = null;
		
		_addStatement(stmt);
		return StatementBuilder.build(stmt);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IStatementContainer#removeStatement()
	 */
	override public function removeStatement(statement:IStatement):IStatement
	{
		var i:ASTIterator = new ASTIterator(node);
		while (i.hasNext())
		{
			var ast:IParserNode = i.next();
			if (statement.node === ast)
			{
				i.remove();
				return StatementBuilder.build(ast);
			}
		}
		return null;
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IStatementContainer#removeStatementAt()
	 */
	override public function removeStatementAt(index:int):IStatement
	{
		var i:ASTIterator = new ASTIterator(node);
		var ast:IParserNode = i.moveTo(index);
		if (ast)
		{
			i.remove();
			return StatementBuilder.build(ast);
		}
		return null;
	}
	
	/**
	 * @private
	 */
	override public function newBreak(label:String = null):IBreakStatement
	{
		var ast:IParserNode = ASTBuilder.newBreak(label);
		_addStatement(ast);
		return new BreakStatementNode(ast);
	}
	
	/**
	 * @private
	 */
	override public function newContinue(label:String = null):IContinueStatement
	{
		var ast:IParserNode = ASTBuilder.newContinue(label);
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
	override public function parseNewDeclaration(assignment:String):IDeclarationStatement
	{
		var ast:IParserNode = AS3FragmentParser.parseDecList(assignment);
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
	override public function newFor(initializer:IExpression,
									condition:IExpression, 
									iterator:IExpression):IForStatement
	{
		var init:IParserNode = initializer ? initializer.node : null;
		var cond:IParserNode = condition ? condition.node : null;
		var iter:IParserNode = iterator ? iterator.node : null;
		
		var ast:IParserNode = ASTBuilder.newFor(init, cond, iter);
		appendBlock(ast);
		_addStatement(ast);
		return new ForStatementNode(ast);
	}
	
	/**
	 * @private
	 */
	override public function parseNewFor(initializer:String,
										 condition:String, 
										 iterator:String):IForStatement
	{
		var init:IParserNode;
		var cond:IParserNode;
		var iter:IParserNode;
		
		if (initializer)
		{
			init = AS3FragmentParser.parseForInit(initializer);
		}
		
		if (condition)
		{
			cond = AS3FragmentParser.parseForCond(condition);
		}
		
		if (iterator)
		{
			iter = AS3FragmentParser.parseForIter(iterator);
		}
		
		var ast:IParserNode = ASTBuilder.newFor(init, cond, iter);
		appendBlock(ast);
		_addStatement(ast);
		return new ForStatementNode(ast);
	}
	
	/**
	 * @private
	 */
	override public function newForEachIn(declaration:IScriptNode,
										  expression:IExpression):IForEachInStatement
	{
		if (!declaration)
			throw new Error("");
		if (!expression)
			throw new Error("");
		
		var ast:IParserNode = ASTBuilder.newForEachIn(declaration.node, expression.node);
		appendBlock(ast);
		_addStatement(ast);
		return new ForEachInStatementNode(ast);
	}
	
	/**
	 * @private
	 */
	override public function newForIn(declaration:IScriptNode,
									  expression:IExpression):IForInStatement
	{
		if (!declaration)
			throw new Error("");
		if (!expression)
			throw new Error("");
		
		var ast:IParserNode = ASTBuilder.newForIn(declaration.node, expression.node);
		appendBlock(ast);
		_addStatement(ast);
		return new ForInStatementNode(ast);
	}
	
	public function appendBlock(ast:IParserNode):IParserNode
	{
		ast.appendToken(TokenBuilder.newSpace());
		var block:IParserNode = ASTBuilder.newBlock();
		ast.addChild(block);
		return block;
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
	override public function newLabel(name:String):ILabelStatement
	{
		var expr:IParserNode = ASTUtil.newAST(AS3NodeKind.EXPR_STMNT);
		expr.addChild(AS3FragmentParser.parseExpression(name));
		var ast:IParserNode = ASTBuilder.newLabel(expr);
		_addStatement(ast);
		return new LabelStatementNode(ast);
	}
	
	/**
	 * @private
	 */
	override public function newForLabel(name:String, kind:String):ILabelStatement
	{
		var expr:IParserNode = ASTUtil.newAST(AS3NodeKind.EXPR_STMNT);
		expr.addChild(AS3FragmentParser.parseExpression(name));
		var ast:IParserNode = ASTBuilder.newForLabel(expr, kind);
		_addStatement(ast);
		return new ForLabelStatementNode(ast);
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
	override public function newSuper(arguments:Vector.<IArgument>):ISuperStatement
	{
		var result:IParserNode = ASTBuilder.newSuper(null);
		_addStatement(result);
		return new SuperStatementNode(result);
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
	
	/**
	 * @private
	 */
	override public function newTryCatch(name:String, type:String):ITryStatement
	{
		var result:IParserNode = ASTBuilder.newTryStatement();
		result.appendToken(TokenBuilder.newSpace());
		result.addChild(ASTBuilder.newCatchClause(name, type));
		_addStatement(result);
		return new TryStatementNode(result);
	}
	
	/**
	 * @private
	 */
	override public function newTryFinally():ITryStatement
	{
		var result:IParserNode = ASTBuilder.newTryStatement();
		result.appendToken(TokenBuilder.newSpace());
		result.addChild(ASTBuilder.newFinallyClause());
		_addStatement(result);
		return new TryStatementNode(result);
	}
	
	/**
	 * @private
	 */
	override public function newWhile(condition:IExpression):IWhileStatement
	{
		var result:IParserNode = ASTBuilder.newWhile(condition.node);
		_addStatement(result);
		return new WhileStatementNode(result);
	}
	
	/**
	 * @private
	 */
	override public function newWith(condition:IExpression):IWithStatement
	{
		var result:IParserNode = ASTBuilder.newWith(condition.node);
		_addStatement(result);
		return new WithStatementNode(result);
	}
	
	
	
	
	private function _addStatement(statement:IParserNode):void
	{
		ASTUtil.addChildWithIndentation(node, statement);
	}
}
}