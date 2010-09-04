package org.teotigraphix.asblocks.impl
{

import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertFalse;
import org.flexunit.asserts.assertNotNull;
import org.flexunit.asserts.assertNull;
import org.flexunit.asserts.assertTrue;
import org.teotigraphix.asblocks.api.IClassTypeNode;
import org.teotigraphix.asblocks.api.ICompilationUnitNode;
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
	public function test_newMethod():void
	{
		var typeNode:IClassTypeNode = unit.typeNode as IClassTypeNode;
		var method:IMethodNode = typeNode.newMethod("methodOne", Visibility.PUBLIC, "String");
		assertPrint("package {\n\tpublic class A {\n\t\tpublic function methodOne()" +
			":String {\n\t\t}\n\t}\n}", unit);
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
		assertEquals(Visibility.PUBLIC, unit.typeNode.visibility);
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