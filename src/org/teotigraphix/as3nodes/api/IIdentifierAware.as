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
 * The <strong>IIdentifierAware</strong> interface allows nodes to contain
 * unique identifiers that act as paths to the instance.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 * @see org.teotigraphix.as3nodes.api.IIdentifierNode#uid
 */
public interface IIdentifierAware
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  uid
	//----------------------------------
	
	/**
	 * The unique identifier that tags an object with <code>localName</code>, 
	 * <code>packageName</code>, <code>qualifiedName</code>, 
	 * <code>fragmentName</code> and <code>fragmentType</code>.
	 */
	function get uid():IIdentifierNode;
	
	/**
	 * @private
	 */
	function set uid(value:IIdentifierNode):void;
}
}