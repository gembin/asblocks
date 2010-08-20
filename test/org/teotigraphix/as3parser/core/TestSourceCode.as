package org.teotigraphix.as3parser.core
{

import org.flexunit.Assert;

public class TestSourceCode
{
	[Test]
	public function testBasic():void
	{
		var code:String = "package {}";
		var filePath:String = "/home/user/src/my/domain/Test.as";
		var classPath:String = "/home/user/src";
		
		var sourceCode:SourceCode = new SourceCode(code, filePath, classPath);
		
		Assert.assertNotNull(sourceCode.code);
		Assert.assertEquals(code, sourceCode.code);
		Assert.assertEquals(filePath, sourceCode.filePath);
		Assert.assertEquals(classPath, sourceCode.classPath);
		
		Assert.assertEquals("as", sourceCode.extension);
		Assert.assertEquals("Test", sourceCode.name);
		Assert.assertEquals("my.domain", sourceCode.packageName);
		Assert.assertEquals("my.domain.Test", sourceCode.qualifiedName);
	}
	
	[Test]
	public function testReplaceCRNLWithNL():void
	{
		var code:String = "package {\r\npublic class \r\n\r\n {\r\n }\r\n}";
		var filePath:String = "/home/user/src/my/domain/Test.as";
		var classPath:String = "/home/user/src";
		
		var sourceCode:SourceCode = new SourceCode(code, filePath, classPath);
		Assert.assertEquals("package {\npublic class \n\n {\n }\n}", sourceCode.code);
	}
	
	[Test]
	public function testPathsCleaned():void
	{
		var code:String = "package {}";
		var filePath:String = "C:\\home\\user\\src\\my\\domain\\Test.as";
		var classPath:String = "C:\\home\\user\\src";
		
		var sourceCode:SourceCode = new SourceCode(code, filePath, classPath);
		Assert.assertEquals("C:/home/user/src/my/domain/Test.as", sourceCode.filePath);
		Assert.assertEquals("C:/home/user/src", sourceCode.classPath);
	}
	
	[Test]
	public function test_packageName():void
	{
		var sourceCode:SourceCode;
		var code:String = "package {}";
		
		sourceCode = new SourceCode(
			code, "/home/user/src/my/domain/Test.as", "/home/user/src");
		Assert.assertEquals("my.domain", sourceCode.packageName);
		
		sourceCode = new SourceCode(
			code, "/home/user/src/Test.as", "/home/user/src");
		Assert.assertNotNull(sourceCode.packageName);
		Assert.assertEquals("", sourceCode.packageName);
	}
	
	[Test]
	public function test_qualifiedName():void
	{
		var sourceCode:SourceCode;
		var code:String = "package {}";
		
		sourceCode = new SourceCode(
			code, "/home/user/src/my/domain/Test.as", "/home/user/src");
		Assert.assertEquals("my.domain", sourceCode.packageName);
		Assert.assertEquals("my.domain.Test", sourceCode.qualifiedName);
		
		sourceCode = new SourceCode(
			code, "/home/user/src/Test.as", "/home/user/src");
		Assert.assertNotNull(sourceCode.packageName);
		Assert.assertEquals("", sourceCode.packageName);
		Assert.assertEquals("Test", sourceCode.qualifiedName);
		Assert.assertEquals("Test", sourceCode.name);
		Assert.assertEquals("as", sourceCode.extension);
	}
	
	[Test]
	public function test_emptyClassPath():void
	{
		var sourceCode:SourceCode;
		var code:String = "package {}";
		
		sourceCode = new SourceCode(
			code, "my/domain/Test.as", "");
		
		Assert.assertEquals("my.domain", sourceCode.packageName);
		Assert.assertEquals("my.domain.Test", sourceCode.qualifiedName);
	}
	
	[Test]
	public function test_getSlice():void
	{
		// TODO implement test_getSlice()
	}
}
}