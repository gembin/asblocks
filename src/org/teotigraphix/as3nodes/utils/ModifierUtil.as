package org.teotigraphix.as3nodes.utils
{

import org.teotigraphix.as3nodes.api.IModifierAware;
import org.teotigraphix.as3nodes.api.Modifier;
import org.teotigraphix.as3parser.api.IParserNode;

public class ModifierUtil
{
	public static function computeModifierList(node:IModifierAware, 
											   child:IParserNode):void
	{
		if (child.numChildren == 0)
			return;
		
		var len:int = child.children.length;
		for (var i:int = 0; i < len; i++)
		{
			var element:IParserNode = child.children[i] as IParserNode;
			var modifier:Modifier = Modifier.create(element.stringValue);
			node.addModifier(modifier);
		}
	}
}
}