package org.as3commons.asblocks.impl
{

import org.flexunit.Assert;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.core.SourceCode;
import org.as3commons.asblocks.parser.impl.AS3FragmentParser;
import org.as3commons.asblocks.ASBlocksSyntaxError;
import org.as3commons.asblocks.CodeMirror;
import org.as3commons.asblocks.api.IExpression;
import org.as3commons.asblocks.api.IFieldAccessExpression;
import org.as3commons.asblocks.api.IINvocationExpression;
import org.as3commons.asblocks.api.ISimpleNameExpression;

public class TestFieldAccessExpressionNode extends BaseASFactoryTest
{
	private var expression:IFieldAccessExpression;
	
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
		var target:IExpression = factory.newExpression("method()");
		var name:String = "field";
		expression = factory.newFieldAccessExpression(target, name);
		assertPrint("method().field", expression);
	}
	
	[Test]
	public function testParse():void
	{
		expression = factory.newExpression("method().field") as IFieldAccessExpression;
		assertPrint("method().field", expression);
	}
	
	[Test]
	public function test_name():void
	{
		expression = factory.newExpression("foo.bar") as IFieldAccessExpression;
		Assert.assertEquals("bar", expression.name);
		assertPrint("foo.bar", expression);
		expression.name = "baz";
		Assert.assertEquals("baz", expression.name);
		assertPrint("foo.baz", expression);
		try
		{
			expression.name = "";
			Assert.fail("cannot set name to empty string");
		}
		catch (e:ASBlocksSyntaxError) {}
		try
		{
			expression.name = null;
			Assert.fail("cannot set name to null");
		}
		catch (e:ASBlocksSyntaxError) {}
	}
	
	[Test]
	public function test_target():void
	{
		expression = factory.newExpression("foo.bar") as IFieldAccessExpression;
		Assert.assertEquals("foo", ISimpleNameExpression(expression.target).name);
		var target:IExpression = factory.newExpression("baz()");
		expression.target = target;
		Assert.assertTrue(target is IINvocationExpression);
		assertPrint("baz().bar", expression);
	}
}
}