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
import org.teotigraphix.asblocks.api.IScriptNode;
import org.teotigraphix.asblocks.api.IStatementContainer;
import org.teotigraphix.asblocks.api.ISwitchCaseNode;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.utils.ASTUtil;

/**
 * The <code>ISwitchCaseNode</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class SwitchCaseNode extends ContainerDelegate implements ISwitchCaseNode
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	override protected function get statementContainer():IStatementContainer
	{
		return new StatementList(node.getChild(1));
	}
	
	//----------------------------------
	//  label
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _label:IExpressionNode;
	
	/**
	 * doc
	 */
	public function get label():IExpressionNode
	{
		return _label;
	}
	
	/**
	 * @private
	 */	
	public function set label(value:IExpressionNode):void
	{
		if (_label == value)
			return;
		
		_label = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function SwitchCaseNode(node:IParserNode)
	{
		super(node);
	}
}
}