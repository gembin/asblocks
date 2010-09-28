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

package org.as3commons.mxmlblocks.api
{
import org.as3commons.asblocks.parser.api.IToken;

/**
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public interface ITagContainer
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  id
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get id():String;
	
	//----------------------------------
	//  binding
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get binding():String;
	
	/**
	 * @private
	 */
	function set binding(value:String):void;
	
	//----------------------------------
	//  localName
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get localName():String;
	
	/**
	 * @private
	 */
	function set localName(value:String):void;
	
	//----------------------------------
	//  hasChildren
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get hasChildren():Boolean;
	
	//----------------------------------
	//  namespaces
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get namespaces():Vector.<IXMLNamespace>;
	
	//----------------------------------
	//  attributes
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get attributes():Vector.<IAttribute>;
	
	//----------------------------------
	//  children
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get children():Vector.<ITag>;
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * TODO Docme
	 */
	function addComment(text:String):IToken;
	
	/**
	 * TODO Docme
	 */
	//function removeComment(statement:IStatement):IToken;
	
	/**
	 * TODO Docme
	 */
	function newXMLNS(localName:String, uri:String):IXMLNamespace;
	
	/**
	 * TODO Docme
	 */
	function newAttribute(name:String, value:String, state:String = null):IAttribute;
	
	/**
	 * TODO Docme
	 */
	function newTag(name:String, binding:String = null):IBlockTag;
	
	/**
	 * TODO Docme
	 */
	function newScriptTag(code:String = null):IScriptTag;
	
	/**
	 * TODO Docme
	 */
	function newMetadataTag(code:String = null):IMetadataTag;
}
}