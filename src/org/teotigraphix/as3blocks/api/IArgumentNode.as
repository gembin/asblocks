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

package org.teotigraphix.as3blocks.api
{

/**
 * A function argument; <code>(arg0:int = 0)</code>.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public interface IArgumentNode extends IScriptFragmentNode
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  defaultValue
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get defaultValue():String;
	
	/**
	 * @private
	 */
	function set defaultValue(value:String):void;
	
	//----------------------------------
	//  description
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get description():String;
	
	/**
	 * @private
	 */
	function set description(value:String):void;
	
	//----------------------------------
	//  name
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get name():String;
	
	//----------------------------------
	//  type
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get type():String;
	
	//----------------------------------
	//  isRest
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get isRest():Boolean;
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
}
}