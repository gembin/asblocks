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
import org.teotigraphix.asblocks.api.INewExpressionNode;
import org.teotigraphix.asblocks.utils.ASTUtil;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.utils.ASTUtil;

/**
 * The <code>INewExpressionNode</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class NewExpressionNode extends InvocationNode 
	implements INewExpressionNode
{
	private function get hasArguments():Boolean
	{
		return node.hasKind(AS3NodeKind.ARGUMENTS);
	}
	
	override public function get arguments():Vector.<IExpressionNode>
	{
		if (hasArguments)
		{
			return super.arguments;
		}
		return null;
	}
	
	override public function set arguments(value:Vector.<IExpressionNode>):void
	{
		super.arguments = value;
		// TODO fix error
		return;
		if (hasArguments)
		{
			if (!value)
			{
				//node.removeChildAt(1);
			}
			else
			{
				//setArguments(value);
			}
		}
		else
		{
			if (value)
			{
				//var arguments:IParserNode = ASTUtil2.newParentheticAST(
				//	AS3NodeKind.ARGUMENTS, 
				//	AS3NodeKind.LPAREN, "(", 
				//	AS3NodeKind.RPAREN, ")");
				//node.addChild(arguments);
				//setArguments(value);
			}
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
	public function NewExpressionNode(node:IParserNode)
	{
		super(node);
	}
}
}