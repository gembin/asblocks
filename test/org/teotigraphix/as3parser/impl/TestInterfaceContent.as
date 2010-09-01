package org.teotigraphix.as3parser.impl
{

import flexunit.framework.Assert;

import org.teotigraphix.as3parser.utils.ASTUtil;

public class TestInterfaceContent
{
	private var parser:AS3ParserOLD;
	
	[Before]
	public function setUp():void
	{
		parser = new AS3ParserOLD();
	}
	
	[Test]
	public function testConditionalCompilation():void
	{
		assertInterfaceContent( "with conditional compilation",
			
			"CONFIG::DEBUG { function output():String; } ",
			"<function line=\"2\" column=\"43\"><name line=\"2\" column=\"26\">"
			+ "output</name><parameter-list line=\"2\" column=\"33\"></parameter-list>"
			+ "<type line=\"2\" column=\"35\">String</type></function>" );
	}
	
	[Test]
	public function testImports():void
	{
		assertInterfaceContent( "1",
			"import a.b.c;",
			"<import line=\"2\" column=\"8\">a.b.c</import>" );
		
		assertInterfaceContent( "2",
			"import a.b.c import x.y.z",
			"<import line=\"2\" column=\"8\">a.b.c</import>"
			+ "<import line=\"2\" column=\"21\">x.y.z</import>" );
	}
	
	[Test]
	public function testMethods():void
	{
		assertInterfaceContent( "1",
			"function a()",
			"<function line=\"3\" column=\"1\">"
			+ "<name line=\"2\" column=\"10\">a</name>"
			+ "<parameter-list line=\"2\" column=\"12\">"
			+ "</parameter-list><type line=\"3\" column=\"1\">"
			+ "</type></function>" );
		
		assertInterfaceContent( "2",
			"function set a( value : int ) : void",
			"<set line=\"3\" column=\"1\"><name line=\"2\" column=\"14\">a"
			+ "</name><parameter-list line=\"2\" column=\"17\">"
			+ "<parameter line=\"2\" column=\"17\">"
			+ "<name-type-init line=\"2\" column=\"17\">"
			+ "<name line=\"2\" column=\"17\">value</name>"
			+ "<type line=\"2\" column=\"25\">int</type>"
			+ "</name-type-init></parameter></parameter-list>"
			+ "<type line=\"2\" column=\"33\">void</type></set>" );
		
		assertInterfaceContent( "3",
			"function get a() : int",
			"<get line=\"3\" column=\"1\"><name line=\"2\" column=\"14\">a"
			+ "</name><parameter-list line=\"2\" column=\"16\">"
			+ "</parameter-list><type line=\"2\" column=\"20\">int" + "</type></get>" );
	}
	
	private function assertInterfaceContent(message:String, 
										  input:String, 
										  expected:String):void
	{
		var lines:Array =
			[
				"{",
				input,
				"}",
				"__END__"
			];
		
		parser.scanner.setLines(ASTUtil.toVector(lines));
		
		parser.nextToken(); // first call
		parser.nextToken(); // skip {
		
		var result:String = ASTUtil.convert(parser.parseInterfaceContent());
		
		Assert.assertEquals("<content line=\"2\" column=\"1\">" + 
			expected + "</content>", result);
	}
}
}