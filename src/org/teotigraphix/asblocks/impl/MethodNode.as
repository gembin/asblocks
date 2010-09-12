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
import org.teotigraphix.asblocks.api.AccessorRole;
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
import org.teotigraphix.asblocks.api.IFunctionCommon;
import org.teotigraphix.asblocks.api.IIfStatement;
import org.teotigraphix.asblocks.api.IMethod;
import org.teotigraphix.asblocks.api.IReturnStatement;
import org.teotigraphix.asblocks.api.IScriptNode;
import org.teotigraphix.asblocks.api.IStatement;
import org.teotigraphix.asblocks.api.IStatementContainer;
import org.teotigraphix.asblocks.api.ISwitchStatement;
import org.teotigraphix.asblocks.api.IThrowStatement;
import org.teotigraphix.asblocks.api.ITryStatement;

/**
 * The <code>IMember</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class MethodNode extends MemberNode 
	implements IMethod
{
	//--------------------------------------------------------------------------
	//
	//  Private :: Variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private var functionMixin:IFunctionCommon;
	
	/**
	 * @private
	 */
	private var containerMixin:IStatementContainer;
	
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
		return containerMixin.hasCode;
	}
	
	//----------------------------------
	//  statements
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	public function get statements():Vector.<IStatement>
	{
		return containerMixin.statements;
	}
	
	//--------------------------------------------------------------------------
	//
	//  IMethodNode API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  accessorRole
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IMethodNode#accessorRole
	 */
	public function get accessorRole():AccessorRole
	{
		if (node.isKind(AS3NodeKind.FUNCTION))
		{
			return AccessorRole.NORMAL;
		}
		else if (node.isKind(AS3NodeKind.GET))
		{
			return AccessorRole.GETTER;
		}
		else if (node.isKind(AS3NodeKind.SET))
		{
			return AccessorRole.SETTER;
		}
		return null;
	}
	
	/**
	 * @private
	 */	
	public function set accessorRole(value:AccessorRole):void
	{
		// TODO impl
	}
	
	//--------------------------------------------------------------------------
	//
	//  IFunctionCommon API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  arguments
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IFunctionCommon#arguments
	 */
	public function get arguments():Vector.<IArgument>
	{
		return functionMixin.arguments;
	}
	
	//----------------------------------
	//  returnType
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IFunctionCommon#returnType
	 */
	public function get returnType():String
	{
		return functionMixin.returnType;
	}
	
	/**
	 * @private
	 */	
	public function set returnType(value:String):void
	{
		functionMixin.returnType = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function MethodNode(node:IParserNode)
	{
		super(node);
		
		var block:IParserNode = node.getKind(AS3NodeKind.BLOCK);
		if (block)
		{
			containerMixin = new StatementList(block);
		}
		
		functionMixin = new FunctionCommon(node);
	}
	
	//--------------------------------------------------------------------------
	//
	//  IFunctionCommon API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IFunctionCommon#addParameter()
	 */
	public function addParameter(name:String, 
								 type:String, 
								 defaultValue:String = null):IArgument
	{
		return functionMixin.addParameter(name, type, defaultValue);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IFunctionCommon#removeParameter()
	 */
	public function removeParameter(name:String):IArgument
	{
		return functionMixin.removeParameter(name);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IFunctionCommon#addRestParam()
	 */
	public function addRestParam(name:String):IArgument
	{
		return functionMixin.addRestParam(name);
	}
	
	//--------------------------------------------------------------------------
	//
	//  IStatementContainer API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IStatementContainer#addComment()
	 */
	public function addComment(text:String):IToken
	{
		return containerMixin.addComment(text);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IStatementContainer#removeComment()
	 */
	public function removeComment(statement:IStatement):IToken
	{
		return containerMixin.removeComment(statement);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IStatementContainer#addStatement()
	 */
	public function addStatement(statement:String):IStatement
	{
		return containerMixin.addStatement(statement);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IStatementContainer#removeStatement()
	 */
	public function removeStatement(statement:IStatement):IStatement
	{
		return containerMixin.removeStatement(statement);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IStatementContainer#removeStatementAt()
	 */
	public function removeStatementAt(index:int):IStatement
	{
		return containerMixin.removeStatementAt(index);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IStatementContainer#newExpressionStatement()
	 */
	public function newExpressionStatement(statement:String):IExpressionStatement
	{
		return containerMixin.newExpressionStatement(statement);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IStatementContainer#newBreak()
	 */
	public function newBreak():IBreakStatement
	{
		return containerMixin.newBreak();
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IStatementContainer#newContinue()
	 */
	public function newContinue():IContinueStatement
	{
		return containerMixin.newContinue();
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IStatementContainer#newDeclaration()
	 */
	public function newDeclaration(assignment:IExpression):IDeclarationStatement
	{
		return containerMixin.newDeclaration(assignment);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IStatementContainer#newDeclaration()
	 */
	public function parseNewDeclaration(assignment:String):IDeclarationStatement
	{
		return containerMixin.parseNewDeclaration(assignment);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IStatementContainer#newDefaultXMLNamespace()
	 */
	public function newDefaultXMLNamespace(namespace:String):IDefaultXMLNamespaceStatement
	{
		return containerMixin.newDefaultXMLNamespace(namespace);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IStatementContainer#newDoWhile()
	 */
	public function newDoWhile(condition:IExpression):IDoWhileStatement
	{
		return containerMixin.newDoWhile(condition);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IStatementContainer#newFor()
	 */
	public function newFor(initializer:IExpression, 
						   condition:IExpression, 
						   iterater:IExpression):IForStatement
	{
		return containerMixin.newFor(initializer, condition, iterater);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IStatementContainer#parseNewFor()
	 */
	public function parseNewFor(initializer:String, 
								condition:String, 
								iterater:String):IForStatement
	{
		return containerMixin.parseNewFor(initializer, condition, iterater);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IStatementContainer#newForEacIn()
	 */
	public function newForEachIn(declaration:IScriptNode, 
								 expression:IExpression):IForEachInStatement
	{
		return containerMixin.newForEachIn(declaration, expression);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IStatementContainer#newForIn()
	 */
	public function newForIn(declaration:IScriptNode, 
							 expression:IExpression):IForInStatement
	{
		return containerMixin.newForIn(declaration, expression);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IStatementContainer#newIf()
	 */
	public function newIf(condition:IExpression):IIfStatement
	{
		return containerMixin.newIf(condition);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IStatementContainer#newReturn()
	 */
	public function newReturn(expression:IExpression = null):IReturnStatement
	{
		return containerMixin.newReturn(expression);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IStatementContainer#newSwitch()
	 */
	public function newSwitch(condition:IExpression):ISwitchStatement
	{
		return containerMixin.newSwitch(condition);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IStatementContainer#newThrow()
	 */
	public function newThrow(expression:IExpression):IThrowStatement
	{
		return containerMixin.newThrow(expression);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IStatementContainer#newTryFinally()
	 */
	public function newTryCatch(name:String, type:String):ITryStatement
	{
		return containerMixin.newTryCatch(name, type);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IStatementContainer#newTryFinally()
	 */
	public function newTryFinally():ITryStatement
	{
		return containerMixin.newTryFinally();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Private :: Methods
	//
	//--------------------------------------------------------------------------
	
}
}