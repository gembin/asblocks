package org.teotigraphix.as3blocks.utils
{
import org.teotigraphix.as3blocks.impl.TokenBuilder;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.core.LinkedListToken;
import org.teotigraphix.as3parser.core.LinkedListTreeAdaptor;
import org.teotigraphix.as3parser.impl.AS3FragmentParser2;

public class ASTUtil2
{
	private static var adapter:LinkedListTreeAdaptor = new LinkedListTreeAdaptor();
	
	public static function findIndent(node:IParserNode):String
	{
		var tok:LinkedListToken = node.startToken;
		if (!tok)
		{
			return findIndent(node.parent);
		}
		
		// the start-token of this AST node is actually whitespace, so
		// scan forward until we hit a non-WS token,
		while (tok.kind == AS3NodeKind.NL || tok.kind == AS3NodeKind.WS)
		{
			if (tok.next == null) 
			{
				break;
			}
			tok = tok.next;
		}
		// search backwards though the tokens, looking for the start of
		// the line,
		for (; tok.previous != null; tok = tok.previous)
		{
			if (tok.kind == AS3NodeKind.NL)
			{
				break;
			}
		}
		if (tok.kind == AS3NodeKind.WS)
		{
			return tok.text;
		}
		if (tok.kind != AS3NodeKind.NL) 
		{
			return "";
		}
		
		var startOfLine:LinkedListToken = tok.next;
		
		if (startOfLine.kind == AS3NodeKind.WS)
		{
			return startOfLine.text;
		}
		return "";
	}
	
	public static function newParentheticAST(kind:String, 
											 startKind:String,
											 startText:String,
											 endKind:String,
											 endText:String):IParserNode
	{
		var ast:IParserNode = newAST(kind);
		var start:LinkedListToken = TokenBuilder.newToken(startKind, startText);
		ast.startToken = start;
		var stop:LinkedListToken = TokenBuilder.newToken(endKind, endText);
		ast.stopToken = stop;
		start.next = stop;
		ast.initialInsertionAfter = start;
		return ast;
	}
	
	public static function increaseIndent(node:IParserNode, indent:String):void
	{
		var newStart:LinkedListToken = increaseIndentAt(node.startToken, indent);
		node.startToken = newStart;
		increaseIndentAfterFirstLine(node, indent);
	}
	
	
	public static function increaseIndentAfterFirstLine(node:IParserNode, indent:String):void
	{
		for (var tok:LinkedListToken = node.startToken ; tok != node.stopToken; tok = tok.next)
		{
			switch (tok.kind)
			{
				case AS3NodeKind.NL:
					tok = increaseIndentAt(tok.next, indent);
					break;
				case AS3NodeKind.AS_DOC:
					//					DocCommentUtils.increaseCommentIndent(tok, indent);
					break;
			}
		}
	}
	
	private static function increaseIndentAt(tok:LinkedListToken, indentStr:String):LinkedListToken
	{
		if (tok.kind == AS3NodeKind.WS) 
		{
			tok.text = indentStr + tok.text;
			return tok;
		}
		
		var indent:LinkedListToken = TokenBuilder.newWhiteSpace(indentStr);
		tok.beforeInsert(indent);
		
		return indent;
	}
	
	public static function newAST(kind:String, text:String = null):IParserNode
	{
		return adapter.create(kind, text);
	}
	
	public static function newTokenAST(token:LinkedListToken):IParserNode
	{
		return adapter.createNode(token);
	}
	
	
	/**
	 * Returns the first child of the given AST node which has the given
	 * type, or null, if no such node exists.
	 */
	public static function findChildByType(ast:IParserNode, kind:String):IParserNode
	{
		return ast.getKind(kind);
	}
	
	public static function newNameAST(name:String):IParserNode
	{
		var ast:IParserNode = newAST(AS3NodeKind.NAME, name);
		return ast;
	}
	
	public static function newTypeAST(type:String):IParserNode
	{
		var ast:IParserNode = newAST(AS3NodeKind.TYPE, type);
		return ast;
	}
	
	public static function newInitAST(defaultValue:String):IParserNode
	{
		var ast:IParserNode = newAST(AS3NodeKind.INIT);
		var init:IParserNode = AS3FragmentParser2.parsePrimaryExpression(defaultValue);
		ast.addChild(init);
		return ast;
	}
	
	public static function newParamterListAST():IParserNode
	{
		var ast:IParserNode = newAST(AS3NodeKind.PARAMETER_LIST);
		return ast;
	}
	
	public static function newParamterAST():IParserNode
	{
		var ast:IParserNode = newAST(AS3NodeKind.PARAMETER);
		ast.addChild(newAST(AS3NodeKind.NAME_TYPE_INIT));
		return ast;
	}
	
	public static function addChildWithIndentation(ast:IParserNode, 
												   stmt:IParserNode):void
	{
		var last:IParserNode = ast.getLastChild();
		var indent:String;
		if (last == null)
		{
			indent = "\t" + findIndent(ast);
		}
		else
		{
			indent = findIndent(last);
		}
		
		increaseIndent(stmt, indent);
		stmt.addTokenAt(TokenBuilder.newNewline(), 0);
		ast.addChild(stmt);
	}
	
	
	
	
}
}