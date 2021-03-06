package org.as3commons.asblocks.parser.impl
{
import flexunit.framework.Assert;

import org.flexunit.asserts.assertTrue;
import org.as3commons.asblocks.parser.core.Token;

public class TestAS3Scanner
{
	private var scanner:AS3Scanner;
	
	[Before]
	public function setUp():void
	{
		scanner = new AS3Scanner();
	}
	
	
	// from lang ref
	
	[Test]
	public function testArithmetic():void
	{
		var lines:Array =
			[
				"+",
				"--",
				"/",
				"++",
				"%",
				"*",
				"-"
			];
		
		scanner.setLines(Vector.<String>(lines));
		
		for (var i:int = 0; i < lines.length; i++)
		{
			assertText(lines[i]);
			if (i == lines.length - 1)
			{
				assertText("__END__");
			}
			else
			{
				assertText("\n");
			}
		}
	}
	
	[Test]
	public function testArithmeticCompoundAssignment():void
	{
		var lines:Array =
			[
				"+=",
				"/=",
				"%=",
				"*=",
				"-="
			];
		
		scanner.setLines(Vector.<String>(lines));
		
		for (var i:int = 0; i < lines.length; i++)
		{
			assertText(lines[i]);
			if (i == lines.length - 1)
			{
				assertText("__END__");
			}
			else
			{
				assertText("\n");
			}
		}
	}
	
	[Test]
	public function testAssignment():void
	{
		var lines:Array =
			[
				"="
			];
		
		scanner.setLines(Vector.<String>(lines));
		
		assertText(lines[0]);
	}
	
	[Test]
	public function testBitwise():void
	{
		var lines:Array =
			[
				"&",
				"<<",
				"<<<", // missing from the docs?
				"~",
				"|",
				">>",
				">>>"
			];
		
		scanner.setLines(Vector.<String>(lines));
		
		for (var i:int = 0; i < lines.length; i++)
		{
			assertText(lines[i]);
			if (i == lines.length - 1)
			{
				assertText("__END__");
			}
			else
			{
				assertText("\n");
			}
		}
	}
	
	[Test]
	public function testBitwiseCompundAssignment():void
	{
		var lines:Array =
			[
				"&=",
				"<<=",
				"|=",
				">>=",
				">>>=",
				"^="
			];
		
		scanner.setLines(Vector.<String>(lines));
		
		for (var i:int = 0; i < lines.length; i++)
		{
			assertText(lines[i]);
			if (i == lines.length - 1)
			{
				assertText("__END__");
			}
			else
			{
				assertText("\n");
			}
		}
	}
	
	[Test]
	public function testComment():void
	{
		var lines:Array =
			[
				"/* block comment. */",
				"// line comment"
			];
		
		scanner.setLines(Vector.<String>(lines));
		
		for (var i:int = 0; i < lines.length; i++)
		{
			assertText(lines[i]);
			if (i == lines.length - 1)
			{
				assertText("__END__");
			}
			else
			{
				assertText("\n");
			}
		}
	}
	
	[Test]
	public function testComparison():void
	{
		var lines:Array =
			[
				"==",
				">",
				">=",
				"!=",
				"<",
				"<=",
				"===",
				"!=="
			];
		
		scanner.setLines(Vector.<String>(lines));
		
		for (var i:int = 0; i < lines.length; i++)
		{
			assertText(lines[i]);
			if (i == lines.length - 1)
			{
				assertText("__END__");
			}
			else
			{
				assertText("\n");
			}
		}
	}
	
	[Test]
	public function testLogical():void
	{
		var lines:Array =
			[
				"&&",
				"&&=",
				"!",
				"||",
				"||="
			];
		
		scanner.setLines(Vector.<String>(lines));
		
		for (var i:int = 0; i < lines.length; i++)
		{
			assertText(lines[i]);
			if (i == lines.length - 1)
			{
				assertText("__END__");
			}
			else
			{
				assertText("\n");
			}
		}
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
		
		scanner.setLines(Vector.<String>(lines));
		
		for (var i:int = 0; i < lines.length; i++)
		{
			assertText(lines[i]);
			if (i == lines.length - 1)
			{
				assertText("__END__");
			}
			else
			{
				assertText("\n");
			}
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
		
		scanner.setLines(Vector.<String>(lines));
		
		for (var i:int = 0; i < lines.length; i++)
		{
			assertText(lines[i]);
			if (i == lines.length - 1)
			{
				assertText("__END__");
			}
			else
			{
				assertText("\n");
			}
		}
	}
	
	[Test]
	public function testE4XAttribute():void
	{
		var lines:Array =
			[
				"myXML.@attributeName",
				"myXML.@*"
			];
		
		scanner.setLines(Vector.<String>(lines));
		
		assertText("myXML");
		assertText(".");
		assertText("@");
		assertText("attributeName");
		assertText("\n");
		assertText("myXML");
		assertText(".");
		assertText("@");
		assertText("*");
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
		
		scanner.setLines(Vector.<String>(lines));
		
		for (var i:int = 0; i < lines.length; i++)
		{
			assertText(lines[i]);
			if (i == lines.length - 1)
			{
				assertText("__END__");
			}
			else
			{
				assertText("\n");
			}
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
				"a.E",
				"a..E"
			];
		
		scanner.setLines(Vector.<String>(lines));
		
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
		assertText("\n");
		assertText("a");
		assertText("..");
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
		
		scanner.setLines(Vector.<String>(lines));
		
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
		
		scanner.setLines(Vector.<String>(lines));
		
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
		
		scanner.setLines(Vector.<String>(lines));
		
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
		
		scanner.setLines(Vector.<String>(lines));
		
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
		
		scanner.setLines(Vector.<String>(lines));
		
		for (var i:int = 0; i < lines.length; i++)
		{
			assertText(lines[i]);
			if (i == lines.length - 1)
			{
				assertText("__END__");
			}
			else
			{
				assertText("\n");
			}
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
		
		scanner.setLines(Vector.<String>(lines));
		
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
		
		scanner.setLines(Vector.<String>(lines));
		
		// the first entry is empty, so we skip it
		for (var i:int = 0; i < lines.length; i++)
		{
			assertText(lines[i]);
			if (i == lines.length - 1)
			{
				assertText("__END__");
			}
			else
			{
				assertText("\n");
			}
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
		
		scanner.setLines(Vector.<String>(lines));
		
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
		
		scanner.setLines(Vector.<String>(lines));
		
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
		
		scanner.setLines(Vector.<String>(lines));
		
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
		
		scanner.setLines(Vector.<String>(lines));
		
		// the first entry is empty, so we skip it
		for (var i:int = 0; i < lines.length; i++)
		{
			assertText(lines[i]);
			if (i == lines.length - 1)
			{
				assertText("__END__");
			}
			else
			{
				assertText("\n");
			}
		}
	}
	
	[Test]
	public function testNegativeInfinity():void
	{
		var lines:Array =
			[
				"-Infinity"
			];
		
		scanner.setLines(Vector.<String>(lines));
		
		assertText(lines[0]);
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