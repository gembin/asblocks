package org.as3commons.asblocks.impl
{

import org.as3commons.asblocks.CodeMirror;
import org.as3commons.asblocks.api.IClassType;
import org.as3commons.asblocks.api.ICompilationUnit;
import org.as3commons.asblocks.api.IMetaData;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.core.SourceCode;
import org.as3commons.asblocks.parser.impl.AS3FragmentParser;
import org.flexunit.Assert;

public class TestMetaDataNode extends BaseASFactoryTest
{
	private var unit:ICompilationUnit;
	
	private var type:IClassType;
	
	private var metadata:IMetaData;
	
	[Before]
	override public function setUp():void
	{
		super.setUp();
		
		unit = null;
		metadata = null;
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
	public function testBasic():void
	{
		unit = factory.newClass("A");
		type = unit.typeNode as IClassType;
		metadata = type.newMetaData("Foo");
		Assert.assertEquals("Foo", metadata.name);
		metadata.addParameter("false");
		metadata.addNamedParameter("bar", "true");
		metadata.addNamedStringParameter("baz", "string");
		
		assertPrint("package {\n\t[Foo(false, bar=true, baz=\"string\")]\n\t" +
			"public class A {\n\t}\n}", unit);
	}
	
	[Test]
	public function test_parameters():void
	{
		unit = factory.newClass("A");
		type = unit.typeNode as IClassType;
		metadata = type.newMetaData("Foo");
		Assert.assertEquals("Foo", metadata.name);
		metadata.addParameter("false");
		metadata.addNamedParameter("bar", "true");
		metadata.addNamedStringParameter("baz", "string");
		
		Assert.assertEquals(3, metadata.parameters.length);
		Assert.assertEquals("(false, bar=true, baz=\"string\")", metadata.parameter);
		
		Assert.assertFalse(metadata.hasParameter("false"));
		Assert.assertTrue(metadata.hasParameter("bar"));
		Assert.assertTrue(metadata.hasParameter("baz"));
		
		Assert.assertEquals("false", metadata.getParameterAt(0).value);
		Assert.assertEquals("true", metadata.getParameter("bar").value);
		Assert.assertEquals("\"string\"", metadata.getParameter("baz").value);
		
		assertPrint("package {\n\t[Foo(false, bar=true, baz=\"string\")]\n\t" +
			"public class A {\n\t}\n}", unit);
	}
	
	[Test]
	public function test_removeParameters():void
	{
		unit = factory.newClass("A");
		type = unit.typeNode as IClassType;
		metadata = type.newMetaData("Foo");
		Assert.assertEquals("Foo", metadata.name);
		metadata.addParameter("false");
		metadata.addNamedParameter("bar", "true");
		metadata.addNamedStringParameter("baz", "string");
		
		Assert.assertEquals(3, metadata.parameters.length);
		Assert.assertNotNull(metadata.removeParameter("bar"));
		// FIXME (mschmalle) removal of meta parameter comma and whitespace
		//assertPrint("package {\n\t[Foo(false, baz=\"string\")]\n\t" +
		//	"public class A {\n\t}\n}", unit);
		Assert.assertEquals(2, metadata.parameters.length);
		Assert.assertEquals("false", metadata.parameters[0].value);
		Assert.assertEquals("\"string\"", metadata.parameters[1].value);
		Assert.assertNotNull(metadata.removeParameterAt(0));
		Assert.assertEquals(1, metadata.parameters.length);
		Assert.assertEquals("\"string\"", metadata.parameters[0].value);
		Assert.assertNotNull(metadata.removeParameter("baz"));
		Assert.assertEquals(0, metadata.parameters.length);
	}
}
}