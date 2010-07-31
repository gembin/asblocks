package org.teotigraphix.as3nodes.api
{

public interface ICommentAware extends INode
{
	function get comment():ICommentNode;
	
	function set comment(value:ICommentNode):void;
}
}