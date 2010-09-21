package org.teotigraphix.asblocks.impl
{

import org.flexunit.Assert;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.core.SourceCode;
import org.teotigraphix.as3parser.impl.AS3FragmentParser;
import org.teotigraphix.asblocks.CodeMirror;
import org.teotigraphix.asblocks.api.IBinaryExpression;
import org.teotigraphix.asblocks.api.IConditionalExpression;
import org.teotigraphix.asblocks.api.IExpression;
import org.teotigraphix.asblocks.api.IINvocationExpression;

public class TestConditionalExpressionNode extends BaseASFactoryTest
{
	private var expression:IConditionalExpression;
	
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
		var condition:IExpression = factory.newExpression("foo");
		var thenExp:IExpression = factory.newExpression("bar");
		var elseExp:IExpression = factory.newExpression("baz");
		expression = factory.newConditionalExpression(condition, thenExp, elseExp);
		assertPrint("foo ? bar : baz", expression);
	}
	
	[Test]
	public function testParse():void
	{
		expression = factory.newExpression("foo ? bar : baz") as IConditionalExpression;
		Assert.assertNotNull(expression);
		assertPrint("foo ? bar : baz", expression);
	}
	
	[Test]
	public function testBasicEncapsulation():void
	{
		var condition:IExpression = factory.newExpression("foo > 42");
		var thenExp:IExpression = factory.newExpression("bar");
		var elseExp:IExpression = factory.newExpression("baz");
		expression = factory.newConditionalExpression(condition, thenExp, elseExp);
		assertPrint("foo > 42 ? bar : baz", expression);
	}
	
	[Test]
	public function testParseEncapsulation():void
	{
		expression = factory.newExpression("(foo > 42) ? bar : baz") as IConditionalExpression;
		Assert.assertNotNull(expression);
		assertPrint("(foo > 42) ? bar : baz", expression);
	}
	
	[Test]
	public function test_condition():void
	{
		var condition:IExpression = factory.newExpression("foo");
		var thenExp:IExpression = factory.newExpression("bar");
		var elseExp:IExpression = factory.newExpression("baz");
		expression = factory.newConditionalExpression(condition, thenExp, elseExp);
		assertPrint("foo ? bar : baz", expression);
		
		expression.condition = factory.newExpression("foo < 42");
		Assert.assertTrue(expression.condition is IBinaryExpression);
		assertPrint("foo < 42 ? bar : baz", expression);
	}
	
	[Test]
	public function test_thenExpression():void
	{
		var condition:IExpression = factory.newExpression("foo");
		var thenExp:IExpression = factory.newExpression("bar");
		var elseExp:IExpression = factory.newExpression("baz");
		expression = factory.newConditionalExpression(condition, thenExp, elseExp);
		assertPrint("foo ? bar : baz", expression);
		
		expression.thenExpression = factory.newExpression("foBar()");
		Assert.assertTrue(expression.thenExpression is IINvocationExpression);
		assertPrint("foo ? foBar() : baz", expression);
	}
	
	[Test]
	public function test_elseExpression():void
	{
		var condition:IExpression = factory.newExpression("foo");
		var thenExp:IExpression = factory.newExpression("bar");
		var elseExp:IExpression = factory.newExpression("baz");
		expression = factory.newConditionalExpression(condition, thenExp, elseExp);
		assertPrint("foo ? bar : baz", expression);
		
		expression.elseExpression = factory.newExpression("foBaz()");
		Assert.assertTrue(expression.elseExpression is IINvocationExpression);
		assertPrint("foo ? bar : foBaz()", expression);
	}
}
}