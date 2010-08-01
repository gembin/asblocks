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

import org.teotigraphix.as3nodes.api.ICompilationNode;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3nodes.api.IPackageNode;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.utils.ASTUtil;

/**
 * The compilation node.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class CompilationNode extends NodeBase implements ICompilationNode
{
	//--------------------------------------------------------------------------
	//
	//  ICompilationNode API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  packageNode
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _packageNode:IPackageNode;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ICompilationNode#packageNode
	 */
	public function get packageNode():IPackageNode
	{
		return _packageNode;
	}
	
	/**
	 * @private
	 */	
	public function set packageNode(value:IPackageNode):void
	{
		_packageNode = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function CompilationNode(node:IParserNode, parent:INode)
	{
		super(node, parent);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden Protected :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	override protected function compute():void
	{
		packageNode = NodeFactory.instance.
			createPackage(ASTUtil.getPackage(node), this);
	}
}
}