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

package org.teotigraphix.asblocks.impl
{

import org.teotigraphix.asblocks.api.IPackageNode;
import org.teotigraphix.asblocks.api.ITypeNode;
import org.teotigraphix.as3parser.api.IParserNode;

/**
 * The <code>ICompilationUnitNode</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class PackageNode extends ScriptNode 
	implements IPackageNode
{
	//--------------------------------------------------------------------------
	//
	//  IPackageNode API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  name
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IPackageNode#name
	 */
	public function get name():String
	{
		return null;
	}
	
	/**
	 * @private
	 */	
	public function set name(value:String):void
	{
		
	}
	
	//----------------------------------
	//  typeNode
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IPackageNode#typeNode
	 */
	public function get typeNode():ITypeNode
	{
		return null;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function PackageNode(node:IParserNode)
	{
		super(node);
	}
	
	//--------------------------------------------------------------------------
	//
	//  IPackageNode API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * TODO Docme
	 */
	public function findImports():String
	{
		return null;
	}
	
	/**
	 * TODO Docme
	 */
	public function addImports(name:String):void
	{
		
	}
	
	/**
	 * TODO Docme
	 */
	public function removeImports():Boolean
	{
		return false;
	}
}
}