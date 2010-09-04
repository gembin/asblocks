package org.teotigraphix.asblocks.utils
{
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.core.LinkedListToken;
import org.teotigraphix.as3parser.core.LinkedListTreeAdaptor;
import org.teotigraphix.as3parser.impl.AS3FragmentParser;
import org.teotigraphix.asblocks.impl.TokenBuilder;

public class ASTUtil
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
	
	public static function collapseWhitespace(startToken:LinkedListToken):void
	{
		// takes 2 tokens like "  " to " "
		if (startToken.channel == AS3NodeKind.HIDDEN 
			&& startToken.next.channel == AS3NodeKind.HIDDEN)
		{
			startToken.next.remove();
		}
	}
	
	public static function removeTrailingWhitespaceAndComma(stopToken:LinkedListToken, 
															trim:Boolean = false):void
	{
		for (var tok:LinkedListToken = stopToken.next; tok != null; tok = tok.next)
		{
			if (tok.channel == AS3NodeKind.HIDDEN)
			{
				tok.remove();
			}
			else if (tok.text == ",")
			{
				tok.remove();
				if (trim && stopToken.next.channel == AS3NodeKind.HIDDEN 
					&& stopToken.previous.channel == AS3NodeKind.HIDDEN)
				{
					stopToken.next.remove();
				}
				break;
			}
			else
			{
				throw new Error("Unexpected token: " + tok);
			}
		}
	}
	
	public static function printNode(ast:IParserNode):String
	{
		var result:String = "";
		for (var tok:LinkedListToken = ast.startToken; tok != null; tok = tok.next)
		{
			result += tok.text;
			if (tok == ast.stopToken)
			{
				break;
			}
		}
		return result;
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
		var init:IParserNode = AS3FragmentParser.parsePrimaryExpression(defaultValue);
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
												   stmt:IParserNode,
												   index:int = -1):void
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
		if (index == -1)
		{
			ast.addChild(stmt);
		}
		else
		{
			ast.addChildAt(stmt, index);
		}
	}
	
	public static function removeAllChildren(ast:IParserNode):void
	{
		while (ast.numChildren > 0)
		{
			ast.removeChildAt(0);
		}
	}
	
	public static function typeText(ast:IParserNode):String
	{
		// TYPE node, I want to change ast some day
		return ast.stringValue;
	}
	
	public static function nameText(ast:IParserNode):String
	{
		// NAME node, I want to change ast some day
		return ast.stringValue;
	}
	
	/**
	 * Converts an <code>IParserNode</code> into a flat XML String.
	 * 
	 * @param ast The <code>IParserNode</code> to convert.
	 * @return A String XML representation of the <code>IParserNode</code>.
	 */
	public static function convert(ast:IParserNode, 
								   location:Boolean = true):String
	{
		return visitNodes(ast, "", 0, location);
	}
	
	
	public static function decodeStringLiteral(string:String):String
	{
		var result:String = "";
		
		if (string.indexOf('"') != 0 && string.indexOf("'") != 0)
		{
			// SyntaxException
			throw new Error("Invalid delimiter at position 0: " + string[0]);
		}
		
		var chars:Array = string.split("");
		
		var delimiter:String = chars[0];
		var end:int = chars.length - 1;
		for (var i:int = 1; i < end; i++) 
		{
			var c:String = chars[i];
			switch (c) 
			{
				case '\\':
					
					c = chars[++i];
					switch (c) 
					{
						case 'n':
							result += '\n';
							break;
						case 't':
							result += '\t';
							break;
						case '\\':
							result += '\\';
							break;
						default:
							result += c;
					}
					break;
				
				default:
					result += c;
			}
		}
		
		if (chars[end] != delimiter) 
		{
			// SyntaxException
			throw new Error("End delimiter doesn't match " + delimiter + " at position " + end);
		}
		
		return result;
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
									   level:int,
									   location:Boolean = true):String
	{
		if (location)
		{
			result += "<" + ast.kind + " line=\"" + 
				ast.line + "\" column=\"" + ast.column + "\">";
		}
		else
		{
			result += "<" + ast.kind + ">";
		}
		
		var numChildren:int = ast.numChildren;
		if (numChildren > 0)
		{
			for (var i:int = 0; i < numChildren; i++)
			{
				result = visitNodes(ast.getChild(i), result, level + 1, location);
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