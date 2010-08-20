package org.teotigraphix.as3nodes.impl
{

import org.flexunit.Assert;
import org.teotigraphix.as3nodes.api.IAS3SourceFile;
import org.teotigraphix.as3nodes.api.ICompilationNode;
import org.teotigraphix.as3nodes.api.IMXMLSourceFile;
import org.teotigraphix.as3parser.core.SourceCode;

public class TestSourceFile
{
	[Before]
	public function setUp():void
	{
	}
	
	[Test]
	public function testBasic():void
	{
		//var code:SourceCode = new SourceCode("");
		//var file:SourceFile = new SourceFile(null, code);
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
			createSourceFile(source, "/home/src/my/domain/internal.as", "/home/src") as IAS3SourceFile;
		
		var compilationNode:ICompilationNode = sourceFile.buildAst();
		
		Assert.assertEquals(source, sourceFile.sourceCode.code);
		Assert.assertEquals("/home/src/my/domain/internal.as", sourceFile.fileName);
		Assert.assertEquals("/home/src/my/domain/internal.as", sourceFile.sourceCode.filePath);
		
		Assert.assertNotNull(compilationNode);
		Assert.assertStrictlyEquals(sourceFile, compilationNode.parent);
		
		Assert.assertEquals("my.domain", sourceFile.compilationNode.packageNode.name);
		Assert.assertEquals("my.domain.Test", sourceFile.compilationNode.packageNode.qualifiedName);
		Assert.assertStrictlyEquals(compilationNode, sourceFile.compilationNode.packageNode.parent);
		
		Assert.assertTrue(compilationNode.packageNode.typeNode.isPublic);
		Assert.assertEquals("Test", compilationNode.packageNode.typeNode.name);
		Assert.assertStrictlyEquals(compilationNode.packageNode, sourceFile.compilationNode.packageNode.typeNode.parent);
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
		Assert.assertEquals("/home/src/my/domain/TestMXML.mxml", sourceFile.fileName);
		Assert.assertEquals("/home/src/my/domain/TestMXML.mxml", sourceFile.sourceCode.filePath);
		
		Assert.assertNotNull(compilationNode);
		Assert.assertStrictlyEquals(sourceFile, compilationNode.parent);
		
		Assert.assertEquals("my.domain", sourceFile.compilationNode.packageNode.name);
		Assert.assertEquals("my.domain.TestMXML", sourceFile.compilationNode.packageNode.qualifiedName);
		Assert.assertStrictlyEquals(compilationNode, sourceFile.compilationNode.packageNode.parent);
		
		Assert.assertTrue(compilationNode.packageNode.typeNode.isPublic);
		Assert.assertEquals("TestMXML", compilationNode.packageNode.typeNode.name);
		Assert.assertStrictlyEquals(compilationNode.packageNode, sourceFile.compilationNode.packageNode.typeNode.parent);
	}
}
}