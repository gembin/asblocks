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
import org.teotigraphix.asblocks.api.IDocComment;
import org.teotigraphix.asblocks.api.IMetaData;
import org.teotigraphix.asblocks.api.IMetaDataParameter;
import org.teotigraphix.asblocks.utils.ASTUtil;
import org.teotigraphix.asblocks.utils.DocCommentUtil;

/**
 * The <code>IMetaData</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class MetaDataNode extends ScriptNode 
	implements IMetaData
{
	private function findParameterList():IParserNode
	{
		return node.getKind(AS3NodeKind.PARAMETER_LIST);
	}
	
	//--------------------------------------------------------------------------
	//
	//  IMetaData API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  parameter
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IMetaData#parameter
	 */
	public function get parameter():String
	{
		return null;
	}
	
	//----------------------------------
	//  name
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IMetaData#parameters
	 */
	public function get parameters():Vector.<IMetaDataParameter>
	{
		return null;
	}
	
	//----------------------------------
	//  label
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IMetaData#hasName
	 */
	public function get hasName():Boolean
	{
		return false;
	}
	
	//--------------------------------------------------------------------------
	//
	//  IDocCommentAware API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  description
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IDocCommentAware#description
	 */
	public function get description():String
	{
		return null;
	}
	
	/**
	 * @private
	 */	
	public function set description(value:String):void
	{
		documentation.description = value;
	}
	
	//----------------------------------
	//  documentation
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IDocCommentAware#documentation
	 */
	public function get documentation():IDocComment
	{
		return DocCommentUtil.createDocComment(node);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function MetaDataNode(node:IParserNode)
	{
		super(node);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IMetaData#addParameter()
	 */
	public function addParameter(value:String):IMetaDataParameter
	{
		return null;
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IMetaData#addNamedParameter()
	 */
	public function addNamedParameter(name:String, value:String):IMetaDataParameter
	{
		return null;
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IMetaData#addNamedStringParameter()
	 */
	public function addNamedStringParameter(name:String, value:String):IMetaDataParameter
	{
		var list:IParserNode = findParameterList();
		if (!list)
		{
			list = ASTUtil.newParentheticAST(
				AS3NodeKind.PARAMETER_LIST, 
				AS3NodeKind.LPAREN, "(", 
				AS3NodeKind.RPAREN, ")");
			node.addChild(list);
		}
		
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.PARAMETER);
		ast.addChild(ASTUtil.newNameAST(name));
		ast.appendToken(TokenBuilder.newAssign());
		ast.addChild(ASTUtil.newAST(AS3NodeKind.STRING, ASTBuilder.escapeString(value)));
		
		if (list.numChildren > 0)
		{
			list.appendToken(TokenBuilder.newComma());
			list.appendToken(TokenBuilder.newSpace());
		}
		
		list.addChild(ast);
		return new MetaDataParameterNode(ast);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IMetaData#getParameter()
	 */
	public function getParameter(name:String):IMetaDataParameter
	{
		return null;
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IMetaData#getParameterAt()
	 */
	public function getParameterAt(index:int):IMetaDataParameter
	{
		return null;
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IMetaData#getParameterValue()
	 */
	public function getParameterValue(name:String):String
	{
		return null;
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IMetaData#hasParameter()
	 */
	public function hasParameter(name:String):Boolean
	{
		return false;
	}
}
}