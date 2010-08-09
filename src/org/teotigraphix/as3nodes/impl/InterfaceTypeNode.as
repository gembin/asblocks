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

import org.teotigraphix.as3nodes.api.IIdentifierNode;
import org.teotigraphix.as3nodes.api.IInterfaceTypeNode;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3nodes.utils.ASTNodeUtil;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;

/**
 * The interface found in the package node.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class InterfaceTypeNode extends TypeNode implements IInterfaceTypeNode
{
	//--------------------------------------------------------------------------
	//
	//  IInterfaceTypeNode API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  superInterfaces
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _superInterfaces:Vector.<IIdentifierNode>;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IInterfaceTypeNode#superInterfaces
	 */
	public function get superInterfaces():Vector.<IIdentifierNode>
	{
		return _superInterfaces;
	}
	
	/**
	 * @private
	 */	
	public function set superInterfaces(value:Vector.<IIdentifierNode>):void
	{
		_superInterfaces = value;
	}
	
	//----------------------------------
	//  isSubType
	//----------------------------------
	
	/**
	 * @private
	 */	
	override public function get isSubType():Boolean
	{
		return superInterfaces.length > 0;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function InterfaceTypeNode(node:IParserNode, parent:INode)
	{
		super(node, parent);
	}
	
	//--------------------------------------------------------------------------
	//
	//  IInterfaceTypeNode API :: Properties
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IInterfaceTypeNode#addSuperInterface()
	 */
	public function addSuperInterface(superInterface:IIdentifierNode):void
	{
		superInterfaces.push(superInterface);
		
		ASTNodeUtil.addSuperInterface(this, superInterface);
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IInterfaceTypeNode#removeSuperInterface()
	 */
	public function removeSuperInterface(superInterface:IIdentifierNode):void
	{
		var len:int = superInterfaces.length;
		for (var i:int = 0; i < len; i++)
		{
			var element:IIdentifierNode = superInterfaces[i] as IIdentifierNode;
			if (element.equals(superInterface))
			{
				superInterfaces.splice(i, 1);
				break;
			}
		}
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
		super.compute();
		
		superInterfaces = new Vector.<IIdentifierNode>();
		
		if (node.numChildren == 0)
			return;
		
		for each (var child:IParserNode in node.children)
		{
			if (child.isKind(AS3NodeKind.EXTENDS))
			{
				computeExtends(child);
			}
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//  Protected :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	protected function computeExtends(child:IParserNode):void
	{
		superInterfaces.push(NodeFactory.instance.createIdentifier(child, this));
	}
}
}