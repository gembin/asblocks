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

package org.teotigraphix.as3book.impl
{

import com.ericfeminella.collections.HashMap;
import com.ericfeminella.collections.IMap;

import flash.events.EventDispatcher;

import org.teotigraphix.as3book.api.IAS3Book;
import org.teotigraphix.as3book.api.IAS3BookAccessor;
import org.teotigraphix.as3book.api.IAS3BookProcessor;
import org.teotigraphix.as3nodes.api.IAS3SourceFile;
import org.teotigraphix.as3nodes.api.IClassTypeNode;
import org.teotigraphix.as3nodes.api.ICompilationNode;
import org.teotigraphix.as3nodes.api.IConstantNode;
import org.teotigraphix.as3nodes.api.IFunctionTypeNode;
import org.teotigraphix.as3nodes.api.IInterfaceTypeNode;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3nodes.api.IPackageNode;
import org.teotigraphix.as3nodes.api.ISeeLinkAware;
import org.teotigraphix.as3nodes.api.ISourceFile;
import org.teotigraphix.as3nodes.api.ISourceFileCollection;
import org.teotigraphix.as3nodes.api.ITypeNode;
import org.teotigraphix.as3nodes.impl.SeeLink;
import org.teotigraphix.as3nodes.impl.SourceFileCollection;
import org.teotigraphix.as3parser.api.AS3NodeKind;

/**
 * The concrete implementation of the <code>IAS3Book</code> API.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class AS3Book extends EventDispatcher implements IAS3Book
{
	/**
	 * @private
	 */
	private var _processor:IAS3BookProcessor;
	
	/**
	 * @private
	 */
	private var sourceFiles:IMap = new HashMap();
	
	/**
	 * @private
	 */
	internal var sourceFileCollections:Vector.<ISourceFileCollection> =
		new Vector.<ISourceFileCollection>();
	
	/**
	 * @private
	 */
	internal var types:Vector.<ITypeNode> = new Vector.<ITypeNode>();
	
	/**
	 * @private
	 */
	internal var placeholders:IMap = new HashMap();
	
	/**
	 * @private
	 */
	internal var classes:IMap = new HashMap();
	
	/**
	 * @private
	 */
	internal var interfaces:IMap = new HashMap();
	
	/**
	 * @private
	 */
	internal var functions:IMap = new HashMap();
	
	/**
	 * @private
	 * of [toLink() => Vector.<ITypeNode>]
	 */
	internal var superclasses:IMap = new HashMap();
	
	/**
	 * @private
	 * of [toLink() => Vector.<ITypeNode>]
	 */
	internal var subclasses:IMap = new HashMap();
	
	/**
	 * @private
	 * of [toLink() => Vector.<ITypeNode>]
	 */
	internal var implementedinterfaces:IMap = new HashMap();
	
	/**
	 * @private
	 * of [toLink() => Vector.<ITypeNode>]
	 */
	internal var interfaceImplementors:IMap = new HashMap();
	
	/**
	 * @private
	 * of [toLink() => Vector.<ITypeNode>]
	 */
	internal var superInterfaces:IMap = new HashMap();
	
	/**
	 * @private
	 * of [toLink() => Vector.<ITypeNode>]
	 */
	internal var subInterfaces:IMap = new HashMap();
	
	/**
	 * @private
	 * of [toLink() => Vector.<ISeeLink>]
	 */
	internal var links:IMap = new HashMap();
	
	/**
	 * @private
	 * of [toLink() => Vector.<IConstantNode>]
	 */
	internal var constants:IMap = new HashMap();
	
	/**
	 * @private
	 * of [toLink() => Vector.<IAttributeNode>]
	 */
	internal var attributes:IMap = new HashMap();
	
	/**
	 * @private
	 * of [toLink() => Vector.<IAccessorNode>]
	 */
	internal var accessors:IMap = new HashMap();
	
	/**
	 * @private
	 * of [toLink() => Vector.<IMethodNode>]
	 */
	internal var methods:IMap = new HashMap();
	
	//--------------------------------------------------------------------------
	//
	//  IAS3Book API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  access
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _access:IAS3BookAccessor;
	
	/**
	 * @copy org.teotigraphix.as3book.api.IAS3BookAccessor#access
	 */
	public function get access():IAS3BookAccessor
	{
		return _access;
	}
	
	/**
	 * @private
	 */	
	public function set access(value:IAS3BookAccessor):void
	{
		_access = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function AS3Book(processor:IAS3BookProcessor, 
							accessor:IAS3BookAccessor)
	{
		super();
		
		_processor = processor;
		_processor.book = this;
		
		_access = accessor;
		_access.book = this;
	}
	
	//--------------------------------------------------------------------------
	//
	//  IAS3Book API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.teotigraphix.as3book.api.IAS3BookAccessor#addSourceFile()
	 */
	public function addSourceFile(sourceFile:ISourceFile):void
	{
		// - ISourceFile
		//   - ICompilationNode
		//     - IPackageNode
		
		// add the SourceFile to the map
		sourceFiles.put(sourceFile.toLink(), sourceFile);
		
		addSourceFileCollection(IAS3SourceFile(sourceFile));
		
		addCompilationNode(sourceFile.compilationNode);
	}
	
	/**
	 * @private
	 */
	private function addSourceFileCollection(sourceFile:IAS3SourceFile):void
	{
		// this creates a new package that is unique to 'my.domain' or 'my.other.domain'
		var path:String = sourceFile.fileName;
		
		for each (var collection:ISourceFileCollection in sourceFileCollections)
		{
			if (collection.name == sourceFile.packageName)
				return;
		}
		
		var newCollection:ISourceFileCollection = 
			new SourceFileCollection(path, sourceFile.packageName);
		
		sourceFileCollections.push(newCollection);
	}
	
	/**
	 * @private
	 */
	private function addCompilationNode(node:ICompilationNode):void
	{
		var packageNode:IPackageNode = node.packageNode;
		var typeNode:ITypeNode = packageNode.typeNode;
		
		//addImportNodes(packageNode.imports);
		// TODO impl IPackageNode.uses
		//addUseNodes(packageNode.uses);
		
		types.push(packageNode.typeNode);
		
		if (typeNode.node.isKind(AS3NodeKind.CLASS))
		{
			addClassNode(IClassTypeNode(typeNode));
			addConstants(IClassTypeNode(typeNode).constants);
		}
		else if (typeNode.node.isKind(AS3NodeKind.INTERFACE))
		{
			addInterfaceNode(IInterfaceTypeNode(typeNode));
		}
		else if (typeNode.node.isKind(AS3NodeKind.FUNCTION))
		{
			addFunctionNode(IFunctionTypeNode(typeNode));
		}
	}
	
	/**
	 * @private
	 */
	private function addClassNode(node:IClassTypeNode):void
	{
		classes.put(node.toLink(), node);
	}
	
	/**
	 * @private
	 */
	private function addInterfaceNode(node:IInterfaceTypeNode):void
	{
		interfaces.put(node.toLink(), node);
	}
	
	/**
	 * @private
	 */
	private function addFunctionNode(node:IFunctionTypeNode):void
	{
		functions.put(node.toLink(), node);
	}
	
	/**
	 * @private
	 */
	private function addConstants(nodes:Vector.<IConstantNode>):void
	{
		if (nodes == null)
			return;
		
		for each (var node:IConstantNode in nodes)
		{
			if (node.comment.hasDocTag("private"))
				continue;
			
			addConstant(node);
		}
	}
	
	/**
	 * @private
	 */
	private function addConstant(node:IConstantNode):void
	{
		var link:String = ISeeLinkAware(node.parent).toLink();
		var list:Vector.<IConstantNode> = constants.getValue(link);
		
		if (list == null)
		{
			list = new Vector.<IConstantNode>();
			constants.put(link, list);
		}
		
		list.push(node);
		
		addLink(node);
	}
	
	public function addLink(node:ISeeLinkAware):void
	{
		var link:String = node.toLink();
		
		if (links.containsKey(link))
		{
			trace("ERROR addLink(); key exists [" + link + "]");
			return;
		}
		
		links.put(link, new SeeLink(INode(node)));
	}
	
	/**
	 * @copy org.teotigraphix.as3book.api.IAS3BookAccessor#process()
	 */
	public function process():void
	{
		_processor.process();
	}
}
}