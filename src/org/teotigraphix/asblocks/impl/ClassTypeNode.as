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
import org.teotigraphix.as3parser.core.LinkedListToken;
import org.teotigraphix.as3parser.impl.AS3FragmentParser;
import org.teotigraphix.as3parser.impl.ASTIterator;
import org.teotigraphix.asblocks.api.IClassTypeNode;
import org.teotigraphix.asblocks.api.IMethodNode;
import org.teotigraphix.asblocks.api.Modifier;
import org.teotigraphix.asblocks.api.Visibility;
import org.teotigraphix.asblocks.utils.ASTUtil;
import org.teotigraphix.asblocks.utils.ModifierUtil;

/**
 * The <code>IClassTypeNode</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class ClassTypeNode extends TypeNode 
	implements IClassTypeNode
{
	//--------------------------------------------------------------------------
	//
	//  Private :: Properties
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//
	//  IClassTypeNode API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  isDynamic
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IClassTypeNode#isDynamic
	 */
	public function get isDynamic():Boolean
	{
		return ModifierUtil.hasModifierFlag(node, Modifier.DYNAMIC);
	}
	
	/**
	 * @private
	 */	
	public function set isDynamic(value:Boolean):void
	{
		ModifierUtil.setModifierFlag(node, value, Modifier.DYNAMIC);
	}
	
	//----------------------------------
	//  isFinal
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IClassTypeNode#isFinal
	 */
	public function get isFinal():Boolean
	{
		return ModifierUtil.hasModifierFlag(node, Modifier.FINAL);
	}
	
	/**
	 * @private
	 */	
	public function set isFinal(value:Boolean):void
	{
		ModifierUtil.setModifierFlag(node, value, Modifier.FINAL);
	}
	
	//----------------------------------
	//  superClass
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IClassTypeNode#superClass
	 */
	public function get superClass():String
	{
		var list:IParserNode = node.getKind(AS3NodeKind.EXTENDS);
		if (!list)
			return null;
		
		// extends/type
		return ASTUtil.typeText(list.getFirstChild());
	}
	
	/**
	 * @private
	 */	
	public function set superClass(value:String):void
	{
		if (value == null || value == "")
		{
			removeExtends();
			return;
		}
		
		var extendz:IParserNode = node.getKind(AS3NodeKind.EXTENDS);
		var type:IParserNode = AS3FragmentParser.parseType(value);
		if (!extendz)
		{
			extendz = ASTUtil.newAST(AS3NodeKind.EXTENDS, "extends");
			extendz.appendToken(TokenBuilder.newSpace());
			// space is between className and 'extends' keyword
			var space:LinkedListToken = TokenBuilder.newSpace();
			extendz.startToken.beforeInsert(space);
			extendz.startToken = space;
			var i:ASTIterator = new ASTIterator(node);
			i.find(AS3NodeKind.NAME);
			i.insertAfterCurrent(extendz);
			extendz.addChild(type);
			//extendz.appendToken(TokenBuilder.newSpace());
		}
		else
		{
			extendz.setChildAt(type, 0);
		}
	}
	
	//----------------------------------
	//  implementedInterfaces
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IClassTypeNode#implementedInterfaces
	 */
	public function get implementedInterfaces():Vector.<String>
	{
		var result:Vector.<String> = new Vector.<String>();
		var implz:IParserNode = node.getKind(AS3NodeKind.IMPLEMENTS);
		if (implz)
		{
			var i:ASTIterator = new ASTIterator(implz);
			while (i.hasNext())
			{
				result.push(ASTUtil.typeText(i.next()));
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
	public function ClassTypeNode(node:IParserNode)
	{
		super(node);
	}
	
	//--------------------------------------------------------------------------
	//
	//  IClassTypeNode API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IClassTypeNode#addImplementedInterface()
	 */
	public function addImplementedInterface(name:String):Boolean
	{
		if (containsImplementor(name))
			return false;
		
		var implz:IParserNode = node.getKind(AS3NodeKind.IMPLEMENTS);
		var type:IParserNode = AS3FragmentParser.parseType(name);
		if (!implz)
		{
			implz = ASTUtil.newAST(AS3NodeKind.IMPLEMENTS, "implements");
			var i:ASTIterator = new ASTIterator(node);
			i.find(AS3NodeKind.CONTENT);
			i.insertBeforeCurrent(implz);
			// adds a space before the 'implements' keyword
			var space:LinkedListToken = TokenBuilder.newSpace();
			implz.startToken.beforeInsert(space);
		}
		else
		{
			implz.appendToken(TokenBuilder.newComma());
		}
		implz.appendToken(TokenBuilder.newSpace());
		implz.addChild(type);
		return true;
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IClassTypeNode#removeImplementedInterface()
	 */
	public function removeImplementedInterface(name:String):Boolean
	{
		var implz:IParserNode = node.getKind(AS3NodeKind.IMPLEMENTS);
		if (!implz)
			return false;
		
		var count:int = 0;
		var i:ASTIterator = new ASTIterator(implz);
		while (i.hasNext())
		{
			var ichild:IParserNode = i.next();
			var n:String = ASTUtil.typeText(ichild);
			if (n == name)
			{
				if (i.hasNext())
				{
					ASTUtil.removeTrailingWhitespaceAndComma(ichild.stopToken, true);
				}
				else if (count == 0)
				{
					var previous:LinkedListToken = implz.startToken.previous;
					node.removeChild(implz);
					// Hack, I can't figure out how to remove both spaces
					ASTUtil.collapseWhitespace(previous)
					return true;
				}
				i.remove();
				if (i.hasNext())
				{
					count++;
				}
				return true;
			}
			count++;
		}
		return false;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden Public :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	override public function newMethod(name:String, 
									   visibility:Visibility, 
									   returnType:String):IMethodNode
	{
		var method:IMethodNode = ASTBuilder.newMethod(name, visibility, returnType);
		addMethod(method);
		return method;
	}
	
	/**
	 * @private
	 */
	public function addMethod(method:IMethodNode):void
	{
		ASTUtil.addChildWithIndentation(contentNode, method.node);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Private :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */	
	private function removeExtends():void
	{
		var i:ASTIterator = new ASTIterator(node);
		while (i.hasNext())
		{
			var child:IParserNode = i.next();
			if (child.isKind(AS3NodeKind.EXTENDS))
			{
				i.remove();
				break;
			}
		}
	}
	
	/**
	 * @private
	 */
	private function containsImplementor(name:String):Boolean
	{
		var impls:IParserNode = node.getKind(AS3NodeKind.IMPLEMENTS);
		if (!impls)
			return false;
		
		var i:ASTIterator = new ASTIterator(impls);
		while (i.hasNext())
		{
			if (ASTUtil.typeText(i.next()) == name)
				return true;
		}
		return false;
	}
}
}