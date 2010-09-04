package org.teotigraphix.asblocks.impl
{

import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertFalse;
import org.flexunit.asserts.assertNotNull;
import org.flexunit.asserts.assertTrue;
import org.teotigraphix.asblocks.api.ICompilationUnitNode;
import org.teotigraphix.asblocks.api.IInterfaceTypeNode;
import org.teotigraphix.asblocks.api.Visibility;

public class TestInterfaceTypeNode extends BaseASFactoryTest
{
	private var unit:ICompilationUnitNode;
	
	[Before]
	override public function setUp():void
	{
		super.setUp();
		
		unit = project.newInterface("IA");
		assertNotNull(unit);
		assertNotNull(unit.typeNode);
	}
	
	[Test]
	public function test_visibility():void
	{
		assertEquals(Visibility.PUBLIC, unit.typeNode.visibility);
	}
	
	[Test]
	public function test_name():void
	{
		var typeNode:IInterfaceTypeNode = unit.typeNode as IInterfaceTypeNode;
		assertEquals("IA", typeNode.name);
		assertPrint("package {\n\tpublic interface IA {\n\t}\n}", unit);
		typeNode.name = "ITestA";
		assertEquals("ITestA", typeNode.name);
		assertPrint("package {\n\tpublic interface ITestA {\n\t}\n}", unit);
		// test that name cannot be set to null or ""
	}
	
	[Test]
	public function test_addSuperInterface():void
	{
		// TODO block adding the same type
		assertPrint("package {\n\tpublic interface IA {\n\t}\n}", unit);
		var typeNode:IInterfaceTypeNode = unit.typeNode as IInterfaceTypeNode;
		typeNode.addSuperInterface("IInterfaceB");
		assertPrint("package {\n\tpublic interface IA extends IInterfaceB {\n\t}\n}", unit);
		typeNode.addSuperInterface("IInterfaceC");
		assertPrint("package {\n\tpublic interface IA extends IInterfaceB, IInterfaceC {\n\t}\n}", unit);
		typeNode.removeSuperInterface("IInterfaceB");
		assertPrint("package {\n\tpublic interface IA extends IInterfaceC {\n\t}\n}", unit);
		typeNode.removeSuperInterface("IInterfaceC");
		assertPrint("package {\n\tpublic interface IA {\n\t}\n}", unit);
	}
	
	[Test]
	public function test_removeSuperInterface():void
	{
		assertPrint("package {\n\tpublic interface IA {\n\t}\n}", unit);
		var typeNode:IInterfaceTypeNode = unit.typeNode as IInterfaceTypeNode;
		typeNode.addSuperInterface("IInterfaceB");
		assertPrint("package {\n\tpublic interface IA extends IInterfaceB {\n\t}\n}", unit);
		typeNode.addSuperInterface("IInterfaceC");
		assertPrint("package {\n\tpublic interface IA extends IInterfaceB, IInterfaceC {\n\t}\n}", unit);
		assertTrue(typeNode.removeSuperInterface("IInterfaceB"));
		assertPrint("package {\n\tpublic interface IA extends IInterfaceC {\n\t}\n}", unit);
		assertTrue(typeNode.removeSuperInterface("IInterfaceC"));
		assertPrint("package {\n\tpublic interface IA {\n\t}\n}", unit);
		assertFalse(typeNode.removeSuperInterface("IInterfaceC"));
		assertPrint("package {\n\tpublic interface IA {\n\t}\n}", unit);
	}
}
}