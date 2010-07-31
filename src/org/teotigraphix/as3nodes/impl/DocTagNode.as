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

import mx.utils.StringUtil;

import org.teotigraphix.as3nodes.api.IDocTag;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3nodes.utils.AsDocUtil;
import org.teotigraphix.as3parser.api.ASDocNodeKind;
import org.teotigraphix.as3parser.api.IParserNode;

/**
 * TODO DOCME
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class DocTagNode extends NodeBase implements IDocTag
{
	//--------------------------------------------------------------------------
	//
	//  IDocTag API :: Properties
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
	 * @copy org.teotigraphix.as3nodes.api.IDocTag#name
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
	//  body
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _body:String;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IDocTag#body
	 */
	public function get body():String
	{
		return _body;
	}
	
	/**
	 * @private
	 */	
	public function set body(value:String):void
	{
		_body = value;
	}
	//----------------------------------
	//  preformated
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _preformated:String;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IDocTag#preformated
	 */
	public function get preformated():String
	{
		return _preformated;
	}
	
	/**
	 * @private
	 */	
	public function set preformated(value:String):void
	{
		_preformated = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function DocTagNode(node:IParserNode, parent:INode)
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
		var nameNode:IParserNode = node.getChild(0);
		name = StringUtil.trim(nameNode.stringValue);
		
		if (node.numChildren == 1)
			return;
		
		var bodyNode:IParserNode = node.getChild(1);
		
		if (bodyNode && bodyNode.numChildren > 0)
		{
			var bodyString:String = "";
			
			for each (var element:IParserNode in bodyNode.children)
			{
				if (element.isKind(ASDocNodeKind.TEXT))
				{
					bodyString += AsDocUtil.returnString(element);
				}
				else if (element.isKind(ASDocNodeKind.PRE_TEXT))
				{
					
				}
			}
			
			body = StringUtil.trim(bodyString);
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//  Public :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	public function toString():String
	{
		return "@" + name + "[" + body + "]";
	}
}
}