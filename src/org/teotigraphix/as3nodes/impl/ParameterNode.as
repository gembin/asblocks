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

import org.teotigraphix.as3nodes.api.ICommentNode;
import org.teotigraphix.as3nodes.api.IDocTag;
import org.teotigraphix.as3nodes.api.IFunctionNode;
import org.teotigraphix.as3nodes.api.IIdentifierNode;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3nodes.api.IParameterNode;
import org.teotigraphix.as3nodes.utils.NodeUtil;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;

// TODO figure out how you want to deal with comments

/**
 * TODO DOCME
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class ParameterNode extends NodeBase implements IParameterNode
{
	//----------------------------------
	//  identifier
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _identifier:IIdentifierNode;
	
	/**
	 * @private
	 */	
	protected function get identifier():IIdentifierNode
	{
		return _identifier;
	}
	
	/**
	 * @private
	 */	
	protected function set identifier(value:IIdentifierNode):void
	{
		_identifier = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  ICommentAware API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  comment
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _comment:ICommentNode;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ICommentAware#comment
	 */
	public function get comment():ICommentNode
	{
		return _comment;
	}
	
	/**
	 * @private
	 */	
	public function setComment(value:ICommentNode):void
	{
		_comment = value;
		
		if (_comment)
			dispatchAddChange(AS3NodeKind.AS_DOC, _comment);
		else
			dispatchRemoveChange(AS3NodeKind.AS_DOC, null);
	}
	
	
	/**
	 * @private
	 */
	public function newDocTag(name:String, body:String = null):IDocTag
	{
		return null;
	}
	
	//----------------------------------
	//  description
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _description:String;
	
	/**
	 * doc
	 */
	public function get description():String
	{
		return _description;
	}
	
	/**
	 * @private
	 */	
	public function set description(value:String):void
	{
		_description = value;
		
		var func:IFunctionNode = parent as IFunctionNode;
		func.newDocTag("param", name + " " + _description);
	}
	
	//----------------------------------
	//  hasDescription
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ICommentAware#hasDescription
	 */
	public function get hasDescription():Boolean
	{
		return comment.hasDescription;
	}
	
	//--------------------------------------------------------------------------
	//
	//  INameAware API :: Properties
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
	 * @copy org.teotigraphix.as3nodes.api.INameAware#name
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
	
	//--------------------------------------------------------------------------
	//
	//  IParameterNode API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  type
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _type:IIdentifierNode;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IParameterNode#type
	 */
	public function get type():IIdentifierNode
	{
		return _type;
	}
	
	/**
	 * @private
	 */	
	public function set type(value:IIdentifierNode):void
	{
		_type = value;
	}
	
	//----------------------------------
	//  hasType
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _hasType:Boolean;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IParameterNode#hasType
	 */
	public function get hasType():Boolean
	{
		return type != null;
	}
	
	//----------------------------------
	//  value
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _value:Object;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IParameterNode#value
	 */
	public function get value():Object
	{
		return _value;
	}
	
	/**
	 * @private
	 */	
	public function set value(value:Object):void
	{
		_value = value;
	}
	
	//----------------------------------
	//  hasValue
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _hasValue:Boolean;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IParameterNode#hasValue
	 */
	public function get hasValue():Boolean
	{
		return value != null;
	}
	
	//----------------------------------
	//  defaultValue
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _defaultValue:String;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IParameterNode#defaultValue
	 */
	public function get defaultValue():String
	{
		return _defaultValue;
	}
	
	/**
	 * @private
	 */	
	public function set defaultValue(value:String):void
	{
		_defaultValue = value;
	}
	
	//----------------------------------
	//  isRest
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _isRest:Boolean;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IParameterNode#isRest
	 */
	public function get isRest():Boolean
	{
		return _isRest;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function ParameterNode(node:IParserNode, parent:INode)
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
		as3Factory.newComment(this);
		
		if (node.numChildren == 0)
			return;
		
		for each (var child:IParserNode in node.children)
		{
			if (child.isKind(AS3NodeKind.NAME_TYPE_INIT))
			{
				computeNameTypeInt(child);
			}
			else if (child.isKind(AS3NodeKind.REST))
			{
				_isRest = true;
				_name = child.stringValue;
			}
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//  Protected :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	protected function computeNameTypeInt(child:IParserNode):void
	{
		identifier = NodeFactory.instance.createIdentifier(child.getChild(0), this);
		name = identifier.localName;
		
		if (child.numChildren > 1)
			type = NodeFactory.instance.createIdentifier(child.getChild(1), this);
		
		if (child.numChildren > 2)
		{
			var init:IParserNode = child.getChild(2);
			var cinit:IParserNode = init.getChild(0);
			if (cinit && cinit.isKind(AS3NodeKind.PRIMARY))
			{
				value = cinit.stringValue;
			}
		}
	}
}
}