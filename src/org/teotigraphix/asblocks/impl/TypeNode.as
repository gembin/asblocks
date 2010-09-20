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
import org.teotigraphix.as3parser.impl.ASTIterator;
import org.teotigraphix.asblocks.ASBlocksSyntaxError;
import org.teotigraphix.asblocks.api.IDocComment;
import org.teotigraphix.asblocks.api.IMetaData;
import org.teotigraphix.asblocks.api.IMethod;
import org.teotigraphix.asblocks.api.IType;
import org.teotigraphix.asblocks.api.Visibility;
import org.teotigraphix.asblocks.utils.ASTUtil;
import org.teotigraphix.asblocks.utils.DocCommentUtil;
import org.teotigraphix.asblocks.utils.MetaDataUtil;
import org.teotigraphix.asblocks.utils.ModifierUtil;

/**
 * The <code>IType</code> implementation and abstract base class for the
 * <code>ClassTypeNode</code>, <code>InterfaceTypeNode</code> and
 * <code>FunctionTypeNode</code>.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class TypeNode extends ScriptNode implements IType
{
	//--------------------------------------------------------------------------
	//
	//  IType API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  name
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IType#name
	 */
	public function get name():String
	{
		var i:ASTIterator = new ASTIterator(node);
		return i.find(AS3NodeKind.NAME).stringValue;
	}
	
	/**
	 * @private
	 */	
	public function set name(value:String):void
	{
		if (value == "")
		{
			throw new ASBlocksSyntaxError("Cannot set IType.name to an empty string");
		}
		else if (value == null)
		{
			throw new ASBlocksSyntaxError("Cannot set IType.name to null");
		}
		var i:ASTIterator = new ASTIterator(node);
		i.find(AS3NodeKind.NAME);
		i.replace(ASTUtil.newAST(AS3NodeKind.NAME, value));
	}
	
	//----------------------------------
	//  visibility
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IType#visibility
	 */
	public function get visibility():Visibility
	{
		return ModifierUtil.getVisibility(node);
	}
	
	/**
	 * @private
	 */	
	public function set visibility(value:Visibility):void
	{
		if (!value.equals(Visibility.PUBLIC))
		{
			throw new ASBlocksSyntaxError("IType visibility must be public");
		}
		return ModifierUtil.setVisibility(node, value);
	}
	
	//----------------------------------
	//  methods
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IType#methods
	 */
	public function get methods():Vector.<IMethod>
	{
		var result:Vector.<IMethod> = new Vector.<IMethod>();
		var i:ASTIterator = new ASTIterator(findContent());
		while (i.hasNext())
		{
			var member:IParserNode = i.next();
			if (member.isKind(AS3NodeKind.FUNCTION)
				|| member.isKind(AS3NodeKind.GET)
				|| member.isKind(AS3NodeKind.SET))
			{
				result.push(new MethodNode(member));
			}
		}
		return result;
	}
	
	//--------------------------------------------------------------------------
	//
	//  IMetaDataAware API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  metaDatas
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IMetaDataAware#metaDatas
	 */
	public function get metaDatas():Vector.<IMetaData>
	{
		return MetaDataUtil.getMetaDatas(node);
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
	public function TypeNode(node:IParserNode)
	{
		super(node);
	}
	
	//--------------------------------------------------------------------------
	//
	//  IType API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IType#newMethod()
	 */
	public function newMethod(name:String, 
							  visibility:Visibility, 
							  returnType:String):IMethod
	{
		return null;
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IType#getMethod()
	 */
	public function getMethod(name:String):IMethod
	{
		var i:ASTIterator = new ASTIterator(findContent());
		while (i.hasNext())
		{
			var member:IParserNode = i.next();
			if (member.isKind(AS3NodeKind.FUNCTION)
				|| member.isKind(AS3NodeKind.GET)
				|| member.isKind(AS3NodeKind.SET))
			{
				var meth:IMethod = new MethodNode(member);
				if (meth.name == name)
				{
					return meth;
				}
			}
		}
		return null;
	}
	
	/**
	 * @private
	 * FIXME add addMethod() to public api ?
	 */
	public function addMethod(method:IMethod):void
	{
		ASTUtil.addChildWithIndentation(findContent(), method.node);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IType#removeMethod()
	 */
	public function removeMethod(name:String):Boolean
	{
		var i:ASTIterator = new ASTIterator(findContent());
		while (i.hasNext())
		{
			var member:IParserNode = i.next();
			if (member.isKind(AS3NodeKind.FUNCTION)
				|| member.isKind(AS3NodeKind.GET)
				|| member.isKind(AS3NodeKind.SET))
			{
				var meth:IMethod = new MethodNode(member);
				if (meth.name == name)
				{
					i.remove();
					return true;
				}
			}
		}
		return false;
	}
	
	//--------------------------------------------------------------------------
	//
	//  IMetaDataAware API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IMetaDataAware#newMetaData()
	 */
	public function newMetaData(name:String):IMetaData
	{
		return MetaDataUtil.newMetaData(node, name);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IMetaDataAware#getMetaData()
	 */
	public function getMetaData(name:String):IMetaData
	{
		return MetaDataUtil.getMetaData(node, name);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IMetaDataAware#getAllMetaData()
	 */
	public function getAllMetaData(name:String):Vector.<IMetaData>
	{
		return MetaDataUtil.getAllMetaData(node, name);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IMetaDataAware#hasMetaData()
	 */
	public function hasMetaData(name:String):Boolean
	{
		return MetaDataUtil.hasMetaData(node, name);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IMetaDataAware#removeMetaData()
	 */
	public function removeMetaData(metaData:IMetaData):Boolean
	{
		return MetaDataUtil.removeMetaData(node, metaData);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Protected :: Properties
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	protected function findContent():IParserNode
	{
		return node.getKind(AS3NodeKind.CONTENT);
	}
}
}