package org.teotigraphix.asblocks.impl
{

import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertFalse;
import org.flexunit.asserts.assertNotNull;
import org.flexunit.asserts.assertNull;
import org.flexunit.asserts.assertStrictlyEquals;
import org.flexunit.asserts.assertTrue;
import org.teotigraphix.asblocks.api.IClassTypeNode;
import org.teotigraphix.asblocks.api.ICompilationUnitNode;
import org.teotigraphix.asblocks.api.IFieldNode;
import org.teotigraphix.asblocks.api.IMethodNode;
import org.teotigraphix.asblocks.api.Visibility;

public class TestClassTypeNode extends BaseASFactoryTest
{
	private var unit:ICompilationUnitNode;
	
	[Before]
	override public function setUp():void
	{
		super.setUp();
		
		unit = project.newClass("A");
		assertNotNull(unit);
		assertNotNull(unit.typeNode);
	}
	
	[Test]
	public function test_newField():void
	{
		var typeNode:IClassTypeNode = unit.typeNode as IClassTypeNode;
		// TODO make sure dups cannot be created
		var field:IFieldNode = typeNode.newField("fieldOne", Visibility.PUBLIC, "String");
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
		var typeNode:IClassTypeNode = unit.typeNode as IClassTypeNode;
		var field:IFieldNode = typeNode.newField("fieldOne", Visibility.PUBLIC, "String");
		assertEquals(field.name, typeNode.getField("fieldOne").name);
		assertNull(typeNode.getField("fieldTwo"));
		typeNode.removeField("fieldOne");
		assertNull(typeNode.getField("fieldOne"));
	}
	
	[Test]
	public function test_removeField():void
	{
		var typeNode:IClassTypeNode = unit.typeNode as IClassTypeNode;
		var field1:IFieldNode = typeNode.newField("fieldOne", Visibility.PUBLIC, "String");
		var field2:IFieldNode = typeNode.newField("fieldTwo", Visibility.PUBLIC, "String");
		var field3:IFieldNode = typeNode.newField("fieldThree", Visibility.PUBLIC, "String");
		assertEquals(3, typeNode.fields.length);
		assertTrue(typeNode.removeField("fieldOne"));
		assertEquals(2, typeNode.fields.length);
		assertTrue(typeNode.removeField("fieldTwo"));
		assertEquals(1, typeNode.fields.length);
		assertTrue(typeNode.removeField("fieldThree"));
		assertEquals(0, typeNode.fields.length);
		assertFalse(typeNode.removeField("fieldFour"));
	}
	
	[Test]
	public function test_newMethod():void
	{
		var typeNode:IClassTypeNode = unit.typeNode as IClassTypeNode;
		// TODO make sure dups cannot be created
		var method:IMethodNode = typeNode.newMethod("methodOne", Visibility.PUBLIC, "String");
		assertNotNull(method);
		assertEquals(Visibility.PUBLIC, method.visibility);
		assertEquals("methodOne", method.name);
		assertEquals("String", method.type);
		assertPrint("package {\n\tpublic class A {\n\t\tpublic function methodOne()" +
			":String {\n\t\t}\n\t}\n}", unit);
		
		assertTrue(typeNode.removeMethod("methodOne"));
		assertPrint("package {\n\tpublic class A {\n\t}\n}", unit);
		assertFalse(typeNode.removeMethod("methodOne"));
	}
	
	[Test]
	public function test_getMethod():void
	{
		var typeNode:IClassTypeNode = unit.typeNode as IClassTypeNode;
		var method:IMethodNode = typeNode.newMethod("methodOne", Visibility.PUBLIC, "String");
		assertEquals(method.name, typeNode.getMethod("methodOne").name);
		assertNull(typeNode.getMethod("methodTwo"));
		typeNode.removeMethod("methodOne");
		assertNull(typeNode.getMethod("methodOne"));
	}
	
	[Test]
	public function test_removeMethod():void
	{
		var typeNode:IClassTypeNode = unit.typeNode as IClassTypeNode;
		var method1:IMethodNode = typeNode.newMethod("methodOne", Visibility.PUBLIC, "String");
		var method2:IMethodNode = typeNode.newMethod("methodTwo", Visibility.PUBLIC, "String");
		var method3:IMethodNode = typeNode.newMethod("methodThree", Visibility.PUBLIC, "String");
		assertEquals(3, typeNode.methods.length);
		assertTrue(typeNode.removeMethod("methodOne"));
		assertEquals(2, typeNode.methods.length);
		assertTrue(typeNode.removeMethod("methodTwo"));
		assertEquals(1, typeNode.methods.length);
		assertTrue(typeNode.removeMethod("methodThree"));
		assertEquals(0, typeNode.methods.length);
		assertFalse(typeNode.removeMethod("methodFour"));
	}
	
	[Test]
	public function test_isDynamic():void
	{
		var typeNode:IClassTypeNode = unit.typeNode as IClassTypeNode;
		assertFalse(typeNode.isDynamic);
		typeNode.isDynamic = true;
		assertTrue(typeNode.isDynamic);
		typeNode.isDynamic = false;
		assertFalse(typeNode.isDynamic);
	}
	
	[Test]
	public function test_isFinal():void
	{
		var typeNode:IClassTypeNode = unit.typeNode as IClassTypeNode;
		assertFalse(typeNode.isFinal);
		typeNode.isFinal = true;
		assertTrue(typeNode.isFinal);
		typeNode.isFinal = false;
		assertFalse(typeNode.isFinal);
	}
	
	[Test]
	public function test_visibility():void
	{
		var typeNode:IClassTypeNode = unit.typeNode as IClassTypeNode;
		assertEquals(Visibility.PUBLIC, typeNode.visibility);
		assertPrint("package {\n\tpublic class A {\n\t}\n}", unit);
		// TOD this shouldn' be possible, just testing right now
		//typeNode.visibility = Visibility.INTERNAL;
		//assertEquals(Visibility.INTERNAL, typeNode.visibility);
		//assertPrint("package {\n\internal class A {\n\t}\n}", unit);
	}
	
	[Test]
	public function test_name():void
	{
		var typeNode:IClassTypeNode = unit.typeNode as IClassTypeNode;
		assertEquals("A", typeNode.name);
		assertPrint("package {\n\tpublic class A {\n\t}\n}", unit);
		typeNode.name = "TestA";
		assertEquals("TestA", typeNode.name);
		assertPrint("package {\n\tpublic class TestA {\n\t}\n}", unit);
		// test that name cannot be set to null or ""
	}
	
	[Test]
	public function test_superClass():void
	{
		var typeNode:IClassTypeNode = unit.typeNode as IClassTypeNode;
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
	}
	
	[Test]
	public function test_addImplementedInterface():void
	{
		// TODO block adding the same type
		assertPrint("package {\n\tpublic class A {\n\t}\n}", unit);
		var typeNode:IClassTypeNode = unit.typeNode as IClassTypeNode;
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
		var typeNode:IClassTypeNode = unit.typeNode as IClassTypeNode;
		typeNode.addImplementedInterface("IInterfaceA");
		assertPrint("package {\n\tpublic class A implements IInterfaceA {\n\t}\n}", unit);
		typeNode.addImplementedInterface("IInterfaceB");
		assertPrint("package {\n\tpublic class A implements IInterfaceA, IInterfaceB {\n\t}\n}", unit);
		assertTrue(typeNode.removeImplementedInterface("IInterfaceA"));
		assertPrint("package {\n\tpublic class A implements IInterfaceB {\n\t}\n}", unit);
		assertTrue(typeNode.removeImplementedInterface("IInterfaceB"));
		assertPrint("package {\n\tpublic class A {\n\t}\n}", unit);
		assertFalse(typeNode.removeImplementedInterface("IInterfaceB"));
	}
	
	[Test]
	public function test_implementedInterface():void
	{
		var typeNode:IClassTypeNode = unit.typeNode as IClassTypeNode;
		typeNode.addImplementedInterface("IInterfaceA");
		typeNode.addImplementedInterface("IInterfaceB");
		typeNode.addImplementedInterface("IInterfaceC");
		
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
	}
}
}