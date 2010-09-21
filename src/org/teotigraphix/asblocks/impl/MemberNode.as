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

import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.asblocks.ASBlocksSyntaxError;
import org.teotigraphix.asblocks.api.IDocComment;
import org.teotigraphix.asblocks.api.IMember;
import org.teotigraphix.asblocks.api.IMetaData;
import org.teotigraphix.asblocks.api.Modifier;
import org.teotigraphix.asblocks.api.Visibility;
import org.teotigraphix.asblocks.utils.DocCommentUtil;
import org.teotigraphix.asblocks.utils.MetaDataUtil;
import org.teotigraphix.asblocks.utils.ModifierUtil;
import org.teotigraphix.asblocks.utils.NameTypeUtil;

/**
 * The <code>IMember</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class MemberNode extends ScriptNode implements IMember
{
	//--------------------------------------------------------------------------
	//
	//  IMember API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  visibility
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IMember#visibility
	 */
	public function get visibility():Visibility
	{
		return ModifierUtil.getVisibility(node);
	}
	
	/**
	 * @private
	 */	
	public function set visibility(value:Visibility):void
	{
		return ModifierUtil.setVisibility(node, value);
	}
	
	//----------------------------------
	//  name
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IMember#name
	 */
	public function get name():String
	{
		return NameTypeUtil.getName(node);
	}
	
	/**
	 * @private
	 */	
	public function set name(value:String):void
	{
		if (value.indexOf(".") != -1)
		{
			throw new ASBlocksSyntaxError("IMember names cannot contain a period");
		}
		NameTypeUtil.setName(node, value);
	}
	
	//----------------------------------
	//  type
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IMember#type
	 */
	public function get type():String
	{
		return NameTypeUtil.getType(node);
	}
	
	/**
	 * @private
	 */	
	public function set type(value:String):void
	{
		NameTypeUtil.setType(node, value);
	}
	
	//----------------------------------
	//  isStatic
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IMember#isStatic
	 */
	public function get isStatic():Boolean
	{
		return ModifierUtil.hasModifierFlag(node, Modifier.STATIC);
	}
	
	/**
	 * @private
	 */	
	public function set isStatic(value:Boolean):void
	{
		ModifierUtil.setModifierFlag(node, value, Modifier.STATIC);
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
	 * @copy org.teotigraphix.asblocks.api.IMetaDataAware#metaDatas
	 */
	public function get metaDatas():Vector.<IMetaData>
	{
		return MetaDataUtil.getMetaDatas(node);
	}
	
	//--------------------------------------------------------------------------
	//
	//  IDocCommentAware API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  description
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IDocCommentAware#description
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
		documentation.description = value;
	}
	
	//----------------------------------
	//  documentation
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IDocCommentAware#documentation
	 */
	public function get documentation():IDocComment
	{
		return DocCommentUtil.createDocComment(node);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function MemberNode(node:IParserNode)
	{
		super(node);
	}
	
	//--------------------------------------------------------------------------
	//
	//  IMetaDataAware API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IMetaDataAware#newMetaData()
	 */
	public function newMetaData(name:String):IMetaData
	{
		return MetaDataUtil.newMetaData(node, name);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IMetaDataAware#getMetaData()
	 */
	public function getMetaData(name:String):IMetaData
	{
		return MetaDataUtil.getMetaData(node, name);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IMetaDataAware#getAllMetaData()
	 */
	public function getAllMetaData(name:String):Vector.<IMetaData>
	{
		return MetaDataUtil.getAllMetaData(node, name);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IMetaDataAware#hasMetaData()
	 */
	public function hasMetaData(name:String):Boolean
	{
		return MetaDataUtil.hasMetaData(node, name);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IMetaDataAware#removeMetaData()
	 */
	public function removeMetaData(metaData:IMetaData):Boolean
	{
		return MetaDataUtil.removeMetaData(node, metaData);
	}
}
}