package org.teotigraphix.asblocks.impl
{

import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.KeyWords;
import org.teotigraphix.as3parser.api.Operators;
import org.teotigraphix.as3parser.core.LinkedListToken;

public class TokenBuilder
{
	public static function newToken(kind:String, text:String):LinkedListToken
	{
		return new LinkedListToken(kind, text);
	}
	
	public static function newPostDec():LinkedListToken
	{
		return newToken(AS3NodeKind.POST_DEC, "--");
	}
	
	public static function newPostInc():LinkedListToken
	{
		return newToken(AS3NodeKind.POST_INC, "++");
	}
	
	public static function newPreDec():LinkedListToken
	{
		return newToken(AS3NodeKind.PRE_DEC, "--");
	}
	
	public static function newPreInc():LinkedListToken
	{
		return newToken(AS3NodeKind.PRE_INC, "++");
	}
	
	public static function newDot():LinkedListToken
	{
		return newToken(AS3NodeKind.DOT, ".");
	}
	
	public static function newQuestion():LinkedListToken
	{
		return newToken(AS3NodeKind.CONDITIONAL, "?");
	}
	
	public static function newSemi():LinkedListToken
	{
		return newToken(AS3NodeKind.SEMI, Operators.SEMI);
	}
	
	public static function newColon():LinkedListToken
	{
		return newToken(AS3NodeKind.COLON, Operators.COLON);
	}
	
	public static function newSpace():LinkedListToken
	{
		return newToken(AS3NodeKind.SPACE, " ");
	}
	
	public static function newClass():LinkedListToken
	{
		return newToken(AS3NodeKind.CLASS, "class");
	}
	
	public static function newInterface():LinkedListToken
	{
		return newToken(AS3NodeKind.INTERFACE, "interface");
	}
	
	public static function newWhile():LinkedListToken
	{
		return newToken(AS3NodeKind.WHILE, "while");
	}
	
	public static function newXML():LinkedListToken
	{
		return newToken(AS3NodeKind.XML, "xml");
	}
	
	public static function newNamespace():LinkedListToken
	{
		return newToken(AS3NodeKind.NAMESPACE, "namespace");
	}
	
	public static function newDefault():LinkedListToken
	{
		return newToken(AS3NodeKind.DEFAULT, "default");
	}
	
	public static function newPlus():LinkedListToken
	{
		return newToken(AS3NodeKind.PLUS, "+");
	}
	
	public static function newAnd():LinkedListToken
	{
		return newToken(AS3NodeKind.LAND, "&&");
	}
	
	public static function newBitAnd():LinkedListToken
	{
		return newToken(AS3NodeKind.BAND, "&");
	}
	
	public static function newBitOr():LinkedListToken
	{
		return newToken(AS3NodeKind.BOR, "|");
	}
	
	public static function newBitXor():LinkedListToken
	{
		return newToken(AS3NodeKind.BXOR, "^");
	}
	
	public static function newDiv():LinkedListToken
	{
		return newToken(AS3NodeKind.DIV, "/");
	}
	
	public static function newEquals():LinkedListToken
	{
		return newToken(AS3NodeKind.EQUAL, "==");
	}
	
	public static function newGreaterEquals():LinkedListToken
	{
		return newToken(AS3NodeKind.GE, ">=");
	}
	
	public static function newGreater():LinkedListToken
	{
		return newToken(AS3NodeKind.GT, ">");
	}
	
	public static function newLessEquals():LinkedListToken
	{
		return newToken(AS3NodeKind.LE, "<=");
	}
	
	public static function newLess():LinkedListToken
	{
		return newToken(AS3NodeKind.LT, "<");
	}
	
	public static function newModulo():LinkedListToken
	{
		return newToken(AS3NodeKind.MOD, "%");
	}
	
	public static function newMult():LinkedListToken
	{
		return newToken(AS3NodeKind.STAR, "*");
	}
	
	public static function newNotEquals():LinkedListToken
	{
		return newToken(AS3NodeKind.NOT_EQUAL, "!=");
	}
	
	public static function newOr():LinkedListToken
	{
		return newToken(AS3NodeKind.LOR, "||");
	}
	
	public static function newShiftLeft():LinkedListToken
	{
		return newToken(AS3NodeKind.SL, "<<");
	}
	
	public static function newShiftRight():LinkedListToken
	{
		return newToken(AS3NodeKind.SR, ">>");
	}
	
	public static function newShiftRightUnsigned():LinkedListToken
	{
		return newToken(AS3NodeKind.SRU, ">>>");
	}
	
	public static function newMinus():LinkedListToken
	{
		return newToken(AS3NodeKind.MINUS, "-");
	}
	
	public static function newConst():LinkedListToken
	{
		return newToken(AS3NodeKind.CONST, "const");
	}
	
	public static function newVar():LinkedListToken
	{
		return newToken(AS3NodeKind.VAR, "var");
	}
	
	public static function newFunction():LinkedListToken
	{
		return newToken(AS3NodeKind.FUNCTION, "function");
	}
	
	public static function newNewline():LinkedListToken
	{
		var token:LinkedListToken = newToken(AS3NodeKind.NL, "\n");
		token.channel = AS3NodeKind.HIDDEN;
		return token;
	}
	
	public static function newWhiteSpace(string:String):LinkedListToken
	{
		var token:LinkedListToken = newToken(AS3NodeKind.WS, string);
		token.channel = AS3NodeKind.HIDDEN;
		return token;
	}
	
	public static function newComma():LinkedListToken
	{
		return newToken(AS3NodeKind.COMMA, ",");
	}
	
	public static function newLeftBracket():LinkedListToken
	{
		return newToken(AS3NodeKind.LBRACKET, Operators.LBRACK);
	}
	
	public static function newRightBracket():LinkedListToken
	{
		return newToken(AS3NodeKind.RBRACKET, Operators.RBRACK);
	}
	
	public static function newAssign():LinkedListToken
	{
		return newToken(AS3NodeKind.ASSIGN, Operators.ASSIGN);
	}
}
}