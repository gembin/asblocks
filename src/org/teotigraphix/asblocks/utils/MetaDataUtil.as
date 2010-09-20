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

package org.teotigraphix.asblocks.utils
{

import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.core.LinkedListToken;
import org.teotigraphix.as3parser.impl.ASTIterator;
import org.teotigraphix.asblocks.api.IMetaData;
import org.teotigraphix.asblocks.impl.ASTBuilder;
import org.teotigraphix.asblocks.impl.MetaDataNode;
import org.teotigraphix.asblocks.impl.TokenBuilder;

/**
 * A utility class for working with the <code>IMetaDataAware</code> api.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class MetaDataUtil
{
	public static function getMetaDatas(ast:IParserNode):Vector.<IMetaData>
	{
		var result:Vector.<IMetaData> = new Vector.<IMetaData>();
		
		var list:IParserNode = findMetaList(ast);
		if (!list)
			return result;
		
		var i:ASTIterator = new ASTIterator(list);
		while (i.hasNext())
		{
			result.push(new MetaDataNode(i.next()));
		}
		
		return result;
	}
	
	public static function newMetaData(ast:IParserNode, name:String):IMetaData
	{
		var metadata:IMetaData = ASTBuilder.newMetaData(name);
		var list:IParserNode = ast.getKind(AS3NodeKind.META_LIST);
		if (!list)
		{
			list = ASTUtil.newAST(AS3NodeKind.META_LIST);
			ast.addChildAt(list, 0);
		}
		var indent:String = ASTUtil.findIndent(ast);
		
		var indentTok:LinkedListToken = TokenBuilder.newWhiteSpace(indent);
		
		list.addChild(metadata.node);
		list.appendToken(TokenBuilder.newNewline());
		list.appendToken(indentTok);
		return metadata;
	}
	
	public static function getMetaData(ast:IParserNode, name:String):IMetaData
	{
		var list:IParserNode = findMetaList(ast);
		if (!list)
			return null;
		
		var i:ASTIterator = new ASTIterator(list);
		while (i.hasNext())
		{
			var meta:IParserNode = i.next();
			if (meta.isKind(AS3NodeKind.NAME) && meta.stringValue == name)
			{
				return new MetaDataNode(meta);
			}
		}
		return null;
	}
	
	public static function getAllMetaData(ast:IParserNode, name:String):Vector.<IMetaData>
	{
		var result:Vector.<IMetaData> = new Vector.<IMetaData>();
		
		var list:IParserNode = findMetaList(ast);
		if (!list)
			return result;
		
		var i:ASTIterator = new ASTIterator(list);
		while (i.hasNext())
		{
			var meta:IParserNode = i.next();
			if (meta.isKind(AS3NodeKind.NAME) && meta.stringValue == name)
			{
				result.push(new MetaDataNode(i.next()));
			}
		}
		
		return result;
	}
	
	public static function hasMetaData(ast:IParserNode, name:String):Boolean
	{
		var list:IParserNode = findMetaList(ast);
		if (!list)
			return false;
		
		var i:ASTIterator = new ASTIterator(list);
		while (i.hasNext())
		{
			var meta:IParserNode = i.next();
			if (meta.isKind(AS3NodeKind.NAME) && meta.stringValue == name)
			{
				return true;
			}
		}
		return false;
	}
	
	public static function removeMetaData(ast:IParserNode, metaData:IMetaData):Boolean
	{
		var list:IParserNode = findMetaList(ast);
		if (!list)
			return false;
		
		var i:ASTIterator = new ASTIterator(list);
		while (i.hasNext())
		{
			var meta:IParserNode = i.next();
			if (meta === metaData)
			{
				i.remove();
				return true;
			}
		}
		return false;
	}
	
	/**
	 * @private
	 */
	private static function findMetaList(ast:IParserNode):IParserNode
	{
		return ast.getKind(AS3NodeKind.META_LIST);
	}
}
}