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
import org.teotigraphix.as3parser.api.IParserNode;

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
	public function addStatement(statement:String):IStatementNode
	{
		return statementContainer.addStatement(statement);
	}
	
	/**
	 * TODO Docme
	 */
	public function newExpressionStatement(statement:String):IExpressionStatementNode
	{
		return statementContainer.newExpressionStatement(statement);
	}
	
	/**
	 * TODO Docme
	 */
	public function newBreak():IBreakStatementNode
	{
		return statementContainer.newBreak();
	}
	
	/**
	 * TODO Docme
	 */
	public function newContinue():IContinueStatementNode
	{
		return statementContainer.newContinue();
	}
	
	/**
	 * TODO Docme
	 */
	public function newDeclaration(assignment:IExpressionNode):IDeclarationStatementNode
	{
		return statementContainer.newDeclaration(assignment);
	}
	
	/**
	 * TODO Docme
	 */
	public function newDefaultXMLNamespace(namespace:String):IDefaultXMLNamespaceStatementNode
	{
		return statementContainer.newDefaultXMLNamespace(namespace);
	}
	
	/**
	 * TODO Docme
	 */
	public function newDoWhile(condition:IExpressionNode):IDoWhileStatementNode
	{
		return statementContainer.newDoWhile(condition);
	}
	
	/**
	 * TODO Docme
	 */
	public function newIf(condition:IExpressionNode):IIfStatementNode
	{
		return statementContainer.newIf(condition);
	}
	
	/**
	 * @private
	 */
	public function newReturn(expression:IExpressionNode = null):IReturnStatementNode
	{
		return statementContainer.newReturn(expression);
	}
	
	/**
	 * @private
	 */
	public function newSwitch(condition:IExpressionNode):ISwitchStatementNode
	{
		return statementContainer.newSwitch(condition);
	}
	
	/**
	 * @private
	 */
	public function newThrow(expression:IExpressionNode):IThrowStatementNode
	{
		return statementContainer.newThrow(expression);
	}
}
}