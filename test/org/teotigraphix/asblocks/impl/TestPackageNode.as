package org.teotigraphix.asblocks.impl
{

import org.flexunit.Assert;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.asblocks.api.ICompilationUnit;
import org.teotigraphix.asblocks.api.IPackage;
import org.teotigraphix.asblocks.api.IScriptNode;
import org.teotigraphix.asblocks.utils.ASTUtil;

public class TestPackageNode extends BaseASFactoryTest
{
	[Test]
	public function testPackageNode():void
	{
		var unit:ICompilationUnit = project.newClass("A");
		
		// test packageNode
		var packageNode:IPackage = unit.packageNode;
		Assert.assertNotNull(packageNode);
		// test packageName get /set
		Assert.assertNull(packageNode.name);
		
		packageNode.name = "my.domain";
		Assert.assertEquals("my.domain", packageNode.name);
		
		packageNode.name = "my.domain.sub";
		Assert.assertEquals("my.domain.sub", packageNode.name);
	}
	
	[Test]
	public function testPackageNode_addImport():void
	{
		var unit:ICompilationUnit = project.newClass("A");
		
		unit.packageNode.addImports("my.other.B");
		unit.packageNode.addImports("my.other.C");
		unit.packageNode.addImports("my.other.D");
		
		assertPrint("package {\n\timport my.other.B;\n\timport my.other.C;\n\t" +
			"import my.other.D;\n\tpublic class A {\n\t}\n}", unit);
	}
	
	[Test]
	public function testPackageNode_removeImport():void
	{
		var unit:ICompilationUnit = project.newClass("A");
		
		unit.packageNode.addImports("my.other.B");
		unit.packageNode.addImports("my.other.C");
		unit.packageNode.addImports("my.other.D");
		
		var imports:Vector.<String> = unit.packageNode.findImports();
		Assert.assertEquals(3, imports.length);
		
		unit.packageNode.removeImport("my.other.C");
		imports = unit.packageNode.findImports();
		Assert.assertEquals(2, imports.length);
		Assert.assertEquals("my.other.B", imports[0]);
		Assert.assertEquals("my.other.D", imports[1]);
		
		assertPrint("package {\n\timport my.other.B;\n\timport my.other.D;" +
			"\n\tpublic class A {\n\t}\n}", unit);
	}
	
	[Test]
	public function testPackageNode_findImports():void
	{
		var unit:ICompilationUnit = project.newClass("A");
		
		unit.packageNode.addImports("my.other.B");
		unit.packageNode.addImports("my.other.C");
		unit.packageNode.addImports("my.other.D");
		
		var imports:Vector.<String> = unit.packageNode.findImports();
		Assert.assertNotNull(imports);
		Assert.assertEquals(3, imports.length);
		Assert.assertEquals("my.other.B", imports[0]);
		Assert.assertEquals("my.other.C", imports[1]);
		Assert.assertEquals("my.other.D", imports[2]);
	}
}
}