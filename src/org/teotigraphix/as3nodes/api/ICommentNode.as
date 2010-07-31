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
 * TODO DOCME
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public interface ICommentNode
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  shortDescription
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get shortDescription():String;
	
	//----------------------------------
	//  longDescription
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get longDescription():String;
	
	//----------------------------------
	//  description
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	//function get description():String;

	//----------------------------------
	//  docTags
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get docTags():Vector.<IDocTag>;
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * TODO Docme
	 */
	//function hasDescription():Boolean;
	
	/**
	 * TODO Docme
	 */
	function getDocTagAt(index:int):IDocTag;
	
	/**
	 * TODO Docme
	 */
	function getDocTag(name:String):IDocTag;
	
	/**
	 * TODO Docme
	 */
	function hasDocTag(name:String):Boolean;
	
	/**
	 * TODO Docme
	 */
	function getDocTags(name:String):Vector.<IDocTag>;
}
}