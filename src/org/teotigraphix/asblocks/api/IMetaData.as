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
 * TODO DOCME
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public interface IMetaData extends IScriptNode
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  parameter
	//----------------------------------
	
	/**
	 * The original String found between the ( and ) with space between the
	 * parameters and equals to make it easier to split and parse.
	 * 
	 * <p>If there was no parenthesis, this property value is null.</p>
	 */
	function get parameter():String;
	
	//----------------------------------
	//  parameters
	//----------------------------------
	
	/**
	 * The list of paramter nodes.
	 */
	function get parameters():Vector.<IMetaDataParameter>;
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * TODO DOCME
	 */
	function addParameter(value:String):IMetaDataParameter;
	
	/**
	 * TODO DOCME
	 */
	function addNamedParameter(name:String, value:String):IMetaDataParameter;
	
	/**
	 * TODO DOCME
	 */
	function addNamedStringParameter(name:String, value:String):IMetaDataParameter;
	
	/**
	 * Returns a <code>IMetaDataParameter</code> by the specified name
	 * or <code>null</code> if the named parameter does not exist.
	 * 
	 * @param name A String parameter name.
	 * @return A <code>IMetaDataParameter</code> or <code>null</code>.
	 */
	function getParameter(name:String):IMetaDataParameter;
	
	/**
	 * Returns a <code>IMetaDataParameter</code> at the specified index
	 * or <code>null</code> if the index is out of range.
	 * 
	 * @param index An int specifying the parameter to return.
	 * @return A <code>IMetaDataParameter</code> or <code>null</code>.
	 */
	function getParameterAt(index:int):IMetaDataParameter;
	
	/**
	 * Returns a <code>IMetaDataParameter.value</code> with the specified name
	 * or <code>null</code> if the paramater dosn't exist.
	 * 
	 * @param name A String parameter name.
	 * @return A String parameter value or <code>null</code>.
	 */
	function getParameterValue(name:String):String;
	
	/**
	 * Returns whether the metadata contains a parameter by the name, 
	 * <code>name</code>.
	 * 
	 * @param name A String parameter name.
	 * @return A Boolean indicating whether the name exists in a paramter.
	 */
	function hasParameter(name:String):Boolean;
}
}