package org.teotigraphix.as3parser.impl
{
import flexunit.framework.Assert;

import org.teotigraphix.as3parser.utils.ASTUtil;

public class TestPrimaryExpression
{
	private var parser:AS3Parser;
	
	[Before]
	public function setUp():void
	{
		parser = new AS3Parser();
	}
	
	[Test]
	public function testArrayLiteral():void
	{
		assertPrimary( "[1,2,3]",
			"<array line=\"1\" column=\"1\"><primary line=\"1\" column=\"2\">1"
			+ "</primary><primary line=\"1\" column=\"4\">2</primary>"
			+ "<primary line=\"1\" column=\"6\">3</primary></array>" );
	}
	
	[Test]
	public function testBooleans():void
	{
		assertPrimary("true", "true");
		assertPrimary("false", "false");
	}
	
	[Test]
	public function testFunctionLiteral():void
	{
		assertPrimary( "function ( a : Object ) : * { trace('test'); }",
			"<lambda line=\"1\" column=\"10\"><parameter-list line=\"1\" column=\"12\">"
			+ "<parameter line=\"1\" column=\"12\"><name-type-init line=\"1\" column=\"12\">"
			+ "<name line=\"1\" column=\"12\">a</name><type line=\"1\" column=\"16\">"
			+ "Object</type></name-type-init></parameter></parameter-list>"
			+ "<type line=\"1\" column=\"27\">*</type><block line=\"1\" column=\"31\">"
			+ "<call line=\"1\" column=\"36\"><primary line=\"1\" column=\"31\">trace</primary>"
			+ "<arguments line=\"1\" column=\"37\"><primary line=\"1\" column=\"37\">'test'"
			+ "</primary></arguments></call></block></lambda>" );
	}
	
	[Test]
	public function testNull():void
	{
		assertPrimary("null", "null");
	}
	
	[Test]
	public function testNumbers():void
	{
		assertPrimary("1", "1");
		assertPrimary("0xff", "0xff");
		assertPrimary("0420", "0420");
		assertPrimary(".42E2", ".42E2");
	}
	
	[Test]
	public function testObjectLiteral():void
	{
		assertPrimary( "{a:1,b:2}",
			"<object line=\"1\" column=\"1\"><prop line=\"1\" column=\"2\">"
			+ "<name line=\"1\" column=\"2\">a</name><value line=\"1\" column=\"4\">"
			+ "<primary line=\"1\" column=\"4\">1</primary></value></prop><prop line=\"1\" column=\"6\">"
			+ "<name line=\"1\" column=\"6\">b</name><value line=\"1\" column=\"8\">"
			+ "<primary line=\"1\" column=\"8\">2</primary></value></prop></object>" );
	}
	
	[Test]
	public function testStrings():void
	{
		assertPrimary("\"string\"", "\"string\"");
		assertPrimary("'string'", "'string'");
	}
	
	[Test]
	public function testUndefined():void
	{
		assertPrimary("undefined", "undefined");
	}
	
	private function assertPrimary(input:String, 
								   expected:String):void
	{
		var lines:Array =
			[
				input,
				"__END__"
			];
		
		parser.scanner.setLines(ASTUtil.toVector(lines));
		
		parser.nextToken(); // first call
		
		var result:String = ASTUtil.convert(parser.parsePrimaryExpression());
		
		Assert.assertEquals("<primary line=\"1\" column=\"1\">" + 
			expected + "</primary>", result);
	}
}
}