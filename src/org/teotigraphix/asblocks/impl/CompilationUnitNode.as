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

import org.teotigraphix.asblocks.api.ICompilationUnitNode;
import org.teotigraphix.asblocks.api.IPackageNode;
import org.teotigraphix.asblocks.api.ITypeNode;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;

/**
 * The <code>ICompilationUnitNode</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class CompilationUnitNode extends ScriptNode 
	implements ICompilationUnitNode
{
	//--------------------------------------------------------------------------
	//
	//  ICompilationUnitNode API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  packageName
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.ICompilationUnitNode#packageName
	 */
	public function get packageName():String
	{
		return packageNode.name;
	}
	
	/**
	 * @private
	 */	
	public function set packageName(value:String):void
	{
		packageNode.name = value;
	}
	
	//----------------------------------
	//  packageNode
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.ICompilationUnitNode#packageName
	 */
	public function get packageNode():IPackageNode
	{
		var ast:IParserNode = node.getKind(AS3NodeKind.PACKAGE);
		if (!ast)
		{
			return null;
		}
		return new PackageNode(ast);
	}
	
	//----------------------------------
	//  typeNode
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.ICompilationUnitNode#packageName
	 */
	public function get typeNode():ITypeNode
	{
		var pkg:IPackageNode = packageNode;
		if (!pkg)
		{
			return null;
		}
		return pkg.typeNode;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function CompilationUnitNode(node:IParserNode)
	{
		super(node);
	}
}
}