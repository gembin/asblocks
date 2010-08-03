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
import org.teotigraphix.as3nodes.api.IIdentifierNode;
import org.teotigraphix.as3nodes.api.IMetaDataNode;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3nodes.api.IScriptNode;
import org.teotigraphix.as3nodes.api.MetaData;
import org.teotigraphix.as3nodes.api.Modifier;
import org.teotigraphix.as3nodes.utils.NodeUtil;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;

/**
 * The base class for all as3 script nodes.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class ScriptNode extends NodeBase implements IScriptNode
{
	//--------------------------------------------------------------------------
	//
	//  Protected :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  uid
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _uid:IIdentifierNode;
	
	/**
	 * The type identifier node.
	 */
	public function get uid():IIdentifierNode
	{
		return _uid;
	}
	
	/**
	 * @private
	 */	
	public function set uid(value:IIdentifierNode):void
	{
		_uid = value;
		if (_uid)
			_name = _uid.localName;
	}
	
	//--------------------------------------------------------------------------
	//
	//  IMetaDataAware API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  numMetaData
	//----------------------------------
	
	/**
	 * @private
	 */
	protected var metadata:Vector.<IMetaDataNode>;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IMetaDataAware#numMetaData
	 */
	public function get numMetaData():int
	{
		return metadata.length;
	}
	
	//----------------------------------
	//  isBindable
	//----------------------------------
	
	/**
	 * Returns whether this node is Bindable.
	 */
	public function get isBindable():Boolean
	{
		return hasMetaData(MetaData.BINDABLE.toString());
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
	public function set comment(value:ICommentNode):void
	{
		_comment = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  IVisible API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  isPublic
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IVisible#isPublic
	 */
	public function get isPublic():Boolean
	{
		return hasModifier(Modifier.PUBLIC);
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
	//  IModifierAware API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  modifiers
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _modifiers:Vector.<Modifier>;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IModifierAware#modifiers
	 */
	public function get modifiers():Vector.<Modifier>
	{
		return _modifiers;
	}
	
	/**
	 * @private
	 */	
	public function set modifiers(value:Vector.<Modifier>):void
	{
		_modifiers = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  IScriptElement API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  isStatic
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IScriptElement#isStatic
	 */
	public function get isStatic():Boolean
	{
		return hasModifier(Modifier.STATIC);
	}
	
	//----------------------------------
	//  isFinal
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IScriptElement#isFinal
	 */
	public function get isFinal():Boolean
	{
		return hasModifier(Modifier.FINAL);
	}
	
	//--------------------------------------------------------------------------
	//
	//  IDeprecateAware API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  isDeprecated
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _isDeprecated:Boolean;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IDeprecateAware#isDeprecated
	 */
	public function get isDeprecated():Boolean
	{
		return _isDeprecated;
	}
	
	/**
	 * @private
	 */	
	public function set isDeprecated(value:Boolean):void
	{
		_isDeprecated = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function ScriptNode(node:IParserNode, parent:INode)
	{
		super(node, parent);
	}
	
	//--------------------------------------------------------------------------
	//
	//  IMetaDataAware API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IMetaDataAware#addMetaData()
	 */
	public function addMetaData(node:IMetaDataNode):void
	{
		metadata.push(node);
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IMetaDataAware#getMetaData()
	 */
	public function getMetaData(name:String):Vector.<IMetaDataNode>
	{
		var result:Vector.<IMetaDataNode> = new Vector.<IMetaDataNode>();
		
		var len:int = metadata.length;
		for (var i:int = 0; i < len; i++)
		{
			var element:IMetaDataNode = metadata[i] as IMetaDataNode;
			if (element.name == name)
				result.push(element);
		}
		
		return result;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IMetaDataAware#hasMetaData()
	 */
	public function hasMetaData(name:String):Boolean
	{
		for each (var element:IMetaDataNode in metadata)
		{
			if (element.name == name)
				return true;
		}
		return false;
	}
	
	//--------------------------------------------------------------------------
	//
	//  IModifierAware API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IModifierAware#addModifier()
	 */
	public function addModifier(modifier:Modifier):void
	{
		modifiers.push(modifier);
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IModifierAware#hasModifier()
	 */
	public function hasModifier(modifier:Modifier):Boolean
	{
		for each (var element:Modifier in modifiers)
		{
			if (element.equals(modifier))
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
		return null;
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
		comment = NodeFactory.instance.createCommentPlaceholderNode(this);
		
		modifiers = new Vector.<Modifier>();
		metadata = new Vector.<IMetaDataNode>();
		
		if (!node || node.numChildren == 0)
			return;
		
		for each (var child:IParserNode in node.children)
		{
			if (child.isKind(AS3NodeKind.META_LIST))
			{
				computeMetaDataList(child);
			}
			else if (child.isKind(AS3NodeKind.AS_DOC))
			{
				computeAsDoc(child);
			}
			else if (child.isKind(AS3NodeKind.MOD_LIST))
			{
				computeModifierList(child);
			}
			else if (child.isKind(AS3NodeKind.NAME))
			{
				computeName(child);
			}
			else if (child.isKind(AS3NodeKind.CONTENT))
			{
				computeContent(child);
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
	protected function computeMetaDataList(typeContent:IParserNode):void
	{
		NodeUtil.computeMetaDataList(this, typeContent);
		
		_isDeprecated = hasMetaData(MetaData.DEPRECATED.name);
	}
	
	/**
	 * @private
	 */
	protected function computeAsDoc(typeContent:IParserNode):void
	{
		NodeUtil.computeAsDoc(this, typeContent);
	}
	
	/**
	 * @private
	 */
	protected function computeModifierList(typeContent:IParserNode):void
	{
		NodeUtil.computeModifierList(this, typeContent);
	}
	
	/**
	 * @private
	 */
	protected function computeName(typeContent:IParserNode):void
	{
		uid = NodeFactory.instance.createIdentifier(typeContent, this);
	}
	
	/**
	 * @private
	 */
	protected function computeContent(typeContent:IParserNode):void
	{
	}
}
}