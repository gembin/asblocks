package org.teotigraphix.as3nodes.api
{

public interface ICommentNode
{
	function get shortDescription():String;
	
	function get longDescription():String;
	
	//function get description():String;
	
	//function hasDescription():Boolean;
	
	//----------------------------------
	//  docTags
	//----------------------------------

	function get docTags():Vector.<IDocTag>;
	
	function getDocTagAt(index:int):IDocTag;
	
	function getDocTag(name:String):IDocTag;
	
	function hasDocTag(name:String):Boolean;
	
	function getDocTags(name:String):Vector.<IDocTag>;
}
}