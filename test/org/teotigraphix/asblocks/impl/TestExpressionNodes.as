package org.teotigraphix.asblocks.impl
{

import org.flexunit.Assert;
import org.teotigraphix.as3parser.core.SourceCode;
import org.teotigraphix.asblocks.ASFactory;
import org.teotigraphix.asblocks.api.IArrayAccessExpression;
import org.teotigraphix.asblocks.api.IAssignmentExpression;
import org.teotigraphix.asblocks.api.IBinaryExpression;
import org.teotigraphix.asblocks.api.IBlock;
import org.teotigraphix.asblocks.api.ICompilationUnit;
import org.teotigraphix.asblocks.api.IConditionalExpression;
import org.teotigraphix.asblocks.api.IDoWhileStatement;
import org.teotigraphix.asblocks.api.IExpression;
import org.teotigraphix.asblocks.api.IFieldAccessExpression;
import org.teotigraphix.asblocks.api.IINvocationExpression;
import org.teotigraphix.asblocks.api.IIfStatement;
import org.teotigraphix.asblocks.api.INewExpression;
import org.teotigraphix.asblocks.api.IPostfixExpression;
import org.teotigraphix.asblocks.api.IPrefixExpression;
import org.teotigraphix.asblocks.api.IScriptNode;
import org.teotigraphix.asblocks.api.ISimpleNameExpression;
import org.teotigraphix.asblocks.api.ISwitchCase;
import org.teotigraphix.asblocks.api.ISwitchDefault;
import org.teotigraphix.asblocks.api.ISwitchStatement;
import org.teotigraphix.asblocks.api.IThrowStatement;
import org.teotigraphix.asblocks.utils.ASTUtil;

public class TestExpressionNodes
{
	private var printer:ASTPrinter;
	
	private var factory:ASFactory;
	private var project:ASProject;
	
	[Before]
	public function setUp():void
	{
		printer = new ASTPrinter(new SourceCode());
		factory = new ASFactory();
		project = new ASProject(factory);
	}
	
	
	[Test]
	public function testClass():void
	{
		var statement:ICompilationUnit = project.newClass("my.domain.ClassA");
		
		var result:String = ASTUtil.convert(statement.node, false);
		
		assertPrint("package my.domain {\n\tpublic class ClassA {\n\t}\n}", statement);
	}
	
	[Test]
	public function testInterface():void
	{
		var statement:ICompilationUnit = project.newInterface("my.domain.IInterfaceA");
		
		var result:String = ASTUtil.convert(statement.node, false);
		
		assertPrint("package my.domain {\n\tpublic interface IInterfaceA {\n\t}\n}", statement);
	}
	
	[Test]
	public function testBlock():void
	{
		var statement:IBlock = factory.newBlock();
		
		assertPrint("{\n}", statement);
	}
	
	[Test]
	public function testBreakStatement():void
	{
		var statement:IBlock = factory.newBlock();
		statement.newBreak();
		assertPrint("{\n\tbreak;\n}", statement);
	}
	
	[Test]
	public function testContinueStatement():void
	{
		var statement:IBlock = factory.newBlock();
		statement.newContinue();
		assertPrint("{\n\tcontinue;\n}", statement);
	}
	
	[Test]
	public function testDeclaration():void
	{
		var statement:IBlock = factory.newBlock();
		// FIXME use var-list and const-list ast model
		var expression:IAssignmentExpression = factory.
			newAssignmentExpression(
				factory.newSimpleNameExpression("a"),
				factory.newNumberLiteral(42));
		
		statement.newDeclaration(expression);
		assertPrint("{\n\tvar a = 42;\n}", statement);
	}
	
	[Test]
	public function testXMLNamespace():void
	{
		var statement:IBlock = factory.newBlock();
		
		statement.newDefaultXMLNamespace("my_namespace");
		assertPrint("{\n\tdefault xml namespace = \"my_namespace\";\n}", statement);
	}
	
	[Test]
	public function testDoWhile():void
	{
		var statement:IBlock = factory.newBlock();
		
		var result:IDoWhileStatement = statement.newDoWhile(factory.newExpression("hasNext()"));
		assertPrint("{\n\tdo {\n\t} while (hasNext());\n}", statement);
		
		result.newExpressionStatement("trace('Hello World')");
		assertPrint("{\n\tdo {\n\t\ttrace('Hello World');\n\t} while (hasNext());\n}", statement);
	}
	
	[Test]
	public function testExpressionStatement():void
	{
		var statement:IBlock = factory.newBlock();
		statement.newExpressionStatement("hasNext()");
		assertPrint("{\n\thasNext();\n}", statement);
	}
	
	[Test]
	public function testForStatement():void
	{
		// TODO impl unit test
	}
	
	[Test]
	public function testForEachInStatement():void
	{
		// TODO impl unit test
	}
	
	[Test]
	public function testForInStatement():void
	{
		// TODO impl unit test
	}
	
	[Test]
	public function testIfStatement():void
	{
		var statement:IBlock = factory.newBlock();
		
		assertPrint("{\n}", statement);
		
		var ifst:IIfStatement = statement.newIf(factory.newExpression("test()"));
		ifst.addStatement("trace('test succeeded')");
		
		assertPrint("{\n\tif (test()) {\n\t\ttrace('test succeeded');\n\t}\n}", ifst);
		
		ifst.elseBlock.addStatement("trace('test failed')");
		
		assertPrint("{\n\tif (test()) {\n\t\ttrace('test succeeded');\n\t} else " +
			"{\n\t\ttrace('test failed');\n\t}\n}", ifst);
		
		var ifstSub:IIfStatement = ifst.newIf(factory.newExpression("test2()"));
		ifstSub.addStatement("trace('sub test succeeded')");
		ifstSub.elseBlock.addStatement("trace('sub test failed')");
		
		assertPrint("{\n\tif (test()) {\n\t\ttrace('test succeeded');\n\t\tif " +
			"(test2()) {\n\t\t\ttrace('sub test succeeded');\n\t\t} else " +
			"{\n\t\t\ttrace('sub test failed');\n\t\t}\n\t} else {\n\t\ttrace(" +
			"'test failed');\n\t}\n}", ifstSub);
	}
	
	[Test]
	public function testReturnStatement():void
	{
		var statement:IBlock = factory.newBlock();
		statement.newReturn(factory.newExpression("result"));
		
		assertPrint("{\n\treturn result;\n}", statement);
		
		statement = factory.newBlock();
		statement.newReturn();
		
		assertPrint("{\n\treturn;\n}", statement);
	}
	
	[Test]
	public function testSwitchStatement():void
	{
		var statement:IBlock = factory.newBlock();
		var switchStatement:ISwitchStatement = statement.
			newSwitch(factory.newExpression("count"));
		
		assertPrint("{\n\tswitch (count) {\n\t}\n}", statement);
		
		var cs:ISwitchCase = switchStatement.newCase("1");
		cs.newBreak();
		
		cs = switchStatement.newCase("2");
		cs.newBreak();
		
		assertPrint("{\n\tswitch (count) {\n\t\tcase 1:\n\t\t\tbreak;\n\t\tcase 2:" +
			"\n\t\t\tbreak;\n\t}\n}", statement);
		
		var csd:ISwitchDefault = switchStatement.newDefault();
		csd.newBreak();
		
		assertPrint("{\n\tswitch (count) {\n\t\tcase 1:\n\t\t\tbreak;\n\t\tcase 2:" +
			"\n\t\t\tbreak;\n\t\tdefault:\n\t\t\tbreak;\n\t}\n}", statement);
	}
	
	[Test]
	public function testThrowStatement():void
	{
		var statement:IBlock = factory.newBlock();
		var throwStatement:IThrowStatement = statement.
			newThrow(factory.newExpression("new Error('Hello World')"));
		
		assertPrint("{\n\tthrow new Error('Hello World');\n}", statement);
	}
	
	[Test]
	public function testTryCatchStatement():void
	{
		// TODO impl unit test
	}
	
	[Test]
	public function testTryFinallyStatement():void
	{
		// TODO impl unit test
	}
	
	[Test]
	public function testWhileStatement():void
	{
		// TODO impl unit test
	}
	
	[Test]
	public function testWithStatement():void
	{
		// TODO impl unit test
	}
	
	[Test]
	public function testArrayAccessExpressionNode():void
	{
		var target:IExpression = factory.newExpression("myObject[42]");
		var subscript:IExpression = factory.newExpression("0");
		
		var expression:IArrayAccessExpression = 
			factory.newArrayAccessExpression(target, subscript);
		
		assertPrint("myObject[42][0]", expression);
		
		// test changing the 'target'
		target = factory.newExpression("myObject");
		expression.target = target;
		
		assertPrint("myObject[0]", expression);
		
		// test changing the 'subscript'
		subscript = factory.newExpression("42");
		expression.subscript = subscript;
		
		assertPrint("myObject[42]", expression);
		
		// test changing the 'subscript' to a string literal
		subscript = factory.newExpression("'myProp'");
		// or you could use
		// subscript = factory.newStringLiteral("'myProp'");
		expression.subscript = subscript;
		
		assertPrint("myObject['myProp']", expression);
	}
	
	[Test]
	public function testAssignmentExpressionNode():void
	{
		var left:IExpression = factory.newExpression("myAnswer");
		var right:IExpression = factory.newExpression("4");
		
		var expression:IAssignmentExpression = 
			factory.newAssignmentExpression(left, right);
		
		assertPrint("myAnswer = 4", expression);
		
		// change right expression
		expression.rightExpression = factory.newExpression("otherAnswer = 4");
		
		assertPrint("myAnswer = otherAnswer = 4", expression);
		
		// change left expression to an array access
		var target:IExpression = factory.newExpression("myObject[42]");
		var subscript:IExpression = factory.newExpression("2");
		
		var arrayAccessExpression:IArrayAccessExpression = 
			factory.newArrayAccessExpression(target, subscript);
		
		expression.leftExpression = arrayAccessExpression;
		
		assertPrint("myObject[42][2] = otherAnswer = 4", expression);
	}
	
	[Test]
	public function testBinaryExpressionNode():void
	{
		var left:IExpression;
		var right:IExpression;
		
		var expression:IBinaryExpression;
		
		// ADD
		expression = factory.newAddExpression(
			factory.newNumberLiteral(4),
			factory.newNumberLiteral(2));
		
		assertPrint("4 + 2", expression);
		
		// AND
		expression = factory.newAndExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrint("a && b", expression);
		
		// BITAND
		expression = factory.newBitAndExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrint("a & b", expression);
		
		// BITOR
		expression = factory.newBitOrExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrint("a | b", expression);
		
		// BITXOR
		expression = factory.newBitXorExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrint("a ^ b", expression);
		
		// DIV
		expression = factory.newDivisionExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrint("a / b", expression);
		
		// EQ
		expression = factory.newEqualsExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrint("a == b", expression);
		
		// GE
		expression = factory.newGreaterEqualsExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrint("a >= b", expression);
		
		// GT
		expression = factory.newGreaterThanExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrint("a > b", expression);
		
		// LE
		expression = factory.newLessEqualsExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrint("a <= b", expression);
		
		// LT
		expression = factory.newLessThanExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrint("a < b", expression);
		
		// MOD
		expression = factory.newModuloExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrint("a % b", expression);
		
		// MUL
		expression = factory.newMultiplyExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrint("a * b", expression);
		
		// NE
		expression = factory.newNotEqualsExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrint("a != b", expression);
		
		// OR
		expression = factory.newOrExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrint("a || b", expression);
		
		// SL
		expression = factory.newShiftLeftExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrint("a << b", expression);
		
		// SR
		expression = factory.newShiftRightExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrint("a >> b", expression);
		
		// SRU
		expression = factory.newShiftRightUnsignedExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrint("a >>> b", expression);
		
		// SUB
		expression = factory.newSubtractExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrint("a - b", expression);
	}
	
	[Test]
	public function testConditionalExpressionNode():void
	{
		var conditionExpression:IExpression = factory.newNotEqualsExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		var thenExpression:IExpression = factory.newBooleanLiteral(false);
		var elseExpression:IExpression = factory.newBooleanLiteral(true);
		
		var expression:IConditionalExpression = 
			factory.newConditionalExpression(
				conditionExpression, thenExpression, elseExpression);
		
		assertPrint("a != b ? false : true", expression);
		
		// test changing the condition
		expression.conditionExpression = factory.newEqualsExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrint("a == b ? false : true", expression);
		
		// test changing the then
		expression.thenExpression = factory.newNumberLiteral(4);
		
		assertPrint("a == b ? 4 : true", expression);
		
		// test changing the else
		expression.elseExpression = factory.newNumberLiteral(2);
		
		assertPrint("a == b ? 4 : 2", expression);
	}
	
	[Test]
	public function testDescendentExpressionNode():void
	{
		// TODO impl unit test
	}
	
	[Test]
	public function testExpressionAttrbuteNode():void
	{
		// TODO impl unit test
	}
	
	[Test]
	public function testFieldAccessExpressionNode():void
	{
		var expression:IFieldAccessExpression = 
			factory.newFieldAccessExpression(
				factory.newSimpleNameExpression("myObject"), "field");
		
		assertPrint("myObject.field", expression);
		
		// change the name
		expression.name = "myField";
		
		assertPrint("myObject.myField", expression);
		
		// change the target expression
		expression.target = factory.newArrayAccessExpression(
			factory.newExpression("myObject"), 
			factory.newExpression("42"));
		
		assertPrint("myObject[42].myField", expression);
		
		// change the target expression
		expression.target = factory.newInvocationExpression(
			factory.newSimpleNameExpression("myObject"), null);
		
		assertPrint("myObject().myField", expression);
	}
	
	[Test]
	public function testFilterExpressionNode():void
	{
		// TODO impl unit test
	}
	
	[Test]
	public function testInvocationExpressionNode():void
	{
		var expression:IINvocationExpression = 
			factory.newInvocationExpression(
				factory.newSimpleNameExpression("myObject"), null);
		
		assertPrint("myObject()", expression);
		
		// test adding args
		var args:Vector.<IExpression> = new Vector.<IExpression>();
		args.push(factory.newBooleanLiteral(true));
		args.push(factory.newStringLiteral("Hello World"));
		
		expression.arguments = args;
		
		assertPrint("myObject(true, \"Hello World\")", expression);
		
		// change the target expression
		expression.target = factory.newArrayAccessExpression(
			factory.newExpression("myObject"), 
			factory.newExpression("42"));
		
		assertPrint("myObject[42](true, \"Hello World\")", expression);
	}
	
	[Test]
	public function testNewExpressionNode():void
	{
		var expression:INewExpression = 
			factory.newNewExpression(
				factory.newSimpleNameExpression("HelloWorld"), null);
		
		assertPrint("new HelloWorld()", expression);
		// should be 
		// assertPrintExpression("new HelloWorld", expression);
		
		// test adding args
		var args:Vector.<IExpression> = new Vector.<IExpression>();
		args.push(factory.newBooleanLiteral(true));
		args.push(factory.newStringLiteral("Hello World"));
		
		expression.arguments = args;
		
		assertPrint("new HelloWorld(true, \"Hello World\")", expression);
	}
	
	[Test]
	public function testPostfixExpressionNode():void
	{
		
		
		var expression:IPostfixExpression;
		
		expression = factory.newPostDecExpression(factory.newSimpleNameExpression("i"));
		assertPrint("i--", expression);
		
		expression.expression = factory.newSimpleNameExpression("count");
		assertPrint("count--", expression);
		
		// FIXME
		//expression.operator = PostfixOperator.POSTINC;
		//assertPrintExpression("count++", expression);
		
		expression = factory.newPostIncExpression(factory.newSimpleNameExpression("i"));
		assertPrint("i++", expression);
		
		expression.expression = factory.newSimpleNameExpression("count");
		assertPrint("count++", expression);
	}
	
	[Test]
	public function testPrefixExpressionNode():void
	{
		var expression:IPrefixExpression;
		
		expression = factory.newPreDecExpression(factory.newSimpleNameExpression("i"));
		assertPrint("--i", expression);
		
		expression = factory.newPreIncExpression(factory.newSimpleNameExpression("i"));
		assertPrint("++i", expression);
	}
	
	[Test]
	public function testPropertyAttributeNode():void
	{
		// TODO impl unit test
	}
	
	[Test]
	public function testSimpleNameExpressionNode():void
	{
		var expression:ISimpleNameExpression = 
			factory.newSimpleNameExpression("myObject");
		
		Assert.assertEquals("myObject", expression.name);
		assertPrint("myObject", expression);
		
		// test changing the 'name'
		
		expression.name = "myOtherObject";
		
		Assert.assertEquals("myOtherObject", expression.name);
		assertPrint("myOtherObject", expression);
	}
	
	[Test]
	public function testStarAttributeNode():void
	{
		// TODO impl unit test
	}
	
	[Test]
	public function testAttributeExpressionNode():void
	{
		// TODO impl unit test
	}
	
	protected function assertPrint(expected:String, 
								   expression:IScriptNode):void
	{
		printer.print(expression.node);
		Assert.assertEquals(expected, printer.flush());
	}
}
}