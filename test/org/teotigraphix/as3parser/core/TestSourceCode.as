package org.teotigraphix.as3parser.core
{

import org.flexunit.Assert;

public class TestSourceCode
{
	[Test]
	public function test_code():void
	{
		var sourceCode:SourceCode = new SourceCode("package{}", "identifier");
		Assert.assertNotNull(sourceCode.code);
		Assert.assertEquals("package{}", sourceCode.code);
		Assert.assertNotNull(sourceCode.filePath);
		Assert.assertEquals("identifier", sourceCode.filePath);
	}
	
	[Test]
	public function testReplaceCRNLWithNL():void
	{
		var code:String = "package {\r\npublic class \r\n\r\n {\r\n }\r\n}";
		var sourceCode:SourceCode = new SourceCode(code, "identifier");
		
		Assert.assertEquals("package {\npublic class \n\n {\n }\n}", sourceCode.code);
	}
	
	[Test]
	public function test_getSlice():void
	{
		// TODO implement test_getSlice()
	}
}
}