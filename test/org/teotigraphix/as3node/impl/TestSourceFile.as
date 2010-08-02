package org.teotigraphix.as3node.impl
{

import org.flexunit.Assert;
import org.teotigraphix.as3nodes.api.ICompilationNode;
import org.teotigraphix.as3nodes.api.ISourceFile;
import org.teotigraphix.as3nodes.impl.SourceFile;
import org.teotigraphix.as3parser.core.SourceCode;
import org.teotigraphix.as3parser.impl.AS3Parser;

public class TestSourceFile
{
	private var parser:AS3Parser;
	
	private var sourceFile:ISourceFile;
	
	private var compilationNode:ICompilationNode;
	
	private var source:String;
	
	[Before]
	public function setUp():void
	{
		parser = new AS3Parser();
		
		source =
			"package my.domain {\n" +
			"    public class Test\n" +
			"    {\n" +
			"    }\n" +
			"}\n";
		
		var code:SourceCode = new SourceCode(source, "internal");
		sourceFile = new SourceFile(null, code);
		
		compilationNode = sourceFile.buildAst();
	}
	
	[Test]
	public function testCompilationNode():void
	{
		Assert.assertEquals(source, sourceFile.sourceCode.code);
		Assert.assertEquals("internal", sourceFile.fileName);
		Assert.assertEquals("internal", sourceFile.sourceCode.fileName);
		
		Assert.assertNotNull(compilationNode);
		Assert.assertStrictlyEquals(sourceFile, compilationNode.parent);
		
		Assert.assertEquals("my.domain", sourceFile.compilationNode.packageNode.name);
		Assert.assertEquals("my.domain.Test", sourceFile.compilationNode.packageNode.qualifiedName);
		Assert.assertStrictlyEquals(compilationNode, sourceFile.compilationNode.packageNode.parent);
		
		Assert.assertTrue(compilationNode.packageNode.typeNode.isPublic);
		Assert.assertEquals("Test", compilationNode.packageNode.typeNode.name);
		Assert.assertStrictlyEquals(compilationNode.packageNode, sourceFile.compilationNode.packageNode.typeNode.parent);
	}
}
}