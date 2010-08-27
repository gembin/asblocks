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

package org.teotigraphix.as3blocks.impl
{

import org.teotigraphix.as3blocks.api.IArgumentNode;
import org.teotigraphix.as3blocks.api.IExpressionStatementNode;
import org.teotigraphix.as3blocks.api.IFunctionCommon;
import org.teotigraphix.as3blocks.api.IFunctionLiteralNode;
import org.teotigraphix.as3blocks.api.IStatementContainer;
import org.teotigraphix.as3blocks.api.IStatementNode;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;

/**
 * The <code>IFunctionLiteralNode</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class FunctionLiteralNode extends ExpressionNode 
	implements IFunctionLiteralNode
{
	private var functionMixin:IFunctionCommon;
	
	private var containerMixin:IStatementContainer;
	
	//--------------------------------------------------------------------------
	//
	//  IFunctionCommon API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  arguments
	//----------------------------------
	
	/**
	 * doc
	 */
	public function get arguments():Vector.<IArgumentNode>
	{
		return functionMixin.arguments;
	}
	
	//----------------------------------
	//  type
	//----------------------------------
	
	/**
	 * doc
	 */
	public function get type():String
	{
		return functionMixin.type;
	}
	
	/**
	 * @private
	 */	
	public function set type(value:String):void
	{
		functionMixin.type = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function FunctionLiteralNode(node:IParserNode)
	{
		super(node);
		
		functionMixin = new FunctionCommon(node);
		containerMixin = new StatementList(node.getKind(AS3NodeKind.BLOCK));
	}
	
	//--------------------------------------------------------------------------
	//
	//  IFunctionCommon API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * TODO Docme
	 */
	public function addParameter(name:String, 
								 type:String, 
								 defaultValue:String = null):IArgumentNode
	{
		return functionMixin.addParameter(name, type, defaultValue);
	}
	
	/**
	 * TODO Docme
	 */
	public function removeParameter(name:String):IArgumentNode
	{
		return functionMixin.removeParameter(name);
	}
	
	/**
	 * TODO Docme
	 */
	public function addRestParam(name:String):IArgumentNode
	{
		return functionMixin.addRestParam(name);
	}
	
	//--------------------------------------------------------------------------
	//
	//  IStatementContainer API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * TODO Docme
	 */
	public function addStatement(statement:String):IStatementNode
	{
		return containerMixin.addStatement(statement);
	}
	
	/**
	 * TODO Docme
	 */
	public function newExpressionStatement(statement:String):IExpressionStatementNode
	{
		return containerMixin.newExpressionStatement(statement);
	}
}
}