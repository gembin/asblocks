package org.teotigraphix.as3nodes.api
{

import org.teotigraphix.as3parser.api.IParserNode;

public interface INode extends INestedNode
{
	function get node():IParserNode;
}
}