package org.teotigraphix.as3nodes.utils
{
import org.teotigraphix.as3nodes.api.ICommentAware;
import org.teotigraphix.as3nodes.impl.CommentNode;
import org.teotigraphix.as3parser.api.IParserNode;

public class AsDocUtil
{
	public static function computeAsDoc(node:ICommentAware, 
										child:IParserNode):void
	{
		if (!child)
			return;
		
		node.comment = new CommentNode(child, node);
	}
}
}