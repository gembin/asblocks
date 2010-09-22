package org.as3commons.asblocks.impl
{

import org.flexunit.Assert;
import org.as3commons.asblocks.parser.core.SourceCode;
import org.as3commons.asblocks.ASFactory;
import org.as3commons.asblocks.api.IArrayAccessExpression;
import org.as3commons.asblocks.api.IBlock;
import org.as3commons.asblocks.api.ICompilationUnit;
import org.as3commons.asblocks.api.IConditionalExpression;
import org.as3commons.asblocks.api.IExpression;
import org.as3commons.asblocks.api.IFieldAccessExpression;
import org.as3commons.asblocks.api.IForStatement;
import org.as3commons.asblocks.api.IINvocationExpression;
import org.as3commons.asblocks.api.INewExpression;
import org.as3commons.asblocks.api.IScriptNode;
import org.as3commons.asblocks.api.ISimpleNameExpression;
import org.as3commons.asblocks.utils.ASTUtil;

/*

Core

* newParser()
* newWriter()

* newEmptyASProject()

* newClass()
* newInterface()

* newBlock()

* newExpression()

ILiteral

* newArrayLiteral()
* newBooleanLiteral()
* newFunctionLiteral()
* newNullLiteral()
* newNumberLiteral()
* newObjectLiteral()
* newRegexpLiteral()
* newStringLiteral()
* newUndefinedLiteral()
* newXMLLiteral()

IBinaryExpression

* newAddExpression()
* newAndExpression()
* newBitAndExpression()
* newBitOrExpression()
* newBitXorExpression()
* newDivisionExpression()
* newEqualsExpression()
* newGreaterEqualsExpression()
* newGreaterThanExpression()
* newLessEqualsExpression()
* newLessThanExpression()
* newModuloExpression()
* newMultiplyExpression()
* newNotEqualsExpression()
* newOrExpression()
* newShiftLeftExpression()
* newShiftRightExpression()
* newShiftRightUnsignedExpression()
* newSubtractExpression()

IAssignmentExpression

* newAddAssignExpression()
* newAssignExpression()
* newBitAndAssignExpression()
* newBitOrAssignExpression()
* newBitXorAssignExpression()
* newDivideAssignExpression()
* newModuloAssignExpression()
* newMultiplyAssignExpression()
* newShiftLeftAssignExpression()
* newShiftRightAssignExpression()
* newShiftRightUnsignedAssignExpression()
* newSubtractAssignExpression()

IPrefixExpression

* newNegativeExpression()
* newNotExpression()
* newPositiveExpression()
* newPreDecExpression()
* newPreIncExpression()

IPostfixExpression

* newPostDecExpression()
* newPostIncExpression()

Misc.

* newArrayAccessExpression()
* newConditionalExpression()
* newFieldAccessExpression()
* newInvocationExpression()
* newNewExpression()
* newSimpleName()

XML

* newDescendantExpression()
* newExpressionAttribute()
* newFilterExpression()
* newPropertyAttribute()
* newStarAttribute()

 */


// TODO impl unit test DescendentExpression
// TODO impl unit test ExpressionAttribute
// TODO impl unit test FilterExpression
// TODO impl unit test PropertyAttribute
// TODO impl unit test StarAttribute
// TODO impl unit test AttributeExpression

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
	public function testParseForStatement():void
	{
		// TODO implement
		var statement:IBlock = factory.newBlock();
		var forstmt:IForStatement = statement.parseNewFor("var i:int = 0", "i < 1", "i++");
		assertPrint("{\n\tfor (var i:int = 0; i < 1; i++) {\n\t}\n}", forstmt);
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
		expression.condition = factory.newEqualsExpression(
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