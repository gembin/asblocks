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

import org.teotigraphix.as3nodes.api.IIdentifierNode;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3nodes.api.IPackageNode;
import org.teotigraphix.as3nodes.api.ITypeNode;
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
		if (_uid)
			return _uid.qualifiedName;
		return null;
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
		if (_uid)
		{
			_qualifiedName = _uid.qualifiedName;
			if (_typeNode && (_uid.qualifiedName != null || _uid.qualifiedName != ""))
				_qualifiedName = _uid.qualifiedName + "." + _typeNode.uid.localName;
		}
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
		_typeNode = value;
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
	private var _imports:Vector.<IIdentifierNode>;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IPackageNode#imports
	 */
	public function get imports():Vector.<IIdentifierNode>
	{
		return _imports;
	}
	
	/**
	 * @private
	 */	
	public function set imports(value:Vector.<IIdentifierNode>):void
	{
		_imports = value;
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
	 * @copy org.teotigraphix.as3nodes.api.IPackageNode#addImport()
	 */
	public function addImport(node:IIdentifierNode):void
	{
		_imports.push(node);
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
		
		var type:IParserNode = ASTUtil.getTypeFromPackage(node);
		
		// FIXME use NodeFactory
		if (type.isKind(AS3NodeKind.CLASS))
		{
			_typeNode = new ClassTypeNode(type, this);
		}
		else if (type.isKind(AS3NodeKind.INTERFACE))
		{
			_typeNode = new InterfaceTypeNode(type, this);
		}
		else if (type.isKind(AS3NodeKind.FUNCTION))
		{
			_typeNode = new FunctionTypeNode(type, this);
		}
		
		NodeUtil.computeImports(this, node.getLastChild());
		
		uid = new IdentifierNode(ASTUtil.getNode(AS3NodeKind.NAME, node), this);
	}
}
}