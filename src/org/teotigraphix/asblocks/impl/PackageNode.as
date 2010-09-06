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

package org.teotigraphix.asblocks.impl
{

import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.impl.AS3FragmentParser;
import org.teotigraphix.as3parser.impl.ASTIterator;
import org.teotigraphix.asblocks.api.IPackage;
import org.teotigraphix.asblocks.api.IType;
import org.teotigraphix.asblocks.utils.ASTUtil;

/**
 * The <code>IPackage</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class PackageNode extends ScriptNode 
	implements IPackage
{
	//--------------------------------------------------------------------------
	//
	//  Private :: Properties
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private function get contentIterator():ASTIterator
	{
		return new ASTIterator(contentNode);
	}
	
	/**
	 * @private
	 */
	private function get contentNode():IParserNode
	{
		return node.getLastChild();
	}
	
	//--------------------------------------------------------------------------
	//
	//  IPackage API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  name
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IPackage#name
	 */
	public function get name():String
	{
		var n:IParserNode = node.getKind(AS3NodeKind.NAME);
		if (n)
		{
			return n.stringValue;
		}
		return null;
	}
	
	/**
	 * @private
	 */	
	public function set name(value:String):void
	{
		var i:ASTIterator = new ASTIterator(node);
		var first:IParserNode = i.next();
		
		// a package can have an asdoc, which would be first
		if (first.isKind(AS3NodeKind.AS_DOC))
		{
			first = i.next();
		}
		
		// if name null, remove NAME node
		if (!value && first.isKind(AS3NodeKind.NAME))
		{
			i.remove();
			return;
		}
		
		// replace with new NAME parsed node or add it new
		var newName:IParserNode = AS3FragmentParser.parseName(value);
		if (first.isKind(AS3NodeKind.NAME))
		{
			i.replace(newName);
		}
		else
		{
			i.insertBeforeCurrent(newName);
			newName.appendToken(TokenBuilder.newSpace());
		}
	}
	
	//----------------------------------
	//  typeNode
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IPackage#typeNode
	 */
	public function get typeNode():IType
	{
		var content:IParserNode = contentNode;
		if (content.hasKind(AS3NodeKind.CLASS))
		{
			return new ClassTypeNode(content.getKind(AS3NodeKind.CLASS));
		}
		else if (content.hasKind(AS3NodeKind.INTERFACE))
		{
			return new InterfaceTypeNode(content.getKind(AS3NodeKind.INTERFACE));
		}
		else if (content.hasKind(AS3NodeKind.FUNCTION))
		{
			//return new FunctionTypeNode(content.getKind(AS3NodeKind.FUNCTION));
		}
		return null;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function PackageNode(node:IParserNode)
	{
		super(node);
	}
	
	//--------------------------------------------------------------------------
	//
	//  IPackage API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IPackage#addImports()
	 */
	public function addImports(name:String):void
	{
		var imp:IParserNode = AS3FragmentParser.parseImport(name);
		var pos:int = nextInsertion();
		ASTUtil.addChildWithIndentation(contentNode, imp, pos);
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IPackage#removeImport()
	 */
	public function removeImport(name:String):Boolean
	{
		var i:ASTIterator = contentIterator;
		var imp:IParserNode;
		while (imp = i.search(AS3NodeKind.IMPORT))
		{
			if (importText(imp) == name)
			{
				i.remove();
				return true;
			}
		}
		return false;
	}
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IPackage#findImports()
	 */
	public function findImports():Vector.<String>
	{
		var i:ASTIterator = contentIterator;
		var imp:IParserNode;
		var result:Vector.<String> = new Vector.<String>();
		while (imp = i.search(AS3NodeKind.IMPORT))
		{
			result.push(importText(imp));
		}
		
		return result;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Private :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private function importText(imp:IParserNode):String
	{
		return imp.getFirstChild().stringValue;
	}
	
	/**
	 * @private
	 */
	private function nextInsertion():int
	{
		var i:ASTIterator = contentIterator;
		var index:int = 0;
		while (i.search(AS3NodeKind.IMPORT))
		{
			index = i.getCurrentIndex() + 1;
		}
		return index;
	}
}
}