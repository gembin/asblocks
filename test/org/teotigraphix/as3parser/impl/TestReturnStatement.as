package org.teotigraphix.as3parser.impl
{

public class TestReturnStatement extends AbstractStatementTest
{
	[Test]
	public function testEmptyReturn():void
	{
		assertStatement( "1",
			"return",
			"<return line=\"2\" column=\"1\"></return>" );
		
		assertStatement( "2",
			"return;",
			"<return line=\"2\" column=\"1\"></return>" );
	}
	
	[Test]
	public function testReturnArrayLiteral():void
	{
		assertStatement( "1",
			"return []",
			"<return line=\"1\" column=\"8\"><primary line=\"1\" column=\"8\">"
			+ "<array line=\"1\" column=\"8\"></array></primary></return>" );
		assertStatement( "2",
			"return [];",
			"<return line=\"1\" column=\"8\"><primary line=\"1\" column=\"8\">"
			+ "<array line=\"1\" column=\"8\"></array></primary></return>" );
	}
}
}