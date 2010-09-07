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
	public function testAdd():void
	{
		expression = factory.newAddExpression(left, right);
		assertOp(BinaryOperator.ADD);
	}
	
	[Test]
	public function testAnd():void
	{
		expression = factory.newAndExpression(left, right);
		assertOp(BinaryOperator.AND);
	}
	
	[Test]
	public function testBitAnd():void
	{
		expression = factory.newBitAndExpression(left, right);
		assertOp(BinaryOperator.BITAND);
	}
	
	[Test]
	public function testBitOr():void
	{
		expression = factory.newBitOrExpression(left, right);
		assertOp(BinaryOperator.BITOR);
	}
	
	[Test]
	public function testBitXor():void
	{
		expression = factory.newBitXorExpression(left, right);
		assertOp(BinaryOperator.BITXOR);
	}
	
	[Test]
	public function testDivision():void
	{
		expression = factory.newDivisionExpression(left, right);
		assertOp(BinaryOperator.DIV);
	}
	
	[Test]
	public function testEquals():void
	{
		//expression = factory.newEqualsExpression(left, right);
		//assertOp(BinaryOperator.EQ);
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
	public function _testLogicalAnd():void
	{
		//expression = factory.newExpression("a && b && c") as IBinaryExpression;
		//var left:IExpression = factory.newExpression("foo");
		//expression.leftExpression = left;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	[Test]
	public function _testBitOr():void
	{
		//expression = factory.newExpression("a | b | c") as IBinaryExpression;
		//var left:IExpression = factory.newExpression("foo");
		//expression.leftExpression = left;
	}
	
	[Test]
	public function _testXor():void
	{
		//expression = factory.newExpression("a ^ b ^ c") as IBinaryExpression;
		//var left:IExpression = factory.newExpression("foo");
		//expression.leftExpression = left;
	}
	
	[Test]
	public function _testBitAnd():void
	{
		//expression = factory.newExpression("a & b & c") as IBinaryExpression;
		//var left:IExpression = factory.newExpression("foo");
		//expression.leftExpression = left;
	}
	
	[Test]
	public function _testEquality():void
	{
		//expression = factory.newExpression("a == b == c") as IBinaryExpression;
		//var left:IExpression = factory.newExpression("foo");
		//expression.leftExpression = left;
	}
	
	[Test]
	public function _testRelational():void
	{
		//expression = factory.newExpression("a < b < c") as IBinaryExpression;
		//var left:IExpression = factory.newExpression("foo");
		//expression.leftExpression = left;
	}
	
	[Test]
	public function _testShift():void
	{
		//expression = factory.newExpression("a << b << c") as IBinaryExpression;
		//var left:IExpression = factory.newExpression("foo");
		//expression.leftExpression = left;
	}
	
	[Test]
	public function _testAdditivePlus():void
	{
		//expression = factory.newExpression("a + b + c") as IBinaryExpression;
		//assertEquals(BinaryOperator.ADD, expression.operator.name);
		//var left:IExpression = factory.newExpression("foo");
		//expression.leftExpression = left;
	}
	
	[Test]
	public function _testAdditiveMinus():void
	{
		//expression = factory.newExpression("a - b - c") as IBinaryExpression;
		//var left:IExpression = factory.newExpression("foo");
		//expression.leftExpression = left;
	}
	
	[Test]
	public function _testMultiplicative():void
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