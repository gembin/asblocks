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

package org.as3commons.asblocks.impl
{

import org.as3commons.asblocks.parser.api.AS3NodeKind;
import org.as3commons.asblocks.parser.api.ASDocNodeKind;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.core.TokenNode;
import org.as3commons.asblocks.parser.impl.ASTIterator;
import org.as3commons.asblocks.api.IDocComment;
import org.as3commons.asblocks.api.IDocTag;
import org.as3commons.asblocks.utils.ASTUtil;
import org.as3commons.asblocks.utils.DocCommentUtil;

/*

What needs to happen.

- asdoc AST is created by parsing the as-doc node of the parent
- the description is the /compilation-unit/content/body
- 
*/

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
	 * @copy org.as3commons.asblocks.api.IDocComment#description
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
		
		return asdoc.getKind(ASDocNodeKind.DESCRIPTION);
	}
	
	private function findDoctagList():IParserNode
	{
		var content:IParserNode = findContent();
		
		if (!content)
			return null;
		
		return content.getKind(ASDocNodeKind.DOCTAG_LIST);
	}
	
	/**
	 * @copy org.as3commons.asblocks.api.IDocComment#newDocTag()
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
		
		var list:TokenNode = findDoctagList() as TokenNode;
		if (!list)
		{
			list = ASTUtil.newAST(ASDocNodeKind.DOCTAG_LIST) as TokenNode;
			var content:IParserNode = asdoc.getKind(ASDocNodeKind.DESCRIPTION);

			content.addChild(list);
		}
		
		var tag:IParserNode = ASTUtil.newAST(ASDocNodeKind.DOCTAG);
		//tag.appendToken(TokenBuilder.newToken("\t", "\t"));
		tag.appendToken(TokenBuilder.newToken("*", "*"));
		tag.appendToken(TokenBuilder.newToken(" ", " "));
		tag.appendToken(TokenBuilder.newToken("@", "@"));
		tag.addChild(ASTUtil.newNameAST(name));
		if (body)
		{
			tag.appendToken(TokenBuilder.newSpace());
			var newline:String = DocCommentUtil.getNewlineText(node, tag);
			//if (description.indexOf("\n") != 0)
			//{
			//	description = "\n" + description;
			//}
			
			body = body.replace(/\n/g, newline);
			tag.addChild(ASTUtil.newAST(ASDocNodeKind.BODY, body));
		}
		
		tag.appendToken(TokenBuilder.newToken("\n", "\n"));
		var indent:String = ASTUtil.findIndent(node);
		//tag.appendToken(TokenBuilder.newToken("\t", "\t"));
		tag.appendToken(TokenBuilder.newToken("ws", indent));
		tag.appendToken(TokenBuilder.newToken(" ", " "));
		list.addChild(tag);
		
		commitAST();
		
		return new DocTagNode(tag);
	}
	
	public function removeDocTag(tag:IDocTag):Boolean
	{
		var list:TokenNode = findDoctagList() as TokenNode;
		if (!list)
			return false;
		
		var i:ASTIterator = new ASTIterator(list);
		while (i.hasNext())
		{
			var t:IParserNode = i.next();
			if (t === tag.node)
			{
				list.removeChild(t);
				commitAST();
				return true;
			}
		}
		return false;
	}
	
	private function commitAST():void
	{
		// the asdoc ast needs to go back into the node's as-doc node.stringValue
		var content:IParserNode = asdoc.getKind(ASDocNodeKind.DESCRIPTION);
		var body:IParserNode = content.getKind(ASDocNodeKind.BODY);
		
		var t:String = ASTUtil.stringifyNode(asdoc);
		
		var anode:IParserNode = node.getKind(AS3NodeKind.AS_DOC);
		//var nast:IParserNode = ASTUtil.newAST("as-doc", t);
		//node.setChildAt(nast, node.getChildIndex(anode));
		anode.stringValue = t;
	}
	

}
}