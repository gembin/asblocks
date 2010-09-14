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

import org.teotigraphix.as3parser.api.ASDocNodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.asblocks.api.IDocComment;
import org.teotigraphix.asblocks.api.IDocTag;
import org.teotigraphix.asblocks.utils.ASTUtil;
import org.teotigraphix.asblocks.utils.DocCommentUtil;

/**
 * The <code>IDocComment</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class DocCommentNode extends ScriptNode 
	implements IDocComment
{
	private var asdoc:IParserNode;
	
	//--------------------------------------------------------------------------
	//
	//  IDocComment API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  description
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IDocComment#description
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
		DocCommentUtil.setDescription(node, value);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function DocCommentNode(node:IParserNode)
	{
		super(node); // node is IDocCommentAware.node
		
		asdoc = DocCommentUtil.buildASDoc(node);
	}
	
	//--------------------------------------------------------------------------
	//
	//  IDocComment API :: Methods
	//
	//--------------------------------------------------------------------------
	
	private function findContent():IParserNode
	{
		if (!asdoc)
			return null;
		
		return asdoc.getKind(ASDocNodeKind.CONTENT);
	}
	
	private function findShortList():IParserNode
	{
		var content:IParserNode = findContent();
		
		if (!content)
			return null;
		
		return content.getKind(ASDocNodeKind.SHORT_LIST);
	}
	
	private function findDoctagList():IParserNode
	{
		var content:IParserNode = findContent();
		
		if (!content)
			return null;
		
		return content.getKind(ASDocNodeKind.DOCTAG_LIST);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IDocComment#newDocTag()
	 */
	public function newDocTag(name:String, body:String = null):IDocTag
	{
		if (!asdoc)
		{
			// create a as-doc node
			asdoc = DocCommentUtil.buildOrAddAsDocAST(node);
		}
		//compilation-unit/content/short-list
		//compilation-unit/content/short-list/text
		//compilation-unit/content/doctag-list
		//compilation-unit/content/doctag-list/doctag
		//compilation-unit/content/doctag-list/doctag/name
		//compilation-unit/content/doctag-list/doctag/body
		
		var list:IParserNode = findDoctagList();
		if (!list)
		{
			list = ASTUtil.newAST(ASDocNodeKind.DOCTAG_LIST);
			asdoc.addChild(list);
		}
		
		var tag:IParserNode = ASTUtil.newAST(ASDocNodeKind.DOCTAG);
		tag.addChild(ASTUtil.newNameAST(name));
		if (body)
		{
			tag.addChild(ASTUtil.newAST(ASDocNodeKind.BODY, body));
		}
		list.addChild(tag);
		
		commitAST();
		
		return new DocTagNode(tag);
	}
	
	private function commitAST():void
	{
		// the asdoc ast needs to go back into the node's as-doc node.stringValue
		
	}
}
}