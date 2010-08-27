/**
 *    Copyright (c) 2009, Adobe Systems, Incorporated
 *    All rights reserved.
 *
 *    Redistribution  and  use  in  source  and  binary  forms, with or without
 *    modification,  are  permitted  provided  that  the  following  conditions
 *    are met:
 *
 *      * Redistributions  of  source  code  must  retain  the  above copyright
 *        notice, this list of conditions and the following disclaimer.
 *      * Redistributions  in  binary  form  must reproduce the above copyright
 *        notice,  this  list  of  conditions  and  the following disclaimer in
 *        the    documentation   and/or   other  materials  provided  with  the
 *        distribution.
 *      * Neither the name of the Adobe Systems, Incorporated. nor the names of
 *        its  contributors  may be used to endorse or promote products derived
 *        from this software without specific prior written permission.
 *
 *    THIS  SOFTWARE  IS  PROVIDED  BY THE  COPYRIGHT  HOLDERS AND CONTRIBUTORS
 *    "AS IS"  AND  ANY  EXPRESS  OR  IMPLIED  WARRANTIES,  INCLUDING,  BUT NOT
 *    LIMITED  TO,  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 *    PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER
 *    OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,  INCIDENTAL,  SPECIAL,
 *    EXEMPLARY,  OR  CONSEQUENTIAL  DAMAGES  (INCLUDING,  BUT  NOT  LIMITED TO,
 *    PROCUREMENT  OF  SUBSTITUTE   GOODS  OR   SERVICES;  LOSS  OF  USE,  DATA,
 *    OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 *    LIABILITY,  WHETHER  IN  CONTRACT,  STRICT  LIABILITY, OR TORT (INCLUDING
 *    NEGLIGENCE  OR  OTHERWISE)  ARISING  IN  ANY  WAY  OUT OF THE USE OF THIS
 *    SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
package org.teotigraphix.as3parser.core
{

import org.teotigraphix.as3parser.api.IParserNode;

/**
 * A parser node that does not contain parser node children.
 * 
 * <p>Initial API; Adobe Systems, Incorporated</p>
 * 
 * @author Adobe Systems, Incorporated
 * @author Michael Schmalle
 * @productversion 1.0
 */
public class Node extends NestedNode implements IParserNode
{
	//--------------------------------------------------------------------------
	//
	//  Public :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  start
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _start:int;
	
	/**
	 * @copy org.teotigraphix.as3parser.api.IParserNode#start
	 */
	public function get start():int
	{
		return _start;
	}
	
	/**
	 * @private
	 */
	public function set start(value:int):void
	{
		_start = value;
	}
	
	//----------------------------------
	//  end
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _end:int;
	
	/**
	 * @copy org.teotigraphix.as3parser.api.IParserNode#end
	 */
	public function get end():int
	{
		return _end;
	}
	
	/**
	 * @private
	 */
	public function set end(value:int):void
	{
		_end = value;
	}
	
	//----------------------------------
	//  column
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _column:int;
	
	/**
	 * @copy org.teotigraphix.as3parser.api.IParserNode#column
	 */
	public function get column():int
	{
		return _column;
	}
	
	/**
	 * @private
	 */
	public function set column(value:int):void
	{
		_column = value;
	}
	
	//----------------------------------
	//  line
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _line:int;
	
	/**
	 * @copy org.teotigraphix.as3parser.api.IParserNode#line
	 */
	public function get line():int
	{
		return _line;
	}
	
	/**
	 * @private
	 */
	public function set line(value:int):void
	{
		_line = value;
	}
	
	//----------------------------------
	//  stringValue
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _stringValue:String;
	
	/**
	 * @copy org.teotigraphix.as3parser.api.IParserNode#stringValue
	 */
	public function get stringValue():String
	{
		return _stringValue;
	}
	
	public function set stringValue(value:String):void
	{
		_stringValue = value;
	}
	
	
	//----------------------------------
	//  startToken
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _startToken:LinkedListToken;
	
	/**
	 * doc
	 */
	public function get startToken():LinkedListToken
	{
		return _startToken;
	}
	
	/**
	 * @private
	 */	
	public function set startToken(value:LinkedListToken):void
	{
		if (parent)
			TokenNode(parent).notifyChildStartTokenChange(this, startToken);
		
		_startToken = value;
	}
	
	//----------------------------------
	//  stopToken
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _stopToken:LinkedListToken;
	
	/**
	 * doc
	 */
	public function get stopToken():LinkedListToken
	{
		return _stopToken;
	}
	
	/**
	 * @private
	 */	
	public function set stopToken(value:LinkedListToken):void
	{
		if (parent)
			TokenNode(parent).notifyChildStopTokenChange(this, stopToken);
		
		_stopToken = value;
	}
	
	//----------------------------------
	//  initialInsertionAfter
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _initialInsertionAfter:LinkedListToken;
	
	/**
	 * doc
	 */
	public function get initialInsertionAfter():LinkedListToken
	{
		return _initialInsertionAfter;
	}
	
	/**
	 * @private
	 */	
	public function set initialInsertionAfter(value:LinkedListToken):void
	{
		_initialInsertionAfter = value;
	}
	
	//----------------------------------
	//  initialInsertionBefore
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _initialInsertionBefore:LinkedListToken;
	
	/**
	 * doc
	 */
	public function get initialInsertionBefore():LinkedListToken
	{
		return _initialInsertionBefore;
	}
	
	/**
	 * @private
	 */	
	public function set initialInsertionBefore(value:LinkedListToken):void
	{
		_initialInsertionBefore = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 * 
	 * @param kind The parser node kind.
	 * @param line The parser node line.
	 * @param column The parser node column.
	 * @param stringValue The parser node stringValue.
	 */
	public function Node(kind:String,
						 line:int,
						 column:int,
						 stringValue:String)
	{
		super(kind, null);
		
		_line = line;
		_column = column;
		_stringValue = stringValue;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Public :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	public function toString():String
	{
		return null;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Public Class :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Creates a new <code>Node</code> instance.
	 * 
	 * @param kind A String <code>NodeKind</code> indicating the kind of node.
	 * @param line The Integer line number.
	 * @param column The Integer column number.
	 * @param stringValue The String value of the node, can be null.
	 * @return A new <code>Node</code> instance.
	 */
	public static function create(kind:String,
								  line:int,
								  column:int,
								  stringValue:String = null):Node
	{
		return new Node(kind, line, column, stringValue);
	}
	
	/**
	 * Creates a new <code>Node</code> instance that will parent the
	 * <code>child</code>.
	 * 
	 * @param kind A String <code>NodeKind</code> indicating the kind of node.
	 * @param line The Integer line number.
	 * @param column The Integer column number.
	 * @param child The <code>Node</code> that will be added as a child to the
	 * new <code>Node</code> created and returned.
	 * @return A new <code>Node</code> instance that is parenting the 
	 * <code>child</code> node.
	 */
	public static function createChild(kind:String,
									   line:int,
									   column:int,
									   child:IParserNode):Node
	{
		var node:Node = new Node(kind, line, column, null);
		node.addChild(child);
		return node;
	}
}
}