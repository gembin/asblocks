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

import com.ericfeminella.collections.IHashMapEntry;

import org.teotigraphix.as3book.api.IAS3Book;
import org.teotigraphix.as3book.api.IAS3BookProcessor;
import org.teotigraphix.as3book.utils.TopLevelUtil;
import org.teotigraphix.as3nodes.api.IAccessorNode;
import org.teotigraphix.as3nodes.api.IAttributeNode;
import org.teotigraphix.as3nodes.api.IClassTypeNode;
import org.teotigraphix.as3nodes.api.IConstantNode;
import org.teotigraphix.as3nodes.api.IIdentifierNode;
import org.teotigraphix.as3nodes.api.IInterfaceTypeNode;
import org.teotigraphix.as3nodes.api.IMethodNode;
import org.teotigraphix.as3nodes.api.IPackageNode;
import org.teotigraphix.as3nodes.api.IParameterNode;
import org.teotigraphix.as3nodes.api.ITypeNode;
import org.teotigraphix.as3nodes.api.ITypeNodePlaceholder;
import org.teotigraphix.as3parser.api.AS3NodeKind;

/**
 * Processes nodes in the book.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class AS3BookProcessor implements IAS3BookProcessor
{
	//--------------------------------------------------------------------------
	//
	//  IAS3BookProcessor API :: Properties
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
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function AS3BookProcessor()
	{
	}
	
	//--------------------------------------------------------------------------
	//
	//  IAS3BookProcessor API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.teotigraphix.as3book.api.IAS3BookProcessor#process()
	 */
	public function process():void
	{
		proccessImports();
		
		// Process ITypeNode
		for each (var type:ITypeNode in _book.types)
		{
			if (type.node.isKind(AS3NodeKind.CLASS))
			{
				proccessClassTree(type);
				proccessClassImplementations(IClassTypeNode(type));
			}
			else (type.node.isKind(AS3NodeKind.INTERFACE))
			{
				proccessInterfaceTree(type);
			}
			
			//if (type.getComment().hasDocTag("copy"))
			//{
			//	copyTypeDoc(type);
			//}
		}
		
		var typeNode:ITypeNode;
		var packageNode:IPackageNode;
		
		// Process IConstantNode
		var entries:Array;
		var entry:IHashMapEntry;
		
		entries = _book.constants.getEntries();
		for each (entry in entries)
		{
			for each (var constant:IConstantNode in entry.value)
			{
				typeNode = constant.parent as ITypeNode;
				packageNode = IPackageNode(typeNode.parent);
				
				if (constant.type)
				{
					resolveQNameFromImports(
						packageNode.imports, 
						constant.type, 
						packageNode.uid);
				}
				
				//if (constant.getComment().hasDocTag("copy"))
				//{
				//	copyDoc(constant);
				//}
			}
		}
		
		entries = _book.attributes.getEntries();
		for each (entry in entries)
		{
			for each (var attribute:IAttributeNode in entry.value)
			{
				typeNode = attribute.parent as ITypeNode;
				packageNode = IPackageNode(typeNode.parent);
				
				if (attribute.type)
				{
					resolveQNameFromImports(
						packageNode.imports, 
						attribute.type, 
						packageNode.uid);
				}

				//if (attribute.getComment().hasDocTag("copy"))
				//{
				//	copyDoc(attribute);
				//}
			}
		}
		
		entries = _book.accessors.getEntries();
		for each (entry in entries)
		{
			for each (var accessor:IAccessorNode in entry.value)
			{
				typeNode = accessor.parent as ITypeNode;
				packageNode = IPackageNode(typeNode.parent);
				
				if (accessor.type)
				{
					resolveQNameFromImports(
						packageNode.imports, 
						accessor.type, 
						packageNode.uid);
				}
				
				//if (accessor.getComment().hasDocTag("copy"))
				//{
				//	copyDoc(attribute);
				//}
			}
		}
		
		entries = _book.methods.getEntries();
		for each (entry in entries)
		{
			for each (var method:IMethodNode in entry.value)
			{
				typeNode = method.parent as ITypeNode;
				packageNode = IPackageNode(typeNode.parent);
				
				if (method.type)
				{
					resolveQNameFromImports(
						packageNode.imports, 
						method.type, 
						packageNode.uid);
				}
				
				if (method.hasParameters)
				{
					for each (var parameter:IParameterNode in method.parameters)
					{
						if (parameter.type)
						{
							resolveQNameFromImports(
								packageNode.imports, 
								parameter.type, 
								packageNode.uid);
						}
					}
				}
				
				//if (accessor.getComment().hasDocTag("copy"))
				//{
				//	copyDoc(attribute);
				//}
			}
		}
	}
	
	/**
	 * @private
	 */
	private function proccessImports():void
	{
		for each (var type:ITypeNode in _book.types)
		{
			resolveImports(type);
		}
	}
	
	/**
	 * @private
	 */
	private function resolveImports(type:ITypeNode):void
	{
		if (type.node.isKind(AS3NodeKind.CLASS) && type.isSubType)
		{
			proccessClassExtends(IClassTypeNode(type));
		}
		
		if (type.node.isKind(AS3NodeKind.CLASS) 
			&& IClassTypeNode(type).implementList.length > 0)
		{
			proccessImplementorImport(IClassTypeNode(type));
		}
		
		if (type.node.isKind(AS3NodeKind.INTERFACE) && type.isSubType)
		{
			proccessSuperInterfacesImport(IInterfaceTypeNode(type));
		}
	}
	
	/**
	 * @private
	 */
	private function proccessClassExtends(type:IClassTypeNode):void
	{
		resolveQNameFromImports(
			IPackageNode(type.parent).imports, 
			type.superType, 
			IPackageNode(type.parent).uid);
	}
	
	/**
	 * @private
	 */
	private function proccessImplementorImport(type:IClassTypeNode):void
	{
		for each (var iname:IIdentifierNode in type.implementList)
		{
			resolveQNameFromImports(
				IPackageNode(type.parent).imports, 
				iname, 
				IPackageNode(type.parent).uid);
		}
	}
	
	/**
	 * @private
	 */
	private function proccessSuperInterfacesImport(type:IInterfaceTypeNode):void
	{
		for each (var siname:IIdentifierNode in type.superTypeList)
		{
			resolveQNameFromImports(
				IPackageNode(type.parent).imports, 
				siname, 
				IPackageNode(type.parent).uid);
		}
	}
	
	/**
	 * @private
	 */
	private function proccessClassTree(type:ITypeNode):void
	{
		if (type.isSubType)
		{
			_book.superclasses.put(type.toLink(), cacheSuperClasses(type));
			
			var superType:ITypeNode = getType(IClassTypeNode(type).superType);
			if (superType != null)
			{
				var list:Vector.<ITypeNode> = _book.subclasses.getValue(superType.toLink());
				
				if (list == null)
				{
					list = new Vector.<ITypeNode>();
					_book.subclasses.put(superType.toLink(), list);
				}
				
				list.push(type);
			}
		}
	}
	
	/**
	 * @private
	 */
	private function proccessClassImplementations(type:IClassTypeNode):void
	{
		if (type.hasImplementations)
		{
			var implementationTypes:Vector.<ITypeNode> =
				getTypesFromQNames(type.implementList);
			
			for each (var interfaceType:ITypeNode in implementationTypes)
			{
				var sublist:Vector.<ITypeNode> =
					_book.implementedinterfaces.getValue(type.toLink());
				
				if (sublist == null)
				{
					sublist = new Vector.<ITypeNode>();
					_book.implementedinterfaces.put(type.toLink(), sublist);
				}
				
				sublist.push(interfaceType);
				
				if (type.node.isKind(AS3NodeKind.CLASS))
				{
					var clslist:Vector.<ITypeNode> =
						_book.interfaceImplementors.getValue(interfaceType.toLink());
					if (clslist == null)
					{
						clslist = new Vector.<ITypeNode>();
						_book.interfaceImplementors.put(interfaceType.toLink(), clslist);
					}
					
					clslist.push(type);
				}
			}
		}
	}
	
	/**
	 * @private
	 */
	private function proccessInterfaceTree(type:ITypeNode):void
	{
		if (type.node.isKind(AS3NodeKind.INTERFACE))
		{
			_book.superInterfaces.put(type.toLink(), cacheSuperInterfaces(type));
		}
	}
	
	/**
	 * @private
	 */
	private function cacheSuperClasses(element:ITypeNode):Vector.<ITypeNode>
	{
		var result:Vector.<ITypeNode> = new Vector.<ITypeNode>();
		_cacheSuperClasses(element, result);
		return result;
	}
	
	/**
	 * @private
	 */
	private function _cacheSuperClasses(element:ITypeNode, 
										result:Vector.<ITypeNode>):Vector.<ITypeNode>
	{
		if (element is ITypeNodePlaceholder)
			return result;
		
		if (IClassTypeNode(element).superType == null)
			return result;
		
		var selement:ITypeNode = getType(IClassTypeNode(element).superType);
		if (selement != null)
		{
			if (selement != null)
			{
				result.push(selement);
				_cacheSuperClasses(selement, result);
			}
		}
		
		return result;
	}
	
	/**
	 * @private
	 */
	private function cacheSuperInterfaces(element:ITypeNode):Vector.<ITypeNode>
	{
		var result:Vector.<ITypeNode> = new Vector.<ITypeNode>();
		_cacheSuperInterfaces(element, result);
		return result;
	}
	
	/**
	 * @private
	 */
	private function _cacheSuperInterfaces(element:ITypeNode, 
										   result:Vector.<ITypeNode>):Vector.<ITypeNode>
	{
		var superTypes:Vector.<ITypeNode> = getTypesFromQNames(
			IInterfaceTypeNode(element).superTypeList);
		
		for each (var superType:ITypeNode in superTypes)
		{
			result.push(superType);
			
			// FIXME move this to the right place
			var sublist:Vector.<ITypeNode> =
				_book.subInterfaces.getValue(superType.toLink());
			
			if (sublist == null)
			{
				sublist = new Vector.<ITypeNode>();
				_book.subInterfaces.put(superType.toLink(), sublist);
			}
			
			sublist.push(element);
			
		}
		return result;
	}
	
	/**
	 * @private
	 */
	private function getType(uid:IIdentifierNode):ITypeNode
	{
		if (!uid.isQualified)
			return null; // for place holder instances
		return book.access.getType(uid.qualifiedName);
	}
	
	/**
	 * @private
	 */
	private function getTypesFromQNames(qnames:Vector.<IIdentifierNode>):Vector.<ITypeNode>
	{
		var result:Vector.<ITypeNode> = new Vector.<ITypeNode>();
		if (qnames == null)
			return result;
		
		for each (var qname:IIdentifierNode in qnames)
		{
			result.push(getType(qname));
		}
		return result;
	}
	
	/**
	 * @private
	 */
	public static function resolveQNameFromImports(imports:Vector.<IIdentifierNode>,
												   name:IIdentifierNode, 
												   packageName:IIdentifierNode):void
	{
		if (name.isQualified)
			return;
		
		if (!name.isQualified && TopLevelUtil.isTopLevel(name.localName))
			return;
		
		var found:Boolean = false;
		
		for each (var imp:IIdentifierNode in imports)
		{
			if (imp.localName ==  name.localName)
			{
				name.qualifiedName = imp.packageName + "." + name.localName;
				found = true;
				break;
			}
		}
		
		if (!found)
		{
			var qname:String = packageName.qualifiedName + ".";
			
			if (qname == "toplevel")
				qname = "";
			
			name.qualifiedName = qname + name.localName;
		}
	}
}
}