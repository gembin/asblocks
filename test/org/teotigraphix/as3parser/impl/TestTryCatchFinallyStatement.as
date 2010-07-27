package org.teotigraphix.as3parser.impl
{

public class TestTryCatchFinallyStatement extends AbstractStatementTest
{
	[Test]
	public function testCatch():void
	{
		assertStatement( "1",
			"catch( e : Error ) {trace( true ); }",
			"<catch line=\"1\" column=\"8\"><name line=\"1\" column=\"8\">e"
			+ "</name><type line=\"1\" column=\"12\">Error</type><block line=\"1\" column=\"21\">"
			+ "<call line=\"1\" column=\"26\"><primary line=\"1\" column=\"21\">trace</primary>"
			+ "<arguments line=\"1\" column=\"28\"><primary line=\"1\" column=\"28\">true"
			+ "</primary></arguments></call></block></catch>" );
	}
	
	[Test]
	public function testFinally():void
	{
		assertStatement( "1",
			"finally {trace( true ); }",
			"<finally line=\"1\" column=\"9\"><block line=\"1\" column=\"10\">"
			+ "<call line=\"1\" column=\"15\"><primary line=\"1\" column=\"10\">"
			+ "trace</primary><arguments line=\"1\" column=\"17\"><primary line=\"1\" column=\"17\">"
			+ "true</primary></arguments></call></block></finally>" );
	}
	
	[Test]
	public function testTry():void
	{
		assertStatement( "1",
			"try {trace( true ); }",
			"<try line=\"1\" column=\"5\"><block line=\"1\" column=\"6\">"
			+ "<call line=\"1\" column=\"11\"><primary line=\"1\" column=\"6\">"
			+ "trace</primary><arguments line=\"1\" column=\"13\"><primary line=\"1\" column=\"13\">"
			+ "true</primary></arguments></call></block></try>" );
	}
}
}