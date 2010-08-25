package org.teotigraphix.as3parser.impl
{
import org.flexunit.Assert;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.core.ASTPrinter;
import org.teotigraphix.as3parser.core.LinkedListToken;
import org.teotigraphix.as3parser.core.SourceCode;
import org.teotigraphix.as3parser.utils.ASTUtil;

/**
 * Tests, token stream, print stream and ast model of the PRIMARY node.
 */
public class TestPrimaryExpression2
{
	private var parser:AS3Parser2 = new AS3Parser2();
	
	[Before]
	public function setUp():void
	{
		parser = new AS3Parser2();
	}
	
	//----------------------------------
	// compiliation-unit
	//----------------------------------
	
	[Test]
	public function testEmptyPackage():void
	{
		var input:String;
		
		input = "package a { } ";
		assertCompilationUnitPrint(input, 
			"package a { } \n" );
		
		assertCompilationUnit( "1",
			input,
			"<catch line=\"1\" column=\"1\"><name line=\"1\" column=\"8\">e" +
			"</name><type line=\"1\" column=\"12\">Error</type><block " +
			"line=\"1\" column=\"20\"><call line=\"1\" column=\"26\">" +
			"<primary line=\"1\" column=\"21\">trace</primary><arguments " +
			"line=\"1\" column=\"26\"><primary line=\"1\" column=\"28\">" +
			"true</primary></arguments></call></block></catch>" );
	}
	
	
	
	
	
	
	
	//----------------------------------
	// try{} catch(){} finally{}
	//----------------------------------
	
	[Test]
	public function testCatch():void
	{
		var input:String;
		
		input = "catch( e : Error ) {trace( true ); }";
		assertStatementPrint(input, 
			"catch( e : Error ) {trace( true ); }\n" );
		
		assertStatement( "1",
			input,
			"<catch line=\"1\" column=\"1\"><name line=\"1\" column=\"8\">e" +
			"</name><type line=\"1\" column=\"12\">Error</type><block " +
			"line=\"1\" column=\"20\"><call line=\"1\" column=\"26\">" +
			"<primary line=\"1\" column=\"21\">trace</primary><arguments " +
			"line=\"1\" column=\"26\"><primary line=\"1\" column=\"28\">" +
			"true</primary></arguments></call></block></catch>" );
	}
	
	[Test]
	public function testFinally():void
	{
		var input:String;
		
		input = "finally {trace( true ); }";
		assertStatementPrint(input, 
			"finally {trace( true ); }\n" );
		
		assertStatement( "1",
			input,
			"<finally line=\"1\" column=\"1\"><block line=\"1\" column=\"9\">" +
			"<call line=\"1\" column=\"15\"><primary line=\"1\" column=\"10\">" +
			"trace</primary><arguments line=\"1\" column=\"15\"><primary " +
			"line=\"1\" column=\"17\">true</primary></arguments></call>" +
			"</block></finally>" );
	}
	
	[Test]
	public function testTry():void
	{
		var input:String;
		
		input = "try {trace( true ); }";
		assertStatementPrint(input, 
			"try {trace( true ); }\n" );
		
		assertStatement( "1",
			input,
			"<try line=\"1\" column=\"1\"><block line=\"1\" column=\"5\">" +
			"<call line=\"1\" column=\"11\"><primary line=\"1\" column=\"6\">" +
			"trace</primary><arguments line=\"1\" column=\"11\"><primary " +
			"line=\"1\" column=\"13\">true</primary></arguments></call>" +
			"</block></try>" );
	}
	
	//----------------------------------
	// while()
	//----------------------------------
	
	[Test]
	public function testWhile():void
	{
		var input:String;
		
		input = "while( i++ ){ trace( i ); }";
		assertStatementPrint(input, 
			"while( i++ ){ trace( i ); }\n" );
		
		assertStatement( "1",
			input,
			"<while line=\"1\" column=\"1\"><condition line=\"1\" " +
			"column=\"6\"><post-inc line=\"1\" column=\"9\"><primary " +
			"line=\"1\" column=\"8\">i</primary></post-inc></condition>" +
			"<block line=\"1\" column=\"13\"><call line=\"1\" column=\"20\">" +
			"<primary line=\"1\" column=\"15\">trace</primary><arguments " +
			"line=\"1\" column=\"20\"><primary line=\"1\" column=\"22\">i" +
			"</primary></arguments></call></block></while>" );
	}
	
	[Test]
	public function testWhileWithEmptyStatement():void
	{
		var input:String;
		
		input = "while( i++ ); ";
		assertStatementPrint(input, 
			"while( i++ ); \n" );
		
		assertStatement( "1",
			input,
			"<while line=\"1\" column=\"1\"><condition line=\"1\" " +
			"column=\"6\"><post-inc line=\"1\" column=\"9\"><primary " +
			"line=\"1\" column=\"8\">i</primary></post-inc></condition>" +
			"<stmt-empty line=\"1\" column=\"13\">;</stmt-empty></while>" );
	}
	
	[Test]
	public function testWhileWithoutBlock():void
	{
		var input:String;
		
		input = "while( i++ ) trace( i ); ";
		assertStatementPrint(input, 
			"while( i++ ) trace( i ); \n" );
		
		assertStatement( "1",
			input,
			"<while line=\"1\" column=\"1\"><condition line=\"1\" " +
			"column=\"6\"><post-inc line=\"1\" column=\"9\"><primary line=\"1\" " +
			"column=\"8\">i</primary></post-inc></condition><call line=\"1\" " +
			"column=\"19\"><primary line=\"1\" column=\"14\">trace</primary>" +
			"<arguments line=\"1\" column=\"19\"><primary line=\"1\" " +
			"column=\"21\">i</primary></arguments></call></while>" );
	}
	
	//----------------------------------
	// do
	//----------------------------------
	
	[Test]
	public function testDo():void
	{
		var input:String;
		
		input = "do{ trace( i ); } while( i++ );";
		assertStatementPrint(input, 
			"do{ trace( i ); } while( i++ );\n" );
		
		assertStatement( "1",
			input,
			"<do line=\"1\" column=\"1\"><block line=\"1\" column=\"3\">" +
			"<call line=\"1\" column=\"10\"><primary line=\"1\" column=\"5\">" +
			"trace</primary><arguments line=\"1\" column=\"10\"><primary " +
			"line=\"1\" column=\"12\">i</primary></arguments></call></block>" +
			"<condition line=\"1\" column=\"24\"><post-inc line=\"1\" " +
			"column=\"27\"><primary line=\"1\" column=\"26\">i</primary>" +
			"</post-inc></condition></do>" );
	}
	
	[Test]
	public function testDoWithEmptyStatement():void
	{
		var input:String;
		
		input = "do ; while( i++ ); ";
		assertStatementPrint(input, 
			"do ; while( i++ ); \n" );
		
		assertStatement( "1",
			input,
			"<do line=\"1\" column=\"1\"><stmt-empty line=\"1\" column=\"4\">" +
			";</stmt-empty><condition line=\"1\" column=\"11\"><post-inc " +
			"line=\"1\" column=\"14\"><primary line=\"1\" column=\"13\">i" +
			"</primary></post-inc></condition></do>" );
	}
	
	[Test]
	public function testDoWithoutBlock():void
	{
		var input:String;
		
		input = "do trace( i ); while( i++ ); ";
		assertStatementPrint(input, 
			"do trace( i ); while( i++ ); \n" );
		
		assertStatement( "1",
			input,
			"<do line=\"1\" column=\"1\"><call line=\"1\" column=\"9\">" +
			"<primary line=\"1\" column=\"4\">trace</primary><arguments " +
			"line=\"1\" column=\"9\"><primary line=\"1\" column=\"11\">i" +
			"</primary></arguments></call><condition line=\"1\" " +
			"column=\"21\"><post-inc line=\"1\" column=\"24\"><primary " +
			"line=\"1\" column=\"23\">i</primary></post-inc></condition></do>" );
	}
	
	//----------------------------------
	// switch()
	//----------------------------------
	
	[Test]
	public function testFullFeatured():void
	{
		var input:String;
		
		input = "switch( x ){ case 1 : trace('one'); break; default : trace('unknown'); }";
		assertStatementPrint(input, 
			"switch( x ){ case 1 : trace('one'); break; default : trace('unknown'); }\n" );
		
		assertStatement( "1",
			input,
			"<switch line=\"1\" column=\"1\"><condition line=\"1\" column=\"7\">" +
			"<primary line=\"1\" column=\"9\">x</primary></condition><cases " +
			"line=\"1\" column=\"12\"><case line=\"1\" column=\"14\"><primary " +
			"line=\"1\" column=\"19\">1</primary><switch-block line=\"1\" " +
			"column=\"23\"><call line=\"1\" column=\"28\"><primary line=\"1\" " +
			"column=\"23\">trace</primary><arguments line=\"1\" column=\"28\">" +
			"<primary line=\"1\" column=\"29\">'one'</primary></arguments>" +
			"</call><primary line=\"1\" column=\"37\">break</primary></switch-block>" +
			"</case><case line=\"1\" column=\"44\"><default line=\"1\" column=\"44\">" +
			"</default><switch-block line=\"1\" column=\"54\"><call line=\"1\" " +
			"column=\"59\"><primary line=\"1\" column=\"54\">trace</primary>" +
			"<arguments line=\"1\" column=\"59\"><primary line=\"1\" column=\"60\">" +
			"'unknown'</primary></arguments></call></switch-block></case>" +
			"</cases></switch>" );
		
		input = "switch( x ){ case 1 : break; default:}";
		assertStatementPrint(input, 
			"switch( x ){ case 1 : break; default:}\n" );
		
		assertStatement( "1",
			input,
			"<switch line=\"1\" column=\"1\"><condition line=\"1\" " +
			"column=\"7\"><primary line=\"1\" column=\"9\">x</primary>" +
			"</condition><cases line=\"1\" column=\"12\"><case line=\"1\" " +
			"column=\"14\"><primary line=\"1\" column=\"19\">1</primary>" +
			"<switch-block line=\"1\" column=\"23\"><primary line=\"1\" " +
			"column=\"23\">break</primary></switch-block></case><case line=\"1\" " +
			"column=\"30\"><default line=\"1\" column=\"30\"></default>" +
			"<switch-block line=\"1\" column=\"38\"></switch-block></case>" +
			"</cases></switch>" );
	}
	
	//----------------------------------
	// if()
	//----------------------------------
	
	[Test]
	public function testIf():void
	{
		var input:String;
		
		input = "if( true ){ trace( true ); }";
		assertStatementPrint(input, 
			"if( true ){ trace( true ); }\n" );
		
		assertStatement( "1",
			input,
			"<if line=\"1\" column=\"1\"><condition line=\"1\" " +
			"column=\"3\"><primary line=\"1\" column=\"5\">true" +
			"</primary></condition><block line=\"1\" column=\"11\">" +
			"<call line=\"1\" column=\"18\"><primary line=\"1\" " +
			"column=\"13\">trace</primary><arguments line=\"1\" " +
			"column=\"18\"><primary line=\"1\" column=\"20\">true" +
			"</primary></arguments></call></block></if>" );
		
		input = "if( \"property\" in object ){ }";
		assertStatementPrint(input, 
			"if( \"property\" in object ){ }\n" );
		
		assertStatement( "2",
			input,
			"<if line=\"1\" column=\"1\"><condition line=\"1\" " +
			"column=\"3\"><relation line=\"1\" column=\"5\">" +
			"<primary line=\"1\" column=\"5\">\"property\"</primary>" +
			"<op line=\"1\" column=\"16\">in</op><primary line=\"1\" " +
			"column=\"19\">object</primary></relation></condition><block " +
			"line=\"1\" column=\"27\"></block></if>" );
		
		input = "if (col.mx_internal::contentSize) {col.mx_internal::_width = NaN;}";
		assertStatementPrint(input, 
			"if (col.mx_internal::contentSize) {col.mx_internal::_width = NaN;}\n" );
		
		assertStatement( "3",
			input,
			"<if line=\"1\" column=\"1\"><condition line=\"1\" column=\"4\">" +
			"<dot line=\"1\" column=\"8\"><primary line=\"1\" column=\"5\">" +
			"col</primary><dot line=\"1\" column=\"20\"><primary line=\"1\" " +
			"column=\"9\">mx_internal</primary><primary line=\"1\" " +
			"column=\"22\">contentSize</primary></dot></dot></condition>" +
			"<block line=\"1\" column=\"35\"><dot line=\"1\" column=\"39\">" +
			"<primary line=\"1\" column=\"36\">col</primary><dot line=\"1\" " +
			"column=\"51\"><primary line=\"1\" column=\"40\">mx_internal" +
			"</primary><assign line=\"1\" column=\"53\"><primary line=\"1\" " +
			"column=\"53\">_width</primary><op line=\"1\" column=\"60\">=</op>" +
			"<primary line=\"1\" column=\"62\">NaN</primary></assign></dot>" +
			"</dot></block></if>" );
	}
	
	[Test]
	public function testIfElse():void
	{
		var input:String;
		
		input = "if( true ){ trace( true ); } else { trace( false )}";
		assertStatementPrint(input, 
			"if( true ){ trace( true ); } else { trace( false )}\n" );
		
		assertStatement( "1",
			input,
			"<if line=\"1\" column=\"1\"><condition line=\"1\" column=\"3\">" +
			"<primary line=\"1\" column=\"5\">true</primary></condition>" +
			"<block line=\"1\" column=\"11\"><call line=\"1\" column=\"18\">" +
			"<primary line=\"1\" column=\"13\">trace</primary><arguments " +
			"line=\"1\" column=\"18\"><primary line=\"1\" column=\"20\">" +
			"true</primary></arguments></call></block><block line=\"1\" " +
			"column=\"35\"><call line=\"1\" column=\"42\"><primary line=\"1\" " +
			"column=\"37\">trace</primary><arguments line=\"1\" column=\"42\">" +
			"<primary line=\"1\" column=\"44\">false</primary></arguments>" +
			"</call></block></if>" );
	}
	
	[Test]
	public function testIfWithArrayAccessor():void
	{
		var input:String;
		
		input = "if ( chart.getItemAt( 0 )[ xField ] > targetXFieldValue ){}";
		assertStatementPrint(input, 
			"if ( chart.getItemAt( 0 )[ xField ] > targetXFieldValue ){}\n" );
		
		assertStatement( "1",
			input,
			"<if line=\"1\" column=\"1\"><condition line=\"1\" column=\"4\">" +
			"<dot line=\"1\" column=\"11\"><primary line=\"1\" column=\"6\">" +
			"chart</primary><relation line=\"1\" column=\"12\"><call line=\"1\" " +
			"column=\"21\"><primary line=\"1\" column=\"12\">getItemAt</primary>" +
			"<arguments line=\"1\" column=\"21\"><primary line=\"1\" " +
			"column=\"23\">0</primary></arguments><array line=\"1\" " +
			"column=\"26\"><primary line=\"1\" column=\"28\">xField</primary>" +
			"</array></call><op line=\"1\" column=\"37\">&gt;</op><primary " +
			"line=\"1\" column=\"39\">targetXFieldValue</primary></relation>" +
			"</dot></condition><block line=\"1\" column=\"58\"></block></if>" );
	}
	
	[Test]
	public function testIfWithEmptyStatement():void
	{
		var input:String;
		
		input = "if( i++ );";
		assertStatementPrint(input, 
			"if( i++ );\n" );
		
		assertStatement( "1",
			"if( i++ );",
			"<if line=\"1\" column=\"1\"><condition line=\"1\" " +
			"column=\"3\"><post-inc line=\"1\" column=\"6\"><primary " +
			"line=\"1\" column=\"5\">i</primary></post-inc></condition>" +
			"<stmt-empty line=\"1\" column=\"10\">;</stmt-empty></if>" );
	}
	
	[Test]
	public function testIfWithoutBlock():void
	{
		var input:String;
		
		input = "if( i++ ) trace( i );";
		assertStatementPrint(input, 
			"if( i++ ) trace( i );\n" );
		
		assertStatement( "1",
			input,
			"<if line=\"1\" column=\"1\"><condition line=\"1\" column=\"3\">" +
			"<post-inc line=\"1\" column=\"6\"><primary line=\"1\" " +
			"column=\"5\">i</primary></post-inc></condition><call line=\"1\" " +
			"column=\"16\"><primary line=\"1\" column=\"11\">trace</primary>" +
			"<arguments line=\"1\" column=\"16\"><primary line=\"1\" " +
			"column=\"18\">i</primary></arguments></call></if>" );
	}
	
	[Test]
	public function testIfWithReturn():void
	{
		var input:String;
		
		input = "if ( true )return;";
		assertStatementPrint(input, 
			"if ( true )return;\n" );
		
		assertStatement( "",
			"if ( true )return;",
			"<if line=\"1\" column=\"1\"><condition line=\"1\" " +
			"column=\"4\"><primary line=\"1\" column=\"6\">true</primary>" +
			"</condition><return line=\"1\" column=\"12\"></return></if>" );
		
		input = "if ( true )throw new Error();";
		assertStatementPrint(input, 
			"if ( true )throw new Error();\n" );
		
		assertStatement( "",
			input,
			"<if line=\"1\" column=\"1\"><condition line=\"1\" column=\"4\">" +
			"<primary line=\"1\" column=\"6\">true</primary></condition>" +
			"<primary line=\"1\" column=\"12\"><throw line=\"1\" column=\"12\">" +
			"<new line=\"1\" column=\"18\"><call line=\"1\" column=\"27\">" +
			"<primary line=\"1\" column=\"22\">Error</primary><arguments " +
			"line=\"1\" column=\"27\"></arguments></call></new></throw>" +
			"</primary></if>" );
	}
	
	//----------------------------------
	// for()
	//----------------------------------
	
	[Test]
	public function testSimpleFor():void
	{
		var input:String;
		
		input = "for( var i : int = 0; i < length; i++ ){ trace( i ); }";
		assertStatementPrint(input, 
			"for( var i : int = 0; i < length; i++ ){ trace( i ); }\n" );
		
		assertStatement("1",
			input,
			"<for line=\"1\" column=\"1\"><init line=\"1\" column=\"6\">" +
			"<var-list line=\"1\" column=\"6\"><name-type-init line=\"1\" " +
			"column=\"10\"><name line=\"1\" column=\"10\">i</name><type line=\"1\" " +
			"column=\"14\">int</type><init line=\"1\" column=\"20\"><primary " +
			"line=\"1\" column=\"20\">0</primary></init></name-type-init>" +
			"</var-list></init><cond line=\"1\" column=\"23\"><relation line=\"1\" " +
			"column=\"23\"><primary line=\"1\" column=\"23\">i</primary><op line=\"1\" " +
			"column=\"25\">&lt;</op><primary line=\"1\" column=\"27\">length" +
			"</primary></relation></cond><iter line=\"1\" column=\"35\"><post-inc " +
			"line=\"1\" column=\"36\"><primary line=\"1\" column=\"35\">i</primary>" +
			"</post-inc></iter><block line=\"1\" column=\"40\"><call line=\"1\" " +
			"column=\"47\"><primary line=\"1\" column=\"42\">trace</primary>" +
			"<arguments line=\"1\" column=\"47\"><primary line=\"1\" " +
			"column=\"49\">i</primary></arguments></call></block></for>");
		
		assertStatement("",
			"for (i = 0; i < n; i++)",
			"<for line=\"1\" column=\"1\"><init line=\"1\" column=\"6\">" +
			"<assign line=\"1\" column=\"6\"><primary line=\"1\" " +
			"column=\"6\">i</primary><op line=\"1\" column=\"8\">=</op>" +
			"<primary line=\"1\" column=\"10\">0</primary></assign></init>" +
			"<cond line=\"1\" column=\"13\"><relation line=\"1\" column=\"13\">" +
			"<primary line=\"1\" column=\"13\">i</primary><op line=\"1\" " +
			"column=\"15\">&lt;</op><primary line=\"1\" column=\"17\">n</primary>" +
			"</relation></cond><iter line=\"1\" column=\"20\"><post-inc " +
			"line=\"1\" column=\"21\"><primary line=\"1\" column=\"20\">i" +
			"</primary></post-inc></iter><primary line=\"2\"" +
			" column=\"1\">__END__</primary></for>");
	}
	
	
	[Test]
	public function testSimpleForEach():void
	{
		var input:String;
		
		input = "for each( var obj : Object in list ){ obj.print( i ); }";
		assertStatementPrint(input, 
			"for each( var obj : Object in list ){ obj.print( i ); }\n" );
		
		assertStatement("1",
			input,
			"<foreach line=\"1\" column=\"1\"><var line=\"1\" column=\"11\">" +
			"<name-type-init line=\"1\" column=\"15\"><name line=\"1\" " +
			"column=\"15\">obj</name><type line=\"1\" column=\"21\">Object" +
			"</type></name-type-init></var><in line=\"1\" column=\"28\">" +
			"<primary line=\"1\" column=\"31\">list</primary></in><block " +
			"line=\"1\" column=\"37\"><dot line=\"1\" column=\"42\"><primary " +
			"line=\"1\" column=\"39\">obj</primary><call line=\"1\" " +
			"column=\"48\"><primary line=\"1\" column=\"43\">print" +
			"</primary><arguments line=\"1\" column=\"48\"><primary " +
			"line=\"1\" column=\"50\">i</primary></arguments></call>" +
			"</dot></block></foreach>");
		
		input = "for each( obj in list ){}";
		assertStatementPrint(input, 
			"for each( obj in list ){}\n" );
		
		assertStatement( "2",
			input,
			"<foreach line=\"1\" column=\"1\"><name line=\"1\" " +
			"column=\"11\">obj</name><in line=\"1\" column=\"15\">" +
			"<primary line=\"1\" column=\"18\">list</primary></in>" +
			"<block line=\"1\" column=\"24\"></block></foreach>" );
		
		input = "for each (var a:XML in xml.classInfo..accessor) {}";
		assertStatementPrint(input, 
			"for each (var a:XML in xml.classInfo..accessor) {}\n" );
		
		assertStatement("3", 
			input,
			"<foreach line=\"1\" column=\"1\"><var line=\"1\" " +
			"column=\"11\"><name-type-init line=\"1\" column=\"15\">" +
			"<name line=\"1\" column=\"15\">a</name><type line=\"1\" " +
			"column=\"17\">XML</type></name-type-init></var><in line=\"1\" " +
			"column=\"21\"><dot line=\"1\" column=\"27\"><primary line=\"1\" " +
			"column=\"24\">xml</primary><e4x-descendent line=\"1\" " +
			"column=\"37\"><primary line=\"1\" column=\"28\">classInfo" +
			"</primary><primary line=\"1\" column=\"39\">accessor</primary>" +
			"</e4x-descendent></dot></in><block line=\"1\" column=\"49\">" +
			"</block></foreach>");
	}
	
	[Test]
	public function testSimpleForIn():void
	{
		var input:String;
		
		input = "for( var s : String in obj ){ trace( s, obj[ s ]); }";
		assertStatementPrint(input, 
			"for( var s : String in obj ){ trace( s, obj[ s ]); }\n" );
		
		assertStatement( "1",
			input,
			"<forin line=\"1\" column=\"1\"><init line=\"1\" column=\"6\">" +
			"<var-list line=\"1\" column=\"6\"><name-type-init line=\"1\" " +
			"column=\"10\"><name line=\"1\" column=\"10\">s</name><type " +
			"line=\"1\" column=\"14\">String</type></name-type-init>" +
			"</var-list></init><in line=\"1\" column=\"21\"><primary " +
			"line=\"1\" column=\"24\">obj</primary></in><block line=\"1\" " +
			"column=\"29\"><call line=\"1\" column=\"36\"><primary line=\"1\" " +
			"column=\"31\">trace</primary><arguments line=\"1\" column=\"36\">" +
			"<primary line=\"1\" column=\"38\">s</primary><arr-acc line=\"1\" " +
			"column=\"44\"><primary line=\"1\" column=\"41\">obj</primary>" +
			"<primary line=\"1\" column=\"46\">s</primary></arr-acc></arguments>" +
			"</call></block></forin>" );
		
	}
	
	protected function assertCompilationUnit(message:String, input:String, expected:String):void
	{
		var lines:Array = 
			[
				input,
				"__END__"
			];
		
		parser.scanner.setLines(ASTUtil.toVector(lines));
		
		var result:String = ASTUtil.convert(parser.parseCompilationUnit());
		Assert.assertEquals(message, expected, result);
	}
	
	protected function assertStatement(message:String, input:String, expected:String):void
	{
		var lines:Array = 
			[
				input,
				"__END__"
			];
		
		parser.scanner.setLines(ASTUtil.toVector(lines));
		
		parser.nextToken();
		
		var result:String = ASTUtil.convert(parser.parseStatement());
		Assert.assertEquals(message, expected, result);
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	[Test]
	public function testBooleans():void
	{
		assertPrimaryTokens("true", ["true"]);
		assertPrimaryPrint( "true", "true\n" );
		assertPrimary("true", "true");
		
		assertPrimaryTokens("false", ["false"]);
		assertPrimaryPrint( "false", "false\n" );
		assertPrimary("false", "false");
	}
	
	[Test]
	public function testNull():void
	{
		assertPrimaryTokens("null", ["null"]);
		assertPrimaryPrint( "null", "null\n" );
		assertPrimary("null", "null");
	}
	
	[Test]
	public function testUndefined():void
	{
		assertPrimary("undefined", "undefined");
		assertPrimaryPrint( "undefined", "undefined\n" );
	}
	
	[Test]
	public function testInfinity():void
	{
		assertPrimary("Infinity", "Infinity");
		assertPrimaryPrint( "Infinity", "Infinity\n" );
		
		assertPrimary("-Infinity", "-Infinity");
		assertPrimaryPrint( "-Infinity", "-Infinity\n" );
	}
	
	[Test]
	public function testNumbers():void
	{
		assertPrimaryTokens("1", ["1"]);
		assertPrimary("1", "1");
		assertPrimaryPrint( "1", "1\n" );
		
		assertPrimaryTokens("0xff", ["0xff"]);
		assertPrimary("0xff", "0xff");
		assertPrimaryPrint( "0xff", "0xff\n" );
		
		assertPrimaryTokens("0420", ["0420"]);
		assertPrimary("0420", "0420");
		assertPrimaryPrint( "0420", "0420\n" );
		
		assertPrimaryTokens(".42E2", [".42E2"]);
		assertPrimary(".42E2", ".42E2");
		assertPrimaryPrint( ".42E2", ".42E2\n" );
	}
	
	[Test]
	public function testStrings():void
	{
		assertPrimary("\"string\"", "\"string\"");
		assertPrimaryPrint( "\"string\"", "\"string\"\n" );
		
		assertPrimary("'string'", "'string'");
		assertPrimaryPrint( "'string'", "'string'\n" );
	}
	
	[Test]
	public function testArrayLiteral():void
	{
		var input:String = "[1,2,3]";
		
		var tokens:Array =
			[
				null,null,"[","1",",","2",",","3","]","\n"
			];
		
		assertPrimaryTokens(input, tokens);
		
		assertPrimaryPrint(input, "[1,2,3]\n" );
		
		assertPrimary(input,
			"<array line=\"1\" column=\"1\"><primary line=\"1\" column=\"2\">1"
			+ "</primary><primary line=\"1\" column=\"4\">2</primary>"
			+ "<primary line=\"1\" column=\"6\">3</primary></array>");
	}
	
	[Test]
	public function testObjectLiteral():void
	{
		var input:String = "{a:1,b:2}";
		
		var tokens:Array =
			[
				null,null,"{","a",":","1",",","b",":","2","}","\n"
			];
		
		//printTokens(input, tokens);
		
		//assertPrimaryTokens(input, tokens);
		
		assertPrimaryPrint(input, "{a:1,b:2}\n" );
		
		assertPrimary( "{a:1,b:2}",
			"<object line=\"1\" column=\"1\"><prop line=\"1\" column=\"2\">"
			+ "<name line=\"1\" column=\"2\">a</name><value line=\"1\" column=\"4\">"
			+ "<primary line=\"1\" column=\"4\">1</primary></value></prop><prop line=\"1\" column=\"6\">"
			+ "<name line=\"1\" column=\"6\">b</name><value line=\"1\" column=\"8\">"
			+ "<primary line=\"1\" column=\"8\">2</primary></value></prop></object>" );
	}
	
	[Test]
	public function testFunctionLiteral():void
	{
		assertPrimary( "function ( a : Object ) : * { trace('test'); }",
			"<lambda line=\"1\" column=\"1\">" +
			"<parameter-list line=\"1\" column=\"10\"><parameter line=\"1\" " +
			"column=\"12\"><name-type-init line=\"1\" column=\"12\"><name " +
			"line=\"1\" column=\"12\">a</name><type line=\"1\" column=\"16\">" +
			"Object</type></name-type-init></parameter></parameter-list>" +
			"<type line=\"1\" column=\"27\">*</type><block line=\"1\" " +
			"column=\"29\"><call line=\"1\" column=\"36\"><primary line=\"1\" " +
			"column=\"31\">trace</primary><arguments line=\"1\" column=\"36\">" +
			"<primary line=\"1\" column=\"37\">'test'</primary></arguments>" +
			"</call></block></lambda>" );
	}
	
	private function printTokens(input:String,
								 tokens:Array):void
	{
		var ast:IParserNode = parsePrimary(input);
		Assert.assertNotNull(ast.startToken);
		
		var next:LinkedListToken = ast.startToken;
		
		for each (var token:String in tokens)
		{
			trace("expected [" + token + "] result [" + next.text + "]");
			next = next.next;
		}
	}
	
	private function assertPrimaryTokens(input:String,
										 tokens:Array):void
	{
		var ast:IParserNode = parsePrimary(input);
		Assert.assertNotNull(ast.startToken);
		
		var next:LinkedListToken = ast.startToken;
		
		for each (var token:String in tokens)
		{
			Assert.assertEquals(token, next.text);
			next = next.next;
		}
	}
	
	private function assertCompilationUnitPrint(input:String, 
												expected:String):void
	{
		var printer:ASTPrinter = createPrinter();
		printer.print(parseCompilationUnit(input));
		
		Assert.assertEquals(expected, printer.toString());
	}
	
	private function assertStatementPrint(input:String, 
										  expected:String):void
	{
		var printer:ASTPrinter = createPrinter();
		printer.print(parseStatement(input));
		
		Assert.assertEquals(expected, printer.toString());
	}
	
	private function assertPrimaryPrint(input:String, 
										expected:String):void
	{
		var printer:ASTPrinter = createPrinter();
		printer.print(parsePrimary(input));
		
		Assert.assertEquals(expected, printer.toString());
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
	
	private function parseCompilationUnit(input:String):IParserNode
	{
		parser.scanner.setLines(Vector.<String>([input]));
		
		return parser.parseCompilationUnit();
	}
	
	private function parseStatement(input:String):IParserNode
	{
		parser.scanner.setLines(Vector.<String>([input]));
		
		parser.nextToken(); // first call
		
		return parser.parseStatement();
	}
	
	private function parsePrimary(input:String):IParserNode
	{
		parser.scanner.setLines(Vector.<String>([input]));
		
		parser.nextToken(); // first call
		
		return parser.parsePrimaryExpression();
	}
	
	private function createPrinter():ASTPrinter
	{
		var sourceCode:SourceCode = new SourceCode();
		var printer:ASTPrinter = new ASTPrinter(sourceCode);
		return printer;
	}
}
}