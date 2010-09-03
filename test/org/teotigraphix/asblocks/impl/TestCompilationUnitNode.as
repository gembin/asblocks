package org.teotigraphix.asblocks.impl
{

import org.teotigraphix.asblocks.api.ICompilationUnitNode;

public class TestCompilationUnitNode extends BaseASFactoryTest
{	
	[Test]
	public function testClass():void
	{
		var statement:ICompilationUnitNode = project.newClass("my.domain.ClassA");
		
		//var result:String = ASTUtil.convert(statement.node, false);
		
		//assertPrint("package my.domain {\n\tpublic class ClassA {\n\t}\n}", statement);
	}
}
}