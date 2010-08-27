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

import org.teotigraphix.as3blocks.api.IBooleanLiteralNode;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.api.KeyWords;
import org.teotigraphix.as3parser.core.LinkedListToken;
import org.teotigraphix.as3parser.core.TokenNode;

/**
 * The <code>IBooleanLiteralNode</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class BooleanLiteralNode extends LiteralNode 
	implements IBooleanLiteralNode
{
	//--------------------------------------------------------------------------
	//
	//  ISimpleNameExpressionNode API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  value
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3blocks.api.IBooleanLiteralNode#value
	 */
	public function get value():Boolean
	{
		return Boolean(tokenText);
	}
	
	/**
	 * @private
	 */
	public function set value(value:Boolean):void
	{
		var token:LinkedListToken = TokenNode(node).token;
		if (value)
		{
			node.kind = AS3NodeKind.TRUE;
			node.stringValue = KeyWords.TRUE;
		}
		else
		{
			node.kind = AS3NodeKind.FALSE;
			node.stringValue = KeyWords.FALSE;
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
	public function BooleanLiteralNode(node:IParserNode)
	{
		super(node);
	}
}
}