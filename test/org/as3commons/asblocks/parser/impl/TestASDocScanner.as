package org.as3commons.asblocks.parser.impl
{

import org.as3commons.asblocks.parser.core.Token;
import org.flexunit.Assert;

public class TestASDocScanner
{
	private var parser:ASDocParser;
	
	private var scanner:ASDocScanner;
	
	[Before]
	public function setUp():void
	{
		parser = new ASDocParser();
		scanner = parser.scanner as ASDocScanner;
	}
	
	[Test]
	public function test_wsSingleLine():void
	{
		var lines:Array =
			[
				"/** A comment. */"
			];
		
		scanner.setLines(Vector.<String>(lines));
		
		assertToken("/**", "ml-start");
		assertToken(" ", "ws");
		assertToken("A", "text");
		assertToken(" ", "text");
		assertToken("comment", "text");
		assertToken(".", "text");
		assertToken(" ", "text");
		assertToken("*/", "ml-end");
		assertToken("__END__", "eof");
	}
	
	[Test]
	public function test_ws():void
	{
		var lines:Array =
			[
				"/**", 
				" * A comment.", 
				" */"
			];
		
		scanner.setLines(Vector.<String>(lines));
		
		Assert.assertTrue(scanner.isWhiteSpace);
		// comment start [turn on ws]
		assertToken("/**", "ml-start");
		
		// newline [turn on ws]
		assertToken("\n", "nl");
		assertToken(" ", "ws");
		assertToken("*", "astrix");
		assertToken(" ", "ws");
		Assert.assertTrue(scanner.isWhiteSpace);
		
		// first identifier [turn off ws]
		assertToken("A", "text");
		Assert.assertFalse(scanner.isWhiteSpace);
		
		assertToken(" ", "text");
		assertToken("comment", "text");
		assertToken(".", "text");
		Assert.assertFalse(scanner.isWhiteSpace);
		
		// newline [turn on ws]
		assertToken("\n", "nl");
		Assert.assertTrue(scanner.isWhiteSpace);
		assertToken(" ", "ws");
		assertToken("*/", "ml-end");
	}
	
	[Test]
	public function test_wsNoAstrix():void
	{
		var lines:Array =
			[
				"/**", 
				" A comment.", 
				" */"
			];
		
		scanner.setLines(Vector.<String>(lines));
		
		Assert.assertTrue(scanner.isWhiteSpace);
		// comment start [turn on ws]
		assertToken("/**", "ml-start");
		
		// newline [turn on ws]
		assertToken("\n", "nl");
		assertToken(" ", "ws");
		Assert.assertTrue(scanner.isWhiteSpace);
		
		// first identifier [turn off ws]
		assertToken("A", "text");
		Assert.assertFalse(scanner.isWhiteSpace);
		
		assertToken(" ", "text");
		assertToken("comment", "text");
		assertToken(".", "text");
		Assert.assertFalse(scanner.isWhiteSpace);
		
		// newline [turn on ws]
		assertToken("\n", "nl");
		Assert.assertTrue(scanner.isWhiteSpace);
		assertToken(" ", "ws");
		assertToken("*/", "ml-end");
	}
	
	[Test]
	public function test_pre():void
	{
		var lines:Array =
			[
				"/**", 
				" * <pre>",
				" *    code",
				" * </pre>",
				" */"
			];
		
		scanner.setLines(Vector.<String>(lines));
		
		assertToken("/**", "ml-start");
		assertToken("\n", "nl");
		assertToken(" ", "ws");
		assertToken("*", "astrix");
		assertToken(" ", "ws");
		assertToken("<pre", "text");
		assertToken(">", "text");
		assertToken("\n", "nl");
		assertToken(" ", "ws");
		assertToken("*", "astrix");
		assertToken(" ", "text");
		assertToken(" ", "text");
		assertToken(" ", "text");
		assertToken(" ", "text");
		assertToken("code", "text");
		assertToken("\n", "nl");
		assertToken(" ", "ws");
		assertToken("*", "astrix");
		assertToken(" ", "text");
		assertToken("</", "text");
		assertToken("pre", "text");
		assertToken(">", "text");
	}
	
	protected function assertToken(text:String, kind:String):void
	{
		var token:Token = scanner.nextToken();
		Assert.assertEquals(text, token.text);
		Assert.assertEquals(kind, token.kind);
	}
	
	private function assertText(text:String):void
	{
		var token:Token = null;
		token = scanner.nextToken();
		Assert.assertEquals(text, token.text);
	}
}
}