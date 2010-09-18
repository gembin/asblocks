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
import org.teotigraphix.asblocks.api.IArgument;

/**
 * The <code>IArgument</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class ArgumentNode extends ScriptNode 
	implements IArgument
{
	//--------------------------------------------------------------------------
	//
	//  IArgument API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  defaultValue
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IArgument#defaultValue
	 */
	public function get defaultValue():String
	{
		if (!isRest)
		{
			var ast:IParserNode = node.getKind(AS3NodeKind.NAME_TYPE_INIT);
			var init:IParserNode = ast.getKind(AS3NodeKind.INIT);
			if (init)
			{
				return init.stringValue;
			}
		}
		return null;
	}
	
	/**
	 * @private
	 */	
	public function set defaultValue(value:String):void
	{
		// TODO impl
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IArgument#hasDefaultValue
	 */
	public function get hasDefaultValue():Boolean
	{
		if (!isRest)
		{
			var ast:IParserNode = node.getKind(AS3NodeKind.NAME_TYPE_INIT);
			var init:IParserNode = ast.getKind(AS3NodeKind.INIT);
			
			return init != null;
		}
		return false;
	}
	
	//----------------------------------
	//  description
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IArgument#description
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
	 * @copy org.teotigraphix.asblocks.api.IArgument#name
	 */
	public function get name():String
	{
		if (isRest)
		{
			var rest:IParserNode = node.getKind(AS3NodeKind.REST);
			return rest.stringValue;
		}
		
		var ast:IParserNode = node.getKind(AS3NodeKind.NAME_TYPE_INIT);
		var name:IParserNode = ast.getKind(AS3NodeKind.NAME);
		if (name)
		{
			return name.stringValue;
		}
		// IllegalStateException
		throw new Error("No parameter name, and not a 'rest' parameter");
	}
	
	//----------------------------------
	//  type
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IArgument#type
	 */
	public function get type():String
	{
		if (!isRest)
		{
			var ast:IParserNode = node.getKind(AS3NodeKind.NAME_TYPE_INIT);
			var type:IParserNode = ast.getKind(AS3NodeKind.TYPE);
			if (type)
			{
				return type.stringValue;
			}
		}
		return null;
	}
	
	//----------------------------------
	//  isRest
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IArgument#isRest
	 */
	public function get isRest():Boolean
	{
		return node.hasKind(AS3NodeKind.REST);
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