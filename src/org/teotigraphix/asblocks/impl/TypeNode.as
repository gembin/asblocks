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

import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.impl.ASTIterator;
import org.teotigraphix.asblocks.api.IMethodNode;
import org.teotigraphix.asblocks.api.ITypeNode;
import org.teotigraphix.asblocks.api.Visibility;
import org.teotigraphix.asblocks.utils.ASTUtil;
import org.teotigraphix.asblocks.utils.ModifierUtil;

/**
 * The <code>ITypeNode</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class TypeNode extends ScriptNode 
	implements ITypeNode
{
	//--------------------------------------------------------------------------
	//
	//  Protected :: Properties
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	protected function get contentNode():IParserNode
	{
		return node.getKind(AS3NodeKind.CONTENT);
	}
	
	//--------------------------------------------------------------------------
	//
	//  ITypeNode API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  name
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.ITypeNode#name
	 */
	public function get name():String
	{
		var i:ASTIterator = new ASTIterator(node);
		return i.find(AS3NodeKind.NAME).stringValue;
	}
	
	/**
	 * @private
	 */	
	public function set name(value:String):void
	{
		var i:ASTIterator = new ASTIterator(node);
		i.find(AS3NodeKind.NAME);
		i.replace(ASTUtil.newAST(AS3NodeKind.NAME, value));
	}
	
	//----------------------------------
	//  visibility
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.ITypeNode#visibility
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
	//  methods
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.ITypeNode#methods
	 */
	public function get methods():Vector.<IMethodNode>
	{
		var result:Vector.<IMethodNode> = new Vector.<IMethodNode>();
		var i:ASTIterator = new ASTIterator(contentNode);
		while (i.hasNext())
		{
			var member:IParserNode = i.next();
			if (member.isKind(AS3NodeKind.FUNCTION)
				|| member.isKind(AS3NodeKind.GET)
				|| member.isKind(AS3NodeKind.SET))
			{
				result.push(new MethodNode(member));
			}
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
	public function TypeNode(node:IParserNode)
	{
		super(node);
	}
	
	//--------------------------------------------------------------------------
	//
	//  ITypeNode API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.ITypeNode#newMethod()
	 */
	public function newMethod(name:String, 
							  visibility:Visibility, 
							  returnType:String):IMethodNode
	{
		return null;
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.ITypeNode#getMethod()
	 */
	public function getMethod(name:String):IMethodNode
	{
		var i:ASTIterator = new ASTIterator(contentNode);
		while (i.hasNext())
		{
			var member:IParserNode = i.next();
			if (member.isKind(AS3NodeKind.FUNCTION)
				|| member.isKind(AS3NodeKind.GET)
				|| member.isKind(AS3NodeKind.SET))
			{
				var meth:IMethodNode = new MethodNode(member);
				if (meth.name == name)
				{
					return meth;
				}
			}
		}
		return null;
	}
	
	/**
	 * @private
	 */
	public function addMethod(method:IMethodNode):void
	{
		ASTUtil.addChildWithIndentation(contentNode, method.node);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.ITypeNode#removeMethod()
	 */
	public function removeMethod(name:String):Boolean
	{
		var i:ASTIterator = new ASTIterator(contentNode);
		while (i.hasNext())
		{
			var member:IParserNode = i.next();
			if (member.isKind(AS3NodeKind.FUNCTION)
				|| member.isKind(AS3NodeKind.GET)
				|| member.isKind(AS3NodeKind.SET))
			{
				var meth:IMethodNode = new MethodNode(member);
				if (meth.name == name)
				{
					i.remove();
					return true;
				}
			}
		}
		return false;
	}
}
}