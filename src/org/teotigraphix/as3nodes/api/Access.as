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

package org.teotigraphix.as3nodes.api
{

import org.teotigraphix.as3parser.api.AS3NodeKind;

/**
 * Class and Interface access.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public final class Access
{
	//--------------------------------------------------------------------------
	//
	//  Public :: Constants
	//
	//--------------------------------------------------------------------------
	
	public static const READ:Access = Access.create("read");
	
	public static const READ_WRITE:Access = Access.create("read-write");
	
	public static const WRITE:Access = Access.create("write");
	
	private static var list:Array =
		[
			READ,
			READ_WRITE,
			WRITE
		];
	
	//--------------------------------------------------------------------------
	//
	//  Public :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  name
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _name:String;
	
	/**
	 * The modifier name.
	 */
	public function get name():String
	{
		return _name;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	public function Access(name:String)
	{
		_name = name;
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
		return _name;
	}
	
	/**
	 * @private
	 */
	public function equals(other:Access):Boolean
	{
		return _name == other.name;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Public Class :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private static function create(name:String):Access
	{
		for each (var element:Access in list) 
		{
			if (element.name == name)
				return element;
		}
		
		return new Access(name);
	}
	
	/**
	 * @private
	 */
	public static function fromKind(kind:String):Access
	{
		if (kind == AS3NodeKind.GET)
			return READ;
		if (kind == AS3NodeKind.SET)
			return WRITE;
		return null;
	}
	
	/**
	 * @private
	 */
	public static function toKind(kind:Access):String
	{
		if (kind.equals(READ))
			return AS3NodeKind.GET;
		if (kind.equals(WRITE))
			return AS3NodeKind.SET;
		return null;
	}
}
}