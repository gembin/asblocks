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

import org.teotigraphix.as3nodes.api.ICommentNode;
import org.teotigraphix.as3nodes.api.IDocTag;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3nodes.utils.AsDocUtil;
import org.teotigraphix.as3parser.api.ASDocNodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.impl.ASDocParser;
import org.teotigraphix.as3parser.utils.ASTUtil;

/**
 * TODO DOCME
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class CommentNode extends NodeBase implements ICommentNode
{
	protected var asdocNode:IParserNode;
	
	//--------------------------------------------------------------------------
	//
	//  ICommentNode API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  shortDescription
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _shortDescription:String;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ICommentNode#shortDescription
	 */
	public function get shortDescription():String
	{
		return _shortDescription;
	}
	
	/**
	 * @private
	 */
	public function set shortDescription(value:String):void
	{
		_shortDescription = value;
	}
	
	//----------------------------------
	//  longDescription
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _longDescription:String;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ICommentNode#longDescription
	 */
	public function get longDescription():String
	{
		return _longDescription;
	}
	
	/**
	 * @private
	 */	
	public function set longDescription(value:String):void
	{
		_longDescription = value;
	}
	
	//----------------------------------
	//  docTags
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _docTags:Vector.<IDocTag>;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ICommentNode#docTags
	 */
	public function get docTags():Vector.<IDocTag>
	{
		return _docTags;
	}
	
	/**
	 * @private
	 */	
	public function set docTags(value:Vector.<IDocTag>):void
	{
		_docTags = value;
	}
	
	//----------------------------------
	//  hasDescription
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ICommentNode#hasDescription
	 */
	public function get hasDescription():Boolean
	{
		return _shortDescription || _longDescription || _docTags;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function CommentNode(node:IParserNode, parent:INode)
	{
		super(node, parent);
	}
	
	//--------------------------------------------------------------------------
	//
	//  ICommentNode API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ICommentNode#getDocTagAt()
	 */
	public function getDocTagAt(index:int):IDocTag
	{
		if (!docTags || index > docTags.length)
			return null;
		
		return docTags[index];
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ICommentNode#getDocTag()
	 */
	public function getDocTag(name:String):IDocTag
	{
		var len:int = docTags.length;
		for (var i:int = 0; i < len; i++)
		{
			if (docTags[i].name == name)
				return docTags[i];	
		}
		return null;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ICommentNode#hasDocTag()
	 */
	public function hasDocTag(name:String):Boolean
	{
		var len:int = docTags.length;
		for (var i:int = 0; i < len; i++)
		{
			if (docTags[i].name == name)
				return true;	
		}
		return false;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ICommentNode#getDocTags()
	 */
	public function getDocTags(name:String):Vector.<IDocTag>
	{
		var result:Vector.<IDocTag> = new Vector.<IDocTag>();
		var len:int = docTags.length;
		for (var i:int = 0; i < len; i++)
		{
			if (docTags[i].name == name)
				result.push(docTags[i]);	
		}
		return result;
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
		if (node)
			return node.stringValue;
		return "[undefined]";
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
		if (!node)
			return;
		
		var parser:ASDocParser = new ASDocParser();
		var lines:Array = toString().split("\n");
		
		asdocNode = parser.buildAst(ASTUtil.toVector(lines), "asdoc");
		
		// compilation-unit/content
		var contentNode:IParserNode = asdocNode.getLastChild();
		shortDescription = parseShortDescription(contentNode); 
		longDescription = parseLongDescription(contentNode);
		docTags = parseDocTagList(contentNode);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Protected :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	protected function parseShortDescription(child:IParserNode):String
	{
		var result:String = "";
		var list:IParserNode = ASTUtil.getNode(ASDocNodeKind.SHORT_LIST, child);
		if (!list)
			return null;
		
		for each (var element:IParserNode in list.children)
		{
			result += AsDocUtil.returnString(element);
		}
		
		result = StringUtil.trim(result);
		
		return result;
	}
	
	/**
	 * @private
	 */
	protected function parseLongDescription(child:IParserNode):String
	{
		var result:String = "";
		var list:IParserNode = ASTUtil.getNode(ASDocNodeKind.LONG_LIST, child);
		if (!list)
			return null;
		
		for each (var element:IParserNode in list.children)
		{
			result += AsDocUtil.returnString(element);
		}
		
		result = StringUtil.trim(result);
		
		return result;
	}
	
	/**
	 * @private
	 */
	protected function parseDocTagList(child:IParserNode):Vector.<IDocTag>
	{
		var list:IParserNode = ASTUtil.getNode(ASDocNodeKind.DOCTAG_LIST, child);
		if (!list)
			return null;
		
		var result:Vector.<IDocTag> = new Vector.<IDocTag>();
		
		for each (var element:IParserNode in list.children)
		{
			result.push(new DocTagNode(element, this));
		}
		
		return result;
	}
}
}