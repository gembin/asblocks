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

package org.teotigraphix.asblocks.utils
{

import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.impl.ASTIterator;
import org.teotigraphix.asblocks.api.Modifier;
import org.teotigraphix.asblocks.api.Visibility;
import org.teotigraphix.asblocks.impl.TokenBuilder;

/**
 * TODO DOCME
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class ModifierUtil
{
	public static function hasModifierFlag(node:IParserNode, modifier:Modifier):Boolean
	{
		var i:ASTIterator = new ASTIterator(node);
		while (i.hasNext())
		{
			var child:IParserNode = i.next();
			if (child.isKind(AS3NodeKind.MODIFIER))
			{
				if (child.stringValue == modifier.name)
				{
					return true;
				}
			}
		}
		return false;
	}
	
	public static function setModifierFlag(node:IParserNode, flag:Boolean, modifier:Modifier):void
	{
		var i:ASTIterator = new ASTIterator(node);
		while (i.hasNext())
		{
			var child:IParserNode = i.next();
			if (child.isKind(AS3NodeKind.MODIFIER))
			{
				if (child.stringValue == modifier.name)
				{
					if (flag)
					{
						return; // already has modifier
					}
					else
					{
						i.remove(); // remove the modifier
					}
					return;
				}
			}
		}
		if (flag)
		{
			var mod:IParserNode = ASTUtil.newAST(AS3NodeKind.MODIFIER, modifier.name);
			mod.appendToken(TokenBuilder.newSpace());
			i.reset();
			// insert the mod right before the NAME
			i.find(AS3NodeKind.NAME);
			i.insertBeforeCurrent(mod);
		}
	}
	
	public static function getVisibility(node:IParserNode):Visibility
	{
		var modifiers:IParserNode = findModifiers(node);
		if (modifiers.numChildren == 0)
		{
			return Visibility.DEFAULT;
		}
		
		var i:ASTIterator = new ASTIterator(modifiers);
		var child:IParserNode;
		while (i.hasNext())
		{
			child = i.next();
			if (Visibility.hasVisibility(child.stringValue))
			{
				return Visibility.getVisibility(child.stringValue);
			}
		}
		return null;
	}
	
	public static function setVisibility(node:IParserNode, visibility:Visibility):void
	{
		var modifiers:IParserNode = findModifiers(node);
		// modifiers always go right before the NAME
		
	}
	
	//--------------------------------------------------------------------------
	//
	//  Private :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private static function findModifiers(node:IParserNode):IParserNode
	{
		return node.getKind(AS3NodeKind.MOD_LIST);
	}
}
}