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

import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.impl.AS3FragmentParser;
import org.teotigraphix.asblocks.ASBlocksSyntaxError;
import org.teotigraphix.asblocks.api.IExpression;
import org.teotigraphix.asblocks.api.IFieldAccessExpression;
import org.teotigraphix.asblocks.utils.ASTUtil;

/**
 * The <code>IFieldAccessExpression</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class FieldAccessExpressionNode extends ExpressionNode 
	implements IFieldAccessExpression
{
	// dot/[target]
	// dot/name
	
	//--------------------------------------------------------------------------
	//
	//  IFieldAccessExpression API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  name
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IFieldAccessExpression#name
	 */
	public function get name():String
	{
		return ASTUtil.stringifyNode(node.getLastChild());
	}
	
	/**
	 * @private
	 */
	public function set name(value:String):void
	{
		if (value == "")
		{
			throw new ASBlocksSyntaxError("Cannot set name to an empty string");
		}
		else if (value == null)
		{
			throw new ASBlocksSyntaxError("Cannot set name to null");
		}
		var ast:IParserNode = AS3FragmentParser.parseName(value);
		node.setChildAt(ast, 1);
	}
	
	//----------------------------------
	//  target
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IFieldAccessExpression#target
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
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function FieldAccessExpressionNode(node:IParserNode)
	{
		super(node);
	}
}
}