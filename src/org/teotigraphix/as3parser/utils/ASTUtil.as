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
	//--------------------------------------------------------------------------
	//
	//  Package compilation-unit/package :: Methods
	//
	//--------------------------------------------------------------------------
	
	public static function getPackage(unit:IParserNode):IParserNode
	{
		return unit.getChild(0);
	}
	
	public static function getPackageName(unit:IParserNode):String
	{
		return getPackage(unit).getChild(0).stringValue;
	}
	
	public static function getPackageContent(unit:IParserNode):IParserNode
	{
		return getPackage(unit).getChild(1);
	}	
	
	public static function getImports(unit:IParserNode):Vector.<IParserNode>
	{
		return getNodes(AS3NodeKind.IMPORT, getPackageContent(unit));
	}
	
	public static function getUses(unit:IParserNode):Vector.<IParserNode>
	{
		return getNodes(AS3NodeKind.USE, getPackageContent(unit));
	}
	
	//--------------------------------------------------------------------------
	//
	//  Type compilation-unit/package/class|interface :: Methods
	//
	//--------------------------------------------------------------------------
	
	public static function getType(unit:IParserNode):IParserNode
	{
		return getPackageContent(unit).getLastChild();
	}
	
	public static function getTypeFromPackage(node:IParserNode):IParserNode
	{
		return node.getLastChild().getLastChild();
	}
	
	public static function getTypeContent(unit:IParserNode):IParserNode
	{
		return getType(unit).getLastChild();
	}
	
	public static function getTypeName(unit:IParserNode):String
	{
		return getNode(AS3NodeKind.NAME, getType(unit)).stringValue;
	}
	
	public static function getTypeMetaData(unit:IParserNode):Vector.<IParserNode>
	{
		var node:IParserNode = getNode(AS3NodeKind.META_LIST, getType(unit));
		return copyNodeToVector(node);
	}
	
	public static function getTypeModifiers(unit:IParserNode):Vector.<IParserNode>
	{
		var node:IParserNode = getNode(AS3NodeKind.MOD_LIST, getType(unit));
		return copyNodeToVector(node);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Class compilation-unit/package/class :: Methods
	//
	//--------------------------------------------------------------------------
	
	public static function getClassExtends(unit:IParserNode):IParserNode
	{
		var extendsNode:IParserNode = getNode(AS3NodeKind.EXTENDS, getType(unit));
		return extendsNode;
	}
	
	public static function getClassImplements(unit:IParserNode):Vector.<IParserNode>
	{
		var node:IParserNode = getNode(AS3NodeKind.IMPLEMENTS_LIST, getType(unit));
		return copyNodeToVector(node);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Members compilation-unit/package/class|interface :: Methods
	//
	//--------------------------------------------------------------------------
	
	public static function getConstants(unit:IParserNode):Vector.<IParserNode>
	{
		var nodes:Vector.<IParserNode> = getNodes(AS3NodeKind.CONST_LIST, getTypeContent(unit));
		return copyVector(nodes);
	}
	
	public static function getVariables(unit:IParserNode):Vector.<IParserNode>
	{
		var nodes:Vector.<IParserNode> = getNodes(AS3NodeKind.VAR_LIST, getTypeContent(unit));
		return copyVector(nodes);
	}
	
	public static function getProperties(unit:IParserNode):Vector.<IParserNode>
	{
		return mergeVectors(getGetProperties(unit), getSetProperties(unit));
	}
	
	public static function getGetProperties(unit:IParserNode):Vector.<IParserNode>
	{
		var nodes:Vector.<IParserNode> = getNodes(AS3NodeKind.GET, getTypeContent(unit));
		return copyVector(nodes);
	}
	
	public static function getSetProperties(unit:IParserNode):Vector.<IParserNode>
	{
		var nodes:Vector.<IParserNode> = getNodes(AS3NodeKind.SET, getTypeContent(unit));
		return copyVector(nodes);
	}
	
	public static function getMethods(unit:IParserNode):Vector.<IParserNode>
	{
		var nodes:Vector.<IParserNode> = getNodes(AS3NodeKind.FUNCTION, getTypeContent(unit));
		return copyVector(nodes);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Function :: Methods
	//
	//--------------------------------------------------------------------------
	
	public static function getParameters(node:IParserNode):Vector.<IParserNode>
	{
		var node:IParserNode = getNode(AS3NodeKind.PARAMETER_LIST, node);
		return copyNodeToVector(node);
	}
	
	public static function isParameterRest(node:IParserNode):Boolean
	{
		if (node.numChildren == 0)
			return false;
		
		return node.getLastChild().isKind(AS3NodeKind.REST);
	}
	
	public static function getMethodType(node:IParserNode):IParserNode
	{
		// method type could either be 'type' or 'vector'
		var type:IParserNode = getNode(AS3NodeKind.TYPE, node);
		if (type)
			return type;
		
		type = getNode(AS3NodeKind.VECTOR, node);
		
		return type;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Node :: Methods
	//
	//--------------------------------------------------------------------------
	
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
	
	public static function getModifiers(node:IParserNode):Vector.<IParserNode>
	{
		var node:IParserNode = getNode(AS3NodeKind.MOD_LIST, node);
		return copyNodeToVector(node);
	}
	
	public static function getNameTypeInit(node:IParserNode, 
										   kind:String = null):IParserNode
	{
		var nti:IParserNode = getNode(AS3NodeKind.NAME_TYPE_INIT, node);
		
		switch (kind)
		{
			case AS3NodeKind.NAME:
				return nti.getChild(0);
				break;
			
			case AS3NodeKind.TYPE:
				return nti.getChild(1);
				break;
			
			case AS3NodeKind.INIT:
				return nti.getChild(2);
				break;
		}
		
		return nti;
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
	
	public static function toSourceCode(list:Array):String
	{
		var code:String = "";
		var len:int = list.length;
		for (var i:int = 0; i < len; i++)
		{
			var line:String = list[i] as String;
			code += line + "\n";
		}
		return code;
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
	
	/**
	 * @private
	 */
	private static function mergeVectors(vector1:Vector.<IParserNode>,
										 vector2:Vector.<IParserNode>):Vector.<IParserNode>
	{
		return vector1.concat(vector2);
	}
	
	/**
	 * @private
	 */
	private static function copyVector(vector:Vector.<IParserNode>):Vector.<IParserNode>
	{
		var result:Vector.<IParserNode> = new Vector.<IParserNode>();
		
		if (!vector || vector.length == 0)
			return result;
		
		var len:int = vector.length;
		for (var i:int = 0; i < len; i++)
		{
			result.push(vector[i]);
		}
		
		return result;
	}
	
	/**
	 * @private
	 */
	private static function copyNodeToVector(node:IParserNode):Vector.<IParserNode>
	{
		var result:Vector.<IParserNode> = new Vector.<IParserNode>();
		
		if (!node || node.numChildren == 0)
			return result;
		
		var len:int = node.numChildren;
		for (var i:int = 0; i < len; i++)
		{
			result.push(node.children[i]);
		}
		
		return result;
	}
}
}