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

package org.teotigraphix.as3blocks.impl
{

import org.teotigraphix.as3blocks.api.IExpressionStatementNode;
import org.teotigraphix.as3blocks.api.IStatementContainer;
import org.teotigraphix.as3blocks.api.IStatementNode;
import org.teotigraphix.as3blocks.utils.ASTUtil2;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.impl.AS3FragmentParser;

/**
 * The <code>IStatementContainer</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class StatementList extends ContainerDelegate
{
	override protected function statementContainer():IStatementContainer
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
	 * TODO Docme
	 */
	override public function addStatement(statement:String):IStatementNode
	{
		var stmt:IParserNode = AS3FragmentParser.parseExpressionStatement(statement);
		stmt.stopToken.next = null;
		_addStatement(stmt);
		return StatementBuilder.build(stmt);
	}
	
	/**
	 * TODO Docme
	 */
	override public function newExpressionStatement(statement:String):IExpressionStatementNode
	{
		var ast:IParserNode = AS3FragmentParser.parseExpressionStatement(statement);
		_addStatement(ast);
		return new ExpressionStatementNode(ast);
	}
	
	private function _addStatement(statement:IParserNode):void
	{
		ASTUtil2.addChildWithIndentation(node, statement);
	}
}
}