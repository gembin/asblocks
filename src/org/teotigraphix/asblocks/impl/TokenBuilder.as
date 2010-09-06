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
		return newToken("postdec", "--");
	}
	
	public static function newPostInc():LinkedListToken
	{
		return newToken("postinc", "++");
	}
	
	public static function newPreDec():LinkedListToken
	{
		return newToken("predec", "--");
	}
	
	public static function newPreInc():LinkedListToken
	{
		return newToken("preinc", "++");
	}
	
	public static function newDot():LinkedListToken
	{
		return newToken("dot", ".");
	}
	
	public static function newQuestion():LinkedListToken
	{
		return newToken("question", "?");
	}
	
	public static function newSemi():LinkedListToken
	{
		return newToken("semi", Operators.SEMI_COLUMN);
	}
	
	public static function newColumn():LinkedListToken
	{
		return newToken("column", Operators.COLUMN);
	}
	
	public static function newEqual():LinkedListToken
	{
		return newToken("equal", Operators.EQUAL);
	}
	
	public static function newSpace():LinkedListToken
	{
		return newToken("space", " ");
	}
	
	public static function newClass():LinkedListToken
	{
		return newToken("class", "class");
	}
	
	public static function newInterface():LinkedListToken
	{
		return newToken("interface", "interface");
	}
	
	public static function newWhile():LinkedListToken
	{
		return newToken("while", "while");
	}
	
	public static function newXML():LinkedListToken
	{
		return newToken("xml", "xml");
	}
	
	public static function newNamespace():LinkedListToken
	{
		return newToken("namespace", "namespace");
	}
	
	public static function newDefault():LinkedListToken
	{
		return newToken("default", "default");
	}
	
	public static function newPlus():LinkedListToken
	{
		return newToken("add", "+");
	}
	
	public static function newAnd():LinkedListToken
	{
		return newToken("and", "&&");
	}
	
	public static function newBitAnd():LinkedListToken
	{
		return newToken("bitand", "&");
	}
	
	public static function newBitOr():LinkedListToken
	{
		return newToken("bitor", "|");
	}
	
	public static function newBitXor():LinkedListToken
	{
		return newToken("bitxor", "^");
	}
	
	public static function newDiv():LinkedListToken
	{
		return newToken("div", "/");
	}
	
	public static function newEquals():LinkedListToken
	{
		return newToken("eq", "==");
	}
	
	public static function newGreaterEquals():LinkedListToken
	{
		return newToken("ge", ">=");
	}
	
	public static function newGreater():LinkedListToken
	{
		return newToken("gt", ">");
	}
	
	public static function newLessEquals():LinkedListToken
	{
		return newToken("le", "<=");
	}
	
	public static function newLess():LinkedListToken
	{
		return newToken("lt", "<");
	}
	
	public static function newModulo():LinkedListToken
	{
		return newToken("mod", "%");
	}
	
	public static function newMult():LinkedListToken
	{
		return newToken("mul", "*");
	}
	
	public static function newNotEquals():LinkedListToken
	{
		return newToken("ne", "!=");
	}
	
	public static function newOr():LinkedListToken
	{
		return newToken("or", "||");
	}
	
	public static function newShiftLeft():LinkedListToken
	{
		return newToken("sl", "<<");
	}
	
	public static function newShiftRight():LinkedListToken
	{
		return newToken("sr", ">>");
	}
	
	public static function newShiftRightUnsigned():LinkedListToken
	{
		return newToken("sru", ">>>");
	}
	
	public static function newMinus():LinkedListToken
	{
		return newToken("sub", "-");
	}
	
	public static function newConst():LinkedListToken
	{
		return newToken("const", "const");
	}
	
	public static function newVar():LinkedListToken
	{
		return newToken("var", "var");
	}
	
	public static function newFunction():LinkedListToken
	{
		return newToken(AS3NodeKind.FUNCTION, KeyWords.FUNCTION);
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
		return newToken("comma", ",");
	}
	
	public static function newLeftBracket():LinkedListToken
	{
		return newToken("left-bracket", Operators.LEFT_SQUARE_BRACKET);
	}
	
	public static function newRightBracket():LinkedListToken
	{
		return newToken("right-bracket", Operators.RIGHT_SQUARE_BRACKET);
	}
	
	public static function newAssign():LinkedListToken
	{
		return newToken(AS3NodeKind.OP, Operators.EQUAL);
	}
}
}