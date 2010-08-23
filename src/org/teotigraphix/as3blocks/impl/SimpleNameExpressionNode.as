package org.teotigraphix.as3blocks.impl
{

import org.teotigraphix.as3blocks.api.ISimpleNameExpressionNode;
import org.teotigraphix.as3parser.api.IParserNode;

public class SimpleNameExpressionNode extends ExpressionNode 
	implements ISimpleNameExpressionNode
{
	public function get name():String
	{
		return node.stringValue;
	}
	
	public function SimpleNameExpressionNode(node:IParserNode)
	{
		super(node);
	}
}
}