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
import org.teotigraphix.as3parser.impl.ASTIterator;
import org.teotigraphix.asblocks.api.IExpression;
import org.teotigraphix.asblocks.api.ISwitchCase;
import org.teotigraphix.asblocks.api.ISwitchDefault;
import org.teotigraphix.asblocks.api.ISwitchLabel;
import org.teotigraphix.asblocks.api.ISwitchStatement;

/*
switch
switch/condition
switch/cases
switch/cases/case
switch/cases/case/label|default
switch/cases/case/switch-block
*/

/**
 * The <code>ISwitchStatement</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class SwitchStatementNode extends ScriptNode 
	implements ISwitchStatement
{
	private function findCondition():IParserNode
	{
		return node.getFirstChild();
	}
	
	private function findCases():IParserNode
	{
		return node.getLastChild();
	}
	
	//--------------------------------------------------------------------------
	//
	//  ISwitchStatement API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  condition
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.ISwitchStatement#condition
	 */
	public function get condition():IExpression
	{
		return ExpressionBuilder.build(findCondition().getFirstChild());
	}
	
	/**
	 * @private
	 */	
	public function set condition(value:IExpression):void
	{
		findCondition().setChildAt(value.node, 0);
	}
	
	//----------------------------------
	//  labels
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.ISwitchStatement#labels
	 */
	public function get labels():Vector.<ISwitchLabel>
	{
		var result:Vector.<ISwitchLabel> = new Vector.<ISwitchLabel>();
		var cases:IParserNode = findCases();
		var i:ASTIterator = new ASTIterator(cases);
		while(i.hasNext())
		{
			var ast:IParserNode = i.next();
			if (ast.isKind(AS3NodeKind.CASE))
			{
				result.push(new SwitchCaseNode(ast));
			}
			else if (ast.isKind(AS3NodeKind.DEFAULT))
			{
				result.push(new SwitchDefaultNode(ast));
			}
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
	public function SwitchStatementNode(node:IParserNode)
	{
		super(node);
	}
	
	//--------------------------------------------------------------------------
	//
	//  ISwitchStatement API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.ISwitchStatement#newCase()
	 */
	public function newCase(label:String):ISwitchCase
	{
		var ast:IParserNode = ASTBuilder.newSwitchCase(node, label);
		return new SwitchCaseNode(ast);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.ISwitchStatement#newDefault()
	 */
	public function newDefault():ISwitchDefault
	{
		var ast:IParserNode = ASTBuilder.newSwitchDefault(node);
		return new SwitchDefaultNode(ast);
	}
}
}