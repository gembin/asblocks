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
import org.teotigraphix.asblocks.api.IINvocation;
import org.teotigraphix.asblocks.utils.ASTUtil;

/**
 * The <code>IINvocation</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class InvocationNode extends ExpressionNode implements IINvocation
{
	//--------------------------------------------------------------------------
	//
	//  IINvocation API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  target
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IINvocation#target
	 */
	public function get target():IExpression
	{
		return ExpressionBuilder.build(node.getFirstChild());
	}
	
	/**
	 * @private
	 */	
	public function set target(value:IExpression):void
	{
		node.setChildAt(value.node, 0);
	}
	
	//----------------------------------
	//  arguments
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IINvocation#arguments
	 */
	public function get arguments():Vector.<IExpression>
	{
		var result:Vector.<IExpression> = new Vector.<IExpression>();
		var ast:IParserNode = findArguments();
		if (!ast)
			return result;
		
		var i:ASTIterator = new ASTIterator(ast);
		while (i.hasNext())
		{
			result.push(ExpressionBuilder.build(i.next()));
		}
		
		return result;
	}
	
	/**
	 * @private
	 */	
	public function set arguments(value:Vector.<IExpression>):void
	{
		setArguments(value);
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
	
	//--------------------------------------------------------------------------
	//
	//  Private :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private function findArguments():IParserNode
	{
		return node.getKind(AS3NodeKind.ARGUMENTS);
	}
	
	/**
	 * @private
	 */
	private function setArguments(value:Vector.<IExpression>):void
	{
		var args:IParserNode = node.getKind(AS3NodeKind.ARGUMENTS);
		
		ASTUtil.removeAllChildren(args);
		
		if (!value)
			return;
		
		var len:int = value.length;
		for (var i:int = 0; i < len; i++)
		{
			var element:IExpression = value[i] as IExpression;
			args.addChild(element.node);
			if (i < len - 1)
			{
				args.appendToken(TokenBuilder.newComma());
				args.appendToken(TokenBuilder.newSpace());
			}
		}
	}
}
}