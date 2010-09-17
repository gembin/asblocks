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
 * A function argument; <code>(arg0:int = 0)</code>.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public interface IArgument extends IScriptNode
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
	 * The arguments default value that is read after an <code>=</code> sign.
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
	 * The asdoc description for the argument.
	 * 
	 * <p>Setting this value will update the documentation <strong>param</strong>
	 * tag for the function owner.</p>
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
	 * The name of the argument; after the <code>(</code> or <code>,</code>.
	 */
	function get name():String;
	
	//----------------------------------
	//  type
	//----------------------------------
	
	/**
	 * The type of the argument; after the <code>:</code>.
	 */
	function get type():String;
	
	//----------------------------------
	//  isRest
	//----------------------------------
	
	/**
	 * Whether this argument is a rest that appears at the end of the argument
	 * list.
	 */
	function get isRest():Boolean;
}
}