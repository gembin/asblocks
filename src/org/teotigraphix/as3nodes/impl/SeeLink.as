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
import org.teotigraphix.as3nodes.api.ISeeLink;

// FIXME Unit Test SeeLink

/**
 * The concrete implementation of the <code>ISeeLink</code> API.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class SeeLink implements ISeeLink
{
	//--------------------------------------------------------------------------
	//
	//  ISeeLink API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  node
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _node:INode;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ISeeLink#node
	 */
	public function get node():INode
	{
		return _node;
	}
	
	/**
	 * @private
	 */	
	public function set node(value:INode):void
	{
		_node = value;
	}
	
	//----------------------------------
	//  uid
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _uid:IIdentifierNode;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ISeeLink#uid
	 */
	public function get uid():IIdentifierNode
	{
		return _uid;
	}
	
	/**
	 * @private
	 */	
	public function set uid(value:IIdentifierNode):void
	{
		_uid = value;
	}
	
	//----------------------------------
	//  name
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ISeeLink#name
	 */
	public function get name():String
	{
		if(_uid.hasFragment)
			return _uid.fragmentName;
		return _uid.localName;
	}
	
	//----------------------------------
	//  packageName
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ISeeLink#packageName
	 */
	public function get packageName():String
	{
		return _uid.packageName;
	}
	
	//----------------------------------
	//  qualifiedName
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ISeeLink#qualifiedName
	 */
	public function get qualifiedName():String
	{
		return _uid.qualifiedName;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function SeeLink(node:INode)
	{
		_node = node;
	}
}
}