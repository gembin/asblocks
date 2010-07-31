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

import flash.utils.Dictionary;

import org.teotigraphix.as3nodes.api.IConstantNode;
import org.teotigraphix.as3nodes.api.IIdentifierNode;
import org.teotigraphix.as3nodes.api.IMetaDataNode;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3nodes.api.ITypeNode;
import org.teotigraphix.as3nodes.api.MetaData;
import org.teotigraphix.as3nodes.api.Modifier;
import org.teotigraphix.as3nodes.utils.MetaDataUtils;
import org.teotigraphix.as3nodes.utils.ModifierUtil;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.utils.ASTUtil;

/**
 * The class|interface found in the package node.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class TypeNode extends NodeBase implements ITypeNode
{
	private var identifier:IdentifierNode;
	
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
	
	//----------------------------------
	//  isFinal
	//----------------------------------
	
	public function get isFinal():Boolean
	{
		return hasModifier(Modifier.FINAL);
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
	protected var metaData:Vector.<IMetaDataNode>;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IMetaDataAware#numMetaData
	 */
	public function get numMetaData():int
	{
		return metaData.length;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IMetaDataAware#addMetaData()
	 */
	public function addMetaData(node:IMetaDataNode):void
	{
		metaData.push(node);
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IMetaDataAware#getMetaData()
	 */
	public function getMetaData(name:String):Vector.<IMetaDataNode>
	{
		var result:Vector.<IMetaDataNode> = new Vector.<IMetaDataNode>();
		
		var len:int = metaData.length;
		for (var i:int = 0; i < len; i++)
		{
			var element:IMetaDataNode = metaData[i] as IMetaDataNode;
			if (element.name == name)
				result.push(element);
		}
		
		return result;
	}
	
	public function hasMetaData(meta:MetaData):Boolean
	{
		for each (var element:IMetaDataNode in metaData)
		{
			if (element.name == meta.name)
				return true;
		}
		return false;
	}
	
	public function get isBindable():Boolean
	{
		return hasMetaData(MetaData.BINDABLE);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function TypeNode(node:IParserNode, parent:INode)
	{
		super(node, parent);
	}
	
	//--------------------------------------------------------------------------
	//
	//  IModifierAware API :: Properties
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	protected var modifiers:Vector.<Modifier>;
	
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
	//  Overridden Protected :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	override protected function compute():void
	{
		modifiers = new Vector.<Modifier>();
		metaData = new Vector.<IMetaDataNode>();
		
		if (node.numChildren == 0)
			return;
		
		for each (var child:IParserNode in node.children)
		{
			if (child.isKind(AS3NodeKind.CONTENT))
			{
				computeTypeContent(child);
			}
			else if (child.isKind(AS3NodeKind.MOD_LIST))
			{
				ModifierUtil.computeModifierList(this, child);
			}
			else if (child.isKind(AS3NodeKind.META_LIST))
			{
				MetaDataUtils.computeMetaDataList(this, child);
			}
			else if (child.isKind(AS3NodeKind.NAME))
			{
				identifier = IdentifierNode.create(child, this);
				_name = identifier.toString();
			}
		}
	}
	
	private var block:IParserNode;
	
	private var constants:Vector.<IConstantNode>;
	
	private function computeTypeContent(typeContent:IParserNode):void
	{
		constants = new Vector.<IConstantNode>();
		
		if (typeContent.numChildren == 0)
			return;
		
		for each (var child:IParserNode in typeContent.children)
		{
			detectBlock(child);
			//detectFunction(child);
			//detectAttribute(child);
			detectConstant(child);
		}
		// constants
		// variables
		// accessors
		// methods
	}
	
	private function detectConstant(child:IParserNode):void
	{
		if (child.isKind(AS3NodeKind.CONST_LIST))
		{
			constants.push(new ConstantNode(child, this));
		}
	}
	
	private function detectBlock(child:IParserNode):void
	{
		if (child.isKind(AS3NodeKind.BLOCK))
		{
			block = child;
		}
	}
}
}