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

import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.asblocks.api.ICompilationUnit;
import org.teotigraphix.asblocks.api.IPackage;
import org.teotigraphix.asblocks.api.IType;

/**
 * The <code>ICompilationUnit</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class CompilationUnitNode extends ScriptNode implements ICompilationUnit
{
	//--------------------------------------------------------------------------
	//
	//  ICompilationUnit API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  packageName
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.ICompilationUnit#packageName
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
	 * @copy org.teotigraphix.asblocks.api.ICompilationUnit#packageNode
	 */
	public function get packageNode():IPackage
	{
		var ast:IParserNode = node.getKind(AS3NodeKind.PACKAGE);
		if (!ast)
			return null;
		
		return new PackageNode(ast);
	}
	
	//----------------------------------
	//  typeNode
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.ICompilationUnit#typeNode
	 */
	public function get typeNode():IType
	{
		var ast:IPackage = packageNode;
		if (!ast)
			return null;
		
		return ast.typeNode;
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