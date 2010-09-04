package org.teotigraphix.asblocks.utils
{

import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.impl.ASTIterator;
import org.teotigraphix.asblocks.api.Modifier;
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
}
}