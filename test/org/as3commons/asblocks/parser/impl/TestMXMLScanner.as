package org.as3commons.asblocks.parser.impl
{
import flexunit.framework.Assert;

import org.as3commons.asblocks.parser.api.IScanner;
import org.as3commons.asblocks.parser.core.Token;

public class TestMXMLScanner
{
	private var parser:MXMLParser;
	
	private var scanner:IScanner;
	
	[Before]
	public function setUp():void
	{
		parser = new MXMLParser();
		scanner = parser.scanner;
		scanner.allowWhiteSpace = false;
	}
	
	[Test]
	public function test_asdoc_tokens_dot():void
	{
		var lines:Array =
			[
				"<Application",
				" alpha.disabled=\"0.5\">",
				"</Application>"
			];
		
		scanner.setLines(Vector.<String>(lines));
		
		assertText("<");
		assertText("Application");
		assertText("alpha");
		assertText(".");
		assertText("disabled");
		assertText("=");
		assertText("\"0.5\"");
		assertText(">");
		assertText("</");
		assertText("Application");
		assertText(">");
	}
	
	[Test]
	public function test_non_asdoc_tokens():void
	{
		var lines:Array = ["<!-- no asdoc comment. -->"];
		
		scanner.setLines(Vector.<String>(lines));
		
		assertText("<!-- no asdoc comment. -->");
	}
	
	[Test]
	public function test_asdoc_tokens_nl():void
	{
		var lines:Array = ["<!--- ", "\t* My asdoc comment. ", "-->"];
		
		scanner.setLines(Vector.<String>(lines));
		
		assertText("<!--- \n\t* My asdoc comment. \n-->");
	}
	
	[Test]
	public function test_cdata_tokens():void
	{
		var lines:Array = 
			[
				"<fx:Script>", 
				"<![CDATA[", 
				"    private var me:String;",
				"]]>", 
				"</fx:Script>"
			];
		
		scanner.setLines(Vector.<String>(lines));
		
		assertText("<");
		assertText("fx");
		assertText(":");
		assertText("Script");
		assertText(">");
		assertText("\n    private var me:String;\n");
		assertText("</");
		assertText("fx");
		assertText(":");
		assertText("Script");
		assertText(">");
	}
	
	private function assertText(text:String):void
	{
		var token:Token = null;
		token = scanner.nextToken();
		Assert.assertEquals(text, token.text);
	}
}
}