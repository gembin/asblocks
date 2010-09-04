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

package org.teotigraphix.asblocks.api
{

/**
 * Function accessor roles.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public final class AccessorRole
{
	//--------------------------------------------------------------------------
	//
	//  Public :: Constants
	//
	//--------------------------------------------------------------------------
	
	public static const NORMAL:AccessorRole = AccessorRole.create("normal");
	
	public static const GETTER:AccessorRole = AccessorRole.create("getter");
	
	public static const SETTER:AccessorRole = AccessorRole.create("setter");
	
	private static var list:Array =
		[
			NORMAL,
			GETTER,
			SETTER
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
	 * The role name.
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
	public function AccessorRole(name:String)
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
	public function equals(other:AccessorRole):Boolean
	{
		return _name == other.name;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Public Class :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Creates a new AccessorRole.
	 * 
	 * @param name A String indicating the name of the role.
	 * @return A new AccessorRole instance.
	 */
	public static function create(name:String):AccessorRole
	{
		for each (var element:AccessorRole in list) 
		{
			if (element.name == name)
				return element;
		}
		
		return new AccessorRole(name);
	}
}
}