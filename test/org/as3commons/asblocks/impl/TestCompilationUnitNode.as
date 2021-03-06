package org.as3commons.asblocks.impl
{

import org.flexunit.Assert;
import org.flexunit.asserts.assertNotNull;
import org.flexunit.asserts.assertTrue;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.core.SourceCode;
import org.as3commons.asblocks.parser.impl.AS3FragmentParser;
import org.as3commons.asblocks.CodeMirror;
import org.as3commons.asblocks.api.IClassType;
import org.as3commons.asblocks.api.ICompilationUnit;
import org.as3commons.asblocks.api.IInterfaceType;
import org.as3commons.asblocks.api.IPackage;

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
	
	[After]
	override public function tearDown():void
	{
		if (unit)
		{
			var sourceCode:SourceCode = new SourceCode();
			var ast:IParserNode = unit.node;
			new ASTPrinter(sourceCode).print(ast);
			var parsed:IParserNode = AS3FragmentParser.parseCompilationUnit(sourceCode.code);
			CodeMirror.assertASTMatch(ast, parsed);
		}
	}
	
	[Test]
	public function testBasic():void
	{
		unit = project.newClass("A");
		assertPrint("package {\n\tpublic class A {\n\t}\n}", unit);
	}
	
	[Test]
	public function testPackageNode():void
	{
		Assert.assertNotNull(unit.packageNode);
		Assert.assertTrue(unit.packageNode is IPackage);
		Assert.assertNull(unit.packageNode.name);
	}
	
	[Test]
	public function testPackageName():void
	{
		Assert.assertNull(unit.packageNode.name);
		Assert.assertNull(unit.packageName);
		
		unit.packageName = "my.domain";
		Assert.assertEquals("my.domain", unit.packageName);
		assertPrint("package my.domain {\n\tpublic class A {\n\t}\n}", unit);
		
		unit.packageName = "my.domain.sub";
		Assert.assertEquals("my.domain.sub", unit.packageName);
		assertPrint("package my.domain.sub {\n\tpublic class A {\n\t}\n}", unit);
		
		unit.packageName = null;
		Assert.assertNull(unit.packageName);
		assertPrint("package {\n\tpublic class A {\n\t}\n}", unit);
	}
	
	[Test]
	public function testTypeNode():void
	{
		unit = project.newClass("A");
		assertNotNull(unit.typeNode);
		assertTrue(unit.typeNode is IClassType);
		assertPrint("package {\n\tpublic class A {\n\t}\n}", unit);
		unit = project.newInterface("IA");
		assertNotNull(unit.typeNode);
		assertTrue(unit.typeNode is IInterfaceType);
		assertPrint("package {\n\tpublic interface IA {\n\t}\n}", unit);
	}
	
	[Test]
	public function test_newInternalClass():void
	{
		unit = project.newClass("A");
		unit.newInternalClass("Foo");
		
		assertPrint("package {\n\tpublic class A {\n\t}\n}\nclass Foo {\n}", unit);
	}
	
	[Test]
	public function test_newInternalFunction():void
	{
		unit = project.newClass("A");
		unit.newInternalFunction("foo", "void");
		
		assertPrint("package {\n\tpublic class A {\n\t}\n}\nfunction foo():void {\n}", unit);
	}
}
}