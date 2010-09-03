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

import org.teotigraphix.asblocks.api.IArgumentNode;
import org.teotigraphix.asblocks.api.IBreakStatementNode;
import org.teotigraphix.asblocks.api.IContinueStatementNode;
import org.teotigraphix.asblocks.api.IDeclarationStatementNode;
import org.teotigraphix.asblocks.api.IDefaultXMLNamespaceStatementNode;
import org.teotigraphix.asblocks.api.IDoWhileStatementNode;
import org.teotigraphix.asblocks.api.IExpressionNode;
import org.teotigraphix.asblocks.api.IExpressionStatementNode;
import org.teotigraphix.asblocks.api.IFunctionCommon;
import org.teotigraphix.asblocks.api.IFunctionLiteralNode;
import org.teotigraphix.asblocks.api.IIfStatementNode;
import org.teotigraphix.asblocks.api.IReturnStatementNode;
import org.teotigraphix.asblocks.api.IStatementContainer;
import org.teotigraphix.asblocks.api.IStatementNode;
import org.teotigraphix.asblocks.api.ISwitchStatementNode;
import org.teotigraphix.asblocks.api.IThrowStatementNode;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;

/**
 * The <code>IFunctionLiteralNode</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class FunctionLiteralNode extends ExpressionNode 
	implements IFunctionLiteralNode
{
	private var functionMixin:IFunctionCommon;
	
	private var containerMixin:IStatementContainer;
	
	//--------------------------------------------------------------------------
	//
	//  IFunctionCommon API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  arguments
	//----------------------------------
	
	/**
	 * doc
	 */
	public function get arguments():Vector.<IArgumentNode>
	{
		return functionMixin.arguments;
	}
	
	//----------------------------------
	//  type
	//----------------------------------
	
	/**
	 * doc
	 */
	public function get type():String
	{
		return functionMixin.type;
	}
	
	/**
	 * @private
	 */	
	public function set type(value:String):void
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
	public function FunctionLiteralNode(node:IParserNode)
	{
		super(node);
		
		functionMixin = new FunctionCommon(node);
		containerMixin = new StatementList(node.getKind(AS3NodeKind.BLOCK));
	}
	
	//--------------------------------------------------------------------------
	//
	//  IFunctionCommon API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * TODO Docme
	 */
	public function addParameter(name:String, 
								 type:String, 
								 defaultValue:String = null):IArgumentNode
	{
		return functionMixin.addParameter(name, type, defaultValue);
	}
	
	/**
	 * TODO Docme
	 */
	public function removeParameter(name:String):IArgumentNode
	{
		return functionMixin.removeParameter(name);
	}
	
	/**
	 * TODO Docme
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
	 * TODO Docme
	 */
	public function addStatement(statement:String):IStatementNode
	{
		return containerMixin.addStatement(statement);
	}
	
	/**
	 * TODO Docme
	 */
	public function newExpressionStatement(statement:String):IExpressionStatementNode
	{
		return containerMixin.newExpressionStatement(statement);
	}
	
	/**
	 * TODO Docme
	 */
	public function newBreak():IBreakStatementNode
	{
		return containerMixin.newBreak();
	}
	
	/**
	 * TODO Docme
	 */
	public function newContinue():IContinueStatementNode
	{
		return containerMixin.newContinue();
	}
	
	/**
	 * TODO Docme
	 */
	public function newDeclaration(assignment:IExpressionNode):IDeclarationStatementNode
	{
		return containerMixin.newDeclaration(assignment);
	}
	
	/**
	 * TODO Docme
	 */
	public function newDefaultXMLNamespace(namespace:String):IDefaultXMLNamespaceStatementNode
	{
		return containerMixin.newDefaultXMLNamespace(namespace);
	}
	
	/**
	 * TODO Docme
	 */
	public function newDoWhile(condition:IExpressionNode):IDoWhileStatementNode
	{
		return containerMixin.newDoWhile(condition);
	}
	
	/**
	 * TODO Docme
	 */
	public function newIf(condition:IExpressionNode):IIfStatementNode
	{
		return containerMixin.newIf(condition);
	}
	
	/**
	 * @private
	 */
	public function newReturn(expression:IExpressionNode = null):IReturnStatementNode
	{
		return containerMixin.newReturn(expression);
	}
	
	/**
	 * @private
	 */
	public function newSwitch(condition:IExpressionNode):ISwitchStatementNode
	{
		return containerMixin.newSwitch(condition);
	}
	
	/**
	 * @private
	 */
	public function newThrow(expression:IExpressionNode):IThrowStatementNode
	{
		return containerMixin.newThrow(expression);
	}
}
}