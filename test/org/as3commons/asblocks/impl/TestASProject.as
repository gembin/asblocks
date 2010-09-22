package org.as3commons.asblocks.impl
{

import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertFalse;
import org.flexunit.asserts.assertNotNull;
import org.flexunit.asserts.assertNull;
import org.flexunit.asserts.assertTrue;
import org.as3commons.asblocks.ASFactory;
import org.as3commons.asblocks.IASProject;
import org.as3commons.asblocks.api.IClassPathEntry;
import org.as3commons.asblocks.api.IClassType;
import org.as3commons.asblocks.api.ICompilationUnit;
import org.as3commons.asblocks.api.IMethod;
import org.as3commons.asblocks.api.Visibility;

public class TestASProject extends BaseASFactoryTest
{
	[Test]
	/**
	 * package {
	 * 	public class Test {
	 * 		public function test():void {
	 * 			trace('Hello world');
	 * 		}
	 * 	}
	 * }
	 */
	public function test_basicExample():void
	{
		var factorty:ASFactory = new ASFactory();
		var project:ASProject = factorty.newEmptyASProject(".") as ASProject;
		var unit:ICompilationUnit = project.newClass("Test");
		var clazz:IClassType = unit.typeNode as IClassType;
		var method:IMethod = clazz.newMethod("test", Visibility.PUBLIC, "void");
		method.addStatement("trace('Hello world')");
		project.writeAll();
		assertEquals("Test.as", 
			project.sourceCodeList[0].filePath);
		assertEquals("package {\n\tpublic class Test {\n\t\tpublic function " +
			"test():void {\n\t\t\ttrace('Hello world');\n\t\t}\n\t}\n}", 
			project.sourceCodeList[0].code);
	}
	
	[Test]
	public function test_outputLocation():void
	{
		assertNull(project.outputLocation);
		project.outputLocation = "/someplace/output";
		assertEquals("/someplace/output", project.outputLocation);
		project.outputLocation = null;
		assertNull(project.outputLocation);
	}
	
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
		assertTrue(project.addCompilationUnit(unit));
		var units:Vector.<ICompilationUnit> = project.compilationUnits;
		assertNotNull(units);
		assertEquals(1, units.length);
		assertEquals("my.domain", units[0].packageName);
		assertEquals("ClassA", units[0].typeNode.name);
		assertFalse(project.addCompilationUnit(unit));
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
	
	[Test]
	public function test_addClassPath():void
	{
		assertNotNull(project.classPathEntries);
		assertNotNull(project.addClassPath("/path1/src"));
		assertNotNull(project.addClassPath("/path2/src"));
		assertNotNull(project.addClassPath("/path3/src"));
		assertNull(project.addClassPath("/path1/src"));
		var entries:Vector.<IClassPathEntry> = project.classPathEntries;
		assertNotNull(entries);
		assertEquals(3, entries.length);
		assertEquals("/path1/src", entries[0].filePath);
		assertEquals("/path2/src", entries[1].filePath);
		assertEquals("/path3/src", entries[2].filePath);
	}
	
	[Test]
	public function test_removeClassPath():void
	{
		assertNotNull(project.classPathEntries);
		assertNotNull(project.addClassPath("/path1/src"));
		assertNotNull(project.addClassPath("/path2/src"));
		assertNotNull(project.addClassPath("/path3/src"));
		var entries:Vector.<IClassPathEntry> = project.classPathEntries;
		assertNotNull(entries);
		assertEquals(3, entries.length);
		assertEquals("/path1/src", entries[0].filePath);
		assertEquals("/path2/src", entries[1].filePath);
		assertEquals("/path3/src", entries[2].filePath);
		assertTrue(project.removeClassPath("/path1/src"));
		assertFalse(project.removeClassPath("/path1/src"));
		entries = project.classPathEntries;
		assertEquals(2, entries.length);
		assertEquals("/path2/src", entries[0].filePath);
		assertEquals("/path3/src", entries[1].filePath);
		assertTrue(project.removeClassPath("/path2/src"));
		assertFalse(project.removeClassPath("/path2/src"));
		entries = project.classPathEntries;
		assertEquals(1, entries.length);
		assertEquals("/path3/src", entries[0].filePath);
		assertTrue(project.removeClassPath("/path3/src"));
		assertFalse(project.removeClassPath("/path3/src"));
		entries = project.classPathEntries;
		assertEquals(0, entries.length);
	}
}
}