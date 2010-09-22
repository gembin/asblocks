package org.as3commons.asblocks.parser.impl
{
import flexunit.framework.Assert;

import org.as3commons.asblocks.parser.core.Token;
import org.as3commons.asblocks.utils.ASTUtil;

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
	public function test_code_tag():void
	{
		var lines:Array =
			[
				"/**", 
				" * A <code>value</code> comment.", 
				"*/"
			];
		
		scanner.setLines(Vector.<String>(lines));
		
		assertText("/**");
		assertText("\n");
		assertText(" ");
		assertText("*");
		assertText(" ");
		assertText("A");
		assertText(" ");
		assertText("<code");
		assertText(">");
		assertText("value");
		assertText("</");
		assertText("code");
		assertText(">");
		assertText(" ");
		assertText("comment");
		assertText(".");
		assertText("\n");
		assertText("*/");
	}
	
	[Test]
	public function testCommentStartAndEnd():void
	{
		var lines:Array =
			[
				"/***A comment.**/"
			];
		
		scanner.setLines(Vector.<String>(lines));
		
		assertText("/**");
		assertText("*");
		assertText("A");
		assertText(" ");
		assertText("comment");
		assertText(".");
		assertText("*");
		assertText("*/");
	}
	
	[Test]
	public function testShortListEnd_Period():void
	{
		var lines:Array =
			[
				"/**A comment.*/"
			];
		
		scanner.setLines(Vector.<String>(lines));
		
		assertText("/**");
		assertText("A");
		assertText(" ");
		assertText("comment");
		assertText("."); // short list ending
		assertText("*/");
	}
	
	[Test]
	public function testShortListEnd_PeriodNewline():void
	{
		var lines:Array =
			[
				"/**A comment.", "*/"
			];
		
		scanner.setLines(Vector.<String>(lines));
		
		assertText("/**");
		assertText("A");
		assertText(" ");
		assertText("comment");
		assertText(".");
		assertText("\n");
		assertText("*/");
	}
	
	[Test]
	public function testShortListSingleEnd_PeriodTab():void
	{
		var lines:Array =
			[
				"/**A comment.\t*/"
			];
		
		scanner.setLines(Vector.<String>(lines));
		
		assertText("/**");
		assertText("A");
		assertText(" ");
		assertText("comment");
		assertText(".");
		assertText("\t");
		assertText("*/");
	}
	
	[Test]
	public function testIsInShortList_Single():void
	{
		var lines:Array =
			[
				"/**", 
				" * A comment.", 
				" * Long description.", 
				"*/"
			];
		
		scanner.setLines(Vector.<String>(lines));
		
		assertText("/**");
		assertText("\n");
		assertText(" ");
		assertText("*");
		assertText(" ");
		assertText("A");
		assertText(" ");
		assertText("comment");
		
		//Assert.assertTrue(scanner.isInShort);
		assertText(".");
		assertText("\n");
		//Assert.assertFalse(scanner.isInShort);
		
		assertText(" ");
		assertText("*");
		assertText(" ");
		assertText("Long");
		assertText(" ");
		assertText("description");
		assertText(".");
		assertText("\n");
		assertText("*/");
	}
	
	[Test]
	public function testIsInShortList_SingleMultiPeriod():void
	{
		var lines:Array =
			[
				"/**",
				" * A comment. Another comment.",
				" * Long description.",
				"*/"
			];
		
		scanner.setLines(Vector.<String>(lines));
		
		assertText("/**");
		assertText("\n");
		assertText(" ");
		assertText("*");
		assertText(" ");
		assertText("A");
		assertText(" ");
		assertText("comment");
		assertText(".");
		assertText(" ");
		assertText("Another");
		assertText(" ");
		assertText("comment");
		
		//Assert.assertTrue(scanner.isInShort);
		assertText(".");
		assertText("\n");
		//Assert.assertFalse(scanner.isInShort);
		
		assertText(" ");
		assertText("*");
		assertText(" ");
		assertText("Long");
		assertText(" ");
		assertText("description");
		assertText(".");
		assertText("\n");
		assertText("*/");
	}

	[Test]
	public function testIsInShortList_MultiMultiPeriod():void
	{
		var lines:Array =
			[
				"/**",
				" * A comment. Another",
				" * comment.",
				" * Long description.",
				"*/"
			];
		
		scanner.setLines(Vector.<String>(lines));
		
		assertText("/**");
		assertText("\n");
		assertText(" ");
		assertText("*");
		assertText(" ");
		assertText("A");
		assertText(" ");
		assertText("comment");
		assertText(".");
		assertText(" ");
		assertText("Another");
		assertText("\n");
		assertText(" ");
		assertText("*");
		assertText(" ");
		assertText("comment");
		
		//Assert.assertTrue(scanner.isInShort);
		assertText(".");
		assertText("\n");
		//Assert.assertFalse(scanner.isInShort);
		
		assertText(" ");
		assertText("*");
		assertText(" ");
		assertText("Long");
		assertText(" ");
		assertText("description");
		assertText(".");
		assertText("\n");
		assertText("*/");
	}
	
	[Test]
	public function testIsInShortList_AtOnly():void
	{
		var lines:Array =
			[
				"/**", 
				"*@private", 
				"*/"
			];
		
		scanner.setLines(Vector.<String>(lines));
		
		assertText("/**");
		assertText("\n");
		assertText("*");
		Assert.assertTrue(scanner.isInShort);
		Assert.assertFalse(scanner.isInDocTag);
		assertText("@");
		Assert.assertFalse(scanner.isInShort);
		Assert.assertTrue(scanner.isInDocTag);
		assertText("private");
		assertText("\n");
		assertText("*/");
	}
	
	[Test]
	public function testDocTag():void
	{
		var lines:Array =
			[
				"/**", 
				"*A comment.", 
				"*@tag value", 
				"*/"
			];
		
		scanner.setLines(Vector.<String>(lines));
		
		assertText("/**");
		assertText("\n");
		assertText("*");
		assertText("A");
		assertText(" ");
		assertText("comment");
		//Assert.assertTrue(scanner.isInShort);
		assertText(".");
		assertText("\n");
		//Assert.assertFalse(scanner.isInShort);
		assertText("*");
		Assert.assertFalse(scanner.isInDocTag);
		assertText("@");
		Assert.assertTrue(scanner.isInDocTag);
		assertText("tag");
		assertText(" ");
		assertText("value");
		assertText("\n");
		assertText("*/");
	}
	
	[Test]
	public function testInlineDocTag():void
	{
		var lines:Array =
			[
				"/**", 
				"*A comment.", 
				"*A {@link value} here.", 
				"*/"
			];
		
		scanner.setLines(Vector.<String>(lines));
		
		assertText("/**");
		assertText("\n");
		assertText("*");
		assertText("A");
		assertText(" ");
		assertText("comment");
		//Assert.assertTrue(scanner.isInShort);
		assertText(".");
		assertText("\n");
		//Assert.assertFalse(scanner.isInShort);
		assertText("*");
		assertText("A");
		assertText(" ");
		Assert.assertFalse(scanner.isInDocTag);
		Assert.assertFalse(scanner.isInInlineDocTag);
		assertText("{@");
		Assert.assertFalse(scanner.isInDocTag);
		Assert.assertTrue(scanner.isInInlineDocTag);
		assertText("link");
		assertText(" ");
		assertText("value");
		assertText("}");
		Assert.assertFalse(scanner.isInInlineDocTag);
		assertText(" ");
		assertText("here");
		assertText(".");
		assertText("\n");
		assertText("*/");
	}
	
	private function assertText(text:String):void
	{
		var token:Token = null;
		token = scanner.nextToken();
		Assert.assertEquals(text, token.text);
	}
}
}