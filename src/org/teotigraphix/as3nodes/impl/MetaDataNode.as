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
import org.teotigraphix.as3nodes.api.IMetaDataNode;
import org.teotigraphix.as3nodes.api.IMetaDataParameterNode;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3nodes.utils.ASTNodeUtil;
import org.teotigraphix.as3nodes.utils.NodeUtil;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.core.Node;

/**
 * TODO DOCME
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class MetaDataNode extends NodeBase implements IMetaDataNode
{
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
	public function set comment(value:ICommentNode):void
	{
		_comment = value;
	}
	
	//----------------------------------
	//  description
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _description:String;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ICommentAware#description
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
		
		var asdoc:IParserNode = ASTNodeUtil.createAsDoc(this, _description);
		comment = new CommentNode(asdoc.getLastChild(), this);
	}
	
	public function addDocTag(name:String, body:String):IDocTag
	{
		return comment.addDocTag(name, body);
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
	//  IMetaDataNode API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  parameter
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _parameter:String;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IMetaDataNode#parameter
	 */
	public function get parameter():String
	{
		return _parameter;
	}
	
	/**
	 * @private
	 */	
	public function set parameter(value:String):void
	{
		_parameter = value;
	}
	
	//----------------------------------
	//  parameters
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _parameters:Vector.<IMetaDataParameterNode>;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IMetaDataNode#parameters
	 */
	public function get parameters():Vector.<IMetaDataParameterNode>
	{
		return _parameters;
	}
	
	/**
	 * @private
	 */	
	public function set parameters(value:Vector.<IMetaDataParameterNode>):void
	{
		_parameters = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden Public :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  qualifiedName
	//----------------------------------
	
	/**
	 * @private
	 */
	public function get qualifiedName():String
	{
		return ""; //super.qualifiedName + "#attribute:" + name;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function MetaDataNode(node:IParserNode, parent:INode)
	{
		super(node, parent);
	}
	
	//--------------------------------------------------------------------------
	//
	//  IMetaDataNode API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IMetaDataNode#getParameter()
	 */
	public function getParameter(name:String):IMetaDataParameterNode
	{
		if (_parameters == null || _parameters.length == 0)
			return null;
		
		for each (var param:IMetaDataParameterNode in _parameters)
		{
			if (param.hasName && param.name == name)
				return param;
		}
		
		return null;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IMetaDataNode#getParameterAt()
	 */
	public function getParameterAt(index:int):IMetaDataParameterNode
	{
		if (_parameters == null || _parameters.length == 0)
			return null;
		return _parameters[index];
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IMetaDataNode#getParameterValue()
	 */
	public function getParameterValue(name:String):String
	{
		if (_parameters == null || _parameters.length == 0)
			return null;
		
		for each (var param:IMetaDataParameterNode in _parameters)
		{
			if (param.hasName && param.name == name)
				return param.value;
		}
		return null;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IMetaDataNode#hasParameter()
	 */
	public function hasParameter(name:String):Boolean
	{
		if (_parameters == null || _parameters.length == 0)
			return false;
		
		for each (var param:IMetaDataParameterNode in _parameters)
		{
			if (param.hasName && param.name == name)
				return true;
		}
		
		return false;
	}
	
	//--------------------------------------------------------------------------
	//
	//  ISeeLinkAware API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ISeeLinkAware#toLink()
	 */
	public function toLink():String
	{
		return qualifiedName;
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
		for each (var child:IParserNode in node.children) 
		{
			if (child.isKind(AS3NodeKind.AS_DOC))
			{
				computeAsdoc(child);
			}
		}
		
		var data:String = node.stringValue;
		
		_name = data.indexOf(" ( ") > -1 ? 
			data.substring( 0, data.indexOf(" ( "))	: 
			data;
		
		_parameter = data.indexOf("( ") > -1 ? 
			data.substring(data.indexOf("( ") + 2, data.lastIndexOf(" )")) : 
			"";
		
		if (_parameter && _parameter != "")
			computeParameters();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Protected :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	protected function computeAsdoc(child:IParserNode):void
	{
		NodeUtil.computeAsDoc(this, child);
	}
	
	/**
	 * @private
	 */
	protected function computeParameters():void
	{
		_parameters = new Vector.<IMetaDataParameterNode>();
		
		var split:Array = _parameter.split(" , ");
		
		for each (var element:String in split)
		{
			var pnode:IParserNode = Node.create(AS3NodeKind.PARAMETER, -1, -1, element);
			_parameters.push(new MetaDataParameterNode(pnode, this));
		}
	}
}
}