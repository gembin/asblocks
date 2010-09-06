package org.teotigraphix.asblocks.impl
{

import org.flexunit.Assert;
import org.flexunit.asserts.assertNotNull;
import org.flexunit.asserts.assertTrue;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.asblocks.api.IClassType;
import org.teotigraphix.asblocks.api.ICompilationUnit;
import org.teotigraphix.asblocks.api.IPackage;

public class TestCompilationUnitNode extends BaseASFactoryTest
{
	private var unit:ICompilationUnit;
	
	[Before]
	override public function setUp():void
	{
		super.setUp();
		
		unit = project.newClass("A");
		assertNotNull(unit);
	}
	
	[Test]
	public function testBasicPackageAndClass():void
	{
		var input:String = "package {\n\tpublic class A {\n\t}\n}";
		
		// create a package with class
		var unit:ICompilationUnit = project.newClass("A");
		var result1:String = toElementString(unit);
		
		// parse a package with class
		var ast:IParserNode = parseCompilationUnit(input);
		var result2:String = toElementString(ast);
		
		// assert the AST is equal
		Assert.assertEquals(result1, result2);
		
		// assert that both ast models will print equal 
		// with newlines, tabs and spaces
		assertPrint(input, new CompilationUnitNode(ast));
		assertPrint(input, unit);
	}
	
	[Test]
	public function testPackageNode():void
	{
		Assert.assertNotNull(unit.packageNode);
	}
	
	[Test]
	public function testPackageName():void
	{
		// test packageNode
		var packageNode:IPackage = unit.packageNode;
		Assert.assertNotNull(packageNode);
		// test packageName get /set
		Assert.assertNull(unit.packageName);
		
		unit.packageName = "my.domain";
		Assert.assertEquals("my.domain", unit.packageName);
		
		unit.packageName = "my.domain.sub";
		Assert.assertEquals("my.domain.sub", unit.packageName);
	}
	
	[Test]
	public function testTypeNode():void
	{
		assertNotNull(unit.typeNode);
		assertTrue(unit.typeNode is IClassType);
	}
}
}