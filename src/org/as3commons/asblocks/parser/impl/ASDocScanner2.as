package org.as3commons.asblocks.parser.impl
{

import org.as3commons.asblocks.parser.core.Token;

public class ASDocScanner2 extends ScannerBase
{
	//--------------------------------------------------------------------------
	//
	//  Public :: Constants
	//
	//--------------------------------------------------------------------------
	
	/**
	 * An end line.
	 */
	public static const EOF:String = "__END__";
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function ASDocScanner2()
	{
		super();
		
		allowWhiteSpace = true;
	}
	
	//--------------------------------------------------------------------------
	//
	// Overridden Public :: Methods
	//
	//--------------------------------------------------------------------------
	
	internal var isWhiteSpace:Boolean = false;
	
	private var length:int = -1;
	
	private var map:Object;
	
	/**
	 * @private
	 */
	override public function setLines(lines:Vector.<String>):void
	{
		super.setLines(lines);
		
		isWhiteSpace = true;
		length = getLength();
	}
	
	/**
	 * @private
	 */
	private function getLength():int
	{
		var len:int = 0;
		for each (var line:String in lines)
		{
			len += line.length;
		}
		return len;
	}
	
	/**
	 * @private
	 */
	override public function nextToken():Token
	{
		var currentCharacter:String;
		var token:Token;
		
		if (lines != null && line < lines.length)
		{
			currentCharacter = nextChar();
		}
		
		if (currentCharacter == EOF)
		{
			token = new Token(EOF, line, column);
		}
		
		if (currentCharacter == "<")
		{
			token = scanCharacterSequence(currentCharacter, 
				["</", "<listing", "<pre", "<code", "<p"]);
		}
		
		if (currentCharacter == " "
			|| currentCharacter == "\n"
			|| currentCharacter == ">"
			|| currentCharacter == '@')
		{
			token = scanSingleCharacterToken(currentCharacter);
		}
		
		if (currentCharacter == "/")
		{
			token = scanCharacterSequence(currentCharacter, ["/**", "/>"]);
		}
		
		if (currentCharacter == "*")
		{
			token = scanCharacterSequence(currentCharacter, ["*/"]);
		}
		
		if (token == null)
		{
			token = scanWord(currentCharacter);
			if (token != null)
			{
				isWhiteSpace = false;
			}
		}
		
		if (token.text == "\n")
		{
			isWhiteSpace = true;
		}
		
		commitKind(token);
		
		return token;
	}
	
	private function commitKind(token:Token):void
	{
		map = {};
		
		map["/**"] = "ml-start";
		map["*/"] = "ml-end";
		map["*"] = "astrix";
		map[" "] = "ws";
		map["\t"] = "ws";
		map["\n"] = "nl";
		map["__END__"] = "eof";
		
		var result:String = map[token.text];
		if (token.text == "/**" || token.text == "*/" || token.text == "__END__")
		{
			token.kind = result;
			return;
		}
		
		
		if (result == null || !isWhiteSpace)
		{
			result = "text";
		}
		
		token.kind = result;
	}
}
}