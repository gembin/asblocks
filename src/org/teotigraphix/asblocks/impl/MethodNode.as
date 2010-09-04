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
import org.teotigraphix.asblocks.api.AccessorRole;
import org.teotigraphix.asblocks.api.IArgumentNode;
import org.teotigraphix.asblocks.api.IBreakStatementNode;
import org.teotigraphix.asblocks.api.IContinueStatementNode;
import org.teotigraphix.asblocks.api.IDeclarationStatementNode;
import org.teotigraphix.asblocks.api.IDefaultXMLNamespaceStatementNode;
import org.teotigraphix.asblocks.api.IDoWhileStatementNode;
import org.teotigraphix.asblocks.api.IExpressionNode;
import org.teotigraphix.asblocks.api.IExpressionStatementNode;
import org.teotigraphix.asblocks.api.IFunctionCommon;
import org.teotigraphix.asblocks.api.IIfStatementNode;
import org.teotigraphix.asblocks.api.IMethodNode;
import org.teotigraphix.asblocks.api.IReturnStatementNode;
import org.teotigraphix.asblocks.api.IStatementContainer;
import org.teotigraphix.asblocks.api.IStatementNode;
import org.teotigraphix.asblocks.api.ISwitchStatementNode;
import org.teotigraphix.asblocks.api.IThrowStatementNode;

/**
 * The <code>IMemberNode</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class MethodNode extends MemberNode 
	implements IMethodNode
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
	public function get arguments():Vector.<IArgumentNode>
	{
		return functionMixin.arguments;
	}
	
	//----------------------------------
	//  type
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IFunctionCommon#type
	 */
	override public function get type():String
	{
		return functionMixin.type;
	}
	
	/**
	 * @private
	 */	
	override public function set type(value:String):void
	{
		functionMixin.type = value;
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
								 defaultValue:String = null):IArgumentNode
	{
		return functionMixin.addParameter(name, type, defaultValue);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IFunctionCommon#removeParameter()
	 */
	public function removeParameter(name:String):IArgumentNode
	{
		return functionMixin.removeParameter(name);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IFunctionCommon#addRestParam()
	 */
	public function addRestParam(name:String):IArgumentNode
	{
		return functionMixin.addRestParam(name);
	}
	
	//--------------------------------------------------------------------------
	//
	//  IStatementContainer API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IStatementContainer#addStatement()
	 */
	public function addStatement(statement:String):IStatementNode
	{
		return containerMixin.addStatement(statement);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IStatementContainer#newExpressionStatement()
	 */
	public function newExpressionStatement(statement:String):IExpressionStatementNode
	{
		return containerMixin.newExpressionStatement(statement);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IStatementContainer#newBreak()
	 */
	public function newBreak():IBreakStatementNode
	{
		return containerMixin.newBreak();
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IStatementContainer#newContinue()
	 */
	public function newContinue():IContinueStatementNode
	{
		return containerMixin.newContinue();
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IStatementContainer#newDeclaration()
	 */
	public function newDeclaration(assignment:IExpressionNode):IDeclarationStatementNode
	{
		return containerMixin.newDeclaration(assignment);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IStatementContainer#newDefaultXMLNamespace()
	 */
	public function newDefaultXMLNamespace(namespace:String):IDefaultXMLNamespaceStatementNode
	{
		return containerMixin.newDefaultXMLNamespace(namespace);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IStatementContainer#newDoWhile()
	 */
	public function newDoWhile(condition:IExpressionNode):IDoWhileStatementNode
	{
		return containerMixin.newDoWhile(condition);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IStatementContainer#newIf()
	 */
	public function newIf(condition:IExpressionNode):IIfStatementNode
	{
		return containerMixin.newIf(condition);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IStatementContainer#newReturn()
	 */
	public function newReturn(expression:IExpressionNode = null):IReturnStatementNode
	{
		return containerMixin.newReturn(expression);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IStatementContainer#newSwitch()
	 */
	public function newSwitch(condition:IExpressionNode):ISwitchStatementNode
	{
		return containerMixin.newSwitch(condition);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IStatementContainer#newThrow()
	 */
	public function newThrow(expression:IExpressionNode):IThrowStatementNode
	{
		return containerMixin.newThrow(expression);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Private :: Methods
	//
	//--------------------------------------------------------------------------
	
}
}