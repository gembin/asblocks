package org.teotigraphix.asblocks.impl
{

import org.flexunit.Assert;
import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertFalse;
import org.flexunit.asserts.assertNotNull;
import org.flexunit.asserts.assertNull;
import org.flexunit.asserts.assertTrue;
import org.teotigraphix.asblocks.ASBlocksSyntaxError;
import org.teotigraphix.asblocks.CodeMirror;
import org.teotigraphix.asblocks.api.IClassType;
import org.teotigraphix.asblocks.api.ICompilationUnit;
import org.teotigraphix.asblocks.api.IField;
import org.teotigraphix.asblocks.api.IInterfaceType;
import org.teotigraphix.asblocks.api.INumberLiteral;
import org.teotigraphix.asblocks.api.IStringLiteral;
import org.teotigraphix.asblocks.api.Visibility;

public class TestFieldNode extends BaseASFactoryTest
{
	private var unit:ICompilationUnit;
	
	private var field:IField;
	
	[Before]
	override public function setUp():void
	{
		super.setUp();
		
		unit = project.newClass("ClassA");
		var clazz:IClassType = unit.typeNode as IClassType;
		field = clazz.newField("test", Visibility.PUBLIC, "Bar");
	}
	
	[After]
	override public function tearDown():void
	{
		CodeMirror.assertReflection(factory, unit);
	}
	
	[Test]
	public function testName():void
	{
		assertEquals("test", field.name);
		field.name = "foobar";
		assertEquals("foobar", field.name);
		try
		{
			field.name = "foo.bar";
			Assert.fail("should not have accepted field name containing '.'");
		}
		catch (e:ASBlocksSyntaxError)
		{
			// expected
		}
	}
	
	[Test]
	public function test_isStatic():void
	{
		assertFalse("new fields should be non-static by default", field.isStatic);
		field.isStatic = false;
		assertFalse("seting non-static when already non-static should be ok", field.isStatic);
		field.isStatic = true;
		assertTrue("changing to static failed", field.isStatic);
		field.isStatic = true;
		assertTrue("static static when already static didn't work", field.isStatic);
		field.isStatic = false;
		assertFalse("removing static again didn't work", field.isStatic);
	}
	
	[Test]
	public function test_init():void
	{
		assertNull(field.initializer);
		
		field.initializer = factory.newStringLiteral("foo");
		assertTrue(field.initializer is IStringLiteral);
		
		field.initializer = factory.newNumberLiteral(1);
		assertTrue(field.initializer is INumberLiteral);
		
		field.initializer = null;
		assertNull(field.initializer);
		
		field.initializer = factory.newExpression("function() { trace('test'); }");
		CodeMirror.assertReflection(factory, unit);
	}
	
	[Test]
	public function test_isConst():void
	{
		assertFalse(field.isConstant);
		field.isConstant = true;
		assertTrue(field.isConstant);
		field.isConstant = false;
		assertFalse(field.isConstant);
		
		// set it to the value it already has,
		field.isConstant = false;
		assertFalse(field.isConstant);
	}
}
}