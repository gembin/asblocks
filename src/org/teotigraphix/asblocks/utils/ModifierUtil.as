package org.teotigraphix.asblocks.utils
{

import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.impl.ASTIterator;
import org.teotigraphix.asblocks.api.Modifier;
import org.teotigraphix.asblocks.api.Visibility;
import org.teotigraphix.asblocks.impl.TokenBuilder;

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
		var modifiers:Vector.<IParserNode> = findModifiers(node);
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
	
	public static function setVisibility(node:IParserNode, visibility:Visibility):void
	{
		var modifiers:Vector.<IParserNode> = findModifiers(node);
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
	private static function findModifiers(node:IParserNode):Vector.<IParserNode>
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