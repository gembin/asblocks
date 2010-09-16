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

import mx.utils.StringUtil;

import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.core.LinkedListToken;
import org.teotigraphix.as3parser.core.TokenNode;
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
		// the ast is the as-doc node's parent IE IType
		
		// find the as-doc node
		var asdoc:IParserNode = ast.getKind(AS3NodeKind.AS_DOC);
		// if there is no node, can't build anyting, just return
		if (!asdoc)
		{
			return null;
		}
		
		var parser:ASDocParser = new ASDocParser();
		// rebuild an ast of the asdoc using the existing string value of the token
		var newAST:IParserNode = parser.buildAst(
			Vector.<String>(asdoc.stringValue.split("\n")), null);
		
		var t:String = stringifyNode(newAST);
		
		return newAST;
	}
	
	public static function createDocComment(ast:IParserNode):IDocComment
	{
		return new DocCommentNode(ast);
	}
	
	private static function getCommentBody(ast:IParserNode):String
	{
		var result:String = ast.stringValue;
		return result.substring(3, result.length - 2);
	}
	
	private static function parse(input:String):IParserNode
	{
		var parser:ASDocParser = new ASDocParser();
		parser.scanner.setLines(Vector.<String>(input.split("\n")));
		parser.nextToken();
		var ast:IParserNode = parser.parseContent();
		return ast;
	}
	
	private static function parseDescription(input:String):IParserNode
	{
		var parser:ASDocParser = new ASDocParser();
		parser.scanner.setLines(Vector.<String>(input.split("\n")));
		parser.nextToken();
		var ast:IParserNode = parser.parseBody();
		return ast;
	}
	
	public static function setDescription(parent:IParserNode, description:String):void
	{
		// find the token in the parent
		var asdoc:IParserNode = parent.getKind(AS3NodeKind.AS_DOC);
		var desc:IParserNode;
		
		if (asdoc)
		{
			asdoc = parse(getCommentBody(asdoc));
			desc = asdoc.getFirstChild();
		}
		else
		{
			
		}
		
		var newline:String = getNewlineText(parent, asdoc);
		if (description.indexOf("\n") != 0)
		{
			description = "\n" + description;
		}
		
		description = description.replace(/\n/g, newline);
		var newDesc:IParserNode = parseDescription(description);
		var indent:String = ASTUtil.findIndent(parent);
		var result:String = "/**" + ASTUtil.stringifyNode(newDesc)/* + "\n"*/ + indent + " */";
		
		if (asdoc == null)
		{
			// FIXME this is for parenthetic updates such as meta []
			// the /** */ needs to go before the [
			asdoc = ASTUtil.newAST(AS3NodeKind.AS_DOC, result);
			TokenNode(parent).absolute = true;
			parent.addChildAt(asdoc, 0);
			TokenNode(parent).absolute = false;
			// FIXME is this right, explain why
			var indentTok:LinkedListToken = TokenBuilder.newWhiteSpace(indent);
			asdoc.appendToken(TokenBuilder.newNewline());
			asdoc.appendToken(indentTok);
		}
		else
		{
			asdoc.stringValue = result;
		}
	}
	
	public static function getNewlineText(ast:IParserNode, javadoc:IParserNode):String
	{
		var newline:String = null;
		if (javadoc != null)
		{
			newline = findNewline(javadoc);
		}
		if (newline == null)
		{
			newline = "\n" + ASTUtil.findIndent(ast) + " * ";  // TODO: use document existing end-of-line format
		}
		return newline;
	}
	
	public static function findNewline(javadoc:IParserNode):String
	{
		var tok:LinkedListToken = javadoc.stopToken;
		if (tok.text == "\n")
		{
			// Skip the very-last NL, since this will precede the
			// closing-comment marker, and therefore will lack the
			// '*' that should be present at the start of every
			// other line,
			tok = tok.previous;
		}
		for (; tok != null; tok = tok.previous)
		{
			if (tok.text == "\n") {
				
				return tok.text;
			}
		}
		return null;
	}
	
	public static function stringifyNode(ast:IParserNode):String
	{
		var result:String = "";
		for (var tok:LinkedListToken =  ast.startToken; tok != null && tok.kind != null; tok = tok.next)
		{
			if (tok.text != null && tok.text == "\n")
			{
				result += tok.text + "*";
			}
			else if (tok.text != null)
			{
				result += tok.text;
			}
			
			if (tok == ast.stopToken)
			{
				break;
			}
		}
		return result;
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