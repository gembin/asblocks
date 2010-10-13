package org.as3commons.asblocks.parser.impl
{

import org.as3commons.asblocks.parser.core.Token;

public class ASDocScanner2 extends ScannerBase
{
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
	}
	
	/**
	 * @private
	 */
	override public function nextToken():Token
	{
		var currentCharacter:String;
		
		if (lines != null && line < lines.length)
		{
			currentCharacter = nextChar();
		}
		
		if (currentCharacter == '/')
		{
			return scanCharacterSequence(currentCharacter, ["/**", "/>"]);
		}
		
		return scanWord(currentCharacter);
	}
}
}