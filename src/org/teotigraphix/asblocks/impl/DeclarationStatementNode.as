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

import org.teotigraphix.asblocks.api.IDeclarationStatement;
import org.teotigraphix.asblocks.api.IScriptNode;
import org.teotigraphix.as3parser.api.IParserNode;

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
	 * @private
	 */
	private var _firstVarName:String;
	
	/**
	 * doc
	 */
	public function get firstVarName():String
	{
		return _firstVarName;
	}
	
	//----------------------------------
	//  firstVarType
	//----------------------------------
	
	/**
	 * doc
	 */
	public function get firstVarType():String
	{
		return _firstVarName;
	}
	
	//----------------------------------
	//  isConstant
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _isConstant:Boolean;
	
	/**
	 * doc
	 */
	public function get isConstant():Boolean
	{
		return _isConstant;
	}
	
	/**
	 * @private
	 */	
	public function set isConstant(value:Boolean):void
	{
		if (_isConstant == value)
			return;
		
		_isConstant = value;
	}
	
	//----------------------------------
	//  vars
	//----------------------------------
	
	/**
	 * doc
	 */
	public function get vars():Vector.<IScriptNode>
	{
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
	public function DeclarationStatementNode(node:IParserNode)
	{
		super(node);
	}
}
}