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
import org.teotigraphix.asblocks.ASBlocksSyntaxError;
import org.teotigraphix.asblocks.api.ICatchClause;
import org.teotigraphix.asblocks.api.IFinallyClause;
import org.teotigraphix.asblocks.api.IStatementContainer;
import org.teotigraphix.asblocks.api.ITryStatement;

/**
 * The <code>ITryStatement</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class TryStatementNode extends ContainerDelegate 
	implements ITryStatement
{
	override protected function get statementContainer():IStatementContainer
	{
		return new StatementList(node.getChild(1)); // block
	}
	
	//--------------------------------------------------------------------------
	//
	//  ITryStatement API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  catchClauses
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.ITryStatement#catchClauses
	 */
	public function get catchClauses():Vector.<ICatchClause>
	{
		return null;
	}
	
	//----------------------------------
	//  finallyClause
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.ITryStatement#finallyClause
	 */
	public function get finallyClause():IFinallyClause
	{
		var ast:IParserNode = finallyClauseNode;
		if (!ast)
			return null;
		return new FinallyClause(ast);
	}
	
	private function get finallyClauseNode():IParserNode
	{
		return node.getKind(AS3NodeKind.FINALLY);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function TryStatementNode(node:IParserNode)
	{
		super(node);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.ITryStatement#newCatchClause()
	 */
	public function newCatchClause(name:String, type:String):ICatchClause
	{
		return null;
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.ITryStatement#newFinallyClause()
	 */
	public function newFinallyClause():IFinallyClause
	{
		var ast:IParserNode = finallyClauseNode;
		if (ast)
		{
			throw new ASBlocksSyntaxError("only one finally-clause allowed");
		}
		ast = ASTBuilder.newFinallyClause();
		node.addChild(ast);
		return new FinallyClause(ast);
	}
}
}