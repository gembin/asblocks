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

import org.teotigraphix.asblocks.api.IArgumentNode;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;

/**
 * The <code>IArgumentNode</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class ArgumentNode extends ScriptNode 
	implements IArgumentNode
{
	//--------------------------------------------------------------------------
	//
	//  ISimpleNameExpressionNode API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  defaultValue
	//----------------------------------
	
	/**
	 * doc
	 */
	public function get defaultValue():String
	{
		return null;
	}
	
	/**
	 * @private
	 */	
	public function set defaultValue(value:String):void
	{
		// TODO impl
	}
	
	//----------------------------------
	//  description
	//----------------------------------
	
	/**
	 * doc
	 */
	public function get description():String
	{
		return null;
	}
	
	/**
	 * @private
	 */	
	public function set description(value:String):void
	{
		// TODO impl
	}
	
	//----------------------------------
	//  name
	//----------------------------------
	
	/**
	 * doc
	 */
	public function get name():String
	{
		var ast:IParserNode = node.getKind(AS3NodeKind.NAME_TYPE_INIT);
		var name:IParserNode = ast.getKind(AS3NodeKind.NAME);
		if (ast)
		{
			if (isRest)
			{
				return "...";
			}
			// IllegalStateException
			throw new Error("No parameter name, and not a 'rest' parameter");
		}
		return name.stringValue;
	}
	
	//----------------------------------
	//  type
	//----------------------------------
	
	/**
	 * doc
	 */
	public function get type():String
	{
		var ast:IParserNode = node.getKind(AS3NodeKind.NAME_TYPE_INIT);
		var type:IParserNode = ast.getKind(AS3NodeKind.TYPE);
		if (type)
		{
			return type.stringValue;
		}
		return null;
	}
	
	//----------------------------------
	//  isRest
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _isRest:Boolean;
	
	/**
	 * doc
	 */
	public function get isRest():Boolean
	{
		return _isRest; 		// TODO impl
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function ArgumentNode(node:IParserNode)
	{
		super(node);
	}
}
}