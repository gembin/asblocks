package org.as3commons.asblocks.impl
{

import org.flexunit.asserts.assertEquals;
import org.as3commons.asblocks.CodeMirror;
import org.as3commons.asblocks.api.IClassType;
import org.as3commons.asblocks.api.ICompilationUnit;
import org.as3commons.asblocks.api.IMethod;
import org.as3commons.asblocks.api.Visibility;

public class TestMethodNode extends BaseASFactoryTest
{
	private var unit:ICompilationUnit;
	
	private var method:IMethod;
	
	[Before]
	override public function setUp():void
	{
		super.setUp();
		
		unit = project.newClass("ClassA");
		var clazz:IClassType = unit.typeNode as IClassType;
		method = clazz.newMethod("test", Visibility.PUBLIC, "Bar");
	}
	
	[After]
	override public function tearDown():void
	{
		CodeMirror.assertReflection(factory, unit);
	}
	
	[Test]
	public function test_name():void
	{
		assertEquals("test", method.name);
		method.name = "foobar";
		assertEquals("foobar", method.name);
	}
	
	[Test]
	public function test_arguments():void
	{
	}
	
	[Test]
	public function test_returnType():void
	{
	}
	
	[Test]
	public function test_addParameter():void
	{
	}
	
	[Test]
	public function test_addRestParameter():void
	{
	}
}
}