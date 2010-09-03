package org.teotigraphix.asblocks.impl
{

import org.flexunit.Assert;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.asblocks.api.ICompilationUnitNode;
import org.teotigraphix.asblocks.api.IScriptNode;
import org.teotigraphix.asblocks.utils.ASTUtil;

public class TestCompilationUnitNode extends BaseASFactoryTest
{	
	[Test]
	public function testDefaultPackageWithClass():void
	{
		//  package { class A {} } 
		var element:ICompilationUnitNode = project.newClass("A");
		var result1:String = toElementString(element);
		
		var ast:IParserNode = parseCompilationUnit("package { public class A {} }");
		var result2:String = ASTUtil.convert(ast, false);
		
		
		//assertPrint("package my.domain {\n\tpublic class ClassA {\n\t}\n}", statement);
	}
	
	
	
	protected function assertCompilationUnit(message:String, 
											 input:String, 
											 expected:String):void
	{
		var result:String = ASTUtil.convert(parseCompilationUnit(input), false);
		Assert.assertEquals(message, expected, result);
	}
	
	protected function parseCompilationUnit(input:String):IParserNode
	{
		parser.scanner.setLines(Vector.<String>([input]));
		return parser.parseCompilationUnit();
	}
	
	protected function toElementString(element:IScriptNode):String
	{
		return ASTUtil.convert(element.node, false);
	}
}
}