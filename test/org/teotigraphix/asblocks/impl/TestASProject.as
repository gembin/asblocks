package org.teotigraphix.asblocks.impl
{

import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertNotNull;
import org.teotigraphix.as3parser.core.SourceCode;
import org.teotigraphix.asblocks.api.ICompilationUnit;

public class TestASProject extends BaseASFactoryTest
{
	[Test]
	public function test_newClass():void
	{
		var unit:ICompilationUnit = project.newClass("my.domain.ClassA");
		assertNotNull(unit.typeNode);
		assertPrint("package my.domain {\n\tpublic class ClassA {\n\t}\n}", unit);
	}
	
	[Test]
	public function test_newInterface():void
	{
		var unit:ICompilationUnit = project.newInterface("my.domain.IInterfaceA");
		assertNotNull(unit.typeNode);
		assertPrint("package my.domain {\n\tpublic interface IInterfaceA {\n\t}\n}", unit);
	}
	
	[Test]
	public function test_compilationUnits():void
	{
		var unit1:ICompilationUnit = project.newClass("my.domain.ClassA");
		var unit2:ICompilationUnit = project.newInterface("my.domain.IInterfaceA");
		var unit3:ICompilationUnit = project.newClass("my.other.domain.ClassB");
		var units:Vector.<ICompilationUnit> = project.compilationUnits;
		assertNotNull(units);
		assertEquals(3, units.length);
		assertEquals("my.domain", units[0].packageName);
		assertEquals("ClassA", units[0].typeNode.name);
		assertEquals("my.domain", units[1].packageName);
		assertEquals("IInterfaceA", units[1].typeNode.name);
		assertEquals("my.other.domain", units[2].packageName);
		assertEquals("ClassB", units[2].typeNode.name);
	}
	
	[Test]
	public function test_addCompilationUnit():void
	{
		var unit:ICompilationUnit = asparser.parseString(
			"package my.domain {\n\tpublic class ClassA {\n\t}\n}");
		assertEquals("my.domain", unit.packageName);
		assertEquals("ClassA", unit.typeNode.name);
		project.addCompilationUnit(unit);
		var units:Vector.<ICompilationUnit> = project.compilationUnits;
		assertNotNull(units);
		assertEquals(1, units.length);
		assertEquals("my.domain", units[0].packageName);
		assertEquals("ClassA", units[0].typeNode.name);
	}
	
	[Test]
	public function test_removeCompilationUnit():void
	{
		var unit:ICompilationUnit = asparser.parseString(
			"package my.domain {\n\tpublic class ClassA {\n\t}\n}");
		project.addCompilationUnit(unit);
		var units:Vector.<ICompilationUnit> = project.compilationUnits;
		assertNotNull(units);
		assertEquals(1, units.length);
		project.removeCompilationUnit(unit);
		units = project.compilationUnits;
		assertNotNull(units);
		assertEquals(0, units.length);
	}
}
}