package org.teotigraphix.as3blocks.impl
{

import org.flexunit.Assert;
import org.teotigraphix.as3blocks.api.IArrayLiteralNode;
import org.teotigraphix.as3blocks.api.IAssignmentExpressionNode;
import org.teotigraphix.as3blocks.api.IBooleanLiteralNode;
import org.teotigraphix.as3blocks.api.IExpressionNode;
import org.teotigraphix.as3blocks.api.IFunctionLiteralNode;
import org.teotigraphix.as3blocks.api.INullLiteralNode;
import org.teotigraphix.as3blocks.api.INumberLiteralNode;
import org.teotigraphix.as3blocks.api.IObjectLiteralNode;
import org.teotigraphix.as3blocks.api.IPropertyFieldNode;
import org.teotigraphix.as3blocks.api.IStringLiteralNode;
import org.teotigraphix.as3blocks.api.IUndefinedLiteralNode;
import org.teotigraphix.as3nodes.impl.AS3Factory2;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.core.ASTPrinter;
import org.teotigraphix.as3parser.core.SourceCode;

public class TestLiteralNodes
{
	private var printer:ASTPrinter;
	
	private var factory:AS3Factory2;
	
	[Before]
	public function setUp():void
	{
		printer = new ASTPrinter(new SourceCode());
		factory = new AS3Factory2();
	}
	
	[Test]
	public function testArrayLiteralNode():void
	{
		var expression:IArrayLiteralNode = factory.newArrayLiteral();
		
		expression.add(factory.newSimpleNameExpression("a"));
		expression.add(factory.newSimpleNameExpression("b"));
		expression.add(factory.newSimpleNameExpression("c"));
		
		assertPrintExpression("[a, b, c]", expression);
		
		expression.remove(2);
		
		var expression2:IArrayLiteralNode = factory.newArrayLiteral();
		
		expression2.add(factory.newNullLiteral());
		expression2.add(factory.newSimpleNameExpression("foo"));
		expression2.add(factory.newStringLiteral("Hello World"));
		expression2.add(factory.newBooleanLiteral(true));
		
		expression.add(factory.newArrayAccessExpression(
			factory.newSimpleNameExpression("abc"),
			factory.newNumberLiteral(0)));
		
		expression.add(expression2);
		
		assertPrintExpression("[a, b, abc[0], [null, foo, \"Hello World\", true]]", expression);
	}
	
	[Test]
	public function testBooleanLiteralNode():void
	{
		var trueExpression:IBooleanLiteralNode = factory.newBooleanLiteral(true);
		var falseExpression:IBooleanLiteralNode = factory.newBooleanLiteral(false);
		
		Assert.assertTrue(trueExpression.node.isKind(AS3NodeKind.TRUE));
		assertPrintExpression("true", trueExpression);
		
		Assert.assertTrue(falseExpression.node.isKind(AS3NodeKind.FALSE));
		assertPrintExpression("false", falseExpression);
		
		// change the value
		trueExpression.value = false;
		Assert.assertTrue(trueExpression.node.isKind(AS3NodeKind.FALSE));
		assertPrintExpression("false", trueExpression);
	}
	
	[Test]
	public function testFunctionLiteralNode():void
	{
		var expression:IFunctionLiteralNode = factory.newFunctionLiteral();
		
		expression.type = "my.domain.Type";
		expression.addParameter("arg0", "String");
		expression.addParameter("arg1", "int", "0");
		
		expression.newExpressionStatement("trace('Hello World')");
		
		assertPrintExpression("function(arg0:String, arg1:int = 0):my.domain.Type " +
			"{\n\ttrace('Hello World');\n}", expression);
		
		var left:IExpressionNode = factory.newExpression("myObject");
		var right:IExpressionNode = factory.newExpression("{a:1,b:2c:3}");
		
		//var arrexpression:IAssignmentExpressionNode = 
		//	factory.newAssignmentExpression(left, right);
		//
		//expression.addStatement("myObject = {a:1,b:2,c:3}");
		//
		//assertPrintExpression("function(arg0:String, arg1:int = 0):my.domain.Type " +
		//	"{\n\ttrace('Hello World');\n\tmyObject = {a:1,b:2,c:3};\n}", expression);
	}
	
	[Test]
	public function testNumberLiteralNode():void
	{
		var expression:INumberLiteralNode = factory.newNumberLiteral(42);
		
		Assert.assertEquals(42, expression.value);
		Assert.assertTrue(expression.node.isKind(AS3NodeKind.NUMBER));
		assertPrintExpression("42", expression);
	}
	
	[Test]
	public function testNullLiteralNode():void
	{
		var expression:INullLiteralNode = factory.newNullLiteral();
		
		Assert.assertTrue(expression.node.isKind(AS3NodeKind.NULL));
		assertPrintExpression("null", expression);
	}
	
	[Test]
	public function testObjectLiteralNode():void
	{
		var expression:IObjectLiteralNode = factory.newObjectLiteral();
		
		expression.newField("a", factory.newNumberLiteral(0));
		expression.newField("b", factory.newNumberLiteral(1));
		expression.newField("c", factory.newNumberLiteral(2));
		
		var fields:Vector.<IPropertyFieldNode> = expression.fields;
		Assert.assertNotNull(fields);
		Assert.assertEquals(3, fields.length);
		
		Assert.assertEquals(0, INumberLiteralNode(fields[0].value).value);
		Assert.assertEquals(1, INumberLiteralNode(fields[1].value).value);
		Assert.assertEquals(2, INumberLiteralNode(fields[2].value).value);
		
		assertPrintExpression("{\n\ta: 0,\n\tb: 1,\n\tc: 2\n}", expression);
		
		// add a sub object
		
		var expression2:IObjectLiteralNode = factory.newObjectLiteral();
		
		expression2.newField("d", factory.newNumberLiteral(3));
		expression2.newField("e", factory.newNumberLiteral(4));
		expression2.newField("f", factory.newNumberLiteral(5));
		
		expression.newField("sub", expression2);
		
		fields = expression.fields;
		Assert.assertNotNull(fields);
		Assert.assertEquals(4, fields.length);
		Assert.assertTrue(fields[3].value is IObjectLiteralNode);
		
		assertPrintExpression("{\n\ta: 0,\n\tb: 1,\n\tc: 2,\n\tsub: {\n\t\td: " +
			"3,\n\t\te: 4,\n\t\tf: 5\n\t}\n}", expression);
	}
	
	[Test]
	public function testRegExpLiteralNode():void
	{
		
	}
	
	[Test]
	public function testStringLiteralNode():void
	{
		var expression:IStringLiteralNode = factory.newStringLiteral("hello world");
		
		Assert.assertEquals("hello world", expression.value);
		Assert.assertTrue(expression.node.isKind(AS3NodeKind.STRING));
		assertPrintExpression("\"hello world\"", expression);
	}
	
	[Test]
	public function testUndefinedLiteralNode():void
	{
		var expression:IUndefinedLiteralNode = factory.newUndefinedLiteral();
		
		Assert.assertTrue(expression.node.isKind(AS3NodeKind.UNDEFINED));
		assertPrintExpression("undefined", expression);
	}
	
	[Test]
	public function testXMLLiteralNode():void
	{
		
	}
	
	protected function assertPrintExpression(expected:String, 
											 expression:IExpressionNode):void
	{
		printer.print(expression.node);
		Assert.assertEquals(expected, printer.flush());
	}
}
}