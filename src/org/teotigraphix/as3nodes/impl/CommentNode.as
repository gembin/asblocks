package org.teotigraphix.as3nodes.impl
{

import org.teotigraphix.as3nodes.api.ICommentNode;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.impl.ASDocParser;
import org.teotigraphix.as3parser.utils.ASTUtil;

public class CommentNode extends NodeBase implements ICommentNode
{
	private var asdocNode:IParserNode;
	
	public function CommentNode(node:IParserNode, parent:INode)
	{
		super(node, parent);
		
		var parser:ASDocParser = new ASDocParser();
		var lines:Array = toString().split("\n");
		asdocNode = parser.buildAst(ASTUtil.toVector(lines), "asdoc");
	}
	
	public function toString():String
	{
		return node.stringValue;
	}
}
}