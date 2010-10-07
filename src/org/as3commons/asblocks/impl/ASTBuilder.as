package org.as3commons.asblocks.impl
{

import org.as3commons.asblocks.api.IMetaData;
import org.as3commons.asblocks.api.Visibility;
import org.as3commons.asblocks.parser.api.AS3NodeKind;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.api.IToken;
import org.as3commons.asblocks.parser.core.LinkedListToken;
import org.as3commons.asblocks.parser.impl.AS3FragmentParser;
import org.as3commons.asblocks.utils.ASTUtil;

public class ASTBuilder
{
	public static function newComment(ast:IParserNode, text:String):IToken
	{
		var comment:LinkedListToken = TokenBuilder.newSLComment("//" + text);
		var indent:String = ASTUtil.findIndentForComment(ast);
		ast.appendToken(TokenBuilder.newNewline());
		ast.appendToken(TokenBuilder.newWhiteSpace(indent));
		ast.appendToken(comment);
		return comment;
	}
	
	public static function newType(type:String):IParserNode
	{
		var colon:LinkedListToken = TokenBuilder.newColon();
		var ast:IParserNode = AS3FragmentParser.parseType(type);
		ast.startToken.prepend(colon);
		ast.startToken = colon;
		return ast;
	}
	
	public static function newParameter(name:String, type:String, defaultValue:String):IParserNode
	{
		var ast:IParserNode = ASTUtil.newParamterAST();
		var nti:IParserNode = ast.getKind(AS3NodeKind.NAME_TYPE_INIT);
		nti.addChild(ASTUtil.newNameAST(name));
		
		var colon:LinkedListToken = TokenBuilder.newColon();
		var typeAST:IParserNode = AS3FragmentParser.parseType(type);
		typeAST.startToken.prepend(colon);
		typeAST.startToken = colon;
		nti.addChild(typeAST);
		
		if (defaultValue)
		{
			nti.appendToken(TokenBuilder.newSpace());
			nti.appendToken(TokenBuilder.newAssign());
			nti.appendToken(TokenBuilder.newSpace());
			nti.addChild(ASTUtil.newInitAST(defaultValue));
		}
		
		return ast;
	}
	
	public static function newRestParameter(name:String):IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.PARAMETER);
		var restAST:IParserNode = ASTUtil.newAST(AS3NodeKind.REST, name);
		ast.addChild(restAST);
		var rest:LinkedListToken = TokenBuilder.newToken(AS3NodeKind.REST_PARM, "...");
		ast.startToken.prepend(rest);
		ast.startToken = rest;
		return ast;
	}
	
	public static function newMetaData(name:String):IMetaData
	{
		var ast:IParserNode = ASTUtil.newParentheticAST(
			AS3NodeKind.META, 
			AS3NodeKind.LBRACKET, "[", 
			AS3NodeKind.RBRACKET, "]");
		
		ast.addChild(ASTUtil.newNameAST(name));
		
		return new MetaDataNode(ast);
	}
	
	public static function newFunctionAST(name:String, 
										  returnType:String, 
										  addModList:Boolean = true):IParserNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.FUNCTION);
		if (addModList)
		{
			var mods:IParserNode = ASTUtil.newAST(AS3NodeKind.MOD_LIST);
			mods.addChild(ASTUtil.newAST(AS3NodeKind.MODIFIER, Visibility.PUBLIC.toString()));
			ast.addChild(mods);
		}
		ast.addChild(ASTUtil.newAST(AS3NodeKind.ACCESSOR_ROLE));
		if (addModList)
		{
			ast.appendToken(TokenBuilder.newSpace());
		}
		ast.appendToken(TokenBuilder.newFunction());
		ast.appendToken(TokenBuilder.newSpace());
		var n:IParserNode = ASTUtil.newAST(AS3NodeKind.NAME, name);
		ast.addChild(n);
		var params:IParserNode = ASTUtil.newParentheticAST(
			AS3NodeKind.PARAMETER_LIST,
			AS3NodeKind.LPAREN, "(",
			AS3NodeKind.RPAREN, ")");
		ast.addChild(params);
		if (returnType)
		{
			var colon:LinkedListToken = TokenBuilder.newColon();
			var typeAST:IParserNode = AS3FragmentParser.parseType(returnType);
			typeAST.startToken.prepend(colon);
			typeAST.startToken = colon;
			ast.addChild(typeAST);
		}
		ast.appendToken(TokenBuilder.newSpace());
		var block:IParserNode = ASTStatementBuilder.newBlock();
		ast.addChild(block);
		return ast;
	}
	
	public static function newCondition(expr:IParserNode):IParserNode
	{
		var cond:IParserNode = ASTUtil.newParentheticAST(
			AS3NodeKind.CONDITION, 
			AS3NodeKind.LPAREN, "(", 
			AS3NodeKind.RPAREN, ")");
		cond.addChild(expr);
		return cond;
	}
	
	
	/**
	 * Escape the given String and place within double quotes so that it
	 * will be a valid ActionScript string literal.
	 */
	public static function escapeString(string:String):String
	{
		var result:String = "\"";
		
		var len:int = string.length;
		for (var i:int = 0; i < len; i++) 
		{
			var c:String = string.charAt(i);
			
			switch (c) 
			{
				case '\n':
					result += "\\n";
					break;
				case '\t':
					result += "\\t";
					break;
				case '\r':
					result += "\\r";
					break;
				case '"':
					result += "\\\"";
					break;
				case '\\':
					result += "\\\\";
					break;
				default:
					result += c;
			}
		}
		result += '"';
		
		return result;
	}
	
	public static function spaceEitherSide(token:LinkedListToken):void
	{
		token.prepend(TokenBuilder.newSpace());
		token.append(TokenBuilder.newSpace());
	}
	
	public static function parenthise(expression:IParserNode):IParserNode
	{
		var result:IParserNode = ASTUtil.newParentheticAST(
			AS3NodeKind.ENCAPSULATED, 
			AS3NodeKind.LPAREN, "(", 
			AS3NodeKind.RPAREN, ")");
		result.addChild(expression);
		return result;
	}
	
	public static function precidence(ast:IParserNode):int
	{
		switch (ast.kind) 
		{
			case AS3NodeKind.ASSIGN:
			case AS3NodeKind.STAR_ASSIGN:
			case AS3NodeKind.DIV_ASSIGN:
			case AS3NodeKind.MOD_ASSIGN:
			case AS3NodeKind.PLUS_ASSIGN:
			case AS3NodeKind.MINUS_ASSIGN:
			case AS3NodeKind.SL_ASSIGN:
			case AS3NodeKind.SR_ASSIGN:
			case AS3NodeKind.BSR_ASSIGN:
			case AS3NodeKind.BAND_ASSIGN:
			case AS3NodeKind.BXOR_ASSIGN:
			case AS3NodeKind.BOR_ASSIGN:
			case AS3NodeKind.LAND_ASSIGN:
			case AS3NodeKind.LOR_ASSIGN:
				return 13;
			case AS3NodeKind.QUESTION:
				return 12;
			case AS3NodeKind.LOR:
				return 11;
			case AS3NodeKind.LAND:
				return 10;
			case AS3NodeKind.BOR:
				return 9;
			case AS3NodeKind.BXOR:
				return 8;
			case AS3NodeKind.BAND:
				return 7;
			case AS3NodeKind.STRICT_EQUAL:
			case AS3NodeKind.STRICT_NOT_EQUAL:
			case AS3NodeKind.NOT_EQUAL:
			case AS3NodeKind.EQUAL:
				return 6;
			case AS3NodeKind.IN:
			case AS3NodeKind.LT:
			case AS3NodeKind.GT:
			case AS3NodeKind.LE:
			case AS3NodeKind.GE:
			case AS3NodeKind.IS:
			case AS3NodeKind.AS:
			case AS3NodeKind.INSTANCE_OF:
				return 5;
			case AS3NodeKind.SL:
			case AS3NodeKind.SR:
			case AS3NodeKind.BSR:
				return 4;
			case AS3NodeKind.PLUS:
			case AS3NodeKind.MINUS:
				return 3;
			case AS3NodeKind.STAR:
			case AS3NodeKind.DIV:
			case AS3NodeKind.MOD:
				return 2;
			default:
				return 1;
		}
	}
}
}