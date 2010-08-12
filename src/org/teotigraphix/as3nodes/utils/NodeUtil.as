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

package org.teotigraphix.as3nodes.utils
{

import org.teotigraphix.as3nodes.api.IClassTypeNode;
import org.teotigraphix.as3nodes.api.ICommentAware;
import org.teotigraphix.as3nodes.api.IFunctionNode;
import org.teotigraphix.as3nodes.api.IInterfaceTypeNode;
import org.teotigraphix.as3nodes.api.IMetaDataAware;
import org.teotigraphix.as3nodes.api.IModifierAware;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3nodes.api.IPackageNode;
import org.teotigraphix.as3nodes.api.IParameterAware;
import org.teotigraphix.as3nodes.api.ITypeNode;
import org.teotigraphix.as3nodes.api.Modifier;
import org.teotigraphix.as3nodes.impl.IdentifierNode;
import org.teotigraphix.as3nodes.impl.NodeFactory;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;

/**
 * Various INode utilities for computing specific node aware interfaces.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class NodeUtil
{
	//--------------------------------------------------------------------------
	//
	//  Public Class :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Computes the <code>node.imports</code>.
	 * 
	 * @param node An IPackageNode node.
	 * @param child The IParserNode internal node.
	 */
	public static function computeImports(node:IPackageNode, 
										  child:IParserNode):void
	{
		if (child.numChildren == 0)
			return;
		
		for each (var element:IParserNode in child.children)
		{
			if (element.isKind(AS3NodeKind.IMPORT))
			{
				node.addImport(new IdentifierNode(element, node));
			}
		}
	}
	
	/**
	 * Computes the <code>node.metaData</code>.
	 * 
	 * @param node An IMetaDataAware node.
	 * @param child The IParserNode internal node.
	 */
	public static function computeMetaDataList(node:IMetaDataAware, 
											   child:IParserNode):void
	{
		if (child.numChildren == 0)
			return;
		
		var len:int = child.children.length;
		for (var i:int = 0; i < len; i++)
		{
			var element:IParserNode = child.children[i] as IParserNode;
			node.addMetaData(NodeFactory.instance.createMetaData(element, INode(node)));
		}
	}
	
	/**
	 * Computes the <code>node.comment</code>.
	 * 
	 * @param node An ICommentAware node.
	 * @param child The IParserNode internal node.
	 */
	public static function computeAsDoc(node:ICommentAware, 
										child:IParserNode):void
	{
		//if (!child)
		//{
		//	node.comment = NodeFactory.instance.createCommentPlaceholderNode(node);
		//	return;
		//}
		
		node.comment = NodeFactory.instance.createComment(child, node);
	}
	
	/**
	 * Computes the <code>node.modifiers</code>.
	 * 
	 * @param node An IModifierAware node.
	 * @param child The IParserNode internal node.
	 */
	public static function computeModifierList(node:IModifierAware, 
											   child:IParserNode):void
	{
		if (child.numChildren == 0)
			return;
		
		var len:int = child.children.length;
		for (var i:int = 0; i < len; i++)
		{
			var element:IParserNode = child.children[i] as IParserNode;
			var modifier:Modifier = Modifier.create(element.stringValue);
			node.modifiers.push(modifier);
			//node.addModifier(modifier);
		}
	}
	
	/**
	 * Computes the <code>node.parameters</code>.
	 * 
	 * @param node An IParameterAware node.
	 * @param child The IParserNode internal node.
	 */
	public static function computeParameterList(node:IParameterAware, 
												child:IParserNode):void
	{
		if (!child || child.numChildren == 0)
			return;
		
		var len:int = child.children.length;
		for (var i:int = 0; i < len; i++)
		{
			node.parameters[i] = NodeFactory.instance.
				createParameter(child.children[i], node)
		}
	}
	
	/**
	 * Computes the <code>node.type</code>.
	 * 
	 * @param node An IFunctionNode node.
	 * @param child The IParserNode internal node.
	 */
	public static function computeReturnType(node:IFunctionNode, 
											 child:IParserNode):void
	{
		if (child && child.stringValue != "")
			node.type = NodeFactory.instance.createIdentifier(child, node);
	}
}
}