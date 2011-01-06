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
import org.as3commons.asblocks.api.IDocTag;
import org.as3commons.asblocks.impl.ASTAsDocBuilder;
import org.as3commons.asblocks.impl.ASTBuilder;
import org.as3commons.asblocks.impl.DocCommentNode;
import org.as3commons.asblocks.impl.DocTagNode;
import org.as3commons.asblocks.impl.TokenBuilder;
import org.as3commons.asblocks.parser.api.AS3NodeKind;
import org.as3commons.asblocks.parser.api.ASDocNodeKind;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.core.LinkedListToken;
import org.as3commons.asblocks.parser.core.TokenNode;
import org.as3commons.asblocks.parser.impl.AS3Parser;
import org.as3commons.asblocks.parser.impl.ASDocFragmentParser;
import org.as3commons.asblocks.parser.impl.ASDocParser;
import org.as3commons.asblocks.parser.impl.ASTIterator;

/**
 * @private
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class DocCommentUtil
{
	/**
	 * @private
	 */
	public static function createDocComment(ast:IParserNode):IDocComment
	{
		return new DocCommentNode(ast);
	}
	
	/**
	 * @private
	 * Returns the as-doc node on the doccomment aware node
	 */
	public static function buildCompilationUnit(parent:IParserNode):IParserNode
	{
		// find the as-doc node
		var ast:IParserNode = parent.getKind(AS3NodeKind.AS_DOC);
		
		// if there is no node, can't build anyting, just return
		if (!ast)
			return null;
		
		// rebuild an ast of the asdoc using the existing string value of the token
		var asdocAST:IParserNode = ASDocFragmentParser.parseCompilationUnit(ast.stringValue);
		
		return asdocAST;
	}
	
	public static function buildOrAddCompilationUnit(parent:IParserNode):IParserNode
	{
		var ast:IParserNode = buildCompilationUnit(parent);
		if (ast != null)
			return ast;
		
		ast = ASTBuilder.newAST(AS3NodeKind.AS_DOC, "/**\n */");
		
		var index:int = !parent.hasKind(AS3NodeKind.META_LIST) ? 0 : 1;
		parent.addChildAt(ast, index);
		var comtok:LinkedListToken = TokenBuilder.newMLComment("/**\n */");
		parent.startToken.prepend(comtok);
		comtok.append(TokenBuilder.newNewline());
		
		return buildCompilationUnit(parent);
	}
	
	public static function newAsDocAST(parent:IParserNode, text:String):IParserNode
	{
		var ast:IParserNode = ASTBuilder.newAST(AS3NodeKind.AS_DOC, text);
		ast.startToken.text = null;
		
		var index:int = 0;
		if (parent.hasKind(AS3NodeKind.META_LIST))
		{
			index++;
		}
		
		TokenNode(parent).absolute = true;
		parent.addChildAt(ast, index);
		TokenNode(parent).absolute = false;
		
		var token:LinkedListToken = TokenBuilder.newMLComment(text);
		ast.startToken.prepend(token);
		
		//token.append(TokenBuilder.newNewline());
		// append the \n\t to the end of the */
		appendNewline(parent, ast);
		
		return ast;
	}
	
	public static function getDescription(comment:IDocComment):String
	{
		var parent:IParserNode = comment.node;
		var ast:IParserNode = buildCompilationUnit(parent);
		if (ast == null)
			return null;
		
		var desc:IParserNode = ast.getKind(ASDocNodeKind.DESCRIPTION);
		var body:IParserNode = desc.getKind(ASDocNodeKind.BODY);
		// this is an empty comment that hasn't been deleted '/**\n */'
		if (!ASTAsDocBuilder.hasValidBody(ast))
			return null;
		return stringify(body);
	}
	
	private static function unsetDescription(comment:IDocComment):void
	{
		// find the token in the parent
		var parent:IParserNode = comment.node;
		// the asdoc node holds the 'stringValue' of the current nodes asdoc
		var asdoc:IParserNode = parent.getKind(AS3NodeKind.AS_DOC);
		// find the indent based on the parent nodes indentation
		var indent:String = ASTUtil.findIndent(parent);
		
		// must remove the body node making sure if there is an as-doc node
		// the tags stay in tact
		// must parse a whole compilation unit, remove the body
		var string:String = asdoc.stringValue;
		var asdocUnit:IParserNode = ASDocFragmentParser.parseCompilationUnit(string);
		var desc:IParserNode = asdocUnit.getKind(ASDocNodeKind.DESCRIPTION);
		
		if (desc.hasKind(ASDocNodeKind.DOCTAG_LIST))
		{
			// remove the body node
			desc.removeKind(ASDocNodeKind.BODY);
		}
		else
		{
			var i:ASTIterator = new ASTIterator(desc);
			i.find(ASDocNodeKind.BODY);
			var btok:IParserNode = ASTBuilder.newAST(ASDocNodeKind.BODY);
			btok.appendToken(TokenBuilder.newNewline());
			// for now, the space is to push the */ over one column
			btok.appendToken(TokenBuilder.newWhiteSpace(indent + " "));
			
			i.replace(btok);
			
			rebuildAST(parent, asdocUnit);
		}
	}
	
	private static function setNewDescription(comment:IDocComment,
											  description:String):void
	{
		// find the token in the parent
		var parent:IParserNode = comment.node;
		// the asdoc node holds the 'stringValue' of the current nodes asdoc
		var asdoc:IParserNode = parent.getKind(AS3NodeKind.AS_DOC);
		// find the indent based on the parent nodes indentation
		var indent:String = ASTUtil.findIndent(parent);
		
		description = documentizeDescription(comment, description);
		var newCommentString:String = "/**" + description + "\n" + indent + " */";
		comment.asdocNode = ASDocFragmentParser.parseCompilationUnit(newCommentString);
		
		var asdocAST:IParserNode = newAsDocAST(parent, newCommentString);
	}
	
	private static function resetNewDescription(comment:IDocComment,
												description:String):void
	{
		// find the token in the parent
		var parent:IParserNode = comment.node;
		// the asdoc node holds the 'stringValue' of the current nodes asdoc
		var asdocAST:IParserNode = parent.getKind(AS3NodeKind.AS_DOC);
		// find the indent based on the parent nodes indentation
		var indent:String = ASTUtil.findIndent(parent);
		
		description = documentizeDescription(comment, description);
		var newCommentString:String = "/**" + description + "\n" + indent + " */";
		comment.asdocNode = ASDocFragmentParser.parseCompilationUnit(newCommentString);
		
		asdocAST.stringValue = newCommentString;
		
		asdocAST.startToken.text = null;
		var atok:LinkedListToken = getASDocToken(asdocAST);
		atok.text = asdocAST.stringValue;
	}
	
	private static function documentizeDescription(comment:IDocComment, 
												   description:String):String
	{
		// find the token in the parent
		var parent:IParserNode = comment.node;
		// the asdoc node holds the 'stringValue' of the current nodes asdoc
		var asdoc:IParserNode = parent.getKind(AS3NodeKind.AS_DOC);
		// '\n\t * '
		var newline:String = getNewlineText(parent, asdoc);
		// this allows the description to start with a newline atrix '/**\n ws* description'
		if (description.indexOf("\n") != 0)
		{
			description = "\n" + description;
		}
		
		// replace all \n in the description with proper '\n\t * ' newline headers
		description = description.replace(/\n/g, newline);
		
		return description;
	}
	
	// this method is completly overridding the whole 'body' node of the as-doc
	// node, this means that the tags are held in the nodes description, not the body
	// we should be checking for the as-doc, if it exists, get the body node, reparse
	// then add the body node back into the as-doc description
	public static function setDescription(comment:IDocComment, description:String):void
	{
		// find the token in the parent
		var parent:IParserNode = comment.node;
		// the asdoc node holds the 'stringValue' of the current nodes asdoc
		var asdocAST:IParserNode = parent.getKind(AS3NodeKind.AS_DOC);
		// find the indent based on the parent nodes indentation
		var indent:String = ASTUtil.findIndent(parent);
		
		// 1) description needs to be unset
		if (description == null)
		{
			unsetDescription(comment);
			return;
		}
		
		// 2) we have no asdoc and no doctags
		if (asdocAST == null)
		{
			setNewDescription(comment, description);
			return;
		}
		
		var i:ASTIterator;
		var asdocUnit:IParserNode;
		var descAST:IParserNode;
		var listAST:IParserNode;
		
		// check to see if we have doc tags
		// parse the old asdoc comment
		asdocUnit = ASDocFragmentParser.parseCompilationUnit(asdocAST.stringValue);
		descAST = asdocUnit.getKind(ASDocNodeKind.DESCRIPTION);
		listAST = descAST.getKind(ASDocNodeKind.DOCTAG_LIST);
		
		// 3) we have a current as-doc stringValue and no doc tags
		if (listAST == null)
		{
			resetNewDescription(comment, description);
			return;
		}
		
		// 4) we have a new description pending and have an existing doc list
		// replace the body
		if (listAST)
		{
			description = description + "\n";
		}
		
		description = documentizeDescription(comment, description);
		
		// create the ast for the description
		var bodyAST:IParserNode = parseBody(description);
		
		// token before this comment takes care of it's own \n\t indent
		// !!! Tokens and blocks always end with [newline][indent]
		var result:String;
		
		asdocUnit = ASDocFragmentParser.parseCompilationUnit(asdocAST.stringValue);
		descAST = asdocUnit.getKind(ASDocNodeKind.DESCRIPTION);
		
		i = new ASTIterator(descAST);
		i.search(ASDocNodeKind.BODY);
		i.replace(bodyAST);
		
		listAST = descAST.getKind(ASDocNodeKind.DOCTAG_LIST);
		if (listAST)
		{
			ASTAsDocBuilder.addDocTagListLineBreak(listAST, parent, true);
		}
		
		result = ASTUtil.stringifyNode(asdocUnit);
		
		
		asdocAST.stringValue = result;
		
		asdocAST.startToken.text = null;
		var atok:LinkedListToken = getASDocToken(asdocAST);
		atok.text = asdocAST.stringValue;
		
		comment.asdocNode = asdocUnit;
		
		
	}
	
	public static function getASDocToken(asdoc:IParserNode):LinkedListToken
	{
		for (var tok:LinkedListToken =  asdoc.startToken; tok != null; tok = tok.previous)
		{
			if (tok.kind == AS3NodeKind.ML_COMMENT)
				return tok;
		}
		return null;
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
	
	public static function appendNewline(parent:IParserNode, ast:IParserNode):void
	{
		var indent:String = ASTUtil.findIndent(parent);
		var indentTok:LinkedListToken = TokenBuilder.newWhiteSpace(indent);
		ast.appendToken(TokenBuilder.newNewline());
		ast.appendToken(indentTok);
	}
	
	public static function findNewline(ast:IParserNode):String
	{
		var tok:LinkedListToken = ast.stopToken;
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
	
	public static function stringify(ast:IParserNode):String
	{
		var result:String = "";
		
		var tok:LinkedListToken = ast.startToken;
		while (tok != null && tok.kind != null)
		{
			if (tok.text != null 
				&& tok.channel != "hidden"
				&& tok.kind != "astrix"
				&& tok.kind != "ws"
				|| (tok.channel == null && tok.kind == "nl"))
			{
				if (tok.kind == "nl")
				{
					result += "\n";
				}
				else
				{
					result += tok.text;
				}
			}
			
			if (tok == ast.stopToken)
			{
				break;
			}
			
			tok = tok.next;
		}
		
		return result;
	}
	
	public static function newDocTag(comment:IDocComment, 
									 name:String, 
									 body:String = null):IDocTag
	{
		var asdoc:IParserNode = buildCompilationUnit(comment.node);
		if (!asdoc)
		{
			asdoc = buildOrAddCompilationUnit(comment.node);
			DocCommentNode(comment).asdocNode = asdoc;
		}
		
		var list:IParserNode = findDoctagList(DocCommentNode(comment).asdocNode);
		if (!list)
		{
			list = ASTAsDocBuilder.newDocTagList(comment.node);
			var description:IParserNode = DocCommentNode(comment).asdocNode.getKind(ASDocNodeKind.DESCRIPTION);
			description.addChild(list);
			// if the asdoc has a valid body, add the line break
			if (ASTAsDocBuilder.hasValidBody(asdoc))
			{
				ASTAsDocBuilder.addDocTagListLineBreak(list, comment.node);
			}
		}
		
		// "
		//  * @foo"
		var tag:IParserNode = ASTAsDocBuilder.addDocTag(comment.node, name, body);
		
		list.addChild(tag);
		
		rebuildAST(comment.node, DocCommentNode(comment).asdocNode);
		
		return new DocTagNode(tag);
	}
	
	public static function removeDocTag(comment:IDocComment, tag:IDocTag):Boolean
	{
		var asdoc:IParserNode = comment.asdocNode;
		if (!asdoc)
			return false;
		
		var list:TokenNode = findDoctagList(asdoc) as TokenNode;
		if (!list)
			return false;
		
		var i:ASTIterator = new ASTIterator(list);
		while (i.hasNext())
		{
			var ast:IParserNode = i.next();
			if (ast === tag.node)
			{
				list.removeChild(ast);
				if (list.numChildren == 0)
				{
					list.parent.removeChild(list);
				}
				
				//if (list.numChildren == 0)
				//{
				//	ASTAsDocBuilder.removeDocTagListLineBreak(list, comment.node);
				//}
				
				rebuildAST(comment.node, asdoc);
				return true;
			}
		}
		return false;
	}
	
	public static function hasDocTag(parent:IParserNode, name:String):Boolean
	{
		var list:TokenNode = findDoctagList(parent) as TokenNode;
		if (!list)
			return false;
		
		var i:ASTIterator = new ASTIterator(list);
		while (i.hasNext())
		{
			var tag:IDocTag = new DocTagNode(i.next());
			if (tag.name == name)
				return true;
		}
		return false;
	}
	
	public static function rebuildAST(parent:IParserNode, asdoc:IParserNode):void
	{
		var result:String = ASTUtil.stringifyNode(asdoc);
		
		var ast:IParserNode = parent.getKind(AS3NodeKind.AS_DOC);
		ast.stringValue = result;
		ast.startToken.text = null;
		
		var tok:LinkedListToken = DocCommentUtil.getASDocToken(ast);
		tok.text = result;
	}
	
	private static function parseDescription(input:String):IParserNode
	{
		// parseDescription requires the /** */ for parenthetic
		var ast:IParserNode = ASDocFragmentParser.parseDescription("/**" + input + "*/");
		return ast;
	}
	
	private static function parseBody(input:String):IParserNode
	{
		var ast:IParserNode = ASDocFragmentParser.parseBody(input);
		return ast;
	}
	
	private static function getCommentBody(ast:IParserNode):String
	{
		var result:String = ast.stringValue;
		return result.substring(3, result.length - 2);
	}
	
	private static function findDescription(ast:IParserNode):IParserNode
	{
		if (!ast)
			return null;
		return ast.getKind(ASDocNodeKind.DESCRIPTION);
	}
	
	private static function findDoctagList(ast:IParserNode):IParserNode
	{
		var ast:IParserNode = findDescription(ast);
		if (!ast)
			return null;
		return ast.getKind(ASDocNodeKind.DOCTAG_LIST);
	}
}
}