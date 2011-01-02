package org.as3commons.asblocks.impl
{

import org.as3commons.asblocks.CodeMirror;
import org.as3commons.asblocks.api.ICompilationUnit;
import org.as3commons.asblocks.api.IFunctionType;
import org.as3commons.asblocks.api.IMetaData;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.core.SourceCode;
import org.as3commons.asblocks.parser.impl.AS3FragmentParser;

public class TestFunctionTypeNode extends BaseASFactoryTest
{
	private var unit:ICompilationUnit;
	
	private var type:IFunctionType;
	
	
	[Before]
	override public function setUp():void
	{
		super.setUp();
		
		unit = null;
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
		unit = factory.newFunction("foo", "void");
		type = unit.typeNode as IFunctionType;
		
		assertPrint("package {\n\tpublic function foo():void {\n\t}\n}", type);
		
		unit = factory.newFunction("baz.bar.foo", "int");
		type = unit.typeNode as IFunctionType;
		
		assertPrint("package baz.bar {\n\tpublic function foo():int {\n\t}\n}", type);
	}
	
	[Test]
	public function testAddParametersAndStatements():void
	{
		unit = factory.newFunction("foo", "void");
		type = unit.typeNode as IFunctionType;
		type.addParameter("arg0", "String", "null");
		type.addRestParameter("rest");
		type.newReturn();
		
		assertPrint("package {\n\tpublic function foo(arg0:String = null, ...rest):" +
			"void {\n\t\treturn;\n\t}\n}", type);
	}
	
	//[Test]
	public function testAddDocCommentAndMetadata():void
	{
		unit = factory.newFunction("foo", "void");
		type = unit.typeNode as IFunctionType;
		var f:IMetaData = type.newMetaData("Foo");
		f.addParameter("true");
		f.description = "A foo metadata.";
		type.description = "A package function.";
		
		assertPrint("package {\n\t/**\n\t * A foo metadata.\n\t */\n\t[Foo(true)]\n\t" +
			"/**\n\t * A package function.\n\t */\n\tpublic function " +
			"foo():void {\n\t}\n}", type);
	}
}
}