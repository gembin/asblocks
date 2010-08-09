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
public interface IIdentifierNode extends INode
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  localName
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get localName():String;
	
	//----------------------------------
	//  packageName
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get packageName():String;
	
	//----------------------------------
	//  qualifiedName
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get qualifiedName():String;
	
	/**
	 * @private
	 */
	function set qualifiedName(value:String):void;
	
	//----------------------------------
	//  parentQualifiedName
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get parentQualifiedName():String;
	
	//----------------------------------
	//  fragmentName
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get fragmentName():String;
	
	//----------------------------------
	//  fragmentType
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get fragmentType():String;
	
	//----------------------------------
	//  fragmentType
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get isQualified():Boolean;
	
	//----------------------------------
	//  fragmentType
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get hasFragment():Boolean;
	
	//----------------------------------
	//  fragmentType
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get hasFragmentType():Boolean;
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * TODO Docme
	 */
	function equals(object:Object):Boolean;
}
}