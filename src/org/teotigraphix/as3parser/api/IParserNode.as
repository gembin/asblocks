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
package org.teotigraphix.as3parser.api
{
import org.teotigraphix.as3parser.core.LinkedListToken;



/**
 * The <strong>IParserNode</strong> interface marks a class as having the
 * ability to be placed in an AST parse tree.
 * 
 * <p>Initial API; Adobe Systems, Incorporated</p>
 * 
 * @author Adobe Systems, Incorporated
 * @author Michael Schmalle
 * @productversion 1.0
 */
public interface IParserNode
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  parent
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get parent():IParserNode;
	
	/**
	 * @private
	 */
	function set parent(value:IParserNode):void;
	
	//----------------------------------
	//  kind
	//----------------------------------
	
	/**
	 * The String kind (type) of parser node.
	 */
	function get kind():String;
	
	/**
	 * @private
	 */
	function set kind(value:String):void;
	
	//----------------------------------
	//  stringValue
	//----------------------------------
	
	/**
	 * The parser node's String value (if any).
	 */
	function get stringValue():String;
	
	/**
	 * @private
	 */
	function set stringValue(value:String):void;
	
	//----------------------------------
	//  line
	//----------------------------------
	
	/**
	 * The line the parser node starts at.
	 */
	function get line():int;
	
	/**
	 * @private
	 */
	function set line(value:int):void;
	
	//----------------------------------
	//  column
	//----------------------------------
	
	/**
	 * The column the parser node starts at.
	 */
	function get column():int;
	
	/**
	 * @private
	 */
	function set column(value:int):void;
	
	//----------------------------------
	//  start
	//----------------------------------
	
	/**
	 * The parser node's start offest.
	 */
	function get start():int;
	
	//----------------------------------
	//  end
	//----------------------------------
	
	/**
	 * The parser node's end offest.
	 */
	function get end():int;
	
	//----------------------------------
	//  children
	//----------------------------------
	
	/**
	 * The parser node's <code>IParserNode</code> children.
	 */
	function get children():Vector.<IParserNode>;
	
	//----------------------------------
	//  numChildren
	//----------------------------------
	
	/**
	 * The parser node's <code>IParserNode</code> child length.
	 */
	function get numChildren():int;
	
	//----------------------------------
	//  stopToken
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get stopToken():LinkedListToken;
	
	/**
	 * @private
	 */
	function set stopToken(value:LinkedListToken):void;
	
	//----------------------------------
	//  startToken
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get startToken():LinkedListToken;
	
	/**
	 * @private
	 */
	function set startToken(value:LinkedListToken):void;
	
	//----------------------------------
	//  initialInsertionAfter
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get initialInsertionAfter():LinkedListToken;
	
	/**
	 * @private
	 */
	function set initialInsertionAfter(value:LinkedListToken):void;
	
	//----------------------------------
	//  initialInsertionBefore
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get initialInsertionBefore():LinkedListToken;
	
	/**
	 * @private
	 */
	function set initialInsertionBefore(value:LinkedListToken):void;
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	function contains(other:IParserNode):Boolean;
	
	/**
	 * Returns the <code>kind</code> of parser node.
	 * 
	 * @param kind A String parser node kind.
	 * @return A Boolean indicating if the kind exists within this parser node.
	 */
	function isKind(kind:String):Boolean;
	
	/**
	 * Returns whether the node has a <code>kind</code> parser node child.
	 * 
	 * @param kind A String parser node kind.
	 * @return A Boolean indicating whether the kind exists on the parser node.
	 */
	function hasKind(kind:String):Boolean;
	
	/**
	 * Returns the <code>IParserNode</code> at the specified index.
	 * 
	 * @param index An int index to retrieve the child.
	 * @return The <code>IParserNode</code> at the specified index 
	 * or <code>null</code>.
	 */
	function getChild(index:int):IParserNode;
	
	function getKind(kind:String):IParserNode;
	
	
	/**
	 * Returns the last <code>IParserNode</code> child.
	 * 
	 * @return The last <code>IParserNode</code> or <code>null</code>.
	 */
	function getLastChild():IParserNode;
	
	/**
	 * Adds an <code>IParserNode</code> child to the children of this parser node.
	 * 
	 * @param The <code>IParserNode</code> to add.
	 * @return The <code>IParserNode</code> added.
	 */
	function addChild(node:IParserNode):IParserNode;
	
	/**
	 * 
	 */
	function addChildAt(node:IParserNode, index:int):IParserNode;
	
	/**
	 * Removes the first <code>kind</code> found.
	 * 
	 * @param kind A String parser node kind.
	 * @return A Boolean indicating whether the kind was removed from the parser node.
	 */
	function removeKind(kind:String):Boolean;
	
	/**
	 * Removes the node.
	 * 
	 * @param node An IParserNode parser node.
	 * @return A Boolean indicating whether the node was removed from the parser node.
	 */
	function removeChild(node:IParserNode):IParserNode;
	
	function removeChildAt(index:int):IParserNode;
	
	function setChildAt(child:IParserNode, index:int):IParserNode;
	
	function getChildIndex(node:IParserNode):int;
	
	function addTokenAt(token:LinkedListToken, index:int):void;
	
	function appendToken(token:LinkedListToken):void;
	
	/**
	 * Returns the first <code>IParserNode</code> child.
	 * 
	 * @return The first <code>IParserNode</code> or <code>null</code>.
	 */
	function getFirstChild():IParserNode;
}
}