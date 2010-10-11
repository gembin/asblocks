package org.as3commons.asblocks.impl
{

import org.as3commons.asblocks.CodeMirror;
import org.as3commons.asblocks.api.IExpression;
import org.as3commons.asblocks.api.INewExpression;
import org.as3commons.asblocks.api.INumberLiteral;
import org.as3commons.asblocks.api.ISimpleNameExpression;
import org.as3commons.asblocks.api.IVectorExpression;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.core.SourceCode;
import org.as3commons.asblocks.parser.impl.AS3FragmentParser;
import org.flexunit.Assert;

public class TestNewExpressionNode extends BaseASFactoryTest
{
	private var statement:INewExpression;
	
	[Before]
	override public function setUp():void
	{
		super.setUp();
		
		statement = null;
	}
	
	[After]
	override public function tearDown():void
	{
		if (statement)
		{
			var sourceCode:SourceCode = new SourceCode();
			var ast:IParserNode = statement.node;
			new ASTPrinter(sourceCode).print(ast);
			var parsed:IParserNode = AS3FragmentParser.parseExpression(sourceCode.code);
			CodeMirror.assertASTMatch(ast, parsed);
		}
	}
	
	[Test]
	public function testBasic():void
	{
		statement = factory.newNewExpression(factory.newExpression("Error"));
		assertPrint("new Error()", statement);
		Assert.assertEquals("Error", ISimpleNameExpression(statement.target).name);
		Assert.assertEquals(0, statement.arguments.length);
		
		var arguments:Vector.<IExpression> = new Vector.<IExpression>();
		arguments.push(factory.newExpression("true"));
		arguments.push(factory.newStringLiteral("Foo bar"));
		statement = factory.newNewExpression(factory.newExpression("Error"), arguments);
		assertPrint("new Error(true, \"Foo bar\")", statement);
		
		arguments = new Vector.<IExpression>();
		arguments.push(factory.newStringLiteral("Baz goo"));
		arguments.push(factory.newExpression("false"));
		
		statement.arguments = arguments;
		assertPrint("new Error(\"Baz goo\", false)", statement);
	}
	
	[Test]
	public function testBasicVector():void
	{
		statement = factory.newNewExpression(factory.newVectorExpression("String"));
		assertPrint("new Vector.<String>()", statement);
		var type:ISimpleNameExpression = IVectorExpression(statement.target).type as ISimpleNameExpression;
		Assert.assertEquals("String", type.name);
		Assert.assertEquals(0, statement.arguments.length);
		statement = factory.newNewExpression(factory.newVectorExpression("Vector.<int>"));
		assertPrint("new Vector.<Vector.<int>>()", statement);
		Assert.assertEquals(0, statement.arguments.length);
		
		var arguments:Vector.<IExpression> = new Vector.<IExpression>();
		arguments.push(factory.newExpression("255"));
		arguments.push(factory.newExpression("true"));
		statement = factory.newNewExpression(factory.newVectorExpression("int"), arguments);
		
		assertPrint("new Vector.<int>(255, true)", statement);
	}
	
	[Test]
	public function testNoArguments():void
	{
		statement = factory.newNewExpression(factory.newExpression("Foo"));
		assertPrint("new Foo()", statement);
		statement.arguments = null;
		assertPrint("new Foo", statement);
		var arguments:Vector.<IExpression> = new Vector.<IExpression>();
		arguments.push(factory.newExpression("bar"));
		statement.arguments = arguments;
		assertPrint("new Foo(bar)", statement);
	}
	
	[Test]
	public function testParse():void
	{
		statement = factory.newExpression("new Foo(bar)") as INewExpression;
		Assert.assertEquals("Foo", ISimpleNameExpression(statement.target).name);
		Assert.assertEquals(1, statement.arguments.length);
		Assert.assertEquals("bar", ISimpleNameExpression(statement.arguments[0]).name);
	}
	
	[Test]
	public function testParseVector():void
	{
		statement = factory.newExpression("new Vector.<Foo>(255, bar)") as INewExpression;
		var vector:IVectorExpression = IVectorExpression(statement.target);
		
		Assert.assertEquals("Foo", ISimpleNameExpression(vector.type).name);
		Assert.assertEquals(2, statement.arguments.length);
		Assert.assertEquals(255, INumberLiteral(statement.arguments[0]).value);
		Assert.assertEquals("bar", ISimpleNameExpression(statement.arguments[1]).name);
	}
}
}