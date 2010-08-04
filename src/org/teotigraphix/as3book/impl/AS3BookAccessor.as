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

import org.teotigraphix.as3book.api.IAS3Book;
import org.teotigraphix.as3book.api.IAS3BookAccessor;
import org.teotigraphix.as3nodes.api.IAttributeNode;
import org.teotigraphix.as3nodes.api.IClassTypeNode;
import org.teotigraphix.as3nodes.api.IConstantNode;
import org.teotigraphix.as3nodes.api.IFunctionTypeNode;
import org.teotigraphix.as3nodes.api.IInterfaceTypeNode;
import org.teotigraphix.as3nodes.api.IMethodNode;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3nodes.api.IScriptNode;
import org.teotigraphix.as3nodes.api.ISourceFileCollection;
import org.teotigraphix.as3nodes.api.ITypeNode;
import org.teotigraphix.as3nodes.api.ITypeNodePlaceholder;
import org.teotigraphix.as3nodes.api.Modifier;
import org.teotigraphix.as3nodes.impl.TypeNodePlaceholder;
import org.teotigraphix.as3parser.api.AS3NodeKind;

/**
 * TODO DOCME
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class AS3BookAccessor implements IAS3BookAccessor
{
	//--------------------------------------------------------------------------
	//
	//  IAS3BookAccessor API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  book
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _book:AS3Book;
	
	/**
	 * @copy org.teotigraphix.as3book.api.IAS3BookProcessor#book
	 */
	public function get book():IAS3Book
	{
		return _book;
	}
	
	/**
	 * @private
	 */	
	public function set book(value:IAS3Book):void
	{
		_book = value as AS3Book;
	}
	
	//----------------------------------
	//  sourceFileCollections
	//----------------------------------
	
	/**
	 * doc
	 */
	public function get sourceFileCollections():Vector.<ISourceFileCollection>
	{
		return _book.sourceFileCollections;
	}
	
	//----------------------------------
	//  types
	//----------------------------------
	
	/**
	 * doc
	 */
	public function get types():Vector.<ITypeNode>
	{
		var result:Vector.<ITypeNode> = new Vector.<ITypeNode>();
		
		for each (var element:ITypeNode in _book.types)
		{
			result.push(element);
		}
		
		return result;
	}
	
	//----------------------------------
	//  classTypes
	//----------------------------------
	
	/**
	 * doc
	 */
	public function get classTypes():Vector.<IClassTypeNode>
	{
		var result:Vector.<IClassTypeNode> = new Vector.<IClassTypeNode>();
		
		for each (var element:ITypeNode in _book.types)
		{
			if (element.node.isKind(AS3NodeKind.CLASS))
				result.push(IClassTypeNode(element));
		}
		
		return result;
	}
	
	//----------------------------------
	//  interfaceTypes
	//----------------------------------
	
	/**
	 * doc
	 */
	public function get interfaceTypes():Vector.<IInterfaceTypeNode>
	{
		var result:Vector.<IInterfaceTypeNode> = new Vector.<IInterfaceTypeNode>();
		
		for each (var element:ITypeNode in _book.types)
		{
			if (element.node.isKind(AS3NodeKind.INTERFACE))
				result.push(IInterfaceTypeNode(element));
		}
		
		return result;
	}
	
	//----------------------------------
	//  functionTypes
	//----------------------------------
	
	/**
	 * doc
	 */
	public function get functionTypes():Vector.<IFunctionTypeNode>
	{
		var result:Vector.<IFunctionTypeNode> = new Vector.<IFunctionTypeNode>();
		
		for each (var element:ITypeNode in _book.types)
		{
			if (element.node.isKind(AS3NodeKind.FUNCTION))
				result.push(IFunctionTypeNode(element));
		}
		
		return result;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function AS3BookAccessor()
	{
	}
	
	public function getSourceFileCollection(packageName:String):ISourceFileCollection
	{
		for each (var element:ISourceFileCollection in _book.sourceFileCollections)
		{
			if (element.name == packageName)
				return element;
		}
		
		return null;
	}
	
	public function findType(qualifiedName:String):ITypeNode
	{
		for each (var element:ITypeNode in _book.types)
		{
			if (element.qualifiedName == qualifiedName)
				return element;
		}
		
		return null;
	}
	
	public function getType(qualifiedName:String):ITypeNode
	{
		var type:ITypeNode = findType(qualifiedName);
		if (type != null)
			return type;
		
		if (_book.placeholders.containsKey(qualifiedName))
			return _book.placeholders.getValue(qualifiedName);
		
		type = new TypeNodePlaceholder(qualifiedName);
		
		_book.placeholders.put(qualifiedName, type);
		
		return type;
	}
	
	public function getTypes(packageName:String):Vector.<ITypeNode>
	{
		var result:Vector.<ITypeNode> = new Vector.<ITypeNode>();
		
		for each (var element:ITypeNode in _book.types)
		{
			if (element.packageName == packageName)
				result.push(element);
		}
		
		return result;
	}
	
	public function hasType(qualifiedName:String):Boolean
	{
		return findType(qualifiedName) != null;
	}
	
	public function findClassType(qualifiedName:String):IClassTypeNode
	{
		return findType(qualifiedName) as IClassTypeNode;
	}
	
	public function findInterfaceType(qualifiedName:String):IInterfaceTypeNode
	{
		return findType(qualifiedName) as IInterfaceTypeNode;
	}
	
	public function findFunctionType(qualifiedName:String):IFunctionTypeNode
	{
		return findType(qualifiedName) as IFunctionTypeNode;
	}
	
	//----------------------------------
	//  Class
	//----------------------------------
	
	public function getSuperClasses(node:ITypeNode):Vector.<ITypeNode>
	{
		return _book.superclasses.getValue(node.toLink());
	}
	
	public function getSubClasses(node:ITypeNode):Vector.<ITypeNode>
	{
		return _book.subclasses.getValue(node.toLink());
	}
	
	public function getImplementedInterfaces(node:ITypeNode):Vector.<ITypeNode>
	{
		return _book.implementedinterfaces.getValue(node.toLink());
	}
	
	public function getInterfaceImplementors(node:ITypeNode):Vector.<ITypeNode>
	{
		return _book.interfaceImplementors.getValue(node.toLink());
	}
	
	public function getSuperInterfaces(node:ITypeNode):Vector.<ITypeNode>
	{
		return _book.superInterfaces.getValue(node.toLink());
	}
	
	public function getSubInterfaces(node:ITypeNode):Vector.<ITypeNode>
	{
		return _book.subInterfaces.getValue(node.toLink());
	}
	
	//----------------------------------
	//  Class members
	//----------------------------------
	
	public function getConstants(node:IClassTypeNode,
								 visibility:Modifier, 
								 inherit:Boolean):Vector.<IConstantNode>
	{
		var members:Vector.<IConstantNode> =
			findConstants(node, visibility, false);
		
		if (!inherit)
		{
			return members;
		}
		
		//------------------------------
		var result:Vector.<IConstantNode> = new Vector.<IConstantNode>();
		
		result = result.concat(members);
		
		var supers:Vector.<ITypeNode> = findSuperClasses(node);
		if (supers == null) // FIXME HACK
			return result;
		
		for each (var type:ITypeNode in supers)
		{
			result = result.concat(findConstants(type, visibility, true));
		}
		
		return result;
	}
	
	public function getAttributes(node:IClassTypeNode,
								  visibility:Modifier, 
								  inherit:Boolean):Vector.<IAttributeNode>
	{
		var members:Vector.<IAttributeNode> = 
			findAttributes(node, visibility, false);
		
		if (!inherit)
		{
			return members;
		}
		
		//------------------------------
		var result:Vector.<IAttributeNode> = new Vector.<IAttributeNode>();
		
		result = result.concat(members);
		
		var supers:Vector.<ITypeNode> = findSuperClasses(node);
		if (supers == null) // FIXME HACK
			return result;
		
		for each (var type:ITypeNode in supers)
		{
			result = result.concat(findAttributes(type, visibility, true));
		}
		
		return result;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	////////////////////////////////////////////////////////////
	
	private function findSuperClasses(node:ITypeNode):Vector.<ITypeNode>
	{
		var result:Vector.<ITypeNode> = null;
		if (node is IInterfaceTypeNode)
		{
			result = book.access.getSuperInterfaces(node);
		}
		else
		{
			result = book.access.getSuperClasses(node);
		}
		
		return result;
	}
	
	public function findConstants(node:ITypeNode,
								  visibility:Modifier, 
								  inherited:Boolean):Vector.<IConstantNode>
	{
		var result:Vector.<IConstantNode> = new Vector.<IConstantNode>();
		
		if (node is ITypeNodePlaceholder)
			return result;
		
		if (!_book.constants.containsKey(node.toLink()))
			return result;
		
		var members:Vector.<IConstantNode> = _book.constants.getValue(node.toLink());
		for each (var member:IConstantNode in members)
		{
			if (isIncluded(member, inherited))
			{
				if (visibility == null || member.hasModifier(visibility))
				{
					result.push(member);
				}
			}
		}
		
		return result;
	}
	
	public function findAttributes(node:ITypeNode,
								   visibility:Modifier, 
								   inherited:Boolean):Vector.<IAttributeNode>
	{
		var result:Vector.<IAttributeNode> = new Vector.<IAttributeNode>();
		
		if (node is ITypeNodePlaceholder)
			return result;
		
		if (!_book.constants.containsKey(node.toLink()))
			return result;
		
		var members:Vector.<IAttributeNode> = _book.attributes.getValue(node.toLink());
		for each (var member:IAttributeNode in members)
		{
			if (isIncluded(member, inherited))
			{
				if (visibility == null || member.hasModifier(visibility))
				{
					result.push(member);
				}
			}
		}
		
		return result;
	}
	
	private function isIncluded(node:IScriptNode, inherited:Boolean):Boolean
	{
		// FIXME TEMP this has to be implemented correctly
		if (inherited && node.hasModifier(Modifier.PRIVATE))
		{
			return false;
		}
		
		if (node.comment.hasDocTag("private")) // needs configuration setting to
		{
			return false;
		}
		
		if (node is IMethodNode)
		{
			if (inherited && IMethodNode(node).isConstructor)
				return false;
		}
		
		return true; // FIXME IMPLEMENT isIncluded()
	}
}
}