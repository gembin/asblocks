package org.teotigraphix.asblocks.impl
{

import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertTrue;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.core.SourceCode;
import org.teotigraphix.as3parser.impl.AS3FragmentParser;
import org.teotigraphix.asblocks.ASFactory;
import org.teotigraphix.asblocks.CodeMirror;
import org.teotigraphix.asblocks.api.BinaryOperator;
import org.teotigraphix.asblocks.api.IBinaryExpression;
import org.teotigraphix.asblocks.api.IExpression;
import org.teotigraphix.asblocks.utils.ASTUtil;

public class TestBinaryExpression
{
	private var factory:ASFactory = new ASFactory();
	
	private var expression:IBinaryExpression;
	
	private var left:IExpression;
	
	private var right:IExpression;
	
	[Before]
	public function setUp():void
	{
		left = factory.newNumberLiteral(1);
		right = factory.newNumberLiteral(2);
		expression = null;
	}
	
	[After]
	public function tearDown():void
	{
		/*
		if (expression)
		{
			var sourceCode:SourceCode = new SourceCode();
			var ast:IParserNode = expression.node;
			new ASTPrinter(sourceCode).print(ast);
			var parsed:IParserNode = AS3FragmentParser.parseExpression(sourceCode.code);
			CodeMirror.assertASTMatch(ast, parsed);
		}
		*/
		if (expression)
		{
			assertEquals(left.node, expression.leftExpression.node);
			assertEquals(right.node, expression.rightExpression.node);
		}
	}
	
	[Test]
	public function testLogicalAdd():void
	{
		expression = factory.newAddExpression(left, right);
		assertOp(BinaryOperator.ADD);
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	[Test]
	public function _testLogicalOr():void
	{
		//expression = factory.newExpression("a || b || c") as IBinaryExpression;
		//assertTrue(expression.operator.equals(BinaryOperator.AND));
		//var left:IExpression = factory.newExpression("foo");
		//expression.leftExpression = left;
	}
	
	[Test]
	public function testLogicalAnd():void
	{
		//expression = factory.newExpression("a && b && c") as IBinaryExpression;
		//var left:IExpression = factory.newExpression("foo");
		//expression.leftExpression = left;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	[Test]
	public function testBitOr():void
	{
		//expression = factory.newExpression("a | b | c") as IBinaryExpression;
		//var left:IExpression = factory.newExpression("foo");
		//expression.leftExpression = left;
	}
	
	[Test]
	public function testXor():void
	{
		//expression = factory.newExpression("a ^ b ^ c") as IBinaryExpression;
		//var left:IExpression = factory.newExpression("foo");
		//expression.leftExpression = left;
	}
	
	[Test]
	public function testBitAnd():void
	{
		//expression = factory.newExpression("a & b & c") as IBinaryExpression;
		//var left:IExpression = factory.newExpression("foo");
		//expression.leftExpression = left;
	}
	
	[Test]
	public function testEquality():void
	{
		//expression = factory.newExpression("a == b == c") as IBinaryExpression;
		//var left:IExpression = factory.newExpression("foo");
		//expression.leftExpression = left;
	}
	
	[Test]
	public function testRelational():void
	{
		//expression = factory.newExpression("a < b < c") as IBinaryExpression;
		//var left:IExpression = factory.newExpression("foo");
		//expression.leftExpression = left;
	}
	
	[Test]
	public function testShift():void
	{
		//expression = factory.newExpression("a << b << c") as IBinaryExpression;
		//var left:IExpression = factory.newExpression("foo");
		//expression.leftExpression = left;
	}
	
	[Test]
	public function testAdditivePlus():void
	{
		//expression = factory.newExpression("a + b + c") as IBinaryExpression;
		//assertEquals(BinaryOperator.ADD, expression.operator.name);
		//var left:IExpression = factory.newExpression("foo");
		//expression.leftExpression = left;
	}
	
	[Test]
	public function testAdditiveMinus():void
	{
		//expression = factory.newExpression("a - b - c") as IBinaryExpression;
		//var left:IExpression = factory.newExpression("foo");
		//expression.leftExpression = left;
	}
	
	[Test]
	public function testMultiplicative():void
	{
		//expression = factory.newExpression("a * b * c") as IBinaryExpression;
		//var left:IExpression = factory.newExpression("foo");
		//expression.leftExpression = left;
	}
	
	private function assertOp(expected:BinaryOperator):void
	{
		var ast:IParserNode = expression.node;
		var expr:IExpression = factory.newExpression(ASTUtil.stringifyNode(ast));
		assertEquals(expected, IBinaryExpression(expr).operator);
	}
}
}