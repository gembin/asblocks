package org.teotigraphix.as3nodes.api
{

import org.teotigraphix.as3parser.api.IParserNode;

public interface IPackageNode extends INode, INameAware
{
	function get typeNode():ITypeNode;
	
	function get qualifiedName():String;
	
	function get imports():Vector.<IParserNode>;
}
}