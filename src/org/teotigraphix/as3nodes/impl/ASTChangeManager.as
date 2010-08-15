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

import org.teotigraphix.as3nodes.api.IMetaDataNode;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3nodes.api.Modifier;
import org.teotigraphix.as3nodes.utils.ASTChangeEvent;
import org.teotigraphix.as3nodes.utils.ASTChangeKind;
import org.teotigraphix.as3nodes.utils.ASTNodeUtil;
import org.teotigraphix.as3parser.api.AS3NodeKind;
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
		
		addEventListener(AS3NodeKind.MODIFIER, modifierChangeHandler);
		addEventListener(AS3NodeKind.META, metaChangeHandler);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Protected AST :: Handlers
	//
	//--------------------------------------------------------------------------
	
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