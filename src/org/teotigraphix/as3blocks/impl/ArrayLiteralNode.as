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

import org.teotigraphix.as3blocks.api.IArrayLiteralNode;
import org.teotigraphix.as3blocks.api.IExpressionNode;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.impl.ASTIterator;
import org.teotigraphix.as3parser.utils.ASTUtil;

/**
 * The <code>IArrayLiteralNode</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class ArrayLiteralNode extends LiteralNode 
	implements IArrayLiteralNode
{
	//--------------------------------------------------------------------------
	//
	//  IArrayLiteralNode API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  entries
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3blocks.api.IArrayLiteralNode#entries
	 */
	public function get entries():Vector.<IExpressionNode>
	{
		var entries:Vector.<IExpressionNode> = new Vector.<IExpressionNode>();
		var i:ASTIterator = new ASTIterator(node);
		while (i.hasNext()) 
		{
			entries.push(ExpressionBuilder.build(i.next()));
		}
		return entries;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function ArrayLiteralNode(node:IParserNode)
	{
		super(node);
	}
	
	//--------------------------------------------------------------------------
	//
	//  IArrayLiteralNode API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.teotigraphix.as3blocks.api.IArrayLiteralNode#add()
	 */
	public function add(expression:IExpressionNode):void
	{
		if (node.numChildren > 0)
		{
			node.appendToken(TokenBuilder.newComma());
			node.appendToken(TokenBuilder.newSpace());
		}
		node.addChild(expression.node);
	}
	
	/**
	 * @copy org.teotigraphix.as3blocks.api.IArrayLiteralNode#remove()
	 */
	public function remove(index:int):IExpressionNode
	{
		var old:IParserNode = node.getChild(index);
		if (node.numChildren - 1 > index)
		{
			ASTUtil.removeTrailingWhitespaceAndComma(old.stopToken);
		} 
		else if (index > 0)
		{
			ASTUtil.removePreceedingWhitespaceAndComma(old.startToken);
		}

		node.removeChild(old);
		return ExpressionBuilder.build(old);
	}
}
}