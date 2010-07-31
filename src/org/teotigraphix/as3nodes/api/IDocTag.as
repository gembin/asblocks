package org.teotigraphix.as3nodes.api
{

public interface IDocTag extends INode
{
	function get name():String;
	
	function set name(value:String):void;
	
	function get body():String;
	
	function set body(value:String):void;
	
	function get preformated():String;
	
	function set preformated(value:String):void;
}
}