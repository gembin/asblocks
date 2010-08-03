////////////////////////////////////////////////////////////////////////////////
// Copyright 2010 Michael Schmalle - Teoti Graphix, LLC
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
// http://www.apache.org/licenses/LICENSE-2.0 
// 
// Unless required by applicable law or agreed to in writing, software 
// distributed under the License is distributed on an "AS IS" BASIS, 
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and 
// limitations under the License
// 
// Author: Michael Schmalle, Principal Architect
// mschmalle at teotigraphix dot com
////////////////////////////////////////////////////////////////////////////////

package org.teotigraphix.as3nodes.impl
{

import org.teotigraphix.as3nodes.api.IIdentifierNode;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3parser.api.IParserNode;

/**
 * An identifier name node.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class IdentifierNode extends NodeBase implements IIdentifierNode
{
	//--------------------------------------------------------------------------
	//
	//  INameAware API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  localName
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _localName:String;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IIdentifierNode#name
	 */
	public function get localName():String
	{
		return _localName;
	}
	
	/**
	 * @private
	 */	
	public function set localName(value:String):void
	{
		_localName = value;
	}
	
	//----------------------------------
	//  packageName
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _packageName:String;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IIdentifierNode#packageName
	 */
	public function get packageName():String
	{
		return _packageName;
	}
	
	/**
	 * @private
	 */	
	public function set packageName(value:String):void
	{
		_packageName = value;
	}
	
	//----------------------------------
	//  qualifiedName
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _qualifiedName:String;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IIdentifierNode#qualifiedName
	 */
	public function get qualifiedName():String
	{
		return _qualifiedName;
	}
	
	/**
	 * @private
	 */	
	public function set qualifiedName(value:String):void
	{
		_qualifiedName = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function IdentifierNode(node:IParserNode, parent:INode)
	{
		super(node, parent);
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
		return _qualifiedName;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden Protected :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	override protected function compute():void
	{
		// FIXME !!!!!!!!!!!
		_localName = node.stringValue;
	}
}
}