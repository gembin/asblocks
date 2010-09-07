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
import org.teotigraphix.as3parser.core.LinkedListToken;
import org.teotigraphix.as3parser.core.TokenNode;
import org.teotigraphix.as3parser.impl.ASTIterator;
import org.teotigraphix.asblocks.ASBlocksSyntaxError;
import org.teotigraphix.asblocks.api.IExpression;
import org.teotigraphix.asblocks.api.IField;
import org.teotigraphix.asblocks.utils.ASTUtil;

/**
 * The <code>IField</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class FieldNode extends MemberNode 
	implements IField
{
	private function get nameTypeInit():IParserNode
	{
		return node.getKind(AS3NodeKind.NAME_TYPE_INIT);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Private :: Variables
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  name
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IMemberNode#name
	 */
	override public function get name():String
	{
		var i:ASTIterator = new ASTIterator(nameTypeInit);
		return ASTUtil.nameText(i.find(AS3NodeKind.NAME));
	}
	
	/**
	 * @private
	 */	
	override public function set name(value:String):void
	{
		if (value.indexOf('.') != -1)
		{
			throw new ASBlocksSyntaxError("field name must not contain '.'");
		}
		var i:ASTIterator = new ASTIterator(nameTypeInit);
		i.find(AS3NodeKind.NAME);
		i.replace(ASTUtil.newAST(AS3NodeKind.NAME, value));
	}
	
	//----------------------------------
	//  type
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IMemberNode#type
	 */
	override public function get type():String
	{
		var i:ASTIterator = new ASTIterator(nameTypeInit);
		return ASTUtil.typeText(i.find(AS3NodeKind.TYPE));
	}
	
	/**
	 * @private
	 */	
	override public function set type(value:String):void
	{
		var i:ASTIterator = new ASTIterator(nameTypeInit);
		i.find(AS3NodeKind.TYPE);
		i.replace(ASTUtil.newAST(AS3NodeKind.TYPE, value));
	}
	
	//--------------------------------------------------------------------------
	//
	//  IField API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  isConstant
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IFieldNode#isConstant
	 */
	public function get isConstant():Boolean
	{
		return node.getKind(AS3NodeKind.FIELD_ROLE).getFirstChild().isKind(AS3NodeKind.CONST);
	}
	
	/**
	 * @private
	 */	
	public function set isConstant(value:Boolean):void
	{
		var role:IParserNode = node.getKind(AS3NodeKind.FIELD_ROLE);
		if (role.getFirstChild().isKind(AS3NodeKind.CONST) == value)
		{
			return;
		}
		
		var node:LinkedListToken;
		if (value) 
		{
			node = TokenBuilder.newConst();
		} 
		else
		{
			node = TokenBuilder.newVar();
		}
		
		role.setChildAt(ASTUtil.newTokenAST(node), 0);
	}
	
	//----------------------------------
	//  initializer
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IFieldNode#initializer
	 */
	public function get initializer():IExpression
	{
		var init:IParserNode = nameTypeInit.getKind(AS3NodeKind.INIT);
		if (!init)
			return null;
		return ExpressionBuilder.build(init.getFirstChild());
	}
	
	/**
	 * @private
	 */	
	public function set initializer(value:IExpression):void
	{
		if (value == null) 
		{
			removeInitializer();
		} 
		else 
		{
			setInitAST(value.node);
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function FieldNode(node:IParserNode)
	{
		super(node);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Private :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */	
	private function setInitAST(expression:IParserNode):void
	{
		var nti:IParserNode = nameTypeInit;
		var init:IParserNode = nti.getKind(AS3NodeKind.INIT);
		if (init == null)
		{
			init = ASTUtil.newAST(AS3NodeKind.INIT, "=");
			// TODO get addTokenAt() in public API
			TokenNode(init).addTokenAt(TokenBuilder.newSpace(), 0);
			init.appendToken(TokenBuilder.newSpace());
			nti.addChild(init);
		}
		else
		{
			init.removeChildAt(0);
		}
		
		init.addChild(expression);
	}
	
	/**
	 * @private
	 */	
	private function removeInitializer():void
	{
		var nti:IParserNode = nameTypeInit;
		var i:ASTIterator = new ASTIterator(nti);
		if (i.search(AS3NodeKind.INIT) != null)
		{
			i.remove();
		}
	}
}
}