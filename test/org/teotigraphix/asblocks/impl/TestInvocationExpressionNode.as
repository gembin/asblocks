package org.teotigraphix.asblocks.impl
{

import org.flexunit.Assert;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.core.SourceCode;
import org.teotigraphix.as3parser.impl.AS3FragmentParser;
import org.teotigraphix.asblocks.CodeMirror;
import org.teotigraphix.asblocks.api.IArgument;
import org.teotigraphix.asblocks.api.IExpression;
import org.teotigraphix.asblocks.api.IFieldAccessExpression;
import org.teotigraphix.asblocks.api.IINvocationExpression;

public class TestInvocationExpressionNode extends BaseASFactoryTest
{
	private var expression:IINvocationExpression;
	
	[Before]
	override public function setUp():void
	{
		super.setUp();
		
		expression = null;
	}
	
	[After]
	override public function tearDown():void
	{
		if (expression)
		{
			var sourceCode:SourceCode = new SourceCode();
			var ast:IParserNode = expression.node;
			new ASTPrinter(sourceCode).print(ast);
			var parsed:IParserNode = AS3FragmentParser.parseExpression(sourceCode.code);
			CodeMirror.assertASTMatch(ast, parsed);
		}
	}
	
	[Test]
	public function testBasic():void
	{
		var target:IExpression = factory.newExpression("foo");
		var arguments:Vector.<IExpression> = new Vector.<IExpression>();
		arguments.push(factory.newExpression("bar"));
		arguments.push(factory.newExpression("\"baz\""));
		expression = factory.newInvocationExpression(target, arguments);
		assertPrint("foo(bar, \"baz\")", expression);
	}
	
	[Test]
	public function testParse():void
	{
		expression = factory.newExpression("foo(bar, \"baz\")") as IINvocationExpression;
		Assert.assertNotNull(expression);
		assertPrint("foo(bar, \"baz\")", expression);
	}
	
	[Test]
	public function test_target():void
	{
		var target:IExpression = factory.newExpression("foo");
		expression = factory.newInvocationExpression(target, null);
		assertPrint("foo()", expression);
		target = factory.newExpression("bar");
		expression.target = target;
		assertPrint("bar()", expression);
	}
	
	[Test]
	public function test_arguments():void
	{
		var target:IExpression = factory.newExpression("foo");
		expression = factory.newInvocationExpression(target, null);
		assertPrint("foo()", expression);
		var arguments:Vector.<IExpression> = new Vector.<IExpression>();
		arguments.push(factory.newExpression("bar"));
		arguments.push(factory.newExpression("\"baz\""));
		expression.arguments = arguments;
		assertPrint("foo(bar, \"baz\")", expression);
	}
}
}