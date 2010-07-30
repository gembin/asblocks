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

package org.teotigraphix.as3parser.utils
{

import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;

/**
 * A utility class for dealing with scanners, parsers and parser node ast.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class ASTUtil
{
	public static function getPackage(unit:IParserNode):IParserNode
	{
		return unit.getChild(0);
	}
	
	public static function getPackageName(unit:IParserNode):String
	{
		var packageNode:IParserNode = getPackage(unit);
		
		return packageNode.getChild(0).stringValue;
	}
	
	public static function getPackageContent(unit:IParserNode):IParserNode
	{
		var packageNode:IParserNode = getPackage(unit);
		
		return packageNode.getChild(1);
	}	
	
	public static function getImports(unit:IParserNode):Vector.<IParserNode>
	{
		var packageContent:IParserNode = getPackageContent(unit);
		var nodes:Vector.<IParserNode> = getNodes(AS3NodeKind.IMPORT, packageContent);
		return nodes;
	}
	
	public static function getUses(unit:IParserNode):Vector.<IParserNode>
	{
		var packageContent:IParserNode = getPackageContent(unit);
		var nodes:Vector.<IParserNode> = getNodes(AS3NodeKind.USE, packageContent);
		return nodes;
	}
	
	public static function getClass(unit:IParserNode):IParserNode
	{
		var packageContentNode:IParserNode = getPackageContent(unit);
		
		return packageContentNode.getLastChild();
	}
	
	public static function getClassContent(unit:IParserNode):IParserNode
	{
		var classNode:IParserNode = getClass(unit);
		
		return classNode.getLastChild();
	}
	
	public static function getClassName(unit:IParserNode):String
	{
		var classNode:IParserNode = getClass(unit);
		var classNameNode:IParserNode = getNode(AS3NodeKind.NAME, classNode);
		
		return classNameNode.stringValue;
	}
	
	public static function getClassMetaData(unit:IParserNode):Vector.<IParserNode>
	{
		var result:Vector.<IParserNode> = new Vector.<IParserNode>();
		
		var classNode:IParserNode = getClass(unit);
		var nodes:IParserNode = getNode(AS3NodeKind.META_LIST, classNode);
		
		if (!nodes || nodes.numChildren == 0)
			return result;
		
		var len:int = nodes.numChildren;
		for (var i:int = 0; i < len; i++)
		{
			result.push(nodes.children[i]);
		}
		
		return result;
	}
	
	public static function getClassModifiers(unit:IParserNode):Vector.<IParserNode>
	{
		var result:Vector.<IParserNode> = new Vector.<IParserNode>();
		
		var classNode:IParserNode = getClass(unit);
		var nodes:IParserNode = getNode(AS3NodeKind.MOD_LIST, classNode);
		
		if (!nodes || nodes.numChildren == 0)
			return result;
		
		var len:int = nodes.numChildren;
		for (var i:int = 0; i < len; i++)
		{
			result.push(nodes.children[i]);
		}
		
		return result;
	}
	
	public static function getClassExtends(unit:IParserNode):IParserNode
	{
		var classNode:IParserNode = getClass(unit);
		
		var extendsNode:IParserNode = getNode(AS3NodeKind.EXTENDS, classNode);
		
		return extendsNode;
	}
	
	public static function getImplements(unit:IParserNode):Vector.<IParserNode>
	{
		var result:Vector.<IParserNode> = new Vector.<IParserNode>();
		
		var classNode:IParserNode = getClass(unit);
		var nodes:IParserNode = getNode(AS3NodeKind.IMPLEMENTS_LIST, classNode);
		
		if (!nodes || nodes.numChildren == 0)
			return result;
		
		var len:int = nodes.numChildren;
		for (var i:int = 0; i < len; i++)
		{
			result.push(nodes.children[i]);
		}
		
		return result;
	}
	
	public static function getClassVariables(unit:IParserNode):Vector.<IParserNode>
	{
		var result:Vector.<IParserNode> = new Vector.<IParserNode>();
		
		var classNode:IParserNode = getClassContent(unit);
		var nodes:Vector.<IParserNode> = getNodes(AS3NodeKind.VAR_LIST, classNode);
		
		if (!nodes || nodes.length == 0)
			return result;
		
		var len:int = nodes.length;
		for (var i:int = 0; i < len; i++)
		{
			result.push(nodes[i]);
		}
		
		return result;
	}
	
	public static function getNodes(kind:String, node:IParserNode):Vector.<IParserNode>
	{
		var result:Vector.<IParserNode> = new Vector.<IParserNode>();
		
		if (node.numChildren == 0)
			return result;
		
		var len:int = node.children.length;
		for (var i:int = 0; i < len; i++)
		{
			var element:IParserNode = node.children[i] as IParserNode;
			if (element.isKind(kind))
				result.push(element)
		}
		
		return result;
	}
	
	public static function getNode(kind:String, node:IParserNode):IParserNode
	{
		if (node.numChildren == 0)
			return null;
		
		var len:int = node.children.length;
		for (var i:int = 0; i < len; i++)
		{
			var element:IParserNode = node.children[i] as IParserNode;
			if (element.isKind(kind))
				return element;
		}
		
		return null;
	}
	
	public static function getAsDoc(node:IParserNode):IParserNode
	{
		if (node.numChildren == 0)
			return null;
		
		var len:int = node.children.length;
		for (var i:int = 0; i < len; i++)
		{
			var element:IParserNode = node.children[i] as IParserNode;
			if (element.isKind(AS3NodeKind.AS_DOC))
				return element;
		}
		
		return null;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Public Class :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Converts a String Array into a String Vector.
	 * 
	 * @param list A String Array.
	 * @return A String Vector.
	 */
	public static function toVector(list:Array):Vector.<String>
	{
		return Vector.<String>(list);
	}
	
	/**
	 * Converts an <code>IParserNode</code> into a flat XML String.
	 * 
	 * @param ast The <code>IParserNode</code> to convert.
	 * @return A String XML representation of the <code>IParserNode</code>.
	 */
	public static function convert(ast:IParserNode):String
	{
		return visitNodes(ast, "", 0);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Private Class :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private static function visitNodes(ast:IParserNode, 
									   result:String, 
									   level:int):String
	{
		result += "<" + ast.kind + " line=\"" + 
			ast.line + "\" column=\"" + ast.column + "\">";
		
		var numChildren:int = ast.numChildren;
		if (numChildren > 0)
		{
			for (var i:int = 0; i < numChildren; i++)
			{
				result = visitNodes(ast.getChild(i), result, level + 1);
			}
		}
		else if (ast.stringValue != null)
		{
			result += escapeEntities(ast.stringValue);
		}
		
		result += "</" + ast.kind + ">";
		
		return result;
	}
	
	/**
	 * @private
	 */
	private static function escapeEntities(stringToEscape:String):String
	{
		var buffer:String = "";
		
		for (var i:int = 0; i < stringToEscape.length; i++)
		{
			var currentCharacter:String = stringToEscape.charAt(i);
			
			if (currentCharacter == '<')
			{
				buffer += "&lt;";
			}
			else if (currentCharacter == '>')
			{
				buffer += "&gt;";
			}
			else
			{
				buffer += currentCharacter;
			}
		}
		return buffer;
	}
}
}