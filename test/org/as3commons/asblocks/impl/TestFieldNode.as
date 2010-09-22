package org.as3commons.asblocks.impl
{

import org.flexunit.Assert;
import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertFalse;
import org.flexunit.asserts.assertNotNull;
import org.flexunit.asserts.assertNull;
import org.flexunit.asserts.assertTrue;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.core.SourceCode;
import org.as3commons.asblocks.parser.impl.AS3FragmentParser;
import org.as3commons.asblocks.ASBlocksSyntaxError;
import org.as3commons.asblocks.CodeMirror;
import org.as3commons.asblocks.api.IClassType;
import org.as3commons.asblocks.api.ICompilationUnit;
import org.as3commons.asblocks.api.IField;
import org.as3commons.asblocks.api.IInterfaceType;
import org.as3commons.asblocks.api.INumberLiteral;
import org.as3commons.asblocks.api.IStringLiteral;
import org.as3commons.asblocks.api.Visibility;

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
	public function test_initializer():void
	{
		assertNull(field.initializer);
		
		field.initializer = factory.newStringLiteral("foo");
		assertTrue(field.initializer is IStringLiteral);
		assertPrint("package {\n\tpublic class ClassA {\n\t\tpublic var " +
			"test:Bar = \"foo\";\n\t}\n}", unit);
		
		field.initializer = factory.newNumberLiteral(1);
		assertTrue(field.initializer is INumberLiteral);
		assertPrint("package {\n\tpublic class ClassA {\n\t\tpublic var " +
			"test:Bar = 1;\n\t}\n}", unit);
		
		field.initializer = null;
		assertNull(field.initializer);
		assertPrint("package {\n\tpublic class ClassA {\n\t\tpublic var " +
			"test:Bar;\n\t}\n}", unit);
		
		field.initializer = factory.newExpression("function() { trace('test'); }");
		
		assertPrint("package {\n\tpublic class ClassA {\n\t\tpublic var test:Bar = " +
			"function() { trace('test'); };\n\t}\n}", unit);
	}
	
	[Test]
	public function test_isConstant():void
	{
		assertFalse(field.isConstant);
		field.isConstant = true;
		assertPrint("package {\n\tpublic class ClassA {\n\t\tpublic const " +
			"test:Bar;\n\t}\n}", unit);
		assertTrue(field.isConstant);
		field.isConstant = false;
		assertFalse(field.isConstant);
		assertPrint("package {\n\tpublic class ClassA {\n\t\tpublic var " +
			"test:Bar;\n\t}\n}", unit);
		
		// set it to the value it already has,
		field.isConstant = false;
		assertFalse(field.isConstant);
	}
}
}