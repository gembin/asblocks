package org.as3commons.asblocks.impl
{

import org.flexunit.Assert;
import org.as3commons.asblocks.parser.api.IToken;
import org.as3commons.asblocks.ASFactory;
import org.as3commons.asblocks.api.IBlock;
import org.as3commons.asblocks.api.IDeclarationStatement;
import org.as3commons.asblocks.api.IDoWhileStatement;
import org.as3commons.asblocks.api.IForEachInStatement;
import org.as3commons.asblocks.api.IForInStatement;
import org.as3commons.asblocks.api.IForLabelStatement;
import org.as3commons.asblocks.api.IForStatement;
import org.as3commons.asblocks.api.IIfStatement;
import org.as3commons.asblocks.api.ILabelStatement;
import org.as3commons.asblocks.api.IScriptNode;
import org.as3commons.asblocks.api.IStatement;
import org.as3commons.asblocks.api.ISuperStatement;
import org.as3commons.asblocks.api.ISwitchCase;
import org.as3commons.asblocks.api.ISwitchDefault;
import org.as3commons.asblocks.api.ISwitchStatement;
import org.as3commons.asblocks.api.IThrowStatement;
import org.as3commons.asblocks.api.ITryStatement;
import org.as3commons.asblocks.api.IWhileStatement;
import org.as3commons.asblocks.api.IWithStatement;
import org.as3commons.asblocks.utils.ASTUtil;

/*

* statementList

* addComment()
* removeComment()
* addStatement()
* removeStatement()
* removeStatementAt()
* containsCode()

* newBreak()
* newContinue()
* newDeclaration(), parseDeclaration()
* newDefaultXMLNamespace()
* newDoWhile(), parseDoWhile()
* newExpressionStatement(), parseExpressionStatement()
* newFor(), parseFor()
* newForEachIn(), parseForEach()
* newForIn(), parseForIn()
* newIf(), parseIf()
* newReturn(), parseReturn()
* newSuper()
* newSwitch(), parseSwitch()
* newThrow()
* newTryCatch(), parseTryCatch()
* newTryFinally()
* newWhile(), parseWhile()
* newWith(), parseWith()

*/

public class TestStatementList
{
	private var factory:ASFactory = new ASFactory();
	
	private var block:IBlock;
	
	[Before]
	public function setUp():void
	{
		block = factory.newBlock();
	}
	
	[After]
	public function tearDown():void
	{
		block = null;
	}
	
	[Test]
	public function test_statements():void
	{
		Assert.assertNotNull(block.statements);
		block.addStatement("trace('Hello World')");
		Assert.assertEquals(1, block.statements.length);
		block.addStatement("trace('Hello World')");
		Assert.assertEquals(2, block.statements.length);
		block.addStatement("trace('Hello World')");
		Assert.assertEquals(3, block.statements.length);
	}
	
	[Test]
	public function test_hasCode():void
	{
		Assert.assertFalse(block.hasCode);
		block.addStatement("trace('Hello World')");
		Assert.assertTrue(block.hasCode);
	}
	
	[Test]
	public function test_addComment():void
	{
		var comment:IToken = block.addComment("A comment.");
		assertPrint("{\n\t//A comment.\n}", block);
	}
	
	[Test]
	public function test_removeComment():void
	{
		var comment1:IToken = block.addComment("A comment 1.");
		var statement1:IStatement = block.addStatement("trace('Hello World 1')");
		var comment2:IToken = block.addComment("A comment 2.");
		var statement2:IStatement = block.addStatement("trace('Hello World 2')");
		assertPrint("{\n\t//A comment 1.\n\ttrace('Hello World 1');\n\t//A comment 2.\n" +
			"\ttrace('Hello World 2');\n}", block);
		
		block.removeComment(statement1);
		assertPrint("{\n\ttrace('Hello World 1');\n\t//A comment 2.\n\t" +
			"trace('Hello World 2');\n}", block);
		
		block.removeComment(statement2);
		assertPrint("{\n\ttrace('Hello World 1');\n\ttrace('Hello World 2');\n}", block);
	}
	
	[Test]
	public function test_removeCommentBackOne():void
	{
		var comment1:IToken = block.addComment("A comment 1.");
		var statement1:IStatement = block.addStatement("trace('Hello World 1')");
		var statement2:IStatement = block.addStatement("trace('Hello World 2')");
		
		block.removeComment(statement1);
		assertPrint("{\n\ttrace('Hello World 1');\n\ttrace('Hello World 2');\n}", block);
	}
	
	[Test]
	public function test_addStatement():void
	{
		block.addStatement("trace('Hello World')");
		assertPrint("{\n\ttrace('Hello World');\n}", block);
	}
	
	[Test]
	public function test_removeStatement():void
	{
		var statement1:IStatement = block.addStatement("trace('Hello World 1')");
		var statement2:IStatement = block.addStatement("trace('Hello World 2')");
		var statement3:IStatement = block.addStatement("trace('Hello World 3')");
		
		Assert.assertEquals(3, block.statements.length);
		Assert.assertNotNull(block.removeStatement(statement2));
		Assert.assertEquals(2, block.statements.length);
		Assert.assertNotNull(block.removeStatement(statement3));
		Assert.assertEquals(1, block.statements.length);
		Assert.assertNull(block.removeStatement(statement3));
		
		Assert.assertNotNull(block.removeStatement(statement1));
		Assert.assertEquals(0, block.statements.length);
	}
	
	[Test]
	public function test_removeStatementAt():void
	{
		var statement1:IStatement = block.addStatement("trace('Hello World 1')");
		var statement2:IStatement = block.addStatement("trace('Hello World 2')");
		var statement3:IStatement = block.addStatement("trace('Hello World 3')");
		
		Assert.assertEquals(3, block.statements.length);
		Assert.assertNotNull(statement3.node, block.removeStatementAt(2));
		Assert.assertEquals(2, block.statements.length);
		Assert.assertNotNull(statement2.node, block.removeStatementAt(1));
		Assert.assertEquals(1, block.statements.length);
		Assert.assertNull(block.removeStatementAt(1));
		
		Assert.assertNotNull(statement1.node, block.removeStatementAt(0));
		Assert.assertEquals(0, block.statements.length);
	}
	
	[Test]
	public function test_newBreak():void
	{
		block.newBreak();
		assertPrint("{\n\tbreak;\n}", block);
	}
	
	[Test]
	public function test_newContinue():void
	{
		block.newContinue();
		assertPrint("{\n\tcontinue;\n}", block);
	}
	
	[Test]
	public function test_newDeclaration():void
	{
		var dec:IDeclarationStatement = block.newDeclaration("i:int = 0");
		Assert.assertNotNull(dec);
		assertPrint("{\n\tvar i:int = 0;\n}", block);
		dec = block.newDeclaration("i:int = 0, j:int = 42, k:String = \"test\"");
		Assert.assertNotNull(dec);
		assertPrint("{\n\tvar i:int = 0;\n\tvar i:int = 0, j:int = 42, " +
			"k:String = \"test\";\n}", block);
	}
	
	[Test]
	public function test_newDefaultXMLNamespace():void
	{
		block.newDefaultXMLNamespace("my_namespace");
		assertPrint("{\n\tdefault xml namespace = my_namespace;\n}", block);
	}
	
	[Test]
	public function test_newDoWhile():void
	{
		var result:IDoWhileStatement = block.newDoWhile(factory.newExpression("hasNext()"));
		assertPrint("{\n\tdo {\n\t} while (hasNext());\n}", block);
		
		result.addStatement("trace('Hello World')");
		assertPrint("{\n\tdo {\n\t\ttrace('Hello World');\n\t} while (hasNext());\n}", block);
	}
	
	[Test]
	public function test_newExpressionStatement():void
	{
		block.newExpressionStatement("hasNext()");
		assertPrint("{\n\thasNext();\n}", block);
	}
	
	[Test]
	public function test_newFor():void
	{
		var forstmt:IForStatement = block.newFor(null, null, null);
		assertPrint("{\n\tfor (; ; ) {\n\t}\n}", forstmt);
		
		block = factory.newBlock();
		forstmt = block.newFor(factory.newExpression("i=0"), null, null);
		assertPrint("{\n\tfor (i=0; ; ) {\n\t}\n}", forstmt);
		
		block = factory.newBlock();
		forstmt = block.newFor(
			factory.newExpression("i=0"), 
			factory.newExpression("i < len + 1"), null);
		assertPrint("{\n\tfor (i=0; i < len + 1; ) {\n\t}\n}", forstmt);
		
		block = factory.newBlock();
		forstmt = block.newFor(
			factory.newExpression("i=0"), 
			factory.newExpression("i < len + 1"), 
			factory.newExpression("++i"));
		assertPrint("{\n\tfor (i=0; i < len + 1; ++i) {\n\t}\n}", forstmt);
		
		block = factory.newBlock();
		forstmt = block.newFor(
			factory.newExpression("i=0"), 
			factory.newExpression("i < len + 1"), 
			factory.newExpression("++i"));
		forstmt.addStatement("trace('Hello World ' + i)");
		assertPrint("{\n\tfor (i=0; i < len + 1; ++i) {\n\t\t" +
			"trace('Hello World ' + i);\n\t}\n}", forstmt);
		
		// test setting initializer
		// can be either IDeclarationStatement or IExpression (assignment)
		forstmt.initializer = factory.newDeclaration("j:int = 0");
		assertPrint("{\n\tfor (var j:int = 0; i < len + 1; ++i) {\n\t\ttrace" +
			"('Hello World ' + i);\n\t}\n}", forstmt);
		
		// test setting condition
		forstmt.condition = factory.newExpression("j < (j + 2)");
		assertPrint("{\n\tfor (var j:int = 0; j < (j + 2); ++i) {\n\t\ttrace" +
			"('Hello World ' + i);\n\t}\n}", forstmt);
		
		// test setting update
		forstmt.iterator = factory.newExpression("next(j)");
		assertPrint("{\n\tfor (var j:int = 0; j < (j + 2); next(j)) {\n\t\ttrace" +
			"('Hello World ' + i);\n\t}\n}", forstmt);
	}
	
	[Test]
	public function test_parseNewFor():void
	{
		// TODO impl unit test
	}
	
	[Test]
	public function test_newForEachIn():void
	{
		var forstmt:IForEachInStatement = block.newForEachIn(
			factory.newExpression("name"), 
			factory.newExpression("object"));
		
		assertPrint("{\n\tfor each (name in object) {\n\t}\n}", forstmt);
		
		// test setting variable
		forstmt.initializer = factory.newDeclaration("prop:String");
		assertPrint("{\n\tfor each (var prop:String in object) {\n\t}\n}", forstmt);
		
		// test setting iterated
		forstmt.iterated = factory.newExpression("getObject(prop)");
		assertPrint("{\n\tfor each (var prop:String in getObject(prop)) {\n\t}\n}", forstmt);
	}
	
	[Test]
	public function test_newForIn():void
	{
		var forstmt:IForInStatement = block.newForIn(
			factory.newExpression("name"), 
			factory.newExpression("object"));
		
		assertPrint("{\n\tfor (name in object) {\n\t}\n}", forstmt);
		
		// test setting variable
		forstmt.initializer = factory.newDeclaration("prop:String");
		assertPrint("{\n\tfor (var prop:String in object) {\n\t}\n}", forstmt);
		
		// test setting iterated
		forstmt.iterated = factory.newExpression("getObject(prop)");
		assertPrint("{\n\tfor (var prop:String in getObject(prop)) {\n\t}\n}", forstmt);
	}
	
	[Test]
	public function test_newIf():void
	{
		var ifst:IIfStatement = block.newIf(factory.newExpression("test()"));
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
	public function test_newLabel():void
	{
		var label:ILabelStatement = block.newLabel("foo");
		label.addStatement("trace('Hello block label')");
		assertPrint("{\n\tfoo : {\n\t\ttrace('Hello block label');\n\t}\n}", block);
		
		block = factory.newBlock();
		label = block.newForLabel("fooLoop", "for");
		//label.addStatement("trace('Hello block label')");
		// TODO impl for and while labels
		//assertPrint("{\n\tfooLoop : for (; ; )\n}", block);
		//IForLabelStatement(label).statement.addStatement("trace('Hello for label')");
		//assertPrint("{\n\tfooLoop : for (; ; )\n}", block);
	}
	
	[Test]
	public function test_newReturn():void
	{
		block.newReturn(factory.newExpression("result"));
		
		assertPrint("{\n\treturn result;\n}", block);
		
		block = factory.newBlock();
		block.newReturn();
		
		assertPrint("{\n\treturn;\n}", block);
	}
	
	[Test]
	public function test_newSuper():void
	{
		var suprstmt:ISuperStatement = block.newSuper(null);
		
		assertPrint("{\n\tsuper();\n}", block);
		// TODO implement super() arguments
	}
	
	[Test]
	public function test_newSwitch():void
	{
		var switchStatement:ISwitchStatement = block.
			newSwitch(factory.newExpression("count"));
		
		assertPrint("{\n\tswitch (count) {\n\t}\n}", block);
		
		var cs:ISwitchCase = switchStatement.newCase("1");
		cs.newBreak();
		
		cs = switchStatement.newCase("2");
		cs.newBreak();
		
		assertPrint("{\n\tswitch (count) {\n\t\tcase 1:\n\t\t\tbreak;\n\t\tcase 2:" +
			"\n\t\t\tbreak;\n\t}\n}", block);
		
		var csd:ISwitchDefault = switchStatement.newDefault();
		csd.newBreak();
		
		assertPrint("{\n\tswitch (count) {\n\t\tcase 1:\n\t\t\tbreak;\n\t\tcase 2:" +
			"\n\t\t\tbreak;\n\t\tdefault:\n\t\t\tbreak;\n\t}\n}", block);
	}
	
	[Test]
	public function test_newThrow():void
	{
		var throwStatement:IThrowStatement = block.
			newThrow(factory.newExpression("new Error('Hello World')"));
		
		assertPrint("{\n\tthrow new Error('Hello World');\n}", block);
	}
	
	[Test]
	public function test_newTryCatch():void
	{
		var trystmt:ITryStatement = block.newTryCatch("e", "Error");
		
		assertPrint("{\n\ttry {\n\t} catch (e:Error) {\n\t}\n}", block);
	}
	
	[Test]
	public function test_newTryFinally():void
	{
		var trystmt:ITryStatement = block.newTryFinally();
		
		assertPrint("{\n\ttry {\n\t} finally {\n\t}\n}", block);
	}
	
	[Test]
	public function test_newWhile():void
	{
		var wstmt:IWhileStatement = block.newWhile(factory.newExpression("hasNext()"));
		
		assertPrint("{\n\twhile (hasNext()){\n\t}\n}", block);
	}
	
	[Test]
	public function test_newWith():void
	{
		var wistmt:IWithStatement = block.newWith(factory.newExpression("Math"));
		
		assertPrint("{\n\twith (Math){\n\t}\n}", block);
		
		wistmt.addStatement("a = PI * pow(r, 2)");
		assertPrint("{\n\twith (Math){\n\t\ta = PI * pow(r, 2);\n\t}\n}", block);
	}
	
	protected function assertPrint(expected:String, 
								   expression:IScriptNode):void
	{
		var result:String = ASTUtil.print(expression.node);
		Assert.assertEquals(expected, result);
	}
}
}