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

import org.teotigraphix.asblocks.api.IExpressionNode;
import org.teotigraphix.asblocks.api.ISwitchCaseNode;
import org.teotigraphix.asblocks.api.ISwitchDefaultNode;
import org.teotigraphix.asblocks.api.ISwitchLabelNode;
import org.teotigraphix.asblocks.api.ISwitchStatementNode;
import org.teotigraphix.asblocks.utils.ASTUtil;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.impl.AS3FragmentParser;

/**
 * The <code>ISwitchStatementNode</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class SwitchStatementNode extends ScriptNode 
	implements ISwitchStatementNode
{
	private function get block():IParserNode
	{
		return node.getLastChild();
	}
	
	//--------------------------------------------------------------------------
	//
	//  ISwitchStatementNode API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  condition
	//----------------------------------
	
	private function get conditionNode():IParserNode
	{
		return node.getFirstChild();
	}
	
	/**
	 * doc
	 */
	public function get condition():IExpressionNode
	{
		return ExpressionBuilder.build(conditionNode.getFirstChild());
	}
	
	/**
	 * @private
	 */	
	public function set condition(value:IExpressionNode):void
	{
		conditionNode.setChildAt(value.node, 0);
	}
	
	/**
	 * doc
	 */
	public function get labels():Vector.<ISwitchLabelNode>
	{
		// TODO Impl
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
	public function SwitchStatementNode(node:IParserNode)
	{
		super(node);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * TODO Docme
	 */
	public function newCase(label:String):ISwitchCaseNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.CASE, "case");
		ast.appendToken(TokenBuilder.newSpace());
		ast.addChild(AS3FragmentParser.parseExpression(label));
		ast.appendToken(TokenBuilder.newColumn());
		var cases:IParserNode = ASTUtil.newAST(AS3NodeKind.CASES);
		ast.addChild(cases);
		ASTUtil.addChildWithIndentation(block, ast);
		return new SwitchCaseNode(ast);
	}
	
	/**
	 * TODO Docme
	 */
	public function newDefault():ISwitchDefaultNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.DEFAULT, "default");
		ast.appendToken(TokenBuilder.newColumn());
		var cases:IParserNode = ASTUtil.newAST(AS3NodeKind.CASES);
		ast.addChild(cases);
		ASTUtil.addChildWithIndentation(block, ast);
		return new SwitchDefaultNode(ast);
	}
}
}