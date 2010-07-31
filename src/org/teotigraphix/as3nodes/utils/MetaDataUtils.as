package org.teotigraphix.as3nodes.utils
{

import org.teotigraphix.as3nodes.api.IMetaDataAware;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3nodes.impl.NodeFactory;
import org.teotigraphix.as3parser.api.IParserNode;

public class MetaDataUtils
{
	public static function computeMetaDataList(node:IMetaDataAware, 
											   child:IParserNode):void
	{
		if (child.numChildren == 0)
			return;
		
		var len:int = child.children.length;
		for (var i:int = 0; i < len; i++)
		{
			var element:IParserNode = child.children[i] as IParserNode;
			node.addMetaData(NodeFactory.createMetaData(element, INode(node)));
		}
	}
}
}