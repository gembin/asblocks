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
import org.teotigraphix.asblocks.api.IFunction;
import org.teotigraphix.asblocks.api.IIfStatement;
import org.teotigraphix.asblocks.api.ILabelStatement;
import org.teotigraphix.asblocks.api.IMethod;
import org.teotigraphix.asblocks.api.IParameter;
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
	private var functionMixin:IFunction;
	
	/**
	 * @private
	 */
	private var containerMixin:IStatementContainer;
	
	private function findAccessorRoleNode():IParserNode
	{
		return node.getKind(AS3NodeKind.ACCESSOR_ROLE);
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
		var role:IParserNode = findAccessorRoleNode();
		if (role.numChildren > 0)
		{
			if (role.getFirstChild().isKind(AS3NodeKind.GET))
			{
				return AccessorRole.GETTER;
			}
			else if (role.getFirstChild().isKind(AS3NodeKind.GET))
			{
				return AccessorRole.GETTER;
			}
		}
		return AccessorRole.NORMAL;
	}
	
	/**
	 * @private
	 */	
	public function set accessorRole(value:AccessorRole):void
	{
		if (value.equals(accessorRole))
		{
			return;
		}
		var role:IParserNode = findAccessorRoleNode();
		var ast:IParserNode = (value == AccessorRole.GETTER) 
			? ASTUtil.newAST(AS3NodeKind.GET, "get")
			: ASTUtil.newAST(AS3NodeKind.SET, "set");
		role.appendToken(TokenBuilder.newSpace());
		if (role.numChildren == 0)
		{
			role.addChild(ast);
		}
		else
		{
			role.setChildAt(ast, 0);
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//  IFunction API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  arguments
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IFunction#arguments
	 */
	public function get parameters():Vector.<IParameter>
	{
		return functionMixin.parameters;
	}
	
	//----------------------------------
	//  hasParameters
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IFunction#hasParameters
	 */
	public function get hasParameters():Boolean
	{
		return functionMixin.hasParameters;
	}
	
	//----------------------------------
	//  returnType
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IFunction#returnType
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
	//  IFunction API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IFunction#addParameter()
	 */
	public function addParameter(name:String, 
								 type:String, 
								 defaultValue:String = null):IParameter
	{
		return functionMixin.addParameter(name, type, defaultValue);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IFunction#removeParameter()
	 */
	public function removeParameter(name:String):IParameter
	{
		return functionMixin.removeParameter(name);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IFunction#addRestParameter()
	 */
	public function addRestParameter(name:String):IParameter
	{
		return functionMixin.addRestParameter(name);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IFunction#removeRestParameter()
	 */
	public function removeRestParameter():IParameter
	{
		return functionMixin.removeRestParameter();
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IFunction#getParameter()
	 */
	public function getParameter(name:String):IParameter
	{
		return functionMixin.getParameter(name);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IFunction#hasParameter()
	 */
	public function hasParameter(name:String):Boolean
	{
		return functionMixin.hasParameter(name);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IFunction#hasRestParameter()
	 */
	public function hasRestParameter():Boolean
	{
		return functionMixin.hasRestParameter();
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
	public function newBreak(label:String = null):IBreakStatement
	{
		return containerMixin.newBreak(label);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IStatementContainer#newContinue()
	 */
	public function newContinue(label:String = null):IContinueStatement
	{
		return containerMixin.newContinue(label);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IStatementContainer#newDeclaration()
	 */
	public function newDeclaration(declaration:String):IDeclarationStatement
	{
		return containerMixin.newDeclaration(declaration);
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
	 * @copy org.teotigraphix.asblocks.api.IStatementContainer#newLabel()
	 */
	public function newLabel(name:String):ILabelStatement
	{
		return containerMixin.newLabel(name);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IStatementContainer#newForLabel()
	 */
	public function newForLabel(name:String, kind:String):ILabelStatement
	{
		return containerMixin.newForLabel(name, kind);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IStatementContainer#newReturn()
	 */
	public function newReturn(expression:IExpression = null):IReturnStatement
	{
		return containerMixin.newReturn(expression);
	}
	
	/**
	 * @private
	 */
	public function newSuper(arguments:Vector.<IArgument>):ISuperStatement
	{
		return containerMixin.newSuper(arguments);
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
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IStatementContainer#newWhile()
	 */
	public function newWhile(condition:IExpression):IWhileStatement
	{
		return containerMixin.newWhile(condition);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IStatementContainer#newWith()
	 */
	public function newWith(condition:IExpression):IWithStatement
	{
		return containerMixin.newWith(condition);
	}
}
}