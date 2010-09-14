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
 * TODO Docme
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public interface IType extends IScriptNode, IMetaDataAware, IDocCommentAware
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  name
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get name():String;
	
	/**
	 * @private
	 */
	function set name(value:String):void;
	
	//----------------------------------
	//  visibility
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get visibility():Visibility;
	
	/**
	 * @private
	 */
	function set visibility(value:Visibility):void;
	
	//----------------------------------
	//  methods
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get methods():Vector.<IMethod>;
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * TODO Docme
	 */
	function newMethod(name:String, 
					   visibility:Visibility, 
					   returnType:String):IMethod;
	
	/**
	 * TODO Docme
	 */
	function getMethod(name:String):IMethod;
	
	/**
	 * TODO Docme
	 */
	function removeMethod(name:String):Boolean;
}
}