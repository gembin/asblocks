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
import org.teotigraphix.as3parser.core.LinkedListToken;
import org.teotigraphix.asblocks.api.IExpression;
import org.teotigraphix.asblocks.api.IScriptNode;
import org.teotigraphix.asblocks.api.IStatementContainer;

/**
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class ForInStatementNodeBase extends ContainerDelegate 
{
	override protected function get statementContainer():IStatementContainer
	{
		return new StatementList(node.getChild(2)); // block
	}
	
	private function findVar():IParserNode
	{
		return node.getChild(0);
	}
	
	private function findIterated():IParserNode
	{
		return node.getChild(1);
	}
	
	//----------------------------------
	//  variable
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IForEachInStatement#variable
	 */
	public function get variable():IScriptNode
	{
		var vars:IParserNode = findVar();
		if (!vars)
			return null;
		
		if (vars.isKind(AS3NodeKind.DEC_LIST))
		{
			return new DeclarationStatementNode(vars);
		}
		else
		{
			return ExpressionBuilder.build(vars);
		}
		
		return null;
	}
	
	/**
	 * @private
	 */	
	public function set variable(value:IScriptNode):void
	{
		var vars:IParserNode = findVar();
		if (!value && vars)
		{
			node.removeChildAt(0);
		}
		else if (value)
		{
			var last:LinkedListToken = value.node.stopToken;
			if (last.text == ";")
			{
				var prev:LinkedListToken = last.previous;
				last.remove();
				value.node.stopToken = prev;
			}
			node.setChildAt(value.node, 0);
		}
	}
	
	//----------------------------------
	//  initializer
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IForEachInStatement#iterated
	 */
	public function get iterated():IExpression
	{
		var ast:IParserNode = findIterated();
		if (!ast)
			return null;
		
		return ExpressionBuilder.build(ast);
	}
	
	/**
	 * @private
	 */	
	public function set iterated(value:IExpression):void
	{
		var ast:IParserNode = findIterated();
		if (!value && ast)
		{
			node.removeChildAt(1);
		}
		else if (value)
		{
			node.setChildAt(value.node, 1);
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function ForInStatementNodeBase(node:IParserNode)
	{
		super(node);
	}
}
}