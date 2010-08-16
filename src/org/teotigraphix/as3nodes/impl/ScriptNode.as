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
import org.teotigraphix.as3nodes.api.IIdentifierNode;
import org.teotigraphix.as3nodes.api.IMetaDataNode;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3nodes.api.IPackageNode;
import org.teotigraphix.as3nodes.api.IScriptNode;
import org.teotigraphix.as3nodes.api.ITypeNode;
import org.teotigraphix.as3nodes.api.MetaData;
import org.teotigraphix.as3nodes.api.Modifier;
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
	//  IIdentifierAware API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  uid
	//----------------------------------
	
	/**
	 * @private
	 */
	protected var _uid:IIdentifierNode;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IIdentifierAware#uid
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
		if (_uid)
			dispatchRemoveChange(AS3NodeKind.NAME, _uid);
		
		_uid = value;
		
		if (!_uid)
			return;
		
		dispatchAddChange(AS3NodeKind.NAME, _uid);
	}
	
	//--------------------------------------------------------------------------
	//
	//  IMetaDataAware API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  metaDatas
	//----------------------------------
	
	/**
	 * @private
	 */
	protected var _metaDatas:Vector.<IMetaDataNode>;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IMetaDataAware#metaDatas
	 */
	public function get metaDatas():Vector.<IMetaDataNode>
	{
		return _metaDatas;
	}
	
	//----------------------------------
	//  numMetaData
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IMetaDataAware#numMetaData
	 */
	public function get numMetaData():int
	{
		return _metaDatas.length;
	}
	
	//----------------------------------
	//  isBindable
	//----------------------------------
	
	/**
	 * Returns whether this node is Bindable.
	 */
	public function get isBindable():Boolean
	{
		return hasMetaData(MetaData.BINDABLE.name);
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
	
	//----------------------------------
	//  description
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _description:String;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ITypeNode#description
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
		
		// will call setComment() and update the AST
		as3Factory.newComment(this, _description);
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
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ICommentAware#newDocTag()
	 */
	public function newDocTag(name:String, body:String = null):IDocTag
	{
		return comment.newDocTag(name, body);
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
	 * @copy org.teotigraphix.as3nodes.api.INameAware#name
	 */
	public function get name():String
	{
		if (_uid)
			return _uid.localName;
		return null;
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
	protected var _modifiers:Vector.<Modifier>;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IModifierAware#modifiers
	 */
	public function get modifiers():Vector.<Modifier>
	{
		return _modifiers;
	}
	
	//--------------------------------------------------------------------------
	//
	//  IScriptElement API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  packageName
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IScriptElement#packageName
	 */
	public function get packageName():String
	{
		if (parent is IPackageNode)
			return IPackageNode(parent).name;
		return ITypeNode(parent).packageName;
	}
	
	//----------------------------------
	//  qualifiedName
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IScriptElement#qualifiedName
	 */
	public function get qualifiedName():String
	{
		if (parent is IPackageNode)
			return IPackageNode(parent).qualifiedName;
		return ITypeNode(parent).qualifiedName;
	}
	
	//----------------------------------
	//  parentQualifiedName
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IScriptElement#parentQualifiedName
	 */
	public function get parentQualifiedName():String
	{
		if (parent is IPackageNode)
			return IPackageNode(parent).name;
		return ITypeNode(parent).qualifiedName;
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
	 * Returns whether this node is DEPRECATED.
	 */
	public function get isDeprecated():Boolean
	{
		return hasMetaData(MetaData.DEPRECATED.name);
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
	public function addMetaData(node:IMetaDataNode):Boolean
	{
		metaDatas.push(node);
		
		dispatchAddChange(AS3NodeKind.META, node);
		
		return true;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IMetaDataAware#removeMetaData()
	 */
	public function removeMetaData(node:IMetaDataNode):Boolean
	{
		var len:int = metaDatas.length;
		for (var i:int = 0; i < len; i++)
		{
			if (metaDatas[i] == node)
			{
				metaDatas.splice(i, 1);
				dispatchRemoveChange(AS3NodeKind.META, node);
				return true;
			}
		}
		
		return false;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IMetaDataAware#getMetaData()
	 */
	public function getMetaData(name:String):IMetaDataNode
	{
		var len:int = metaDatas.length;
		for (var i:int = 0; i < len; i++)
		{
			if (metaDatas[i].name == name)
				return metaDatas[i];
		}
		
		return null;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IMetaDataAware#getAllMetaData()
	 */
	public function getAllMetaData(name:String):Vector.<IMetaDataNode>
	{
		var result:Vector.<IMetaDataNode> = new Vector.<IMetaDataNode>();
		
		var len:int = metaDatas.length;
		for (var i:int = 0; i < len; i++)
		{
			if (metaDatas[i].name == name)
				result.push(metaDatas[i]);
		}
		
		return result;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IMetaDataAware#hasMetaData()
	 */
	public function hasMetaData(name:String):Boolean
	{
		var len:int = metaDatas.length;
		for (var i:int = 0; i < len; i++)
		{
			if (metaDatas[i].name == name)
				return true;
		}
		return false;
	}
	
	/**
	 * @see org.teotigraphix.as3nodes.api.IAS3Factory#newMetaData()
	 */
	public function newMetaData(name:String):IMetaDataNode
	{
		return as3Factory.newMetaData(this, name);
	}
	
	//--------------------------------------------------------------------------
	//
	//  IModifierAware API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IModifierAware#addModifier()
	 */
	public function addModifier(modifier:Modifier):Boolean
	{
		// test to see if we have the modifier
		if (hasModifier(modifier))
			return false;
		
		// add the modifier to the vector
		modifiers.push(modifier);
		
		dispatchAddChange(AS3NodeKind.MODIFIER, modifier);
		
		return true;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IModifierAware#removeModifier()
	 */
	public function removeModifier(modifier:Modifier):Boolean
	{
		if (!hasModifier(modifier))
			return false;
		
		var len:int = modifiers.length;
		for (var i:int = 0; i < len; i++)
		{
			if (modifiers[i].equals(modifier))
			{
				modifiers.splice(i, 1);
				dispatchRemoveChange(AS3NodeKind.MODIFIER, modifier);
				return true;
			}
		}
		
		return false;
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
		_modifiers = new Vector.<Modifier>();
		_metaDatas = new Vector.<IMetaDataNode>();
		
		if (node.numChildren == 0)
		{
			// special case; for now all script nodes have a 
			// comment so they are not null
			as3Factory.newComment(this);
			return;
		}
		
		// need a copy because AST might be added through this loop
		var children:Vector.<IParserNode> = node.children.concat();
		
		for each (var child:IParserNode in children)
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
		
		// special case; for now all script nodes have a 
		// comment so they are not null
		if (!comment)
			as3Factory.newComment(this);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Protected :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	protected function computeMetaDataList(child:IParserNode):void
	{
		var len:int = child.numChildren;
		for (var i:int = 0; i < len; i++)
		{
			var metaData:IMetaDataNode = NodeFactory.instance.
				createMetaData(child.children[i], this);
			metaDatas.push(metaData);
		}
	}
	
	/**
	 * @private
	 */
	protected function computeAsDoc(child:IParserNode):void
	{
		as3Factory.newComment(this, child.stringValue);
	}
	
	/**
	 * @private
	 */
	protected function computeModifierList(child:IParserNode):void
	{
		var len:int = child.numChildren;
		for (var i:int = 0; i < len; i++)
		{
			var modifier:Modifier = Modifier.create(child.children[i].stringValue);
			// the node already has correct AST, just add the Modifier to the list
			modifiers.push(modifier);
		}
	}
	
	/**
	 * @private
	 */
	protected function computeName(child:IParserNode):void
	{
		// we set the backing var so we don't trigger a change event
		_uid = NodeFactory.instance.createIdentifier(child, this);
	}
	
	/**
	 * @private
	 */
	protected function computeContent(child:IParserNode):void
	{
	}
}
}