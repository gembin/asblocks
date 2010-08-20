package org.teotigraphix.as3nodes.impl
{

import org.flexunit.Assert;
import org.teotigraphix.as3nodes.api.IAS3SourceFile;
import org.teotigraphix.as3nodes.api.ICompilationNode;
import org.teotigraphix.as3nodes.api.IMXMLSourceFile;
import org.teotigraphix.as3parser.core.SourceCode;

public class TestAS3SourceFile
{
	[Before]
	public function setUp():void
	{
	}
	
	[Test]
	public function testBasic():void
	{
		var code:String = "package {}";
		var filePath:String = "/home/user/src/my/domain/Test.as";
		var classPath:String = "/home/user/src";
		
		var file:AS3SourceFile = new AS3SourceFile(new SourceCode(code, filePath), classPath);
		
		Assert.assertNotNull(file.sourceCode);
		Assert.assertEquals(code, file.sourceCode.code);
		Assert.assertEquals(filePath, file.filePath);
		Assert.assertEquals(classPath, file.classPath);
		
		Assert.assertEquals("as", file.extension);
		Assert.assertEquals("Test", file.name);
		Assert.assertEquals("my.domain", file.packageName);
		Assert.assertEquals("my.domain.Test", file.qualifiedName);
	}
	
	[Test]
	public function testReplaceCRNLWithNL():void
	{
		var code:String = "package {\r\npublic class \r\n\r\n {\r\n }\r\n}";
		var filePath:String = "/home/user/src/my/domain/Test.as";
		var classPath:String = "/home/user/src";
		
		var file:AS3SourceFile = new AS3SourceFile(new SourceCode(code, filePath), classPath);
		
		Assert.assertEquals("package {\npublic class \n\n {\n }\n}", file.sourceCode.code);
	}
	
	[Test]
	public function testPathsCleaned():void
	{
		var code:String = "package {}";
		var filePath:String = "C:\\home\\user\\src\\my\\domain\\Test.as";
		var classPath:String = "C:\\home\\user\\src";
		
		var file:AS3SourceFile = new AS3SourceFile(new SourceCode(code, filePath), classPath);
		Assert.assertEquals("C:/home/user/src/my/domain/Test.as", file.filePath);
		Assert.assertEquals("C:/home/user/src", file.classPath);
	}
	
	[Test]
	public function test_packageName():void
	{
		var file:AS3SourceFile;
		var code:String = "package {}";
		var filePath:String = "/home/user/src/my/domain/Test.as";
		var classPath:String = "/home/user/src";
		
		file = new AS3SourceFile(new SourceCode(code, "/home/user/src/my/domain/Test.as"), "/home/user/src");
		Assert.assertNotNull(file.packageName);
		Assert.assertEquals("my.domain", file.packageName);
		
		file = new AS3SourceFile(new SourceCode(code, "/home/user/src/Test.as"), "/home/user/src");
		Assert.assertNotNull(file.packageName);
		Assert.assertEquals("", file.packageName);
	}
	
	[Test]
	public function test_qualifiedName():void
	{
		var file:AS3SourceFile;
		var code:String = "package {}";
		var filePath:String = "/home/user/src/my/domain/Test.as";
		var classPath:String = "/home/user/src";
		
		file = new AS3SourceFile(new SourceCode(code, "/home/user/src/my/domain/Test.as"), "/home/user/src");
		Assert.assertNotNull(file.qualifiedName);
		Assert.assertEquals("my.domain.Test", file.qualifiedName);
		
		file = new AS3SourceFile(new SourceCode(code, "/home/user/src/Test.as"), "/home/user/src");
		Assert.assertNotNull(file.qualifiedName);
		Assert.assertEquals("Test", file.qualifiedName);
	}
	
	[Test]
	public function test_emptyClassPath():void
	{
		var file:AS3SourceFile;
		var code:String = "package {}";
		
		file = new AS3SourceFile(new SourceCode(code, "my/domain/Test.as"), "");
		
		Assert.assertEquals("my.domain", file.packageName);
		Assert.assertEquals("my.domain.Test", file.qualifiedName);
	}
	
	[Test]
	public function testIAS3SourceFile():void
	{
		var source:String =
			"package my.domain {\n" +
			"    public class Test\n" +
			"    {\n" +
			"    }\n" +
			"}\n";
		
		var sourceFile:IAS3SourceFile = NodeFactory.instance.
			createSourceFile(source, "/home/src/my/domain/Test.as", "/home/src") as IAS3SourceFile;
		
		var compilationNode:ICompilationNode = sourceFile.buildAst();
		
		Assert.assertEquals(source, sourceFile.sourceCode.code);
		Assert.assertEquals("/home/src/my/domain/Test.as", sourceFile.filePath);
		Assert.assertEquals("/home/src/my/domain/Test.as", sourceFile.sourceCode.filePath);
		
		Assert.assertNotNull(compilationNode);
		Assert.assertStrictlyEquals(sourceFile, compilationNode.parent);
		
		Assert.assertEquals("Test", sourceFile.name);
		Assert.assertEquals("my.domain", sourceFile.packageName);
		Assert.assertEquals("my.domain.Test", sourceFile.qualifiedName);
		Assert.assertStrictlyEquals(compilationNode, sourceFile.packageNode.parent);
		
		Assert.assertTrue(compilationNode.typeNode.isPublic);
		Assert.assertEquals("Test", compilationNode.typeNode.name);
		Assert.assertStrictlyEquals(compilationNode.packageNode, sourceFile.typeNode.parent);
	}
	
	[Test]
	public function testIMXMLSourceFile():void
	{
		var source:String =
			"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n" +
			"<!--- \n" +
			"  The application comment.\n" +
			"-->\n" +
			"<s:Application xmlns:fx=\"http://ns.adobe.com/mxml/2009\"\n" +
			"    xmlns:s=\"library://ns.adobe.com/flex/spark\"\n" +
			"    xmlns:controls=\"my.package.controls.*\"" +
			"    implements=\"ITest, my.domain.IOther\">\n" +
			"    <fx:Metadata>\n" +
			"        [Event(name=\"myEvent\",type=\"flash.events.Event\")]" +
			"    </fx:Metadata>\n" +
			"    <fx:Script>\n" +
			"        <![CDATA[\n" +
			"        /** A public var 1. */\n" +
			"        public var variable1:int = 1;\n" +
			"        /** A public var 2. */\n" +
			"        public var variable2:int = 2;\n" +
			"        /** A public method 1. */\n" +
			"        public function method2():void\n" +
			"        {\n" +
			"        }\n" +
			"        ]]>\n" +
			"    </fx:Script>\n" +
			"    <!--- The button1. -->\n" +
			"    <s:Button id=\"button1\" label=\"Label 1\"/>\n" +
			"    <!--- The button2. -->\n" +
			"    <s:Button id=\"button2\" label=\"Label 2\"/>\n" +
			"    <!--- The control1. -->\n" +
			"    <controls:MyControl id=\"control1\"/>\n" +
			"</s:Application>}\n";
		
		var sourceFile:IMXMLSourceFile = NodeFactory.instance.
			createSourceFile(source, "/home/src/my/domain/TestMXML.mxml", "/home/src") as IMXMLSourceFile;
		
		var compilationNode:ICompilationNode = sourceFile.buildAst();
		
		Assert.assertEquals(source, sourceFile.sourceCode.code);
		Assert.assertEquals("/home/src/my/domain/TestMXML.mxml", sourceFile.filePath);
		Assert.assertEquals("/home/src/my/domain/TestMXML.mxml", sourceFile.sourceCode.filePath);
		
		Assert.assertNotNull(compilationNode);
		Assert.assertStrictlyEquals(sourceFile, compilationNode.parent);
		
		Assert.assertEquals("TestMXML", sourceFile.name);
		Assert.assertEquals("my.domain", sourceFile.packageName);
		Assert.assertEquals("my.domain.TestMXML", sourceFile.qualifiedName);
		Assert.assertStrictlyEquals(compilationNode, sourceFile.packageNode.parent);
		
		Assert.assertTrue(compilationNode.typeNode.isPublic);
		Assert.assertEquals("TestMXML", compilationNode.typeNode.name);
		Assert.assertStrictlyEquals(compilationNode.packageNode, sourceFile.typeNode.parent);
	}
}
}