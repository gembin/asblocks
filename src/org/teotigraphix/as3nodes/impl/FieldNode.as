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

import org.teotigraphix.as3nodes.api.ICommentNode;
import org.teotigraphix.as3nodes.api.IFieldNode;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3nodes.api.Modifier;
import org.teotigraphix.as3nodes.utils.AsDocUtil;
import org.teotigraphix.as3nodes.utils.ModifierUtil;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;

/**
 * TODO DOCME
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class FieldNode extends VariableNode implements IFieldNode
{
	//--------------------------------------------------------------------------
	//
	//  ICommentAware API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  comment
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _comment:ICommentNode;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.ICommentAware#comment
	 */
	public function get comment():ICommentNode
	{
		return _comment;
	}
	
	/**
	 * @private
	 */	
	public function set comment(value:ICommentNode):void
	{
		_comment = value;
	}
	
	//----------------------------------
	//  isPublic
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IVisible#isPublic
	 */
	public function get isPublic():Boolean
	{
		return hasModifier(Modifier.PUBLIC);
	}
	
	//----------------------------------
	//  isStatic
	//----------------------------------
	
	public function get isStatic():Boolean
	{
		return hasModifier(Modifier.STATIC);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function FieldNode(node:IParserNode, parent:INode)
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
		super.compute();
		
		modifiers = new Vector.<Modifier>();
		
		for each (var element:IParserNode in node.children)
		{
			if (element.isKind(AS3NodeKind.AS_DOC))
			{
				AsDocUtil.computeAsDoc(this, element);
			}
			else if (element.isKind(AS3NodeKind.MOD_LIST))
			{
				ModifierUtil.computeModifierList(this, element);
			}
		}
	}
}
}