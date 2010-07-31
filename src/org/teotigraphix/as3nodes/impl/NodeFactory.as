package org.teotigraphix.as3nodes.impl
{

import org.teotigraphix.as3nodes.api.IMetaDataNode;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3nodes.api.IPackageNode;
import org.teotigraphix.as3parser.api.IParserNode;

public class NodeFactory
{
	public static function createPackage(node:IParserNode, parent:INode):IPackageNode
	{
		return new PackageNode(node, parent);
	}
	
	public static function createMetaData(node:IParserNode, parent:INode):IMetaDataNode
	{
		return new MetaDataNode(node, parent);
	}
}
}