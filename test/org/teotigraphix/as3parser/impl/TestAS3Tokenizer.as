package org.teotigraphix.as3parser.impl
{

import flexunit.framework.Assert;

import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.core.SourceCode;
import org.teotigraphix.as3parser.core.TokenEntry;
import org.teotigraphix.as3parser.core.Tokens;
import org.teotigraphix.as3parser.utils.ASTUtil;

public class TestAS3Tokenizer
{
	private var tokenizer:AS3Tokenizer;
	
	private var sourceCode:SourceCode;
	
	private var tokens:Tokens;
	
	[Before]
	public function setUp():void
	{
		tokenizer = new AS3Tokenizer();
		
		var lines:Array =
			[
				"package my.domain {",
				"    /** Class comment. */",
				"    public class Test",
				"    {",
				"    }",
				"}",
			];
		
		sourceCode = new SourceCode(ASTUtil.toSourceCode(lines));
	}
	
	[Test]
	public function testTokenize():void
	{
		tokens = new Tokens();
		
		tokenizer.tokenize(sourceCode, tokens);
		
		assertToken(1, "package", tokens.tokens[0]);
		assertToken(1, "my", tokens.tokens[1]);
		assertToken(1, ".", tokens.tokens[2]);
		assertToken(1, "domain", tokens.tokens[3]);
		assertToken(1, "{", tokens.tokens[4]);
		assertToken(2, "/** Class comment. */", tokens.tokens[5]);
		assertToken(3, "public", tokens.tokens[6]);
		assertToken(3, "class", tokens.tokens[7]);
		assertToken(3, "Test", tokens.tokens[8]);
		assertToken(4, "{", tokens.tokens[9]);
		assertToken(5, "}", tokens.tokens[10]);
		assertToken(6, "}", tokens.tokens[11]);
		assertToken(-1, TokenEntry.getEOF().text, tokens.tokens[12]);
	}
	
	protected function assertToken(line:int, text:String, token:TokenEntry):void
	{
		Assert.assertEquals(line, token.startLine);
		Assert.assertEquals(text, token.text);
	}
}
}