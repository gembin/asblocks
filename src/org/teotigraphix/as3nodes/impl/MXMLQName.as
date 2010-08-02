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

package org.teotigraphix.as3nodes.impl
{

import org.teotigraphix.as3parser.api.IParserNode;

/**
 * TODO DOCME
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class MXMLQName
{
	//--------------------------------------------------------------------------
	//
	//  Public :: Variables
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  uri
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _uri:String;
	
	/**
	 * The qname uri.
	 */
	public function get uri():String
	{
		return _uri;
	}
	
	//----------------------------------
	//  localName
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _localName:String;
	
	/**
	 * The qname localName.
	 */
	public function get localName():String
	{
		return _localName;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function MXMLQName(node:IParserNode)
	{
		_localName = node.getChild(0).stringValue;
		_uri = node.getChild(1).stringValue;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Public :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	public function toString():String
	{
		return _localName + ":" + _uri;
	}
}
}