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
 * Clients implement this interface to hold IMetaDataNode.
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
	//  name
	//----------------------------------
	
	/**
	 * The metadata nodes found on the host.
	 */
	function get metaDatas():Vector.<IMetaData>;
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * TODO Docme
	 */
	function newMetaData(name:String):IMetaData;
	
	/**
	 * Returns the first IMetaData node named name.
	 * 
	 * @param name A String indicating the first IMetaData node to return.
	 * @return An IMetaData named name.
	 */
	function getMetaData(name:String):IMetaData;
	
	/**
	 * Returns all IMetaData nodes named name as a Vector.
	 * 
	 * @param name A String indicating the IMetaData nodes to return.
	 * @return A Vector of IMetaData named name.
	 */
	function getAllMetaData(name:String):Vector.<IMetaData>;
	
	/**
	 * Returns whether the host contains metadata named name.
	 * 
	 * @param name A String indicating the metadata name to test.
	 * @return A Boolean indicating whether the metadata exists.
	 */
	function hasMetaData(name:String):Boolean;
	
	/**
	 * Removes an IMetaData node from the host.
	 * 
	 * @param node The metadata node to remove.
	 */
	function removeMetaData(node:IMetaData):Boolean;
}
}