package org.teotigraphix.as3parser.core
{
import org.teotigraphix.as3parser.api.IParser;
import org.teotigraphix.as3parser.api.IParserNode;

public class TokenNode extends Node
{
	public var token:LinkedListToken;
	
	override public function set stringValue(value:String):void
	{
		super.stringValue = value;
		
		if (token)
		{
			token.text = value;
		}
	}

	
	public function TokenNode(kind:String,
							  stringValue:String,
							  line:int,
							  column:int)
	{
		super(kind, line, column, stringValue);
	}
	
	
	/**
	 * called when one of this node's children updates it's start-token,
	 * so that this node can potentially take action; maybe by setting
	 * the same start-token IF the child was the very-first in this node's
	 * list of children.
	 */
	internal function notifyChildStartTokenChange(child:IParserNode, 
												  newStart:LinkedListToken):void
	{
		// TODO: maybe move to delegates
		if (isFirst(child) && isSameStartToken(child)) 
		{
			startToken = newStart;
		}
		
	}
	
	/**
	 * called when one of this node's children updates it's stop-token,
	 * so that this node can potentially take action; maybe by setting
	 * the same stop-token IF the child was the very-last in this node's
	 * list of children.
	 */
	internal function notifyChildStopTokenChange(child:IParserNode, 
												 newStop:LinkedListToken):void
	{
		// TODO: maybe move to delegates
		if (isLast(child) && (isSameStopToken(child) || isNoStopToken(child)))
		{
			stopToken = newStop;
		}
	}
	
	
	
	
	private function isSameStartToken(child:IParserNode):Boolean
	{
		return child.startToken == startToken;
	}
	
	private function isFirst(child:IParserNode):Boolean
	{
		return child == getFirstChild();
	}
	
	private function isNoStopToken(child:IParserNode):Boolean
	{
		return child.stopToken == null;
	}
	
	private function isSameStopToken(child:IParserNode):Boolean
	{
		return child.stopToken == stopToken;
	}
	
	private function isLast(child:IParserNode):Boolean
	{
		return child == getLastChild();
	}

}
}