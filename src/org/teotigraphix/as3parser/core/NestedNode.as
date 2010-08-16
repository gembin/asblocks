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
 * A parser node that contains parser node children.
 * 
 * <p>Initial API; Adobe Systems, Incorporated</p>
 * 
 * @author Adobe Systems, Incorporated
 * @author Michael Schmalle
 * @productversion 1.0
 */
public class NestedNode
{
	//--------------------------------------------------------------------------
	//
	//  Public :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  kind
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _kind:String;
	
	/**
	 * @copy org.teotigraphix.as3parser.api.IParserNode#kind
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
	//  children
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _children:Vector.<IParserNode>;
	
	/**
	 * @copy org.teotigraphix.as3parser.api.IParserNode#children
	 */
	public function get children():Vector.<IParserNode>
	{
		return _children;
	}
	
	//----------------------------------
	//  numChildren
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3parser.api.IParserNode#numChildren
	 */
	public function get numChildren():int
	{
		if (_children == null)
			return 0;
		return _children.length;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Creates a new Node instance.
	 * 
	 * @param kind A String parser node kind.
	 * @param child The node child.
	 */
	public function NestedNode(kind:String, child:IParserNode)
	{
		_kind = kind;
		
		addChild(child);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Public :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.teotigraphix.as3parser.api.IParserNode#isKind()
	 */
	public function isKind(kind:String):Boolean
	{
		if (_kind == kind)
			return true;
		return false;
	}
	
	/**
	 * @copy org.teotigraphix.as3parser.api.IParserNode#hasKind()
	 */
	public function hasKind(kind:String):Boolean
	{
		if (numChildren == 0)
			return false;
		
		var len:int = children.length;
		for (var i:int = 0; i < len; i++)
		{
			if (children[i].isKind(kind))
				return true;
		}
		
		return false;
	}
	
	/**
	 * @copy org.teotigraphix.as3parser.api.IParserNode#getChild()
	 */
	public function getChild(index:int):IParserNode
	{
		if (_children == null || _children.length == 0)
			return null;
		
		return _children[index];
	}
	
	/**
	 * @copy org.teotigraphix.as3parser.api.IParserNode#getLastChild()
	 */
	public function getLastChild():IParserNode
	{
		return _children[_children.length - 1];
	}
	
	/**
	 * @copy org.teotigraphix.as3parser.api.IParserNode#addChild()
	 */
	public function addChild(child:IParserNode):IParserNode
	{
		if (child == null)
			return null;
		
		if (_children == null)
			_children = new Vector.<IParserNode>();
		
		_children.push(child);
		
		return child;
	}
	
	/**
	 * @copy org.teotigraphix.as3parser.api.IParserNode#addChildAt()
	 */
	public function addChildAt(child:IParserNode, index:int):IParserNode
	{
		if (child == null)
			return null;
		
		if (index > numChildren)
			index = numChildren;
		
		if (_children == null)
			_children = new Vector.<IParserNode>();
		
		_children.splice(index, 0, child);
		
		return child;
	}
	
	/**
	 * @copy org.teotigraphix.as3parser.api.IParserNode#addRawChild()
	 */
	public function addRawChild(kind:String,
								line:int,
								column:int,
								stringValue:String):IParserNode
	{
		return addChild(Node.create(kind, line, column, stringValue));
	}
	
	public function addNodeChild(kind:String,
								 line:int,
								 column:int,
								 sibling:IParserNode):IParserNode
	{
		var node:IParserNode = Node.create(kind, line, column, null);
		node.addChild(sibling);
		return addChild(node);
	}
	
	public function removeKind(kind:String):Boolean
	{
		if (!hasKind(kind))
			return false;
		
		var len:int = children.length;
		for (var i:int = 0; i < len; i++)
		{
			if (children[i].isKind(kind))
			{
				children.splice(i, 1);
				return true;
			}
		}
		
		return false;
	}
}
}