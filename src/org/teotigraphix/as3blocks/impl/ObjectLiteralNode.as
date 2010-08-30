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

package org.teotigraphix.as3blocks.impl
{

import org.teotigraphix.as3blocks.api.IExpressionNode;
import org.teotigraphix.as3blocks.api.IObjectLiteralNode;
import org.teotigraphix.as3blocks.api.IPropertyFieldNode;
import org.teotigraphix.as3blocks.utils.ASTUtil2;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.impl.ASTIterator;

/**
 * The <code>IObjectLiteralNode</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class ObjectLiteralNode extends LiteralNode 
	implements IObjectLiteralNode
{
	//--------------------------------------------------------------------------
	//
	//  IArrayLiteralNode API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  entries
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3blocks.api.IObjectLiteralNode#fields
	 */
	public function get fields():Vector.<IPropertyFieldNode>
	{
		var result:Vector.<IPropertyFieldNode> = new Vector.<IPropertyFieldNode>();
		var i:ASTIterator = new ASTIterator(node);
		while (i.hasNext()) 
		{
			result.push(new PropertyFieldNode(i.next()));
		}
		return result;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function ObjectLiteralNode(node:IParserNode)
	{
		super(node);
	}
	
	//--------------------------------------------------------------------------
	//
	//  IArrayLiteralNode API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.teotigraphix.as3blocks.api.IObjectLiteralNode#add()
	 */
	public function newField(name:String, expression:IExpressionNode):IPropertyFieldNode
	{
		var ast:IParserNode = ASTBuilder.newObjectField(name, expression.node);
		var indent:String = ASTUtil2.findIndent(node) + "\t";
		ASTUtil2.increaseIndent(ast, indent);
		if (node.numChildren > 0)
		{
			node.appendToken(TokenBuilder.newComma());
		}
		node.appendToken(TokenBuilder.newNewline());
		node.addChild(ast);
		return new PropertyFieldNode(ast);
	}
}
}