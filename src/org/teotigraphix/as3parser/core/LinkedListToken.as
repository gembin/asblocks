package org.teotigraphix.as3parser.core
{

import flash.errors.IllegalOperationError;

public class LinkedListToken extends Token
{
	//----------------------------------
	//  channel
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _channel:String;
	
	/**
	 * doc
	 */
	public function get channel():String
	{
		if (_channel == null)
		{
			if (text == "\n" || text == "\n" || text == " ")
				return "hidden";
		}
		return _channel;
	}
	
	/**
	 * @private
	 */	
	public function set channel(value:String):void
	{
		_channel = value;
	}
	
	//----------------------------------
	//  kind
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _kind:String;
	
	/**
	 * The token's kind.
	 */
	public function get kind():String
	{
		return _kind;
	}
	
	/**
	 * @private
	 */
	public function set kind(value:String):void
	{
		_kind = value;
	}
	
	//----------------------------------
	//  previous
	//----------------------------------
	
	/**
	 * @private
	 */
	internal var _previous:LinkedListToken;
	
	/**
	 * doc
	 */
	public function get previous():LinkedListToken
	{
		return _previous;
	}
	
	/**
	 * @private
	 */	
	public function set previous(value:LinkedListToken):void
	{
		if (this == value)
			throw new Error("Loop detected");
		
		_previous = value;
		
		if (_previous)
			_previous._next = this;
	}
	
	//----------------------------------
	//  next
	//----------------------------------
	
	/**
	 * @private
	 */
	internal var _next:LinkedListToken;
	
	/**
	 * doc
	 */
	public function get next():LinkedListToken
	{
		return _next;
	}
	
	/**
	 * @private
	 */	
	public function set next(value:LinkedListToken):void
	{
		if (this == value)
			throw new Error("Loop detected");
		
		_next = value;
		
		if (_next)
			_next._previous = this;
	}
	
	public function LinkedListToken(kind:String, 
									text:String, 
									line:int = -1, 
									column:int = -1)
	{
		super(text, line, column);
		
		_kind = kind;
	}
	
	public function afterInsert(insert:LinkedListToken):void
	{
		if (insert.previous)
			throw new IllegalOperationError("afterInsert(" + insert + ") : previous was not null");
		
		if (insert.next)
			throw new IllegalOperationError("afterInsert(" + next + ") : previous was not null");
		
		insert._next = _next;
		insert._previous = this;
		
		if (_next)
			_next._previous = insert;
		
		_next = insert;
	}
	
	public function beforeInsert(insert:LinkedListToken):void
	{
		if (insert.previous)
			throw new IllegalOperationError("afterInsert(" + insert + ") : previous was not null");
		
		if (insert.next)
			throw new IllegalOperationError("afterInsert(" + next + ") : previous was not null");
		
		insert._previous = _previous;
		insert._next = this;
		
		if (_previous)
			_previous._next = insert;
		
		_previous = insert;
	}
	
	public function remove():void
	{
		if (_previous)
			_previous._next = _next;
		if (_next)
			_next._previous = _previous;
		
		_next = null;
		_previous = null;
	}
}
}