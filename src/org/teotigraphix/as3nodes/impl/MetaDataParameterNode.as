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

package org.teotigraphix.as3nodes.impl
{

import org.teotigraphix.as3nodes.api.IMetaDataParameterNode;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.utils.ASTUtil;

/**
 * TODO DOCME
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class MetaDataParameterNode extends NodeBase implements IMetaDataParameterNode
{
	//--------------------------------------------------------------------------
	//
	//  IMetaDataParameterNode API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  name
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _name:String;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IMetaDataParameterNode#name
	 */
	public function get name():String
	{
		return _name;
	}
	
	/**
	 * @private
	 */	
	public function set name(value:String):void
	{
		_name = value;
	}
	
	//----------------------------------
	//  value
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _value:String;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IMetaDataParameterNode#value
	 */
	public function get value():String
	{
		return _value;
	}
	
	/**
	 * @private
	 */	
	public function set value(value:String):void
	{
		_value = value;
	}
	
	//----------------------------------
	//  hasName
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IMetaDataParameterNode#hasName
	 */
	public function get hasName():Boolean
	{
		return _name != null && _name != "";
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function MetaDataParameterNode(node:IParserNode, parent:INode)
	{
		super(node, parent);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden Protected :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	override protected function compute():void
	{
		if (node.numChildren == 0)
			return;
		
		for each (var child:IParserNode in node.children) 
		{
			if (child.isKind(AS3NodeKind.NAME))
			{
				_name = child.stringValue;
			}
			else if (child.isKind(AS3NodeKind.VALUE))
			{
				_value = child.stringValue;
			}
		}
	}
}
}