package org.as3commons.asblocks.impl
{

import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertFalse;
import org.flexunit.asserts.assertNotNull;
import org.flexunit.asserts.assertNull;
import org.flexunit.asserts.assertTrue;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.core.SourceCode;
import org.as3commons.asblocks.parser.impl.AS3FragmentParser;
import org.as3commons.asblocks.CodeMirror;
import org.as3commons.asblocks.api.IClassType;
import org.as3commons.asblocks.api.ICompilationUnit;
import org.as3commons.asblocks.api.IField;
import org.as3commons.asblocks.api.Visibility;

public class TestClassTypeNode extends BaseASFactoryTest
{
	private var unit:ICompilationUnit;
	
	[Before]
	override public function setUp():void
	{
		super.setUp();
		
		unit = project.newClass("A");
		assertNotNull(unit);
		assertNotNull(unit.typeNode);
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
			CodeMirror.assertReflection(factory, unit);
		}
	}
	
	[Test]
	public function test_isDynamic():void
	{
		var typeNode:IClassType = unit.typeNode as IClassType;
		assertFalse(typeNode.isDynamic);
		typeNode.isDynamic = true;
		assertTrue(typeNode.isDynamic);
		assertPrint("package {\n\tpublic dynamic class A {\n\t}\n}", unit);
		typeNode.isDynamic = false;
		assertFalse(typeNode.isDynamic);
		assertPrint("package {\n\tpublic class A {\n\t}\n}", unit);
	}
	
	[Test]
	public function test_isFinal():void
	{
		var typeNode:IClassType = unit.typeNode as IClassType;
		assertFalse(typeNode.isFinal);
		typeNode.isFinal = true;
		assertTrue(typeNode.isFinal);
		assertPrint("package {\n\tpublic final class A {\n\t}\n}", unit);
		typeNode.isFinal = false;
		assertFalse(typeNode.isFinal);
		assertPrint("package {\n\tpublic class A {\n\t}\n}", unit);
	}
	
	[Test]
	public function test_superClass():void
	{
		var typeNode:IClassType = unit.typeNode as IClassType;
		assertNull(typeNode.superClass);
		typeNode.superClass = "ClassB";
		assertEquals("ClassB", typeNode.superClass);
		assertPrint("package {\n\tpublic class A extends ClassB {\n\t}\n}", unit);
		typeNode.superClass = "ClassD";
		assertEquals("ClassD", typeNode.superClass);
		assertPrint("package {\n\tpublic class A extends ClassD {\n\t}\n}", unit);
		typeNode.superClass = null;
		assertNull(typeNode.superClass);
		assertPrint("package {\n\tpublic class A {\n\t}\n}", unit);
		typeNode.superClass = "my.domain.B";
		assertEquals("my.domain.B", typeNode.superClass);
		assertPrint("package {\n\tpublic class A extends my.domain.B {\n\t}\n}", unit);
	}
	
	[Test]
	public function test_implementedInterface():void
	{
		var typeNode:IClassType = unit.typeNode as IClassType;
		typeNode.addImplementedInterface("IInterfaceA");
		typeNode.addImplementedInterface("IInterfaceB");
		typeNode.addImplementedInterface("IInterfaceC");
		
		assertPrint("package {\n\tpublic class A implements IInterfaceA, " +
			"IInterfaceB, IInterfaceC {\n\t}\n}", unit);
		
		var ifaces:Vector.<String> = typeNode.implementedInterfaces;
		assertNotNull(ifaces);
		assertEquals(3, ifaces.length);
		assertEquals("IInterfaceA", ifaces[0]);
		assertEquals("IInterfaceB", ifaces[1]);
		assertEquals("IInterfaceC", ifaces[2]);
		
		typeNode.removeImplementedInterface("IInterfaceA");
		
		ifaces = typeNode.implementedInterfaces;
		assertNotNull(ifaces);
		assertEquals(2, ifaces.length);
		assertEquals("IInterfaceB", ifaces[0]);
		assertEquals("IInterfaceC", ifaces[1]);
		
		assertPrint("package {\n\tpublic class A implements " +
			"IInterfaceB, IInterfaceC {\n\t}\n}", unit);
	}
	
	[Test]
	public function test_addImplementedInterface():void
	{
		assertPrint("package {\n\tpublic class A {\n\t}\n}", unit);
		var typeNode:IClassType = unit.typeNode as IClassType;
		typeNode.addImplementedInterface("IInterfaceA");
		assertPrint("package {\n\tpublic class A implements IInterfaceA {\n\t}\n}", unit);
		typeNode.addImplementedInterface("IInterfaceB");
		assertPrint("package {\n\tpublic class A implements IInterfaceA, IInterfaceB {\n\t}\n}", unit);
		typeNode.removeImplementedInterface("IInterfaceA");
		assertPrint("package {\n\tpublic class A implements IInterfaceB {\n\t}\n}", unit);
		typeNode.removeImplementedInterface("IInterfaceB");
		assertPrint("package {\n\tpublic class A {\n\t}\n}", unit);
	}
	
	[Test]
	public function test_removeImplementedInterface():void
	{
		assertPrint("package {\n\tpublic class A {\n\t}\n}", unit);
		var typeNode:IClassType = unit.typeNode as IClassType;
		assertEquals(0, typeNode.implementedInterfaces.length);
		typeNode.addImplementedInterface("IInterfaceA");
		assertEquals(1, typeNode.implementedInterfaces.length);
		assertPrint("package {\n\tpublic class A implements IInterfaceA {\n\t}\n}", unit);
		typeNode.addImplementedInterface("IInterfaceB");
		assertPrint("package {\n\tpublic class A implements IInterfaceA, IInterfaceB {\n\t}\n}", unit);
		assertEquals(2, typeNode.implementedInterfaces.length);
		assertTrue(typeNode.removeImplementedInterface("IInterfaceA"));
		assertEquals(1, typeNode.implementedInterfaces.length);
		assertPrint("package {\n\tpublic class A implements IInterfaceB {\n\t}\n}", unit);
		assertTrue(typeNode.removeImplementedInterface("IInterfaceB"));
		assertEquals(0, typeNode.implementedInterfaces.length);
		assertPrint("package {\n\tpublic class A {\n\t}\n}", unit);
		assertFalse(typeNode.removeImplementedInterface("IInterfaceB"));
	}
	
	[Test]
	public function test_newField():void
	{
		var typeNode:IClassType = unit.typeNode as IClassType;
		// TODO make sure dups cannot be created
		var field:IField = typeNode.newField("fieldOne", Visibility.PUBLIC, "String");
		assertNotNull(field);
		assertEquals(Visibility.PUBLIC, field.visibility);
		assertEquals("fieldOne", field.name);
		assertEquals("String", field.type);
		assertPrint("package {\n\tpublic class A {\n\t\tpublic var fieldOne:String;\n\t}\n}", unit);
		
		assertTrue(typeNode.removeField("fieldOne"));
		assertPrint("package {\n\tpublic class A {\n\t}\n}", unit);
		assertFalse(typeNode.removeField("fieldOne"));
	}
	
	[Test]
	public function test_getField():void
	{
		var typeNode:IClassType = unit.typeNode as IClassType;
		var field:IField = typeNode.newField("fieldOne", Visibility.PUBLIC, "String");
		assertEquals(field.name, typeNode.getField("fieldOne").name);
		assertNull(typeNode.getField("fieldTwo"));
		typeNode.removeField("fieldOne");
		assertNull(typeNode.getField("fieldOne"));
	}
	
	[Test]
	public function test_removeField():void
	{
		var typeNode:IClassType = unit.typeNode as IClassType;
		var field1:IField = typeNode.newField("fieldOne", Visibility.PUBLIC, "String");
		var field2:IField = typeNode.newField("fieldTwo", Visibility.PUBLIC, "String");
		var field3:IField = typeNode.newField("fieldThree", Visibility.PUBLIC, "String");
		assertPrint("package {\n\tpublic class A {\n\t\tpublic var fieldOne:String;" +
			"\n\t\tpublic var fieldTwo:String;\n\t\tpublic var fieldThree:String;\n\t}\n}", unit);
		assertEquals(3, typeNode.fields.length);
		assertTrue(typeNode.removeField("fieldOne"));
		assertEquals(2, typeNode.fields.length);
		assertTrue(typeNode.removeField("fieldTwo"));
		assertEquals(1, typeNode.fields.length);
		assertTrue(typeNode.removeField("fieldThree"));
		assertEquals(0, typeNode.fields.length);
		assertFalse(typeNode.removeField("fieldFour"));
		assertPrint("package {\n\tpublic class A {\n\t}\n}", unit);
	}
}
}