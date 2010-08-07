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
import org.teotigraphix.as3nodes.api.IAccessorNode;
import org.teotigraphix.as3nodes.api.IAttributeNode;
import org.teotigraphix.as3nodes.api.IClassTypeNode;
import org.teotigraphix.as3nodes.api.ICompilationNode;
import org.teotigraphix.as3nodes.api.IConstantNode;
import org.teotigraphix.as3nodes.api.IFunctionTypeNode;
import org.teotigraphix.as3nodes.api.IInterfaceTypeNode;
import org.teotigraphix.as3nodes.api.IMethodNode;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3nodes.api.IPackageNode;
import org.teotigraphix.as3nodes.api.IParameterNode;
import org.teotigraphix.as3nodes.api.ISeeLinkAware;
import org.teotigraphix.as3nodes.api.ISourceFile;
import org.teotigraphix.as3nodes.api.ISourceFilePackage;
import org.teotigraphix.as3nodes.api.ITypeNode;
import org.teotigraphix.as3nodes.impl.SeeLink;
import org.teotigraphix.as3nodes.impl.SourceFilePackage;
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
	internal var sourceFilePackages:Vector.<ISourceFilePackage> =
		new Vector.<ISourceFilePackage>();
	
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
	 * of [toLink() => ISeeLink]
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
	 * @copy org.teotigraphix.as3book.api.IAS3Book#access
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
	 * @copy org.teotigraphix.as3book.api.IAS3Book#addSourceFile()
	 */
	public function addSourceFile(sourceFile:ISourceFile):void
	{
		// - ISourceFile
		//   - ICompilationNode
		//     - IPackageNode
		
		// TODO Check for duplicates
		
		// add the SourceFile to the map
		sourceFiles.put(sourceFile.toLink(), sourceFile);
		
		addSourceFilePackage(IAS3SourceFile(sourceFile));
		
		addCompilationNode(sourceFile.compilationNode);
	}
	
	/**
	 * @copy org.teotigraphix.as3book.api.IAS3Book#addLink()
	 */
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
	 * @copy org.teotigraphix.as3book.api.IAS3Book#process()
	 */
	public function process():void
	{
		_processor.process();
	}
	
	/**
	 * @private
	 */
	private function addSourceFilePackage(sourceFile:IAS3SourceFile):void
	{
		var sourceFilePackage:ISourceFilePackage;
		
		// this creates a new package that is unique to 'my.domain' or 'my.other.domain'
		if (access.hasSourceFilePackage(sourceFile.packageName))
			sourceFilePackage = access.getSourceFilePackage(sourceFile.packageName);
		
		if (!sourceFilePackage)
		{
			sourceFilePackage = new SourceFilePackage(
				sourceFile.fileName, sourceFile.packageName);
		}
		
		sourceFilePackages.push(sourceFilePackage);
		sourceFilePackage.addSourceFile(sourceFile);
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
			addAttributes(IClassTypeNode(typeNode).attributes);
			addAccessors(typeNode.getters, typeNode.setters);
			addMethods(typeNode.methods);
		}
		else if (typeNode.node.isKind(AS3NodeKind.INTERFACE))
		{
			addInterfaceNode(IInterfaceTypeNode(typeNode));
			
			addAccessors(typeNode.getters, typeNode.setters);
			addMethods(typeNode.methods);
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
	private function addAttributes(nodes:Vector.<IAttributeNode>):void
	{
		if (nodes == null)
			return;
		
		for each (var node:IAttributeNode in nodes)
		{
			if (node.comment.hasDocTag("private"))
				continue;
			
			addAttribute(node);
		}
	}
	
	/**
	 * @private
	 */
	private function addAccessors(getters:Vector.<IAccessorNode>,
								  setters:Vector.<IAccessorNode>):void
	{
		var getter:IAccessorNode;
		var setter:IAccessorNode;
		// FIXME this will need to search superclasses as well
		// this is probably not the place to do this
		
		// need to merge the accessors into ONE element, the content
		// will still hold all the original information
		if (getters != null)
		{
			for each (getter in getters)
			{
				// find the setter
				setter = findMirrorAccessor(getter, setters);
				
				if (setter != null)
				{
					getter.access = "read-write";
					setter.access = "read-write";
				}
				else
				{
					getter.access = "read";
				}
				
				addAccessor(getter);
				ITypeNode(getter.parent).addAccessor(getter);
			}
		}
		
		if (setters != null)
		{
			for each (setter in setters)
			{
				if (!setter.isReadWrite)
				{
					setter.access = "write";
					
					// need to take the param type and put it into setType()
					var parameter:IParameterNode = setter.parameters[0];
					setter.type = parameter.type;
					
					addAccessor(setter);
					ITypeNode(setter.parent).addAccessor(setter);
				}
			}
		}
	}
	
	/**
	 * @private
	 */
	private function addMethods(nodes:Vector.<IMethodNode>):void
	{
		if (nodes == null)
			return;
		
		for each (var node:IMethodNode in nodes)
		{
			if (node.comment.hasDocTag("private"))
				continue;
			
			addMethod(node);
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
	
	/**
	 * @private
	 */
	private function addAttribute(node:IAttributeNode):void
	{
		var link:String = ISeeLinkAware(node.parent).toLink();
		var list:Vector.<IAttributeNode> = attributes.getValue(link);
		
		if (list == null)
		{
			list = new Vector.<IAttributeNode>();
			attributes.put(link, list);
		}
		
		list.push(node);
		
		addLink(node);
	}
	
	/**
	 * @private
	 */
	private function addAccessor(node:IAccessorNode):void
	{
		var link:String = ISeeLinkAware(node.parent).toLink();
		var list:Vector.<IAccessorNode> = accessors.getValue(link);
		
		if (list == null)
		{
			list = new Vector.<IAccessorNode>();
			accessors.put(link, list);
		}
		
		list.push(node);
		
		addLink(node);
	}
	
	/**
	 * @private
	 */
	private function addMethod(node:IMethodNode):void
	{
		var link:String = ISeeLinkAware(node.parent).toLink();
		var list:Vector.<IMethodNode> = methods.getValue(link);
		
		if (list == null)
		{
			list = new Vector.<IMethodNode>();
			methods.put(link, list);
		}
		
		list.push(node);
		
		addLink(node);
	}
	
	private static function findMirrorAccessor(node:IAccessorNode,
											   list:Vector.<IAccessorNode>):IAccessorNode
	{
		for each (var accessor:IAccessorNode in list)
		{
			if (node.name == accessor.name)
				return accessor;
		}
		
		return null;
	}
}
}