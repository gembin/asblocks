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

import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3nodes.api.ITypeNodePlaceholder;
import org.teotigraphix.as3parser.api.IParserNode;

/**
 * The concrete implementation of the <code>ITypeElementPlaceholder</code> API.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class TypeNodePlaceholder extends TypeNode implements ITypeNodePlaceholder
{
	//--------------------------------------------------------------------------
	//
	//  Overridden Public :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  name
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _name:String;
	
	/**
	 * @private
	 */
	override public function get name():String
	{
		return _name;
	}
	
	//----------------------------------
	//  packageName
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _packageName:String;
	
	/**
	 * @private
	 */
	override public function get packageName():String
	{
		return _packageName;
	}
	
	//----------------------------------
	//  qualifiedName
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _qualifiedName:String;
	
	/**
	 * @private
	 */
	override public function get qualifiedName():String
	{
		return _qualifiedName;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function TypeNodePlaceholder(qualifiedName:String)
	{
		super(null, null);
		
		_name = qualifiedName;
		_packageName = qualifiedName;
		_qualifiedName = qualifiedName;
		
		if (_qualifiedName.indexOf(".") != -1)
		{
			var split:Array = _qualifiedName.split(".");
			_name = split.pop();
			_packageName = split.join(".");
		}
		
		uid = IdentifierNode.createType(_qualifiedName, this);
	}
}
}