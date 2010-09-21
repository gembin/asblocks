package org.teotigraphix.asblocks.impl
{

import org.flexunit.Assert;
import org.flexunit.asserts.assertNotNull;
import org.flexunit.asserts.assertTrue;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.core.SourceCode;
import org.teotigraphix.as3parser.impl.AS3FragmentParser;
import org.teotigraphix.asblocks.CodeMirror;
import org.teotigraphix.asblocks.api.IClassType;
import org.teotigraphix.asblocks.api.ICompilationUnit;
import org.teotigraphix.asblocks.api.IInterfaceType;
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
}
}