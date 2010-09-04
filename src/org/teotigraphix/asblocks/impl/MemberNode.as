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
import org.teotigraphix.asblocks.api.IMemberNode;
import org.teotigraphix.asblocks.api.Modifier;
import org.teotigraphix.asblocks.api.Visibility;
import org.teotigraphix.asblocks.utils.ASTUtil;
import org.teotigraphix.asblocks.utils.ModifierUtil;

/**
 * The <code>IMemberNode</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class MemberNode extends ScriptNode 
	implements IMemberNode
{
	//--------------------------------------------------------------------------
	//
	//  Private :: Properties
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//
	//  IMemberNode API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  visibility
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IMemberNode#visibility
	 */
	public function get visibility():Visibility
	{
		// get all MODIFIER nodes from the CLASS|INTERFACE node which is root
		var modifiers:Vector.<IParserNode> = findModifiers();
		if (modifiers.length == 0)
		{
			return Visibility.DEFAULT;
		}
		
		var len:int = modifiers.length;
		for (var i:int = 0; i < len; i++)
		{
			var modifier:String = modifiers[i].stringValue;
			if (Visibility.hasVisibility(modifier))
			{
				return Visibility.getVisibility(modifier);
			}
		}
		
		return null;
	}
	
	/**
	 * @private
	 */	
	public function set visibility(value:Visibility):void
	{
		// TODO IMPL
	}
	
	//----------------------------------
	//  name
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IMemberNode#name
	 */
	public function get name():String
	{
		var i:ASTIterator = new ASTIterator(node);
		return ASTUtil.nameText(i.find(AS3NodeKind.NAME));
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
	//  type
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IMemberNode#type
	 */
	public function get type():String
	{
		var i:ASTIterator = new ASTIterator(node);
		return i.find(AS3NodeKind.TYPE).stringValue;
	}
	
	/**
	 * @private
	 */	
	public function set type(value:String):void
	{
		var i:ASTIterator = new ASTIterator(node);
		i.find(AS3NodeKind.TYPE);
		i.replace(ASTUtil.newAST(AS3NodeKind.TYPE, value));
	}
	
	//----------------------------------
	//  isStatic
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IMemberNode#isStatic
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
	//  IMemberNode API :: Methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//
	//  Private :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private function findModifiers():Vector.<IParserNode>
	{
		var result:Vector.<IParserNode> = new Vector.<IParserNode>();
		var i:ASTIterator = new ASTIterator(node);
		var child:IParserNode;
		while (i.hasNext())
		{
			child = i.next();
			if (child.isKind(AS3NodeKind.MODIFIER))
			{
				result.push(child);
			}
		}
		return result;
	}
}
}