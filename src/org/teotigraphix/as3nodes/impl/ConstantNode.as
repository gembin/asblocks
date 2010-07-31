package org.teotigraphix.as3nodes.impl
{

import org.teotigraphix.as3nodes.api.IConstantNode;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3parser.api.IParserNode;

public class ConstantNode extends FieldNode implements IConstantNode
{
	public function ConstantNode(node:IParserNode, parent:INode)
	{
		super(node, parent);
	}
	
}
}