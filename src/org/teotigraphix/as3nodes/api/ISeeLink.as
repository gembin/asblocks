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
 * The <code>ISeeLink</code> allows a light handle to an actual
 * <code>INode</code> that was parsed in the current session.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public interface ISeeLink
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  node
	//----------------------------------
	
	/**
	 * The <code>INode</code> owner.
	 */
	function get node():INode;
	
	//----------------------------------
	//  node
	//----------------------------------
	
	/**
	 * The <code>IIdentifierNode</code> of the owner.
	 */
	function get uid():IIdentifierNode;
	
	//----------------------------------
	//  name
	//----------------------------------
	
	/**
	 * The simple display name of the element.
	 */
	function get name():String;
	
	//----------------------------------
	//  name
	//----------------------------------
	
	/**
	 * The package display name of the element.
	 */
	function get packageName():String;
	
	//----------------------------------
	//  name
	//----------------------------------
	
	/**
	 * The qualified display name of the element.
	 */
	function get qualifiedName():String;
}
}