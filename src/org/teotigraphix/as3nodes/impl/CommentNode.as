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
import org.teotigraphix.as3nodes.api.IDocTagNode;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3nodes.api.IParameterNode;
import org.teotigraphix.as3nodes.utils.ASTNodeUtil;
import org.teotigraphix.as3nodes.utils.AsDocUtil;
import org.teotigraphix.as3parser.api.ASDocNodeKind;
import org.teotigraphix.as3parser.api.IParser;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.utils.ASTUtil;

/**
 * The concrete implementation of <code>ICommentNode</code> API.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class CommentNode extends NodeBase implements ICommentNode
{
	//--------------------------------------------------------------------------
	//
	//  Protected :: Variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	protected var compilationUnit:IParserNode;
	
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
	//  description
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _description:String;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ICommentNode#description
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
	}
	
	//----------------------------------
	//  docTags
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _docTags:Vector.<IDocTagNode> = new Vector.<IDocTagNode>();
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ICommentNode#docTags
	 */
	public function get docTags():Vector.<IDocTagNode>
	{
		return _docTags;
	}
	
	/**
	 * @private
	 */	
	public function set docTags(value:Vector.<IDocTagNode>):void
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
		return _shortDescription || _longDescription 
			|| _docTags && _docTags.length > 0;
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
	 * @copy org.teotigraphix.as3nodes.api.ICommentNode#addDocTag()
	 */
	public function addDocTag(node:IDocTagNode):Boolean
	{
		docTags.push(node);
		
		dispatchAddChange(ASDocNodeKind.DOCTAG, node);
		
		return true;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ICommentNode#addDocTag()
	 */
	public function removeDocTag(node:IDocTagNode):Boolean
	{
		var len:int = docTags.length;
		for (var i:int = 0; i < len; i++)
		{
			if (docTags[i] === node)
			{
				docTags.splice(i, 1);
				dispatchRemoveChange(ASDocNodeKind.DOCTAG, node);
				return true;
			}
		}
		return false;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ICommentNode#getDocTagAt()
	 */
	public function getDocTagAt(index:int):IDocTagNode
	{
		if (!docTags || index > docTags.length)
			return null;
		
		return docTags[index];
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ICommentNode#getDocTag()
	 */
	public function getDocTag(name:String):IDocTagNode
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
	public function getDocTags(name:String):Vector.<IDocTagNode>
	{
		var result:Vector.<IDocTagNode> = new Vector.<IDocTagNode>();
		var len:int = docTags.length;
		for (var i:int = 0; i < len; i++)
		{
			if (docTags[i].name == name)
				result.push(docTags[i]);	
		}
		return result;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ICommentNode#newDocTag()
	 */
	public function newDocTag(name:String, body:String = null):IDocTagNode
	{
		return as3Factory.newDocTag(this, name, body);
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
		var unit:IParserNode = node.getChild(0);
		if (unit)
		{
			compilationUnit = unit;
		}
		else if (node.stringValue && node.stringValue != "")
		{
			compilationUnit = ASTNodeUtil.createAsDocCompilationUnit(node.stringValue);
			// FIXME !!!
			node.addChild(compilationUnit);
		}
		
		if (compilationUnit)
		{
			// compilation-unit/content
			var content:IParserNode = compilationUnit.getLastChild();
			
			for each (var child:IParserNode in content.children)
			{
				if (child.isKind(ASDocNodeKind.SHORT_LIST))
				{
					computeShortDescription(child);
				}
				else if (child.isKind(ASDocNodeKind.LONG_LIST))
				{
					computeLongDescription(child);
				}
				else if (child.isKind(ASDocNodeKind.DOCTAG_LIST))
				{
					computeDocTagList(child);
				}
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
	protected function computeShortDescription(child:IParserNode):void
	{
		var result:String = "";
		
		for each (var element:IParserNode in child.children)
		{
			result += AsDocUtil.returnString(element);
		}
		
		result = StringUtil.trim(result);
		
		shortDescription = result;
	}
	
	/**
	 * @private
	 */
	protected function computeLongDescription(child:IParserNode):void
	{
		var result:String = "";
		
		for each (var element:IParserNode in child.children)
		{
			result += AsDocUtil.returnString(element);
		}
		
		result = StringUtil.trim(result);
		
		longDescription = result;
	}
	
	/**
	 * @private
	 */
	protected function computeDocTagList(child:IParserNode):void
	{
		var result:Vector.<IDocTagNode> = new Vector.<IDocTagNode>();
		
		for each (var element:IParserNode in child.children)
		{
			result.push(new DocTagNode(element, this));
		}
		
		docTags = result;
	}
}
}