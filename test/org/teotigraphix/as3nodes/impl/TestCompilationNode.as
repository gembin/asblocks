package org.teotigraphix.as3nodes.impl
{

import flexunit.framework.Assert;

import org.teotigraphix.as3parser.core.SourceCode;

public class TestCompilationNode
{
	[Test]
	public function testBasic():void
	{
		// packageNode
		// packageName
		// typeNode
		var source:String = "package my.domain { public class Test { public function Test() {} } }";
		var name:String = "Test.as";
		var path:String = "c://project/src";
		
		var code:SourceCode = new SourceCode(source, name + "/" + path);
		var file:AS3SourceFile = new AS3SourceFile(code, path);
		file.buildAst();
		
		Assert.assertNotNull(file.compilationNode.node);
		Assert.assertStrictlyEquals(file, file.compilationNode.parent);
		Assert.assertEquals("my.domain", file.compilationNode.packageName);
		Assert.assertNotNull(file.compilationNode.packageNode);
		Assert.assertNotNull(file.compilationNode.typeNode);
		Assert.assertEquals("Test", file.compilationNode.typeNode.name);
	}
}
}