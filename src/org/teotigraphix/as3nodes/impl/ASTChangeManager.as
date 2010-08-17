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

package org.teotigraphix.as3nodes.impl
{

import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;

import org.teotigraphix.as3nodes.api.IAttributeNode;
import org.teotigraphix.as3nodes.api.ICommentNode;
import org.teotigraphix.as3nodes.api.IConstantNode;
import org.teotigraphix.as3nodes.api.IDocTagNode;
import org.teotigraphix.as3nodes.api.IFunctionNode;
import org.teotigraphix.as3nodes.api.IIdentifierAware;
import org.teotigraphix.as3nodes.api.IIdentifierNode;
import org.teotigraphix.as3nodes.api.IMetaDataNode;
import org.teotigraphix.as3nodes.api.IMethodNode;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3nodes.api.Modifier;
import org.teotigraphix.as3nodes.utils.ASTChangeEvent;
import org.teotigraphix.as3nodes.utils.ASTChangeKind;
import org.teotigraphix.as3nodes.utils.ASTNodeUtil;
import org.teotigraphix.as3nodes.utils.NodeUtil;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.ASDocNodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.utils.ASTUtil;

/**
 * TODO DOCME
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class ASTChangeManager extends EventDispatcher
{
	public function ASTChangeManager()
	{
		super();
		
		addEventListener(AS3NodeKind.AS_DOC, asDocChangeHandler);
		addEventListener(ASDocNodeKind.DOCTAG, docTagChangeHandler);
		addEventListener(AS3NodeKind.MODIFIER, modifierChangeHandler);
		addEventListener(AS3NodeKind.META, metaChangeHandler);
		addEventListener(AS3NodeKind.NAME, nameChangeHandler);
		
		// members
		addEventListener(AS3NodeKind.CONST_LIST, constListChangeHandler);
		addEventListener(AS3NodeKind.VAR_LIST, varListChangeHandler);
		addEventListener(AS3NodeKind.GET, getChangeHandler);
		addEventListener(AS3NodeKind.SET, setChangeHandler);
		addEventListener(AS3NodeKind.FUNCTION, functionChangeHandler);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Protected AST :: Handlers
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Handles the AS3NodeKind.AS_DOC add/remove.
	 * 
	 * <p>
	 * <ul>
	 * <li><strong>event.parent</strong> : <code>ICommentAware</code></li>
	 * <li><strong>event.data</strong> : <code>ICommentNode</code></li>
	 * </ul>
	 * </p>
	 * 
	 * @param event The ASTChangeEvent event.
	 * @see org.teotigraphix.as3nodes.api.ICommentAware#setComment()
	 */
	protected function asDocChangeHandler(event:ASTChangeEvent):void
	{
		var commentNode:ICommentNode = event.data as ICommentNode;
		var node:IParserNode = INode(event.parent).node;
		var asDoc:IParserNode =  ASTUtil.getNode(AS3NodeKind.AS_DOC, node);
		
		if (event.kind == ASTChangeKind.ADD)
		{
			// if there is an existing as-doc node on node, remove it
			if (node.hasKind(AS3NodeKind.AS_DOC))
				node.removeKind(AS3NodeKind.AS_DOC);
			
			node.addChildAt(commentNode.node, node.numChildren - 1);
		}
		else if (event.kind == ASTChangeKind.REMOVE && asDoc)
		{
			node.removeKind(AS3NodeKind.AS_DOC);
		}
	}
	
	/**
	 * Handles the AS3NodeKind.DOCTAG add/remove.
	 * 
	 * <p>
	 * <ul>
	 * <li><strong>event.parent</strong> : <code>ICommentNode</code></li>
	 * <li><strong>event.data</strong> : <code>IDocTagNode</code></li>
	 * </ul>
	 * </p>
	 * 
	 * @param event The ASTChangeEvent event.
	 * @see org.teotigraphix.as3nodes.api.ICommentAware#addDocTag()
	 */
	protected function docTagChangeHandler(event:ASTChangeEvent):void
	{
		var comment:ICommentNode = event.parent as ICommentNode;
		var docTagNode:IDocTagNode = event.data as IDocTagNode;
		
		var node:IParserNode = INode(comment).node;
		var unit:IParserNode = node.getLastChild();
		var content:IParserNode = unit.getLastChild();
		
		var doctagList:IParserNode =  ASTUtil.getNode(ASDocNodeKind.DOCTAG_LIST, content);
		
		if (event.kind == ASTChangeKind.ADD)
		{
			if (!doctagList)
				doctagList = content.addChild(ASTNodeUtil.create(ASDocNodeKind.DOCTAG_LIST));
			
			doctagList.addChild(docTagNode.node);
		}
		else if (event.kind == ASTChangeKind.REMOVE && doctagList)
		{
			var len:int = doctagList.numChildren;
			for (var i:int = 0; i < len; i++)
			{
				if (doctagList.children[i] === docTagNode.node)
				{
					doctagList.children.splice(i, 1);
					break;
				}
			}
		}
	}
	
	/**
	 * Handles the AS3NodeKind.META add/remove.
	 * 
	 * <p>
	 * <ul>
	 * <li><strong>event.parent</strong> : <code>IMetaDataAware</code></li>
	 * <li><strong>event.data</strong> : <code>IMetaDataNode</code></li>
	 * </ul>
	 * </p>
	 * 
	 * @param event The ASTChangeEvent event.
	 * @see org.teotigraphix.as3nodes.api.IMetaDataAware#addMetaData()
	 */
	protected function metaChangeHandler(event:ASTChangeEvent):void
	{
		var metaData:IMetaDataNode = event.data as IMetaDataNode;
		var node:IParserNode = INode(event.parent).node;
		var metaList:IParserNode =  ASTUtil.getNode(AS3NodeKind.META_LIST, node);
		
		if (event.kind == ASTChangeKind.ADD)
		{
			if (!metaList)
				metaList = node.addChildAt(ASTNodeUtil.create(AS3NodeKind.META_LIST), node.numChildren - 1);
			
			metaList.addChild(metaData.node);
		}
		else if (event.kind == ASTChangeKind.REMOVE && metaList)
		{
			var len:int = metaList.numChildren;
			for (var i:int = 0; i < len; i++)
			{
				if (metaList.children[i] === metaData.node)
				{
					metaList.children.splice(i, 1);
					break;
				}
			}
		}
	}
	
	/**
	 * Handles the AS3NodeKind.MODIFIER add/remove.
	 * 
	 * <p>
	 * <ul>
	 * <li><strong>event.parent</strong> : <code>IModifierAware</code></li>
	 * <li><strong>event.data</strong> : <code>Modifier</code></li>
	 * </ul>
	 * </p>
	 * 
	 * @param event The ASTChangeEvent event.
	 * @see org.teotigraphix.as3nodes.api.IModifierAware#addModifier()
	 */
	protected function modifierChangeHandler(event:ASTChangeEvent):void
	{
		var modifier:Modifier = event.data as Modifier;
		var node:IParserNode = INode(event.parent).node;
		var modList:IParserNode =  ASTUtil.getNode(AS3NodeKind.MOD_LIST, node);
		
		if (event.kind == ASTChangeKind.ADD)
		{
			if (!modList)
				modList = node.addChildAt(ASTNodeUtil.create(AS3NodeKind.MOD_LIST), node.numChildren - 1);
			
			modList.addChild(ASTNodeUtil.createModifier(modifier.name));
		}
		else if (event.kind == ASTChangeKind.REMOVE && modList)
		{
			var len:int = modList.numChildren;
			for (var i:int = 0; i < len; i++)
			{
				if (modList.children[i].stringValue === modifier.name)
				{
					modList.children.splice(i, 1);
					break;
				}
			}
		}
	}
	
	/**
	 * Handles the AS3NodeKind.NAME add/remove.
	 * 
	 * <p>
	 * <ul>
	 * <li><strong>event.parent</strong> : <code>IIDentifierAware</code></li>
	 * <li><strong>event.data</strong> : <code>IIDentifierNode</code></li>
	 * </ul>
	 * </p>
	 * 
	 * @param event The ASTChangeEvent event.
	 * @see org.teotigraphix.as3nodes.api.IIDentifierAware#uid
	 */
	protected function nameChangeHandler(event:ASTChangeEvent):void
	{
		var idNode:IIdentifierNode = event.data as IIdentifierNode;
		var node:IParserNode = INode(event.parent).node;
		var nameNode:IParserNode = node.getKind(AS3NodeKind.NAME);
		
		if (event.kind == ASTChangeKind.ADD)
		{
			if (!nameNode)
			{
				node.addChildAt(ASTNodeUtil.createName(
					idNode.qualifiedName), node.numChildren - 1);
			}
			else
			{
				nameNode.stringValue = idNode.qualifiedName;
			}
		}
		else if (event.kind == ASTChangeKind.REMOVE)
		{
			node.removeKind(AS3NodeKind.NAME);
		}
	}
	
	/**
	 * Handles the AS3NodeKind.CONST_LIST add/remove.
	 * 
	 * <p>
	 * <ul>
	 * <li><strong>event.parent</strong> : <code>IClassTypeNode</code></li>
	 * <li><strong>event.data</strong> : <code>IConstantNode</code></li>
	 * </ul>
	 * </p>
	 * 
	 * @param event The ASTChangeEvent event.
	 * @see org.teotigraphix.as3nodes.api.ITypeNode#attributes
	 */
	protected function constListChangeHandler(event:ASTChangeEvent):void
	{
		var constantNode:IConstantNode = event.data as IConstantNode;
		var node:IParserNode = INode(event.parent).node;
		
		var content:IParserNode = node.getKind(AS3NodeKind.CONTENT);
		
		if (event.kind == ASTChangeKind.ADD)
		{
			if (!content)
				node.addChild(ASTNodeUtil.create(AS3NodeKind.CONTENT));
			
			content.addChild(constantNode.node);
		}
		else if (event.kind == ASTChangeKind.REMOVE && content)
		{
			content.removeChild(constantNode.node);
		}
	}
	
	/**
	 * Handles the AS3NodeKind.VAR_LIST add/remove.
	 * 
	 * <p>
	 * <ul>
	 * <li><strong>event.parent</strong> : <code>IClassTypeNode</code></li>
	 * <li><strong>event.data</strong> : <code>IAttributeNode</code></li>
	 * </ul>
	 * </p>
	 * 
	 * @param event The ASTChangeEvent event.
	 * @see org.teotigraphix.as3nodes.api.ITypeNode#attributes
	 */
	protected function varListChangeHandler(event:ASTChangeEvent):void
	{
		var attributeNode:IAttributeNode = event.data as IAttributeNode;
		var node:IParserNode = INode(event.parent).node;
		
		var content:IParserNode = node.getKind(AS3NodeKind.CONTENT);
		
		if (event.kind == ASTChangeKind.ADD)
		{
			if (!content)
				node.addChild(ASTNodeUtil.create(AS3NodeKind.CONTENT));
			
			content.addChild(attributeNode.node);
		}
		else if (event.kind == ASTChangeKind.REMOVE && content)
		{
			content.removeChild(attributeNode.node);
		}
	}
	
	/**
	 * Handles the AS3NodeKind.GET add/remove.
	 * 
	 * <p>
	 * <ul>
	 * <li><strong>event.parent</strong> : <code>ITypeNode</code></li>
	 * <li><strong>event.data</strong> : <code>IAccessorNode</code></li>
	 * </ul>
	 * </p>
	 * 
	 * @param event The ASTChangeEvent event.
	 * @see org.teotigraphix.as3nodes.api.ITypeNode#accessors
	 */
	protected function getChangeHandler(event:ASTChangeEvent):void
	{
	}
	
	/**
	 * Handles the AS3NodeKind.SET add/remove.
	 * 
	 * <p>
	 * <ul>
	 * <li><strong>event.parent</strong> : <code>ITypeNode</code></li>
	 * <li><strong>event.data</strong> : <code>IAccessorNode</code></li>
	 * </ul>
	 * </p>
	 * 
	 * @param event The ASTChangeEvent event.
	 * @see org.teotigraphix.as3nodes.api.ITypeNode#accessors
	 */
	protected function setChangeHandler(event:ASTChangeEvent):void
	{
	}
	
	/**
	 * Handles the AS3NodeKind.FUNCTION add/remove.
	 * 
	 * <p>
	 * <ul>
	 * <li><strong>event.parent</strong> : <code>ITypeNode</code></li>
	 * <li><strong>event.data</strong> : <code>IMethodNode</code></li>
	 * </ul>
	 * </p>
	 * 
	 * @param event The ASTChangeEvent event.
	 * @see org.teotigraphix.as3nodes.api.ITypeNode#methods
	 */
	protected function functionChangeHandler(event:ASTChangeEvent):void
	{
		var functionNode:IFunctionNode = event.data as IFunctionNode;
		var node:IParserNode = INode(event.parent).node;
		
		var content:IParserNode = node.getKind(AS3NodeKind.CONTENT);
		
		if (event.kind == ASTChangeKind.ADD)
		{
			if (!content)
				node.addChild(ASTNodeUtil.create(AS3NodeKind.CONTENT));
			
			content.addChild(functionNode.node);
		}
		else if (event.kind == ASTChangeKind.REMOVE && content)
		{
			content.removeChild(functionNode.node);
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//  Public Class :: Properties
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private static var _instance:IEventDispatcher;
	
	/**
	 * Returns the single instance of the ASTChangeManager.
	 */
	public static function get instance():IEventDispatcher
	{
		if (!_instance)
			_instance = new ASTChangeManager();
		return _instance;
	}
}
}