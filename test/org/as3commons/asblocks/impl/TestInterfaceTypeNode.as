package org.as3commons.asblocks.impl
{

import org.as3commons.asblocks.ASBlocksSyntaxError;
import org.as3commons.asblocks.api.AccessorRole;
import org.as3commons.asblocks.api.ICompilationUnit;
import org.as3commons.asblocks.api.IInterfaceType;
import org.as3commons.asblocks.api.IMethod;
import org.as3commons.asblocks.api.Visibility;
import org.flexunit.Assert;
import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertFalse;
import org.flexunit.asserts.assertNotNull;
import org.flexunit.asserts.assertTrue;

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
	
	[Test]
	public function test_newMethod():void
	{
		unit = project.newInterface("IA");
		assertPrint("package {\n\tpublic interface IA {\n\t}\n}", unit);
		
		var itype:IInterfaceType = unit.typeNode as IInterfaceType;
		itype.newMethod("foo", Visibility.PUBLIC, "void");
		assertPrint("package {\n\tpublic interface IA {\n\t\tfunction foo():void;\n\t}\n}", unit);
	}
	
	[Test]
	public function test_newAccessor():void
	{
		unit = project.newInterface("IA");
		assertPrint("package {\n\tpublic interface IA {\n\t}\n}", unit);
		
		var itype:IInterfaceType = unit.typeNode as IInterfaceType;
		var m:IMethod = itype.newMethod("foo", Visibility.PUBLIC, "String");
		m.accessorRole = AccessorRole.GETTER;
		
		assertPrint("package {\n\tpublic interface IA {\n\t\tfunction get foo():String;" +
			"\n\t}\n}", unit);
		
		m = itype.newMethod("foo", Visibility.PUBLIC, "void");
		m.accessorRole = AccessorRole.SETTER;
		m.addParameter("value", "String");
		
		assertPrint("package {\n\tpublic interface IA {\n\t\tfunction get foo():String;" +
			"\n\t\tfunction set foo(value:String):void;\n\t}\n}", unit);
	}
}
}