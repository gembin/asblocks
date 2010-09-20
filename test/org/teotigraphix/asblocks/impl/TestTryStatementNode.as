package org.teotigraphix.asblocks.impl
{

import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertNotNull;
import org.flexunit.asserts.assertNull;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.core.SourceCode;
import org.teotigraphix.as3parser.impl.AS3FragmentParser;
import org.teotigraphix.asblocks.ASFactory;
import org.teotigraphix.asblocks.CodeMirror;
import org.teotigraphix.asblocks.api.IBlock;
import org.teotigraphix.asblocks.api.ICatchClause;
import org.teotigraphix.asblocks.api.ITryStatement;

public class TestTryStatementNode
{
	private var factory:ASFactory = new ASFactory();
	
	private var block:IBlock;
	
	private var statement:ITryStatement;
	
	[Before]
	public function setUp():void
	{
		block = null;
		statement = null;
	}
	
	[After]
	public function tearDown():void
	{
		if (block)
		{
			var sourceCode:SourceCode = new SourceCode();
			var ast:IParserNode = block.node;
			new ASTPrinter(sourceCode).print(ast);
			var parsed:IParserNode = AS3FragmentParser.parseStatement(sourceCode.code);
			CodeMirror.assertASTMatch(ast.getFirstChild(), parsed.getFirstChild());
		}
	}
	
	[Test]
	public function testBasicTryCatch():void
	{
		block = factory.newBlock();
		statement = block.newTryCatch("e1", "Error");
		var clauses:Vector.<ICatchClause> = statement.catchClauses;
		assertEquals(clauses.length, 1);
		assertEquals(clauses[0].name, "e1");
		assertEquals(clauses[0].type, "Error");
	}
	
	[Test]
	public function testBasicTryFinally():void
	{
		block = factory.newBlock();
		statement = block.newTryFinally();
	}

	[Test]
	public function testParseTryCatch():void
	{
		block = factory.newBlock();
		statement = block.addStatement("try { } catch ( e:Error ) { }") as ITryStatement;
	}
	
	[Test]
	public function testParseTryFinally():void
	{
		block = factory.newBlock();
		statement = block.addStatement("try { } finally { }") as ITryStatement;
	}
	
	[Test]
	public function testParseTryCatchFinally():void
	{
		block = factory.newBlock();
		statement = block.addStatement("try { } catch ( e:Error ) { } finally { }") as ITryStatement;
	}
	
	[Test]
	public function test_finallyClause():void
	{
		block = factory.newBlock();
		statement = block.newTryFinally();
		assertNotNull(statement.finallyClause);
	}
	
	[Test]
	public function test_removeCatchClause():void
	{
		block = factory.newBlock();
		statement = block.newTryCatch("e", "Error");
		assertEquals(1, statement.catchClauses.length);
		var cclause:ICatchClause = statement.catchClauses[0];
		assertNotNull(cclause);
		statement.removeCatch(cclause);
		assertEquals(0, statement.catchClauses.length);
	}
	
	[Test]
	public function test_removeFinallyClause():void
	{
		block = factory.newBlock();
		statement = block.newTryFinally();
		assertNotNull(statement.finallyClause);
		statement.removeFinally();
		assertNull(statement.finallyClause);
	}
}
}