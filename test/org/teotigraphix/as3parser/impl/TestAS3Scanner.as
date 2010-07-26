package org.teotigraphix.as3parser.impl
{
import flexunit.framework.Assert;

import org.flexunit.asserts.assertTrue;
import org.teotigraphix.as3parser.core.Token;
import org.teotigraphix.as3parser.utils.ASTUtil;

public class TestAS3Scanner
{
	private var scanner:AS3Scanner;
	
	[Before]
	public function setUp():void
	{
		scanner = new AS3Scanner();
	}
	
	[Test]
	public function testAssignments():void
	{
		var lines:Array =
			[
				"=",
				"+=",
				"-=",
				"%=",
				"^=",
				"&=",
				"|=",
				"/="
			];
		
		scanner.setLines(ASTUtil.toVector(lines));
		
		for (var i:int = 0; i < lines.length; i++)
		{
			assertText(lines[i]);
			assertText("\n");
		}
	}
	
	[Test]
	public function testBooleanOperators():void
	{
		var lines:Array =
			[
				"&&",
				"&=",
				"||",
				"|="
			];
		
		scanner.setLines(ASTUtil.toVector(lines));
		
		for (var i:int = 0; i < lines.length; i++)
		{
			assertText(lines[i]);
			assertText("\n");
		}
	}
	
	[Test]
	public function testComparisonOperators():void
	{
		var lines:Array =
			[
				">",
				">>>=",
				">>>",
				">>=",
				">>",
				">=",
				"===",
				"==",
				"!==",
				"!="
			];
		
		scanner.setLines(ASTUtil.toVector(lines));
		
		for (var i:int = 0; i < lines.length; i++)
		{
			assertText(lines[i]);
			assertText("\n");
		}
	}
	
	[Test]
	public function testIdentifiers():void
	{
		var lines:Array =
			[
				"a",
				"a.b.*",
				"a.b::c",
				"a.E"
			];
		
		scanner.setLines(ASTUtil.toVector(lines));
		
		assertText("a");
		assertText("\n");
		assertText("a");
		assertText(".");
		assertText("b");
		assertText(".");
		assertText("*");
		assertText("\n");
		assertText("a");
		assertText(".");
		assertText("b");
		assertText("::");
		assertText("c");
		assertText("\n");
		assertText("a");
		assertText(".");
		assertText("E");
	}
	
	[Test]
	public function testIsDecimalChar():void
	{
		var decimalString:String = "0123456789";
		
		for (var i:int = 0; i < decimalString.length; i++)
		{
			Assert.assertTrue(ScannerBase.isDecimalChar(decimalString.charAt(i)));
		}
		
		Assert.assertFalse(ScannerBase.isDecimalChar("F"));
	}
	
	[Test]
	public function testIsHex():void
	{
		Assert.assertTrue(ScannerBase.isHexChar("0"));
		Assert.assertTrue(ScannerBase.isHexChar("9"));
		Assert.assertTrue(ScannerBase.isHexChar("A"));
		Assert.assertTrue(ScannerBase.isHexChar("a"));
		Assert.assertTrue(ScannerBase.isHexChar("F"));
		Assert.assertTrue(ScannerBase.isHexChar("f"));
		Assert.assertFalse(ScannerBase.isHexChar(";"));
		Assert.assertFalse(ScannerBase.isHexChar("]"));
		Assert.assertFalse(ScannerBase.isHexChar(" "));
	}
	
	[Test]
	public function testMultiLineComment():void
	{
		var lines:Array =
			[
				"/* this is a multi line comment, not really */",
				"/** now for real",
				"/* now for real",
				"*/"
			];
		
		scanner.setLines(ASTUtil.toVector(lines));
		
		assertText(lines[0]);
		assertText("\n");
		assertText("/** now for real\n/* now for real\n*/");
	}
	
	[Test]
	public function testMultilineXML():void
	{
		var lines:Array =
			[
				"<?xml version=\"1.0\"?>",
				"<a>",
				"<b>test</b>",
				"</a>"
			];
		
		scanner.setLines(ASTUtil.toVector(lines));
		
		assertText(join(lines, "\n"));
	}
	
	
	[Test]
	public function testMultipleWords():void
	{
		var lines:Array =
			[
				"word1 word2 word3",
				"word4",
				"word5 word6"
			];
		
		scanner.setLines(ASTUtil.toVector(lines));
		
		assertText("word1");
		assertText("word2");
		assertText("word3");
		assertText("\n");
		assertText("word4");
		assertText("\n");
		assertText("word5");
		assertText("word6");
	}
	
	[Test]
	public function testNumbers():void
	{
		var lines:Array =
			[
				"0",
				"1.2",
				"1.2E5",
				"0xffgg"
			];
		
		scanner.setLines(ASTUtil.toVector(lines));
		
		assertText(lines[0]);
		assertText("\n" );
		assertText(lines[1]);
		assertText("\n" );
		assertText(lines[2]);
		assertText("\n" );
		assertText(lines[3]);
	}
	
	[Test]
	public function testPlusSymbols():void
	{
		var lines:Array =
			[
				"++",
				"+=",
				"+",
				"--",
				"-=",
				"-"
			];
		
		scanner.setLines(ASTUtil.toVector(lines));
		
		for (var i:int = 0; i < lines.length; i++)
		{
			assertText(lines[i]);
			assertText("\n");
		}
	}
	
	[Test]
	public function testRegExp():void
	{
		var lines:Array =
			[
				"/a/",
				"/[+-.]/",
				"/[+-.\\/]/",
				"/[+-.]\\\\//"
			];
		
		scanner.setLines(ASTUtil.toVector(lines));
		
		assertText(lines[0]);
		assertText("\n");
		assertText(lines[1]);
		assertText("\n");
		assertText(lines[2]);
		assertText("\n");
		assertText("/[+-.]\\\\/");
	}
	
	[Test]
	public function testSingleCharacterSymbols():void
	{
		var lines:Array = "{}()[]:;,?~".split("");
		
		scanner.setLines(ASTUtil.toVector(lines));
		
		// the first entry is empty, so we skip it
		for (var i:int = 0; i < lines.length; i++)
		{
			assertText(lines[i]);
			assertText("\n");
		}
	}
	
	[Test]
	public function testSingleLineComment():void
	{
		var lines:Array =
			[
				"//this is a single line comment",
				"word //another single line comment"
			];
		
		scanner.setLines(ASTUtil.toVector(lines));
		
		assertText(lines[0]);
		assertText("\n");
		assertText("word");
		assertText("//another single line comment");
	}
	
	[Test]
	public function testSingleWord():void
	{
		var lines:Array =
			[
				"word"
			];
		
		scanner.setLines(ASTUtil.toVector(lines));
		
		assertText(lines[0]);
	}
	
	[Test]
	public function testStrings():void
	{
		var lines:Array =
			[
				"\"string\"",
				"\'string\'",
				"\"string\\\"\""
			];
		
		scanner.setLines(ASTUtil.toVector(lines));
		
		assertText(lines[0]);
		assertText("\n");
		assertText(lines[1]);
		assertText("\n");
		assertText(lines[2]);
	}
	
	//[Test]
	public function testXML():void
	{
		var lines:Array =
			[
				"<root/>",
				"<root>test</root>",
				"<?xml version=\"1.0\"?><root>test</root>"
			];
		
		scanner.setLines(ASTUtil.toVector(lines));
		
		// the first entry is empty, so we skip it
		for (var i:int = 0; i < lines.length; i++)
		{
			assertText(lines[i]);
			assertText("\n");
		}
	}
	
	private function assertText(text:String):void
	{
		var token:Token = null;
		token = scanner.nextToken();
		Assert.assertEquals(text, token.text);
	}
	
	private function join(lines:Array, delimiter:String):String
	{
		var result:String = "";
		for (var i:int = 0; i < lines.length; i++ )
		{
			if (i > 0)
			{
				result += delimiter;
			}
			result += lines[i];
		}
		return result;
	}
	
}
}