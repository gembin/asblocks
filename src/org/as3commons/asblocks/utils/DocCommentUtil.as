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

package org.as3commons.asblocks.utils
{

import mx.utils.StringUtil;

import org.as3commons.asblocks.api.IDocComment;
import org.as3commons.asblocks.impl.ASTBuilder;
import org.as3commons.asblocks.impl.DocCommentNode;
import org.as3commons.asblocks.impl.TokenBuilder;
import org.as3commons.asblocks.parser.api.AS3NodeKind;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.core.LinkedListToken;
import org.as3commons.asblocks.parser.core.TokenNode;
import org.as3commons.asblocks.parser.impl.ASDocFragmentParser;
import org.as3commons.asblocks.parser.impl.ASDocParser;

/**
 * @private
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class DocCommentUtil
{
	public static function createDocComment(ast:IParserNode):IDocComment
	{
		return new DocCommentNode(ast);
	}
	
	
	
	
	
	
	public static function buildOrAddAsDocAST(parent:IParserNode):IParserNode
	{
		var ast:IParserNode = parent.getKind(AS3NodeKind.AS_DOC);
		if (ast)
		{
			return buildASDoc(parent);
		}
		
		ast = ASTBuilder.newAST(AS3NodeKind.AS_DOC, "/** */");
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

		return newAST;
	}
	

	
	private static function getCommentBody(ast:IParserNode):String
	{
		var result:String = ast.stringValue;
		return result.substring(3, result.length - 2);
	}
	
	private static function parse(input:String):IParserNode
	{
		var ast:IParserNode = ASDocFragmentParser.parseBody(input);
		return ast;
	}
	
	private static function parseDescription(input:String):IParserNode
	{
		var ast:IParserNode = ASDocFragmentParser.parseBody(input);
		return ast;
	}
	
	public static function getDescription(ast:IParserNode):String
	{
		var asdoc:IParserNode = buildASDoc(ast);
		if (asdoc == null) {
			return null;
		}
		var desc:IParserNode = asdoc.getFirstChild().getFirstChild();
		return stringify(desc);
	}
	
	public static function stringify(ast:IParserNode):String
	{
		var result:String = "";
		for (var tok:LinkedListToken =  ast.startToken; tok != null && tok.kind != null; tok = tok.next)
		{
			if (tok.text != null && tok.channel != "hidden")
			{
				result += tok.text;
			}
			else if (tok.kind == "nl" && tok.channel != "hidden")
			{
				result += "\n";
			}
			
			if (tok == ast.stopToken)
			{
				break;
			}
		}
		return result;
	}
	
	public static function setDescription(parent:IParserNode, description:String):void
	{
		// find the token in the parent
		var asdoc:IParserNode = parent.getKind(AS3NodeKind.AS_DOC);
		
		//if (!asdoc)
		//{
		//	var body:String = getCommentBody(asdoc);
		//	asdoc = parse(body);
		//}
		//else
		//{
		//	
		//}
		
		// '\n\t * '
		var newline:String = getNewlineText(parent, asdoc);
		// this allows the description to start with a newline atrix '/**\n ws* description'
		if (description.indexOf("\n") != 0)
		{
			description = "\n" + description;
		}
		
		// replace all \n in the description with proper '\n\t * ' newline headers
		description = description.replace(/\n/g, newline);
		
		// create the ast for the description
		var newDesc:IParserNode = parseDescription(description);
		
		var test1:String = ASTUtil.stringifyNode(newDesc);
		
		trace(test1);
		trace(test1 == description);
		
		// find the indent based on the parent nodes indentation
		var indent:String = ASTUtil.findIndent(parent);
		
		// token before this comment takes care of it's own \n\t indent
		// !!! Tokens and blocks always end with [newline][indent]
		var result:String = "/**" + ASTUtil.stringifyNode(newDesc) + "\n" + indent + " */";
		
		if (asdoc == null)
		{
			// FIXME (mschmalle) this is for parenthetic updates such as meta []
			// the /** */ needs to go before the [
			asdoc = ASTBuilder.newAST(AS3NodeKind.AS_DOC, result);
			asdoc.startToken.text = null;
			
			var index:int = 0;
			if (parent.hasKind(AS3NodeKind.META_LIST))
			{
				index++;
			}
			
			TokenNode(parent).absolute = true;
			parent.addChildAt(asdoc, index);
			var rs:String = ASTUtil.convert(asdoc, false);
			TokenNode(parent).absolute = false;
			
			var tok:LinkedListToken = TokenBuilder.newMLComment(result);
			asdoc.startToken.prepend(tok);
			
			// append the \n\t to the end of the */
			appendNewline(parent, asdoc);
		}
		else
		{
			asdoc.stringValue = "/**" + description + "\n" + indent + " */";
			asdoc.startToken.text = null;
			var atok:LinkedListToken = getASDocToken(asdoc);
			atok.text = asdoc.stringValue;
		}
	}
	
	public static function getASDocToken(asdoc:IParserNode):LinkedListToken
	{
		for (var tok:LinkedListToken =  asdoc.startToken; tok != null; tok = tok.previous)
		{
			if (tok.kind == "ml-comment")
				return tok;
		}
		return null;
	}
	
	
	public static function appendNewline(parent:IParserNode, ast:IParserNode):void
	{
		var indent:String = ASTUtil.findIndent(parent);
		var indentTok:LinkedListToken = TokenBuilder.newWhiteSpace(indent);
		ast.appendToken(TokenBuilder.newNewline());
		ast.appendToken(indentTok);
	}
	
	public static function getNewlineText(ast:IParserNode, asdoc:IParserNode):String
	{
		var newline:String = null;
		//if (asdoc != null)
		//{
		//	newline = findNewline(asdoc);
		//}
		if (newline == null)
		{
			newline = "\n" + ASTUtil.findIndent(ast) + " * ";
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
			if (tok.text == "\n")
			{
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
			var middle:String = (i == 0) ? "" : " * ";
			result += indent + middle + split[i] + "\n";
		}
		
		return result;
	}
}
}