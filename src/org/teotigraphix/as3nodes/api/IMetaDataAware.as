package org.teotigraphix.as3nodes.api
{

public interface IMetaDataAware
{
	function get numMetaData():int;
	
	function addMetaData(node:IMetaDataNode):void;
	
	function getMetaData(name:String):Vector.<IMetaDataNode>;
}
}