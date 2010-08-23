package org.teotigraphix.as3parser.core
{
import org.teotigraphix.as3parser.api.IParserNode;

public class PlaceholderLinkedListToken extends LinkedListToken
{
	//----------------------------------
	//  held
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _held:IParserNode;
	
	/**
	 * doc
	 */
	public function get held():IParserNode
	{
		return _held;
	}
	
	public function PlaceholderLinkedListToken(node:IParserNode)
	{
		super("virtual-placeholder", "");
		
		//channel = channel-placeholder
		
		_held = node;
		_held.startToken = this;
		_held.stopToken = this;
	}
}
}