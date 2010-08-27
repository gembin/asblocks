package org.teotigraphix.as3blocks.impl
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