package org.as3commons.asblocks.impl
{

import org.as3commons.asblocks.parser.api.ASDocNodeKind;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.core.LinkedListToken;
import org.as3commons.asblocks.utils.ASTUtil;
import org.as3commons.asblocks.utils.DocCommentUtil;

public class ASTAsDocBuilder
{
	public static function newDocTagList(parent:IParserNode):IParserNode
	{
		var ast:IParserNode = ASTBuilder.newAST(ASDocNodeKind.DOCTAG_LIST);	
		return ast;
	}
	
	public static function addDocTagListLineBreak(ast:IParserNode, parent:IParserNode, start:Boolean = false):void
	{
		//ast.appendToken(TokenBuilder.newNewline());
		var indent:String = ASTUtil.findIndent(parent);
		//ast.appendToken(TokenBuilder.newWhiteSpace(indent + " * "));
		
		var breakToken:LinkedListToken = TokenBuilder.newWhiteSpace("\n" + indent + " * ");
		breakToken.kind = "doctag-list-break";
		
		if (!start)
		{
			ast.appendToken(breakToken);
		}
		else
		{
			ast.startToken.append(breakToken);
		}
	}
	
	public static function removeDocTagListLineBreak(ast:IParserNode, parent:IParserNode):void
	{
		
	}
	
	
	
	public static function hasValidBody(ast:IParserNode):Boolean
	{
		var desc:IParserNode = ast.getKind(ASDocNodeKind.DESCRIPTION);
		var body:IParserNode = desc.getKind(ASDocNodeKind.BODY);
		// this is an empty comment that hasn't been deleted '/**\n */'
		if (body.numChildren == 1 && body.getChild(0).isKind("nl"))
			return false;
		return true;
	}
	
	public static function newDocTag():IParserNode
	{
		var ast:IParserNode = ASTBuilder.newAST(ASDocNodeKind.DOCTAG);
		return ast;
	}
	
	public static function addDocTag(parent:IParserNode, name:String, body:String):IParserNode
	{
		var indent:String = ASTUtil.findIndent(parent);
		
		var ast:IParserNode = newDocTag();
		ast.appendToken(TokenBuilder.newToken(ASDocNodeKind.NL, "\n"));
		ast.appendToken(TokenBuilder.newToken(ASDocNodeKind.WS, indent + " "));
		ast.appendToken(TokenBuilder.newToken(ASDocNodeKind.ASTRIX, "*"));
		ast.appendToken(TokenBuilder.newToken(ASDocNodeKind.WS, " "));
		ast.appendToken(TokenBuilder.newToken(ASDocNodeKind.AT, "@"));
		ast.addChild(ASTBuilder.newNameAST(name));
		
		//\n * @foo
		var result:String = ASTUtil.stringifyNode(ast);
		
		if (body)
		{
			ast.appendToken(TokenBuilder.newSpace());
			var nl:String = DocCommentUtil.getNewlineText(parent, ast);
			
			body = body.replace(/\n/g, nl);
			ast.addChild(ASTBuilder.newAST(ASDocNodeKind.BODY, body));
		}
		
		return ast;
	}
}
}