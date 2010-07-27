package org.teotigraphix.as3parser.impl
{

public class TestForStatement extends AbstractStatementTest
{
	[Test]
	public function testSimpleFor():void
	{
		assertStatement( "1",
			"for( var i : int = 0; i < length; i++ ){ trace( i ); }",
			"<for line=\"1\" column=\"6\"><init line=\"1\" column=\"6\">"
			+ "<var-list line=\"1\" column=\"10\"><name-type-init line=\"1\" "
			+ "column=\"10\"><name line=\"1\" column=\"10\">i</name><type line=\"1\" "
			+ "column=\"14\">int</type><init line=\"1\" column=\"20\">"
			+ "<primary line=\"1\" column=\"20\">0</primary></init>"
			+ "</name-type-init></var-list></init>"
			+ "<cond line=\"1\" column=\"23\"><relation line=\"1\" column=\"23\">"
			+ "<primary line=\"1\" column=\"23\">i</primary><op line=\"1\" "
			+ "column=\"25\">&lt;</op><primary line=\"1\" column=\"27\">length"
			+ "</primary></relation></cond><iter line=\"1\" column=\"35\">"
			+ "<post-inc line=\"1\" column=\"39\"><primary line=\"1\" column=\"35\">i"
			+ "</primary></post-inc></iter><block line=\"1\" column=\"42\"><call line=\"1\" "
			+ "column=\"47\"><primary line=\"1\" column=\"42\">trace"
			+ "</primary><arguments line=\"1\" column=\"49\"><primary line=\"1\" column=\"49\">i"
			+ "</primary></arguments></call></block></for>" );
		
		assertStatement( "",
			"        for (i = 0; i < n; i++)",
			"<for line=\"1\" column=\"14\"><init line=\"1\" column=\"14\">"
			+ "<assign line=\"1\" column=\"14\"><primary line=\"1\" column=\"14\">"
			+ "i</primary><op line=\"1\" column=\"16\">=</op>"
			+ "<primary line=\"1\" column=\"18\">0</primary></assign></init>"
			+ "<cond line=\"1\" column=\"21\"><relation line=\"1\" column=\"21\">"
			+ "<primary line=\"1\" column=\"21\">i</primary>"
			+ "<op line=\"1\" column=\"23\">&lt;</op><primary line=\"1\" column=\"25\">n"
			+ "</primary></relation></cond><iter line=\"1\" column=\"28\">"
			+ "<post-inc line=\"1\" column=\"31\"><primary line=\"1\" column=\"28\">i"
			+ "</primary></post-inc></iter><primary line=\"2\" column=\"1\">__END__</primary></for>" );
	}
	
	[Test]
	public function testSimpleForEach():void
	{
		assertStatement( "1",
			"for each( var obj : Object in list ){ obj.print( i ); }",
			"<foreach line=\"1\" column=\"11\"><var line=\"1\" column=\"11\">"
			+ "<name-type-init line=\"1\" column=\"15\"><name line=\"1\" "
			+ "column=\"15\">obj</name><type line=\"1\" column=\"21\">Object"
			+ "</type></name-type-init></var><in line=\"1\" column=\"31\">"
			+ "<primary line=\"1\" column=\"31\">list</primary></in>"
			+ "<block line=\"1\" column=\"39\"><dot line=\"1\" column=\"43\">"
			+ "<primary line=\"1\" column=\"39\">obj</primary><call line=\"1\" "
			+ "column=\"48\"><primary line=\"1\" column=\"43\">print</primary>"
			+ "<arguments line=\"1\" column=\"50\"><primary line=\"1\" column=\"50\">"
			+ "i</primary></arguments></call></dot></block></foreach>" );
		
		assertStatement( "1",
			"for each( obj in list ){}",
			"<foreach line=\"1\" column=\"11\"><name line=\"1\" column=\"11\">obj</name>"
			+ "<in line=\"1\" column=\"18\"><primary line=\"1\" column=\"18\">list</primary>"
			+ "</in><block line=\"1\" column=\"25\"></block></foreach>" );
		
		// assertStatement(
		// "", "for each (var a:XML in classInfo..accessor) {}", "" );
	}
	
	[Test]
	public function testSimpleForIn():void
	{
		assertStatement( "1",
			"for( var s : String in obj ){ trace( s, obj[ s ]); }",
			"<forin line=\"1\" column=\"6\"><init line=\"1\" column=\"6\">"
			+ "<var-list line=\"1\" column=\"10\"><name-type-init line=\"1\" "
			+ "column=\"10\"><name line=\"1\" column=\"10\">s</name>"
			+ "<type line=\"1\" column=\"14\">String</type></name-type-init>"
			+ "</var-list></init><in line=\"1\" column=\"24\"><primary line=\"1\" "
			+ "column=\"24\">obj</primary></in></forin>" );
		
		assertStatement( "for in",
			"            for (p in events);",
			"<forin line=\"1\" column=\"18\"><init line=\"1\" column=\"18\">"
			+ "<primary line=\"1\" column=\"18\">p</primary></init><in line=\"1\" "
			+ "column=\"23\"><primary line=\"1\" column=\"23\">events</primary></in></forin>" );
	}
}
}