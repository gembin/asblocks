package org.teotigraphix.as3parser.impl
{
public class TestIfStatement extends AbstractStatementTest
{
	[Test]
	public function testIf():void
	{
		assertStatement( "1",
			"if( true ){ trace( true ); }",
			"<if line=\"1\" column=\"3\">"
			+ "<condition line=\"1\" column=\"5\">"
			+ "<primary line=\"1\" column=\"5\">true</primary></condition>"
			+ "<block line=\"1\" column=\"13\"><call line=\"1\" column=\"18\">"
			+ "<primary line=\"1\" column=\"13\">trace"
			+ "</primary><arguments line=\"1\" column=\"20\">"
			+ "<primary line=\"1\" column=\"20\">true</primary>"
			+ "</arguments></call></block></if>" );
		
		assertStatement( "1",
			"if( \"i\" in oaderContext ){ }",
			"<if line=\"1\" column=\"3\"><condition line=\"1\" column=\"5\">"
			+ "<relation line=\"1\" column=\"5\"><primary line=\"1\" column=\"5\">"
			+ "\"i\"</primary><op line=\"1\" column=\"9\">in</op>"
			+ "<primary line=\"1\" column=\"12\">oaderContext</primary>"
			+ "</relation></condition><block line=\"1\" column=\"28\"></block></if>" );
		
		assertStatement( "internal",
			"if (col.mx_internal::contentSize) {col.mx_internal::_width = NaN;}",
			"<if line=\"1\" column=\"4\"><condition line=\"1\" column=\"5\">"
			+ "<dot line=\"1\" column=\"9\"><primary line=\"1\" column=\"5\">col"
			+ "</primary><dot line=\"1\" column=\"22\"><primary line=\"1\" column=\"9\">"
			+ "mx_internal</primary><primary line=\"1\" column=\"22\">contentSize"
			+ "</primary></dot></dot></condition><block line=\"1\" column=\"36\">"
			+ "<dot line=\"1\" column=\"40\"><primary line=\"1\" column=\"36\">col"
			+ "</primary><dot line=\"1\" column=\"53\"><primary line=\"1\" column=\"40\">"
			+ "mx_internal</primary><assign line=\"1\" column=\"53\">"
			+ "<primary line=\"1\" column=\"53\">_width</primary>"
			+ "<op line=\"1\" column=\"60\">=</op><primary line=\"1\" column=\"62\">"
			+ "NaN</primary></assign></dot></dot></block></if>" );
	}
	
	[Test]
	public function testIfElse():void
	{
		assertStatement( "1",
			"if( true ){ trace( true ); } else { trace( false )}",
			"<if line=\"1\" column=\"3\"><condition line=\"1\" column=\"5\">"
			+ "<primary line=\"1\" column=\"5\">true"
			+ "</primary></condition><block line=\"1\" column=\"13\">"
			+ "<call line=\"1\" column=\"18\"><primary line=\"1\" column=\"13\">trace"
			+ "</primary><arguments line=\"1\" column=\"20\">"
			+ "<primary line=\"1\" column=\"20\">true</primary></arguments>"
			+ "</call></block><block line=\"1\" column=\"37\">"
			+ "<call line=\"1\" column=\"42\">"
			+ "<primary line=\"1\" column=\"37\">trace</primary>"
			+ "<arguments line=\"1\" column=\"44\">"
			+ "<primary line=\"1\" column=\"44\">false</primary>"
			+ "</arguments></call></block></if>" );
	}
	
	[Test]
	public function testIfWithArrayAccessor():void
	{
		assertStatement( "",
			"if ( chart.getItemAt( 0 )[ xField ] > targetXFieldValue ){}",
			"<if line=\"1\" column=\"4\"><condition line=\"1\" column=\"6\"><dot line=\"1\""
			+ " column=\"12\"><primary line=\"1\" "
			+ "column=\"6\">chart</primary><relation line=\"1\" "
			+ "column=\"12\"><call line=\"1\" column=\"21\"><primary line=\"1\" "
			+ "column=\"12\">getItemAt</primary><arguments line=\"1\" "
			+ "column=\"23\"><primary line=\"1\" "
			+ "column=\"23\">0</primary></arguments><array line=\"1\" "
			+ "column=\"26\"><primary line=\"1\" "
			+ "column=\"28\">xField</primary></array></call><op line=\"1\" "
			+ "column=\"37\">&gt;</op><primary "
			+ "line=\"1\" column=\"39\">targetXFieldValue</primary>"
			+ "</relation></dot></condition><block line=\"1\" "
			+ "column=\"59\"></block></if>" );
	}
	
	[Test]
	public function testIfWithEmptyStatement():void
	{
		assertStatement( "1",
			"if( i++ ); ",
			"<if line=\"1\" column=\"3\"><condition line=\"1\" column=\"5\">"
			+ "<post-inc line=\"1\" column=\"9\"><primary line=\"1\" column=\"5\">"
			+ "i</primary></post-inc></condition><stmt-empty line=\"1\" column=\"10\">;"
			+ "</stmt-empty></if>" );
	}
	
	[Test]
	public function testIfWithoutBlock():void
	{
		assertStatement( "1",
			"if( i++ ) trace( i ); ",
			"<if line=\"1\" column=\"3\"><condition line=\"1\" column=\"5\">"
			+ "<post-inc line=\"1\" column=\"9\"><primary line=\"1\" column=\"5\">i"
			+ "</primary></post-inc></condition><call line=\"1\" column=\"16\">"
			+ "<primary line=\"1\" column=\"11\">trace</primary><arguments line=\"1\" "
			+ "column=\"18\"><primary line=\"1\" column=\"18\">i</primary>"
			+ "</arguments></call></if>" );
	}
	
	[Test]
	public function testIfWithReturn():void
	{
		assertStatement( "",
			"if ( true )return;",
			"<if line=\"1\" column=\"4\"><condition line=\"1\" column=\"6\"><primary line=\"1\" "
			+ "column=\"6\">true</primary></condition><return line=\"2\" "
			+ "column=\"1\"></return></if>" );
		
		assertStatement( "",
			"if ( true )throw new Error();",
			"<if line=\"1\" column=\"4\"><condition line=\"1\" column=\"6\"><primary line=\"1\" "
			+ "column=\"6\">true</primary></condition><primary line=\"1\" column=\"12\">"
			+ "throw</primary></if>" );
	}
}
}