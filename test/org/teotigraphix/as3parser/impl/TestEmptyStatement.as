package org.teotigraphix.as3parser.impl
{

public class TestEmptyStatement extends AbstractStatementTest
{
	[Test]
	public function testComplex():void
	{
		assertStatement( "1",
			"{;1;;}",
			"<block line=\"1\" column=\"2\"><stmt-empty line=\"1\" column=\"2\">;"
			+ "</stmt-empty><primary line=\"1\" column=\"3\">1"
			+ "</primary><stmt-empty line=\"1\" column=\"5\">;</stmt-empty></block>" );
	}
	
	[Test]
	public function testSimple():void
	{
		assertStatement( "1",
			";",
			"<stmt-empty line=\"1\" column=\"1\">;</stmt-empty>" );
	}
}
}