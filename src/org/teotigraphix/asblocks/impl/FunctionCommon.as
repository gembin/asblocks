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
import org.teotigraphix.as3parser.impl.AS3FragmentParser;
import org.teotigraphix.as3parser.impl.ASTIterator;
import org.teotigraphix.asblocks.api.IParameter;
import org.teotigraphix.asblocks.api.IFunctionCommon;
import org.teotigraphix.asblocks.utils.ASTUtil;

/**
 * The <code>IFunctionCommon</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class FunctionCommon implements IFunctionCommon
{
	private var node:IParserNode;
	
	//--------------------------------------------------------------------------
	//
	//  IFunctionCommon API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  arguments
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IFunctionCommon#arguments
	 */
	public function get parameters():Vector.<IParameter>
	{
		var result:Vector.<IParameter> = new Vector.<IParameter>();
		var paramList:IParserNode = findParameterList();
		if (!paramList)
			return result;
		
		var i:ASTIterator = new ASTIterator(paramList);
		while (i.hasNext())
		{
			result.push(new ParameterNode(i.next()));
		}
		
		return result;
	}
	
	//----------------------------------
	//  returnType
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IFunctionCommon#returnType
	 */
	public function get returnType():String
	{
		var t:IParserNode = node.getKind(AS3NodeKind.TYPE);
		if (t)
			return ASTUtil.typeText(t);
		return null;
	}
	
	/**
	 * @private
	 */	
	public function set returnType(value:String):void
	{
		// lambda/name-type-int/type
		var nameTypeInit:IParserNode = node.getKind(AS3NodeKind.NAME_TYPE_INIT);
		var existingType:IParserNode = nameTypeInit.getKind(AS3NodeKind.TYPE);
		if (value == null)
		{
			if (existingType != null)
			{
				nameTypeInit.removeChild(existingType);
			}
			return;
		}
		
		var newType:IParserNode = AS3FragmentParser.parseType(value);
		if (nameTypeInit == null) // SHOULDN'T BE
		{
			
		}
		else
		{
			nameTypeInit.setChildAt(newType, 0);
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
	public function FunctionCommon(node:IParserNode)
	{
		super();
		
		this.node = node;
	}
	
	//--------------------------------------------------------------------------
	//
	//  IFunctionCommon API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IFunctionCommon#addParameter()
	 */
	public function addParameter(name:String, 
								 type:String, 
								 defaultValue:String = null):IParameter
	{
		var ast:IParserNode = ASTUtil.newParamterAST();
		ast.addChild(ASTUtil.newNameAST(name));
		ast.appendToken(TokenBuilder.newColon());
		ast.addChild(ASTUtil.newTypeAST(type));
		if (defaultValue)
		{
			ast.appendToken(TokenBuilder.newSpace());
			ast.appendToken(TokenBuilder.newAssign());
			ast.appendToken(TokenBuilder.newSpace());
			ast.addChild(ASTUtil.newInitAST(defaultValue));
		}
		return createParameter(ast);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IFunctionCommon#removeParameter()
	 */
	public function removeParameter(name:String):IParameter
	{
		return null;
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IFunctionCommon#addRestParameter()
	 */
	public function addRestParameter(name:String):IParameter
	{
		return null;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Private :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private function findParameterList():IParserNode
	{
		return node.getKind(AS3NodeKind.PARAMETER_LIST);
	}
	
	/**
	 * @private
	 */
	private function createParameter(ast:IParserNode):IParameter
	{
		var paramList:IParserNode = node.getKind(AS3NodeKind.PARAMETER_LIST);
		if (paramList.numChildren > 0)
		{
			paramList.appendToken(TokenBuilder.newComma());
			paramList.appendToken(TokenBuilder.newSpace());
		}
		paramList.addChild(ast);
		return new ParameterNode(ast);
	}
}
}