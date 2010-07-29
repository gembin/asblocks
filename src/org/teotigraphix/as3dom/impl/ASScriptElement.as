package org.teotigraphix.as3dom.impl
{

import org.teotigraphix.as3dom.api.IScriptElement;
import org.teotigraphix.as3parser.api.IParserNode;

public class ASScriptElement implements IScriptElement
{
	private var _node:IParserNode;
	
	protected function get node():IParserNode
	{
		return _node;
	}
	
	public function ASScriptElement(node:IParserNode)
	{
		_node = node;
	}
	
	public function toString():String
	{
		return _node.stringValue;
	}
}
}