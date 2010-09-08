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
import org.teotigraphix.as3parser.core.Token;
import org.teotigraphix.as3parser.core.TokenNode;
import org.teotigraphix.as3parser.impl.ASTIterator;
import org.teotigraphix.asblocks.api.IDeclarationStatement;
import org.teotigraphix.asblocks.api.IVarDeclarationFragment;
import org.teotigraphix.asblocks.utils.ASTUtil;

/**
 * The <code>IDeclarationStatement</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class DeclarationStatementNode extends ScriptNode 
	implements IDeclarationStatement
{
	//----------------------------------
	//  firstVarName
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IDeclarationStatement#firstVarName
	 */
	public function get firstVarName():String
	{
		return firstVar.name;
	}
	
	//----------------------------------
	//  firstVarType
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IDeclarationStatement#firstVarType
	 */
	public function get firstVarType():String
	{
		return firstVar.type;
	}
	
	//----------------------------------
	//  isConstant
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IDeclarationStatement#isConstant
	 */
	public function get isConstant():Boolean
	{
		// dec-list/dec-role
		return node.getFirstChild().getFirstChild().isKind(AS3NodeKind.CONST);
	}
	
	/**
	 * @private
	 */	
	public function set isConstant(value:Boolean):void
	{
		var roleList:IParserNode = node.getFirstChild();
		if (value && roleList.getFirstChild().isKind(AS3NodeKind.CONST))
			return;
		
		var kind:String = (value) ? AS3NodeKind.CONST : AS3NodeKind.VAR;
		var role:IParserNode = ASTUtil.newAST(AS3NodeKind.DEC_ROLE);
		var ast:IParserNode = ASTUtil.newAST(kind);
		role.addChild(ast);
		role.appendToken(TokenBuilder.newToken(kind, kind));
		node.setChildAt(role, 0);
		role.appendToken(TokenBuilder.newSpace());
	}
	
	//----------------------------------
	//  vars
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IDeclarationStatement#vars
	 */
	public function get vars():Vector.<IVarDeclarationFragment>
	{
		var result:Vector.<IVarDeclarationFragment> = new Vector.<IVarDeclarationFragment>();
		var i:ASTIterator = new ASTIterator(node);
		i.next(); // dec-role
		while(i.hasNext())
		{
			result.push(build(i.next()));
		}
		return result;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function DeclarationStatementNode(node:IParserNode)
	{
		super(node);
	}
	
	/**
	 * @private
	 */
	private function get firstVar():IVarDeclarationFragment
	{
		return build(node.getChild(1));
	}
	
	/**
	 * @private
	 */
	private function build(ast:IParserNode):IVarDeclarationFragment
	{
		return new VarDeclarationFragment(ast);
	}
}
}