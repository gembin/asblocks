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
 * A common interface for IMethodNode and IFunctionLiteralNode.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public interface IFunctionCommon
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  arguments
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get arguments():Vector.<IArgumentNode>;
	
	/**
	 * @private
	 */
	//function set arguments(value:Vector.<IArgumentNode>):void;
	
	//----------------------------------
	//  type
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get type():String;
	
	/**
	 * @private
	 */
	function set type(value:String):void;
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * TODO Docme
	 */
	function addParameter(name:String, type:String, defaultValue:String = null):IArgumentNode;
	
	/**
	 * TODO Docme
	 */
	function removeParameter(name:String):IArgumentNode;
	
	/**
	 * TODO Docme
	 */
	function addRestParam(name:String):IArgumentNode;
}
}