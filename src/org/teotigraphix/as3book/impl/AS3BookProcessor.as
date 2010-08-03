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
import org.teotigraphix.as3book.api.IAS3BookProcessor;
import org.teotigraphix.as3nodes.api.IClassTypeNode;
import org.teotigraphix.as3nodes.api.ITypeNode;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;

/**
 * TODO DOCME
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
		
		for each (var type:ITypeNode in _book.types)
		{
			proccessClassTree(type);
			//proccessInterfaceTree(type);
			
			//proccessClassImplementations(type);
			
			//if (type.getComment().hasDocTag("copy"))
			//{
			//	copyTypeDoc(type);
			//}
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
			//proccessClassExtends(type);
		}
		
		if (type.node.isKind(AS3NodeKind.CLASS) 
			&& IClassTypeNode(type).implementList.length > 0)
		{
			//proccessImplementorImport(type);
		}
		
		if (type.node.isKind(AS3NodeKind.INTERFACE) && type.isSubType)
		{
			//proccessSuperInterfacesImport(type);
		}
	}
	


	
	private function proccessClassTree(type:ITypeNode):void
	{
		if (type.isSubType)
		{
			_book.superclasses.put(type.toLink(), cacheSuperClasses(type));
			
			var superType:ITypeNode = getType(IClassTypeNode(type).superType.name);
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
	
	private function cacheSuperClasses(element:ITypeNode):Vector.<ITypeNode>
	{
		var result:Vector.<ITypeNode> = new Vector.<ITypeNode>();
		_cacheSuperClasses(element, result);
		return result;
	}
	
	private function _cacheSuperClasses(element:ITypeNode, 
										result:Vector.<ITypeNode>):Vector.<ITypeNode>
	{
		var superName:String = "";
		if (element is IClassTypeNode)
			superName = IClassTypeNode(element).superType.name;
				
		var selement:ITypeNode = getType(superName);
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
	
	private function getType(qualifiedName:String):ITypeNode
	{
		if (qualifiedName == null || qualifiedName == "")
			return null; // for place holder instances
		return book.access.getType(qualifiedName);
	}
	
	
	
	
	
	
	
	
	
	
}
}