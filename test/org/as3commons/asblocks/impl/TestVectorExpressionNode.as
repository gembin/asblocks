package org.as3commons.asblocks.impl
{

import org.as3commons.asblocks.CodeMirror;
import org.as3commons.asblocks.api.ISimpleNameExpression;
import org.as3commons.asblocks.api.IVectorExpression;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.core.SourceCode;
import org.as3commons.asblocks.parser.impl.AS3FragmentParser;
import org.flexunit.Assert;

public class TestVectorExpressionNode extends BaseASFactoryTest
{
	private var vector:IVectorExpression;
	
	[Before]
	override public function setUp():void
	{
		super.setUp();
		
		vector = null;
	}
	
	[After]
	override public function tearDown():void
	{
		if (vector)
		{
			var sourceCode:SourceCode = new SourceCode();
			var ast:IParserNode = vector.node;
			new ASTPrinter(sourceCode).print(ast);
			var parsed:IParserNode = AS3FragmentParser.parseType(sourceCode.code);
			CodeMirror.assertASTMatch(ast, parsed);
		}
	}
	
	[Test]
	public function testBasic():void
	{
		vector = factory.newVectorExpression("String");
		assertPrint("Vector.<String>", vector);
		vector = factory.newVectorExpression("Vector.<String>");
		assertPrint("Vector.<Vector.<String>>", vector);
	}
	
	[Test]
	public function test_type():void
	{
		vector = factory.newVectorExpression("String");
		var type:ISimpleNameExpression = vector.type as ISimpleNameExpression;
		Assert.assertNotNull(type);
		Assert.assertEquals("String", type.name);
		vector = factory.newVectorExpression("Vector.<int>");
		var v:IVectorExpression = vector.type as IVectorExpression;
		Assert.assertNotNull(v);
		type = v.type as ISimpleNameExpression;
		Assert.assertEquals("int", type.name);
	}
}
}