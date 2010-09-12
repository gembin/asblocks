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
import org.teotigraphix.as3parser.impl.AS3FragmentParser;
import org.teotigraphix.asblocks.api.IExpression;
import org.teotigraphix.asblocks.api.IForStatement;
import org.teotigraphix.asblocks.api.IScriptNode;
import org.teotigraphix.asblocks.api.IStatementContainer;

/*
for/init/dec-list
for/init/dec-list/dec-role
for/init/dec-list/name-type-init
for/init/dec-list/name-type-init/name
for/init/dec-list/name-type-init/type
for/init/dec-list/name-type-init/init
for/init/dec-list/dec-role
for/cond/releational
for/iter/post-inc
for/block
*/

/**
 * The <code>IForStatement</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class ForStatement extends ContainerDelegate 
	implements IForStatement
{
	override protected function get statementContainer():IStatementContainer
	{
		return new StatementList(node.getChild(3)); // block
	}
	
	private function findInit():IParserNode
	{
		return node.getKind(AS3NodeKind.INIT);
	}
	
	private function findCondition():IParserNode
	{
		return node.getKind(AS3NodeKind.COND);
	}
	
	private function findUpdate():IParserNode
	{
		return node.getKind(AS3NodeKind.ITER);
	}
	
	//----------------------------------
	//  initializer
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IForStatement#initializer
	 */
	public function get initializer():IScriptNode
	{
		var init:IParserNode = findInit();
		if (!init)
			return null;
		
		init = init.getFirstChild();
		
		if (init.isKind(AS3NodeKind.DEC_LIST))
		{
			return new DeclarationStatementNode(init);
		}
		else
		{
			return ExpressionBuilder.build(init);
		}
		
		return null;
	}
	
	/**
	 * @private
	 */	
	public function set initializer(value:IScriptNode):void
	{
		var init:IParserNode = findInit();
		if (!value && init)
		{
			init.removeChildAt(0);
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
			init.setChildAt(value.node, 0);
		}
	}
	
	//----------------------------------
	//  condition
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IForStatement#condition
	 */
	public function get condition():IExpression
	{
		var cond:IParserNode = findCondition();
		if (!cond)
			return null;
		
		return ExpressionBuilder.build(cond.getFirstChild());
	}
	
	/**
	 * @private
	 */	
	public function set condition(value:IExpression):void
	{
		var cond:IParserNode = findCondition();
		if (!value && cond)
		{
			cond.removeChildAt(0);
		}
		else if (value)
		{
			cond.setChildAt(value.node, 0);
		}
	}
	
	//----------------------------------
	//  iterator
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IForStatement#update
	 */
	public function get update():IExpression
	{
		var update:IParserNode = findUpdate();
		if (!update)
			return null;
		
		return ExpressionBuilder.build(update.getFirstChild());
	}
	
	/**
	 * @private
	 */	
	public function set update(value:IExpression):void
	{
		var updt:IParserNode = findUpdate();
		if (!value && updt)
		{
			updt.removeChildAt(0);
		}
		else if (value)
		{
			updt.setChildAt(value.node, 0);
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
	public function ForStatement(node:IParserNode)
	{
		super(node);
	}
}
}