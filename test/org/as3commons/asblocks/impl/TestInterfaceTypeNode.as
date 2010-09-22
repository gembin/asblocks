package org.as3commons.asblocks.impl
{

import org.flexunit.Assert;
import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertFalse;
import org.flexunit.asserts.assertNotNull;
import org.flexunit.asserts.assertTrue;
import org.as3commons.asblocks.ASBlocksSyntaxError;
import org.as3commons.asblocks.api.ICompilationUnit;
import org.as3commons.asblocks.api.IInterfaceType;
import org.as3commons.asblocks.api.Visibility;

public class TestInterfaceTypeNode extends BaseASFactoryTest
{
	private var unit:ICompilationUnit;
	
	[Before]
	override public function setUp():void
	{
		super.setUp();
		
		unit = project.newInterface("IA");
		assertNotNull(unit);
		assertNotNull(unit.typeNode);
	}
	
	[Test]
	public function test_addSuperInterface():void
	{
		// TODO block adding the same type
		assertPrint("package {\n\tpublic interface IA {\n\t}\n}", unit);
		var typeNode:IInterfaceType = unit.typeNode as IInterfaceType;
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
	public function test_addSuperInterfaceDuplicate():void
	{
		// TODO block adding the same type
		assertPrint("package {\n\tpublic interface IA {\n\t}\n}", unit);
		var typeNode:IInterfaceType = unit.typeNode as IInterfaceType;
		typeNode.addSuperInterface("IInterfaceB");
		typeNode.addSuperInterface("IInterfaceB");
		assertPrint("package {\n\tpublic interface IA extends IInterfaceB {\n\t}\n}", unit);
		//try
		//{
		//	typeNode.addSuperInterface("IInterfaceB");
		//	Assert.fail("duplicate super interface");
		//}
		//catch (e:ASBlocksSyntaxError) {}
	}
	
	[Test]
	public function test_removeSuperInterface():void
	{
		assertPrint("package {\n\tpublic interface IA {\n\t}\n}", unit);
		var typeNode:IInterfaceType = unit.typeNode as IInterfaceType;
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