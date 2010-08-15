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

package org.teotigraphix.as3nodes.utils
{

import flash.events.Event;

import org.teotigraphix.as3nodes.api.INode;

/**
 * TODO DOCME
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class ASTChangeEvent extends Event
{
	//--------------------------------------------------------------------------
	//
	//  Public :: Variables
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  kind
	//----------------------------------
	
	/**
	 * The change kind; <code>ASTChangeKind</code>.
	 */
	public var kind:String;
	
	//----------------------------------
	//  parent
	//----------------------------------
	
	/**
	 * The change parent.
	 */
	public var parent:INode;
	
	//----------------------------------
	//  data
	//----------------------------------
	
	/**
	 * The change data; see the <code>ASTChangeManager</code> for each
	 * data type per event type.
	 */
	public var data:Object;
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function ASTChangeEvent(type:String, 
								   kind:String, 
								   parent:INode, 
								   data:Object)
	{
		super(type);
		
		this.kind = kind;
		this.parent = parent;
		this.data = data;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden Public :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	override public function clone():Event
	{
		return new ASTChangeEvent(type, kind, parent, data);
	}
}
}