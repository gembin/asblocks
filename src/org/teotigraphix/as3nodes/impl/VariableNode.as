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
import org.teotigraphix.as3nodes.api.IMetaDataNode;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3nodes.api.IVariableNode;
import org.teotigraphix.as3nodes.utils.NodeUtil;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.utils.ASTUtil;

/**
 * TODO DOCME
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class VariableNode extends ScriptNode implements IVariableNode
{
	//--------------------------------------------------------------------------
	//
	//  IVariableNode API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  type
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _type:IIdentifierNode;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IVariableNode#type
	 */
	public function get type():IIdentifierNode
	{
		return _type;
	}
	
	/**
	 * @private
	 */	
	public function set type(value:IIdentifierNode):void
	{
		_type = value;
	}
	
	//----------------------------------
	//  primary
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _primary:String;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IVariableNode#primary
	 */
	public function get primary():String
	{
		return _primary;
	}
	
	/**
	 * @private
	 */	
	public function set primary(value:String):void
	{
		_primary = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function VariableNode(node:IParserNode, parent:INode)
	{
		super(node, parent);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden Protected :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	override protected function compute():void
	{
		super.compute();
		
		var nti:IParserNode = ASTUtil.getNameTypeInit(node);
		if (!nti)
			return;
		
		var nameNode:IParserNode = nti.getKind(AS3NodeKind.NAME);
		_uid = NodeFactory.instance.createIdentifier(nameNode, this);
		
		var typeNode:IParserNode = nti.getKind(AS3NodeKind.TYPE);
		if (typeNode)
			_type = NodeFactory.instance.createIdentifier(typeNode, this);
		
		var initNode:IParserNode = nti.getKind(AS3NodeKind.INIT);
		if (initNode && initNode.hasKind(AS3NodeKind.PRIMARY))
			_primary = initNode.getKind(AS3NodeKind.PRIMARY).stringValue;
	}
}
}