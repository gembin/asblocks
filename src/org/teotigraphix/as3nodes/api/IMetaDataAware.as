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
 * Clients implement this interface to host IMetaDataNode nodes.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public interface IMetaDataAware
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  metaDatas
	//----------------------------------
	
	/**
	 * The metadata nodes found on the host.
	 */
	function get metaDatas():Vector.<IMetaDataNode>;
	
	//----------------------------------
	//  numMetaData
	//----------------------------------
	
	/**
	 * The number of metadata nodes found on the host.
	 */
	function get numMetaData():int;
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Adds an IMetaDataNode node to the host.
	 * 
	 * @param node The metadata node to add.
	 */
	function addMetaData(node:IMetaDataNode):void;
	
	/**
	 * Removes an IMetaDataNode node from the host.
	 * 
	 * @param node The metadata node to remove.
	 */
	function removeMetaData(node:IMetaDataNode):void;
	
	/**
	 * Returns the first IMetaDataNode node named name.
	 * 
	 * @param name A String indicating the first IMetaDataNode node to return.
	 * @return An IMetaDataNode named name.
	 */
	function getMetaData(name:String):IMetaDataNode;
	
	/**
	 * Returns all IMetaDataNode nodes named name as a Vector.
	 * 
	 * @param name A String indicating the IMetaDataNode nodes to return.
	 * @return A Vector of IMetaDataNode named name.
	 */
	function getAllMetaData(name:String):Vector.<IMetaDataNode>;
	
	/**
	 * Returns whether the host contains metadata named name.
	 * 
	 * @param name A String indicating the metadata name to test.
	 * @return A Boolean indicating whether the metadata exists.
	 */
	function hasMetaData(name:String):Boolean;
}
}