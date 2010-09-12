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

import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.api.IToken;
import org.teotigraphix.asblocks.api.IArgument;
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
import org.teotigraphix.asblocks.api.IReturnStatement;
import org.teotigraphix.asblocks.api.IScriptNode;
import org.teotigraphix.asblocks.api.IStatement;
import org.teotigraphix.asblocks.api.IStatementContainer;
import org.teotigraphix.asblocks.api.ISuperStatement;
import org.teotigraphix.asblocks.api.ISwitchStatement;
import org.teotigraphix.asblocks.api.IThrowStatement;
import org.teotigraphix.asblocks.api.ITryStatement;
import org.teotigraphix.asblocks.api.IWhileStatement;

/**
 * The <code>IStatementContainer</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class ContainerDelegate extends ScriptNode 
	implements IStatementContainer
{
	protected function get statementContainer():IStatementContainer
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
	public function get hasCode():Boolean
	{
		return statementContainer.hasCode;
	}
	
	//----------------------------------
	//  statements
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	public function get statements():Vector.<IStatement>
	{
		return statementContainer.statements;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function ContainerDelegate(node:IParserNode)
	{
		super(node);
	}
	
	/**
	 * TODO Docme
	 */
	public function addComment(text:String):IToken
	{
		return statementContainer.addComment(text);
	}
	
	/**
	 * TODO Docme
	 */
	public function removeComment(statement:IStatement):IToken
	{
		return statementContainer.removeComment(statement);
	}
	
	/**
	 * TODO Docme
	 */
	public function addStatement(statement:String):IStatement
	{
		return statementContainer.addStatement(statement);
	}
	
	/**
	 * TODO Docme
	 */
	public function removeStatement(statement:IStatement):IStatement
	{
		return statementContainer.removeStatement(statement);
	}
	
	/**
	 * TODO Docme
	 */
	public function removeStatementAt(index:int):IStatement
	{
		return statementContainer.removeStatementAt(index);
	}
	
	/**
	 * TODO Docme
	 */
	public function newExpressionStatement(statement:String):IExpressionStatement
	{
		return statementContainer.newExpressionStatement(statement);
	}
	
	/**
	 * TODO Docme
	 */
	public function newBreak():IBreakStatement
	{
		return statementContainer.newBreak();
	}
	
	/**
	 * TODO Docme
	 */
	public function newContinue():IContinueStatement
	{
		return statementContainer.newContinue();
	}
	
	/**
	 * TODO Docme
	 */
	public function newDeclaration(assignment:IExpression):IDeclarationStatement
	{
		return statementContainer.newDeclaration(assignment);
	}
	
	/**
	 * TODO Docme
	 */
	public function parseNewDeclaration(assignment:String):IDeclarationStatement
	{
		return statementContainer.parseNewDeclaration(assignment);
	}
	
	/**
	 * TODO Docme
	 */
	public function newDefaultXMLNamespace(namespace:String):IDefaultXMLNamespaceStatement
	{
		return statementContainer.newDefaultXMLNamespace(namespace);
	}
	
	/**
	 * TODO Docme
	 */
	public function newDoWhile(condition:IExpression):IDoWhileStatement
	{
		return statementContainer.newDoWhile(condition);
	}
	
	/**
	 * TODO Docme
	 */
	public function newFor(initializer:IExpression, 
						   condition:IExpression, 
						   iterater:IExpression):IForStatement
	{
		return statementContainer.newFor(initializer, condition, iterater);
	}
	
	/**
	 * TODO Docme
	 */
	public function parseNewFor(initializer:String, 
								condition:String, 
								iterater:String):IForStatement
	{
		return statementContainer.parseNewFor(initializer, condition, iterater);
	}
	
	/**
	 * TODO Docme
	 */
	public function newForEachIn(declaration:IScriptNode, 
								 expression:IExpression):IForEachInStatement
	{
		return statementContainer.newForEachIn(declaration, expression);
	}
	
	/**
	 * TODO Docme
	 */
	public function newForIn(declaration:IScriptNode, 
							 expression:IExpression):IForInStatement
	{
		return statementContainer.newForIn(declaration, expression);
	}
	
	/**
	 * TODO Docme
	 */
	public function newIf(condition:IExpression):IIfStatement
	{
		return statementContainer.newIf(condition);
	}
	
	/**
	 * @private
	 */
	public function newReturn(expression:IExpression = null):IReturnStatement
	{
		return statementContainer.newReturn(expression);
	}
	
	/**
	 * @private
	 */
	public function newSuper(arguments:Vector.<IArgument>):ISuperStatement
	{
		return statementContainer.newSuper(arguments);
	}
	
	/**
	 * @private
	 */
	public function newSwitch(condition:IExpression):ISwitchStatement
	{
		return statementContainer.newSwitch(condition);
	}
	
	/**
	 * @private
	 */
	public function newThrow(expression:IExpression):IThrowStatement
	{
		return statementContainer.newThrow(expression);
	}
	
	/**
	 * @private
	 */
	public function newTryCatch(name:String, type:String):ITryStatement
	{
		return statementContainer.newTryCatch(name, type);
	}
	
	/**
	 * @private
	 */
	public function newTryFinally():ITryStatement
	{
		return statementContainer.newTryFinally();
	}
	
	/**
	 * @private
	 */
	public function newWhile(condition:IExpression):IWhileStatement
	{
		return statementContainer.newWhile(condition);
	}
}
}