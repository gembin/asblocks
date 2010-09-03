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

import org.teotigraphix.asblocks.api.IExpressionNode;
import org.teotigraphix.asblocks.api.IINvocationNode;
import org.teotigraphix.asblocks.utils.ASTUtil;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.impl.ASTIterator;

/**
 * The <code>IINvocationNode</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class InvocationNode extends ExpressionNode 
	implements IINvocationNode
{
	protected function setArguments(value:Vector.<IExpressionNode>):void
	{
		var args:IParserNode = node.getKind(AS3NodeKind.ARGUMENTS);
		
		ASTUtil.removeAllChildren(args);
		
		if (!value)
			return;
		
		var len:int = value.length;
		for (var i:int = 0; i < len; i++)
		{
			var element:IExpressionNode = value[i] as IExpressionNode;
			args.addChild(element.node);
			if (i < len - 1)
			{
				args.appendToken(TokenBuilder.newComma());
				args.appendToken(TokenBuilder.newSpace());
			}
		}
	}
	
	//----------------------------------
	//  arguments
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IINvocationNode#arguments
	 */
	public function get arguments():Vector.<IExpressionNode>
	{
		var args:IParserNode = node.getKind(AS3NodeKind.ARGUMENTS);
		var i:ASTIterator = new ASTIterator(args);
		
		var result:Vector.<IExpressionNode> = new Vector.<IExpressionNode>();
		while (i.hasNext())
		{
			result.push(ExpressionBuilder.build(i.next()));
		}
		
		return result;
	}
	
	/**
	 * @private
	 */	
	public function set arguments(value:Vector.<IExpressionNode>):void
	{
		setArguments(value);
	}
	
	//----------------------------------
	//  target
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IINvocationNode#target
	 */
	public function get target():IExpressionNode
	{
		return ExpressionBuilder.build(node.getFirstChild());
	}
	
	/**
	 * @private
	 */	
	public function set target(value:IExpressionNode):void
	{
		node.setChildAt(value.node, 0);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function InvocationNode(node:IParserNode)
	{
		super(node);
	}
}
}