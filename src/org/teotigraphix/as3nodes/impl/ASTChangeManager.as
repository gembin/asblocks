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

import org.teotigraphix.as3nodes.api.IAccessorNode;
import org.teotigraphix.as3nodes.api.IAttributeNode;
import org.teotigraphix.as3nodes.api.IBlockCommentNode;
import org.teotigraphix.as3nodes.api.IClassTypeNode;
import org.teotigraphix.as3nodes.api.ICommentNode;
import org.teotigraphix.as3nodes.api.IConstantNode;
import org.teotigraphix.as3nodes.api.IDocTagNode;
import org.teotigraphix.as3nodes.api.IFunctionNode;
import org.teotigraphix.as3nodes.api.IFunctionTypeNode;
import org.teotigraphix.as3nodes.api.IIdentifierNode;
import org.teotigraphix.as3nodes.api.IIncludeNode;
import org.teotigraphix.as3nodes.api.IInterfaceTypeNode;
import org.teotigraphix.as3nodes.api.IMetaDataNode;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3nodes.api.IPackageNode;
import org.teotigraphix.as3nodes.api.IParameterNode;
import org.teotigraphix.as3nodes.api.IUseNode;
import org.teotigraphix.as3nodes.api.Modifier;
import org.teotigraphix.as3nodes.utils.ASTChangeEvent;
import org.teotigraphix.as3nodes.utils.ASTChangeKind;
import org.teotigraphix.as3nodes.utils.ASTNodeUtil;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.ASDocNodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.utils.ASTUtil;

// FIXME implement setParent() and unsetParent() in relevent methods

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
		
		addEventListener(AS3NodeKind.IMPORT, importChangeHandler);
		addEventListener(AS3NodeKind.INCLUDE, includeChangeHandler);
		addEventListener(AS3NodeKind.USE, useChangeHandler);
		
		addEventListener(AS3NodeKind.AS_DOC, asDocChangeHandler);
		addEventListener(ASDocNodeKind.DOCTAG, docTagChangeHandler);
		addEventListener(AS3NodeKind.BLOCK_DOC, blockDocChangeHandler);
		addEventListener(AS3NodeKind.MODIFIER, modifierChangeHandler);
		addEventListener(AS3NodeKind.META, metaChangeHandler);
		addEventListener(AS3NodeKind.NAME, nameChangeHandler);
		addEventListener(AS3NodeKind.TYPE, typeChangeHandler);
		
		// types
		addEventListener(AS3NodeKind.CLASS, classChangeHandler);
		addEventListener(AS3NodeKind.INTERFACE, interfaceChangeHandler);
		
		// members
		addEventListener(AS3NodeKind.CONST_LIST, constListChangeHandler);
		addEventListener(AS3NodeKind.VAR_LIST, varListChangeHandler);
		addEventListener(AS3NodeKind.GET, getChangeHandler);
		addEventListener(AS3NodeKind.SET, setChangeHandler);
		addEventListener(AS3NodeKind.FUNCTION, functionChangeHandler);
		addEventListener(AS3NodeKind.PARAMETER, parameterChangeHandler);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Protected AST :: Handlers
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Handles the AS3NodeKind.IMPORT add/remove.
	 * 
	 * <p>
	 * <ul>
	 * <li><strong>event.parent</strong> : <code>IPackageNode</code></li>
	 * <li><strong>event.data</strong> : <code>IIdentifierNode</code></li>
	 * </ul>
	 * </p>
	 * 
	 * @param event The ASTChangeEvent event.
	 * @see org.teotigraphix.as3nodes.api.IPackageNode#imports
	 */
	protected function importChangeHandler(event:ASTChangeEvent):void
	{
		var uidNode:IIdentifierNode = event.data as IIdentifierNode;
		var node:IParserNode = INode(event.parent).node;
		
		var content:IParserNode = node.getKind(AS3NodeKind.CONTENT);
		
		if (event.kind == ASTChangeKind.ADD)
		{
			if (!content)
				content = node.addChild(ASTNodeUtil.create(AS3NodeKind.CONTENT));
			
			content.addChildAt(uidNode.node, content.numChildren - 1);
			
			setParent(uidNode, event.parent);
		}
		else if (event.kind == ASTChangeKind.REMOVE)
		{
			node.removeChild(uidNode.node);
			
			unsetParent(uidNode);
		}
	}
	
	/**
	 * Handles the AS3NodeKind.INCLUDE add/remove.
	 * 
	 * <p>
	 * <ul>
	 * <li><strong>event.parent</strong> : <code>IPackageNode</code></li>
	 * <li><strong>event.data</strong> : <code>IIncludeNode</code></li>
	 * </ul>
	 * </p>
	 * 
	 * @param event The ASTChangeEvent event.
	 * @see org.teotigraphix.as3nodes.api.IPackageNode#includes
	 */
	protected function includeChangeHandler(event:ASTChangeEvent):void
	{
		var uidNode:IIncludeNode = event.data as IIncludeNode;
		var node:IParserNode = INode(event.parent).node;
		
		var content:IParserNode = node.getKind(AS3NodeKind.CONTENT);
		
		if (event.kind == ASTChangeKind.ADD)
		{
			if (!content)
				content = node.addChild(ASTNodeUtil.create(AS3NodeKind.CONTENT));
			
			content.addChildAt(uidNode.node, content.numChildren - 1);
			
			setParent(uidNode, event.parent);
		}
		else if (event.kind == ASTChangeKind.REMOVE)
		{
			node.removeChild(uidNode.node);
			
			unsetParent(uidNode);
		}
	}
	
	/**
	 * Handles the AS3NodeKind.USE add/remove.
	 * 
	 * <p>
	 * <ul>
	 * <li><strong>event.parent</strong> : <code>IPackageNode</code></li>
	 * <li><strong>event.data</strong> : <code>IUseNode</code></li>
	 * </ul>
	 * </p>
	 * 
	 * @param event The ASTChangeEvent event.
	 * @see org.teotigraphix.as3nodes.api.IPackageNode#uses
	 */
	protected function useChangeHandler(event:ASTChangeEvent):void
	{
		var uidNode:IUseNode = event.data as IUseNode;
		var node:IParserNode = INode(event.parent).node;
		
		var content:IParserNode = node.getKind(AS3NodeKind.CONTENT);
		
		if (event.kind == ASTChangeKind.ADD)
		{
			if (!content)
				content = node.addChild(ASTNodeUtil.create(AS3NodeKind.CONTENT));
			
			content.addChildAt(uidNode.node, content.numChildren - 1);
			
			setParent(uidNode, event.parent);
		}
		else if (event.kind == ASTChangeKind.REMOVE)
		{
			node.removeChild(uidNode.node);
			
			unsetParent(uidNode);
		}
	}
	
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
	 * Handles the AS3NodeKind.BLOCK_DOC add/remove.
	 * 
	 * <p>
	 * <ul>
	 * <li><strong>event.parent</strong> : <code>IBlockCommentAware</code></li>
	 * <li><strong>event.data</strong> : <code>IBlockCommentNode</code></li>
	 * </ul>
	 * </p>
	 * 
	 * @param event The ASTChangeEvent event.
	 * @see org.teotigraphix.as3nodes.api.IBlockCommentAware#setBlockComment()
	 */
	protected function blockDocChangeHandler(event:ASTChangeEvent):void
	{
		var blockCommentNode:IBlockCommentNode = event.data as IBlockCommentNode;
		var node:IParserNode = INode(event.parent).node;
		var blockDoc:IParserNode =  ASTUtil.getNode(AS3NodeKind.BLOCK_DOC, node);
		
		if (event.kind == ASTChangeKind.ADD)
		{
			// if there is an existing block-doc node on node, remove it
			if (blockDoc)
				node.removeChild(blockDoc);
			
			node.addChildAt(blockCommentNode.node, node.numChildren - 1);
		}
		else if (event.kind == ASTChangeKind.REMOVE && blockDoc)
		{
			if (blockDoc)
				node.removeChild(blockDoc);
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
	 * Handles the AS3NodeKind.TYPE add/remove.
	 * 
	 * <p>
	 * <ul>
	 * <li><strong>event.parent</strong> : <code>TODO</code></li>
	 * <li><strong>event.data</strong> : <code>TODO</code></li>
	 * </ul>
	 * </p>
	 * 
	 * @param event The ASTChangeEvent event.
	 */
	protected function typeChangeHandler(event:ASTChangeEvent):void
	{
		var idNode:IIdentifierNode = event.data as IIdentifierNode;
		var node:IParserNode = INode(event.parent).node;
		var typeNode:IParserNode = node.getKind(AS3NodeKind.TYPE);
		
		if (event.kind == ASTChangeKind.ADD)
		{
			if (!typeNode)
			{
				node.addChildAt(ASTNodeUtil.createType(
					idNode.qualifiedName), node.numChildren - 1);
			}
			else
			{
				typeNode.stringValue = idNode.qualifiedName;
			}
		}
		else if (event.kind == ASTChangeKind.REMOVE)
		{
			node.removeKind(AS3NodeKind.TYPE);
		}
	}
	
	/**
	 * Handles the AS3NodeKind.CLASS add/remove.
	 * 
	 * <p>
	 * <ul>
	 * <li><strong>event.parent</strong> : <code>IPackageNode</code></li>
	 * <li><strong>event.data</strong> : <code>IClassTypeNode</code></li>
	 * </ul>
	 * </p>
	 * 
	 * @param event The ASTChangeEvent event.
	 * @see org.teotigraphix.as3nodes.api.IPackageNode#typeNode
	 */
	protected function classChangeHandler(event:ASTChangeEvent):void
	{
		var classNode:IClassTypeNode = event.data as IClassTypeNode;
		var node:IParserNode = INode(event.parent).node;
		
		var content:IParserNode = node.getKind(AS3NodeKind.CONTENT);
		// TODO check for existing class node on content node
		
		if (event.kind == ASTChangeKind.ADD)
		{
			if (!content)
				node.addChild(ASTNodeUtil.create(AS3NodeKind.CONTENT));
			
			content.addChild(classNode.node);
			setParent(classNode, event.parent);
		}
		else if (event.kind == ASTChangeKind.REMOVE && content)
		{
			content.removeChild(classNode.node);
			unsetParent(classNode);
		}
	}
	
	/**
	 * Handles the AS3NodeKind.INTERFACE add/remove.
	 * 
	 * <p>
	 * <ul>
	 * <li><strong>event.parent</strong> : <code>IPackageNode</code></li>
	 * <li><strong>event.data</strong> : <code>IInterfaceTypeNode</code></li>
	 * </ul>
	 * </p>
	 * 
	 * @param event The ASTChangeEvent event.
	 * @see org.teotigraphix.as3nodes.api.IPackageNode#typeNode
	 */
	protected function interfaceChangeHandler(event:ASTChangeEvent):void
	{
		var interfaceNode:IInterfaceTypeNode = event.data as IInterfaceTypeNode;
		var node:IParserNode = INode(event.parent).node;
		
		var content:IParserNode = node.getKind(AS3NodeKind.CONTENT);
		// TODO check for existing interface node on content node
		
		if (event.kind == ASTChangeKind.ADD)
		{
			if (!content)
				node.addChild(ASTNodeUtil.create(AS3NodeKind.CONTENT));
			
			content.addChild(interfaceNode.node);
			setParent(interfaceNode, event.parent);
		}
		else if (event.kind == ASTChangeKind.REMOVE && content)
		{
			content.removeChild(interfaceNode.node);
			unsetParent(interfaceNode);
		}
	}
	
	/**
	 * Handles the AS3NodeKind.FUNCTION (global) add/remove.
	 * 
	 * <p>Called from <code>functionChangeHandler()</code>.</p>
	 * 
	 * <p>
	 * <ul>
	 * <li><strong>event.parent</strong> : <code>IPackageNode</code></li>
	 * <li><strong>event.data</strong> : <code>IFunctionTypeNode</code></li>
	 * </ul>
	 * </p>
	 * 
	 * @param event The ASTChangeEvent event.
	 * @see org.teotigraphix.as3nodes.api.IPackageNode#typeNode
	 */
	protected function functionTypeChangeHandler(event:ASTChangeEvent):void
	{
		var functionNode:IFunctionTypeNode = event.data as IFunctionTypeNode;
		var node:IParserNode = INode(event.parent).node;
		
		var content:IParserNode = node.getKind(AS3NodeKind.CONTENT);
		// TODO check for existing interface node on content node
		
		if (event.kind == ASTChangeKind.ADD)
		{
			if (!content)
				node.addChild(ASTNodeUtil.create(AS3NodeKind.CONTENT));
			
			content.addChild(functionNode.node);
			setParent(functionNode, event.parent);
		}
		else if (event.kind == ASTChangeKind.REMOVE && content)
		{
			content.removeChild(functionNode.node);
			unsetParent(functionNode);
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
		var functionNode:IAccessorNode = event.data as IAccessorNode;
		var node:IParserNode = INode(event.parent).node;
		
		var content:IParserNode = node.getKind(AS3NodeKind.CONTENT);
		
		if (event.kind == ASTChangeKind.ADD)
		{
			if (!content)
				content = node.addChild(ASTNodeUtil.create(AS3NodeKind.CONTENT));
			
			content.addChild(functionNode.node);
		}
		else if (event.kind == ASTChangeKind.REMOVE && content)
		{
			content.removeChild(functionNode.node);
		}
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
		var functionNode:IAccessorNode = event.data as IAccessorNode;
		var node:IParserNode = INode(event.parent).node;
		
		var content:IParserNode = node.getKind(AS3NodeKind.CONTENT);
		
		if (event.kind == ASTChangeKind.ADD)
		{
			if (!content)
				content = node.addChild(ASTNodeUtil.create(AS3NodeKind.CONTENT));
			
			content.addChild(functionNode.node);
		}
		else if (event.kind == ASTChangeKind.REMOVE && content)
		{
			content.removeChild(functionNode.node);
		}
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
		if (event.data is IFunctionTypeNode)
		{
			functionTypeChangeHandler(event);
			return;
		}
		
		var functionNode:IFunctionNode = event.data as IFunctionNode;
		var node:IParserNode = INode(event.parent).node;
		
		var content:IParserNode = node.getKind(AS3NodeKind.CONTENT);
		
		if (event.kind == ASTChangeKind.ADD)
		{
			if (!content)
				content = node.addChild(ASTNodeUtil.create(AS3NodeKind.CONTENT));
			
			content.addChild(functionNode.node);
		}
		else if (event.kind == ASTChangeKind.REMOVE && content)
		{
			content.removeChild(functionNode.node);
		}
	}
	
	/**
	 * Handles the AS3NodeKind.PARAMETER add/remove.
	 * 
	 * <p>
	 * <ul>
	 * <li><strong>event.parent</strong> : <code>IParameterAware</code></li>
	 * <li><strong>event.data</strong> : <code>IParameterNode</code></li>
	 * </ul>
	 * </p>
	 * 
	 * @param event The ASTChangeEvent event.
	 * @see org.teotigraphix.as3nodes.api.IParameterAware#parameters
	 */
	protected function parameterChangeHandler(event:ASTChangeEvent):void
	{
		var parameterNode:IParameterNode = event.data as IParameterNode;
		var node:IParserNode = INode(event.parent).node;
		
		var parameterList:IParserNode = node.getKind(AS3NodeKind.PARAMETER_LIST);
		
		if (event.kind == ASTChangeKind.ADD)
		{
			if (!parameterList)
				parameterList = node.addChild(ASTNodeUtil.create(AS3NodeKind.PARAMETER_LIST));
			
			parameterList.addChild(parameterNode.node);
		}
		else if (event.kind == ASTChangeKind.REMOVE && parameterList)
		{
			parameterList.removeChild(parameterNode.node);
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//  Protected :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	protected function setParent(client:INode, parent:INode):void
	{
		if (client.parent != parent)
			client.parent = parent;
	}
	
	/**
	 * @private
	 */
	protected function unsetParent(client:INode):void
	{
		client.parent = null;
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