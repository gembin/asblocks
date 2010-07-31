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

/**
 * Metadata types.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public final class MetaData
{
	//--------------------------------------------------------------------------
	//
	//  Public :: Constants
	//
	//--------------------------------------------------------------------------
	
	public static const ARRAY_ELEMENT_TYPE:MetaData = MetaData.create("ArrayElementType");
	
	public static const BEFORE:MetaData = MetaData.create("Before");
	
	public static const BINDABLE:MetaData = MetaData.create("Bindable");
	
	public static const DEFAULT_PROPERTY:MetaData = MetaData.create("DefaultProperty");
	
	public static const DEPRECATED:MetaData = MetaData.create("Deprecated");
	
	public static const EFFECT:MetaData = MetaData.create("Effect");
	
	public static const EMBED:MetaData = MetaData.create("Embed");
	
	public static const EVENT:MetaData = MetaData.create("Event");
	
	public static const EXCLUDE:MetaData = MetaData.create("Exclude");
	
	public static const EXCLUDE_CLASS:MetaData = MetaData.create("ExcludeClass");
	
	public static const ICON_FILE:MetaData = MetaData.create("IconFile");
	
	public static const INSPECTABLE:MetaData = MetaData.create("Inspectable");
	
	public static const INSTANCE_TYPE:MetaData = MetaData.create("InstanceType");
	
	public static const NON_COMITTING_CHANGE_EVENT:MetaData = MetaData.create("NonCommittingChangeEvent");
	
	public static const OTHER:MetaData = MetaData.create("Other");
	
	public static const REMOTE_CLASS:MetaData = MetaData.create("RemoteClass");
	
	public static const STYLE:MetaData = MetaData.create("Style");
	
	public static const TEST:MetaData = MetaData.create("Test");
	
	public static const TRANSIENT:MetaData = MetaData.create("Transient");
	
	private static var list:Array =
		[
			ARRAY_ELEMENT_TYPE,
			BEFORE,
			BINDABLE,
			DEFAULT_PROPERTY,
			DEPRECATED,
			EFFECT,
			EMBED,
			EVENT,
			EXCLUDE,
			EXCLUDE_CLASS,
			ICON_FILE,
			INSPECTABLE,
			INSTANCE_TYPE,
			NON_COMITTING_CHANGE_EVENT,
			OTHER,
			REMOTE_CLASS,
			STYLE,
			TEST,
			TRANSIENT
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
	public function MetaData(name:String)
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
	public function equals(other:MetaData):Boolean
	{
		return _name == other.name;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Public Class :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Creates a new MetaData.
	 * 
	 * @param name A String indicating the name of the MetaData.
	 * @return A new MetaData instance.
	 */
	public static function create(name:String):MetaData
	{
		for each (var element:MetaData in list) 
		{
			if (element.name == name)
				return element;
		}
		
		return new MetaData(name);
	}
}
}