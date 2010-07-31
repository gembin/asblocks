package org.teotigraphix.as3nodes.api
{

public interface IVariableNode extends IMetaDataAware, INameAware, INode
{
	function get type():IIdentifierNode;
}
}