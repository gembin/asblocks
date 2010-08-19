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

import org.teotigraphix.as3nodes.api.IBlockCommentNode;
import org.teotigraphix.as3nodes.api.IClassTypeNode;
import org.teotigraphix.as3nodes.api.IFunctionTypeNode;
import org.teotigraphix.as3nodes.api.IIdentifierNode;
import org.teotigraphix.as3nodes.api.IInterfaceTypeNode;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3nodes.api.IPackageNode;
import org.teotigraphix.as3nodes.api.ITypeNode;
import org.teotigraphix.as3nodes.api.Modifier;
import org.teotigraphix.as3nodes.utils.NodeUtil;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.utils.ASTUtil;

/**
 * The package found in the compilation unit, does not contain internal
 * classes or functions.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class PackageNode extends NodeBase implements IPackageNode
{
	//--------------------------------------------------------------------------
	//
	//  INameAware API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  name
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.INameAware#name
	 */
	public function get name():String
	{
		if (_uid && _uid.isQualified)
			return _uid.qualifiedName;
		return ""; // "" toplevel (default)
	}
	
	//--------------------------------------------------------------------------
	//
	//  IIdentifierAware API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  uid
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _uid:IIdentifierNode;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IIdentifierAware#uid
	 */
	public function get uid():IIdentifierNode
	{
		return _uid;
	}
	
	/**
	 * @private
	 */	
	public function set uid(value:IIdentifierNode):void
	{
		_uid = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  IPackageNode API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  classNode
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _typeNode:ITypeNode;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IPackageNode#typeNode
	 */
	public function get typeNode():ITypeNode
	{
		return _typeNode;
	}
	
	/**
	 * @private
	 */	
	public function set typeNode(value:ITypeNode):void
	{
		if (_typeNode)
			dispatchRemoveChange(_typeNode.node.kind, _typeNode);
		
		_typeNode = value;
		
		if (_typeNode)
			dispatchAddChange(_typeNode.node.kind, _typeNode);
	}
	
	//----------------------------------
	//  qualifiedName
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _qualifiedName:String;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IPackageNode#qualifiedName
	 */
	public function get qualifiedName():String
	{
		if (_uid)
		{
			var packageName:String = "";
			if(_uid.qualifiedName != null)
				packageName = _uid.qualifiedName;
			if (_typeNode && (packageName != ""))
				_qualifiedName = packageName + "." + _typeNode.uid.localName;
			else if (_typeNode)
				_qualifiedName = _typeNode.uid.localName;
		}
		
		return _qualifiedName;
	}
	
	/**
	 * @private
	 */	
	public function set qualifiedName(value:String):void
	{
		_qualifiedName = value;
	}
	
	//----------------------------------
	//  imports
	//----------------------------------
	
	/**
	 * @private
	 */
	protected var _imports:Vector.<IIdentifierNode>;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IPackageNode#imports
	 */
	public function get imports():Vector.<IIdentifierNode>
	{
		return _imports;
	}
	
	//--------------------------------------------------------------------------
	//
	//  IBlockCommentAware API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  blockComment
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _blockComment:IBlockCommentNode;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IBlockCommentAware#blockComment
	 */
	public function get blockComment():IBlockCommentNode
	{
		return _blockComment;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IBlockCommentAware#setBlockComment()
	 */
	public function setBlockComment(value:IBlockCommentNode):void
	{
		if (_blockComment)
			dispatchRemoveChange(AS3NodeKind.BLOCK_DOC, _blockComment);
		
		_blockComment = value;
		
		if (_blockComment)
			dispatchAddChange(AS3NodeKind.BLOCK_DOC, _blockComment);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function PackageNode(node:IParserNode, parent:INode)
	{
		super(node, parent);
	}
	
	//--------------------------------------------------------------------------
	//
	//  IPackageNode API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IPackageNode#hasImport()
	 */
	public function hasImport(qualifiedName:String):Boolean
	{
		var len:int = imports.length;
		for (var i:int = 0; i < len; i++)
		{
			if (imports[i].qualifiedName == qualifiedName)
				return true;
		}
		return false;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IPackageNode#addImport()
	 */
	public function addImport(element:IIdentifierNode):IIdentifierNode
	{
		if (hasImport(element.qualifiedName))
			return null;
		
		imports.push(element);
		
		dispatchAddChange(AS3NodeKind.IMPORT, element);
		
		return element;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IPackageNode#removeImport()
	 */
	public function removeImport(element:IIdentifierNode):IIdentifierNode
	{
		var len:int = imports.length;
		for (var i:int = 0; i < len; i++)
		{
			if (imports[i] === element 
				&& imports[i].qualifiedName == element.qualifiedName)
			{
				imports.splice(i, 1);
				dispatchRemoveChange(AS3NodeKind.IMPORT, element);
				return element;
			}
		}
		
		return null;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IPackageNode#getImport()
	 */
	public function getImport(qualifiedName:String):IIdentifierNode
	{
		var len:int = imports.length;
		for (var i:int = 0; i < len; i++)
		{
			if (imports[i].qualifiedName == qualifiedName)
				return imports[i];
		}
		return null;
	}
	
	//----------------------------------
	//  Factory
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IPackageNode#newImport()
	 */
	public function newImport(name:String):IIdentifierNode
	{
		return as3Factory.newImport(this, name);
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IPackageNode#newClass()
	 */
	public function newClass(name:String):IClassTypeNode
	{
		var classType:IClassTypeNode = as3Factory.newClass(this, name);
		classType.addModifier(Modifier.PUBLIC);
		return classType;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IPackageNode#newInterface()
	 */
	public function newInterface(name:String):IInterfaceTypeNode
	{
		var interfaceType:IInterfaceTypeNode = as3Factory.newInterface(this, name);
		interfaceType.addModifier(Modifier.PUBLIC);
		return interfaceType;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IPackageNode#newFunction()
	 */
	public function newFunction(name:String):IFunctionTypeNode
	{
		var functionType:IFunctionTypeNode = as3Factory.newFunction(this, name);
		functionType.addModifier(Modifier.PUBLIC);
		return functionType;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IPackageNode#newBlockComment()
	 */
	public function newBlockComment(comment:String, 
									wrap:Boolean = false):IBlockCommentNode
	{
		return as3Factory.newBlockComment(this, comment, wrap);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden Protected :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	override protected function compute():void
	{
		_imports = new Vector.<IIdentifierNode>();
		
		NodeUtil.computeImports(this, node.getLastChild());
		
		uid = NodeFactory.instance.createIdentifier(node.getKind(AS3NodeKind.NAME), this);
		
		var type:IParserNode = ASTUtil.getTypeFromPackage(node);
		if (!type)
			return;
		
		if (type.isKind(AS3NodeKind.CLASS))
		{
			_typeNode = NodeFactory.instance.createClassType(type, this);
		}
		else if (type.isKind(AS3NodeKind.INTERFACE))
		{
			_typeNode = NodeFactory.instance.createInterfaceType(type, this);
		}
		else if (type.isKind(AS3NodeKind.FUNCTION))
		{
			_typeNode = NodeFactory.instance.createFunctionType(type, this);
		}
	}
}
}