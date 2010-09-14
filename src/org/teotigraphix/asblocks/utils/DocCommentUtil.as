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
import org.teotigraphix.as3parser.impl.ASDocParser;
import org.teotigraphix.asblocks.api.IDocComment;
import org.teotigraphix.asblocks.impl.DocCommentNode;
import org.teotigraphix.asblocks.impl.TokenBuilder;

/**
 * TODO DOCME
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class DocCommentUtil
{
	public static function buildOrAddAsDocAST(parent:IParserNode):IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.AS_DOC, "/** */");
		var index:int = !parent.hasKind(AS3NodeKind.META_LIST) ? 0 : 1;
		parent.addChildAt(ast, index);
		
		return buildASDoc(parent);
	}
	
	public static function buildASDoc(ast:IParserNode):IParserNode
	{
		// find the as-doc node
		var asdoc:IParserNode = ast.getKind(AS3NodeKind.AS_DOC);
		if (!asdoc)
		{
			return null;
		}
		
		var parser:ASDocParser = new ASDocParser();
		var ast:IParserNode = parser.buildAst(Vector.<String>(asdoc.stringValue.split("\n")), null);
		return ast;
	}
	
	public static function createDocComment(ast:IParserNode):IDocComment
	{
		return new DocCommentNode(ast);
	}
	
	public static function setDescription(parent:IParserNode, description:String):void
	{
		var indent:String = ASTUtil.findIndent(parent);
		
		var d:String = "";
		// this won't change
		d += "/**\n";
		
		// split the description string on \n, then loop the description together
		d += convertDescription(description, indent);
		
		// then add the doc tags doing the same with splitting on the \n
		d += indent + " * \n";
		
		
		// this won't change
		d += indent + " */";
		
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.AS_DOC, d);
		
		var indentTok:LinkedListToken = TokenBuilder.newWhiteSpace(indent);
		
		parent.addChildAt(ast, 0);
		ast.appendToken(TokenBuilder.newNewline());
		ast.appendToken(indentTok);
	}
	
	
	private static function convertDescription(description:String, indent:String):String
	{
		var result:String = "";
		
		var split:Array = description.split("\n");
		var len:int = split.length;
		for (var i:int = 0; i < len; i++)
		{
			var middle:String = (i == 0) ? " * " : " *";
			result += indent + middle + split[i] + "\n";
		}
		
		return result;
	}
}
}