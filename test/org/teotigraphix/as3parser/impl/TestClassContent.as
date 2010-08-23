package org.teotigraphix.as3parser.impl
{
import flexunit.framework.Assert;

import org.teotigraphix.as3parser.utils.ASTUtil;

public class TestClassContent
{
	private var parser:AS3Parser;
	
	[Before]
	public function setUp():void
	{
		parser = new AS3Parser();
	}
	
	[Test]
	public function testConstDeclarations():void
	{
		assertClassContent("1",
			"const a",
			"<const-list line=\"2\" column=\"7\"><name-type-init line=\"2\" " +
			"column=\"7\"><name line=\"2\" column=\"7\">a</name><type line=\"3\" " +
			"column=\"1\"></type></name-type-init></const-list>");
		
		assertClassContent("2",
			"public const a",
			"<const-list line=\"2\" column=\"14\"><mod-list line=\"2\" column=\"1\">"
			+ "<mod line=\"2\" column=\"1\">public</mod></mod-list><name-type-init line=\"2\" "
			+ "column=\"14\"><name line=\"2\" column=\"14\">a</name><type line=\"3\" column=\"1\">"
			+ "</type></name-type-init></const-list>");
		
		assertClassContent("3",
			"public static const a : int = 0",
			"<const-list line=\"2\" column=\"21\"><mod-list line=\"2\" column=\"1\">"
			+ "<mod line=\"2\" column=\"1\">public</mod><mod line=\"2\" column=\"8\">"
			+ "static</mod></mod-list><name-type-init line=\"2\" column=\"21\"><name "
			+ "line=\"2\" column=\"21\">a</name><type line=\"2\" column=\"25\">int</type>"
			+ "<init line=\"2\" column=\"31\"><primary line=\"2\" column=\"31\">0</primary>"
			+ "</init></name-type-init></const-list>");
		
		assertClassContent("4",
			"[Bindable] const a",
			"<const-list line=\"2\" column=\"18\">" +
			"<meta-list line=\"2\" column=\"1\"><meta line=\"2\" column=\"1\">" +
			"<name line=\"2\" column=\"2\">Bindable</name></meta></meta-list>" +
			"<name-type-init line=\"2\" column=\"18\"><name line=\"2\" column=\"18\">" +
			"a</name><type line=\"3\" column=\"1\"></type></name-type-init>" +
			"</const-list>");
	}
	
	[Test]
	public function testImports():void
	{
		assertClassContent("1",
			"import a.b.c;",
			"<import line=\"2\" column=\"8\">a.b.c</import>");
		
		assertClassContent("2",
			"import a.b.c import x.y.z",
			"<import line=\"2\" column=\"8\">a.b.c</import>" + 
			"<import line=\"2\" column=\"21\">x.y.z</import>");
	}
	
	[Test]
	public function testMethods():void
	{
		assertClassContent("1",
			"function a(){}",
			"<function line=\"2\" column=\"13\"><name line=\"2\" column=\"10\">a</name>" +
			"<parameter-list line=\"2\" column=\"12\"></parameter-list><type line=\"2\" " +
			"column=\"13\"></type><block line=\"2\" column=\"14\"></block></function>");

		assertClassContent("2",
			"function set a( value : int ) : void {}",
			"<set line=\"2\" column=\"38\"><name line=\"2\" column=\"14\">a</name>"
			+ "<parameter-list line=\"2\" column=\"17\"><parameter line=\"2\" column=\"17\">"
			+ "<name-type-init line=\"2\" column=\"17\"><name line=\"2\" column=\"17\">value"
			+ "</name><type line=\"2\" column=\"25\">int</type></name-type-init></parameter>"
			+ "</parameter-list><type line=\"2\" column=\"33\">void</type><block line=\"2\" "
			+ "column=\"39\"></block></set>");
		
		assertClassContent("3",
			"function get a() : int {}",
			"<get line=\"2\" column=\"24\"><name line=\"2\" column=\"14\">a</name>" +
			"<parameter-list line=\"2\" column=\"16\"></parameter-list><type line=\"2\" " +
			"column=\"20\">int</type><block line=\"2\" column=\"25\"></block></get>");
		
		assertClassContent( "function with default parameter",
			"public function newLine ( height:*='' ):void{}",
			"<function line=\"2\" column=\"45\"><mod-list line=\"2\" column=\"1\"><mod line=\"2\" "
			+ "column=\"1\">public</mod></mod-list><name line=\"2\" column=\"17\">newLine"
			+ "</name><parameter-list line=\"2\" column=\"27\"><parameter line=\"2\" "
			+ "column=\"27\"><name-type-init line=\"2\" column=\"27\"><name line=\"2\" "
			+ "column=\"27\">height</name><type line=\"2\" column=\"34\">*</type>"
			+ "<init line=\"2\" column=\"36\"><primary line=\"2\" column=\"36\">''"
			+ "</primary></init></name-type-init></parameter></parameter-list>"
			+ "<type line=\"2\" column=\"41\">void</type><block line=\"2\" column=\"46\">"
			+ "</block></function>" );
	}
	
	[Test]
	public function testMethodsWithAsDoc():void
	{
		var lines:Array =
			[
				"{",
				"/** AsDoc */public function a(){}",
				"}",
				"__END__"
			];
		
		parser.scanner.setLines(ASTUtil.toVector(lines));
		
		parser.nextToken(); // first call
		parser.nextToken(); // skip {
		
		Assert.assertEquals( "<content line=\"2\" column=\"12\"><function line=\"2\" column=\"32\">"
			+ "<as-doc line=\"2\" column=\"1\">/** AsDoc */</as-doc><mod-list "
			+ "line=\"2\" column=\"13\"><mod line=\"2\" column=\"13\">public</mod>"
			+ "</mod-list><name line=\"2\" column=\"29\">a</name><parameter-list "
			+ "line=\"2\" column=\"31\"></parameter-list><type line=\"2\" column=\"32\">"
			+ "</type><block line=\"2\" column=\"33\"></block></function></content>",
			ASTUtil.convert(parser.parseClassContent()) );
	}
	
	[Test]
	public function testMethodWithMetadataComment():void
	{
		var lines:Array =
			[
				"{",
				"/** Comment */ [Bindable] public function a () : void { }",
				"}",
				"__END__"
			];
		
		parser.scanner.setLines(ASTUtil.toVector(lines));
		
		parser.nextToken(); // first call
		parser.nextToken(); // skip {
		
		var result:String = ASTUtil.convert(parser.parseClassContent());
		
		Assert.assertEquals("<content line=\"2\" column=\"14\"><function " +
			"line=\"2\" column=\"55\"><meta-list line=\"2\" column=\"16\">" +
			"<meta line=\"2\" column=\"16\"><as-doc line=\"2\" column=\"1\">/**" +
			" Comment */</as-doc><name line=\"2\" column=\"17\">Bindable</name>" +
			"</meta></meta-list><mod-list line=\"2\" column=\"27\"><mod line=\"2\" " +
			"column=\"27\">public</mod></mod-list><name line=\"2\" column=\"43\">a" +
			"</name><parameter-list line=\"2\" column=\"46\"></parameter-list><type " +
			"line=\"2\" column=\"50\">void</type><block line=\"2\" column=\"57\"></block>" +
			"</function></content>",
			result);
	}
	
	[Test]
	public function testRestParameter():void
	{
		assertClassContent("",
			"public function log(message:String, ... rest):void{}",
			"<function line=\"2\" column=\"51\"><mod-list line=\"2\" column=\"1\">"
			+ "<mod line=\"2\" column=\"1\">public</mod></mod-list><name line=\"2\" column=\"17\">"
			+ "log</name><parameter-list line=\"2\" column=\"21\">"
			+ "<parameter line=\"2\" column=\"21\"><name-type-init line=\"2\" column=\"21\">"
			+ "<name line=\"2\" column=\"21\">message</name><type line=\"2\" column=\"29\">String"
			+ "</type></name-type-init></parameter><parameter line=\"2\" column=\"37\">"
			+ "<rest line=\"2\" column=\"41\">rest</rest></parameter></parameter-list>"
			+ "<type line=\"2\" column=\"47\">void</type><block line=\"2\" column=\"52\">"
			+ "</block></function>");
	}
	
	[Test]
	public function testVarDeclarations():void
	{
		assertClassContent("1",
			"var a",
			"<var-list line=\"2\" column=\"5\"><name-type-init line=\"2\" column=\"5\">" +
			"<name line=\"2\" column=\"5\">a" +
			"</name><type line=\"3\" column=\"1\"></type></name-type-init></var-list>" );
		
		assertClassContent("2",
			"public var a;",
			"<var-list line=\"2\" column=\"12\"><mod-list line=\"2\" column=\"1\">"
			+ "<mod line=\"2\" column=\"1\">public</mod></mod-list><name-type-init line=\"2\" "
			+ "column=\"12\"><name line=\"2\" column=\"12\">a</name><type line=\"2\" "
			+ "column=\"13\"></type></name-type-init></var-list>");
		
		assertClassContent("3",
			"public static var a : int = 0",
			"<var-list line=\"2\" column=\"19\"><mod-list line=\"2\" column=\"1\">"
			+ "<mod line=\"2\" column=\"1\">public</mod><mod line=\"2\" column=\"8\">"
			+ "static</mod></mod-list><name-type-init line=\"2\" column=\"19\">"
			+ "<name line=\"2\" column=\"19\">a</name><type line=\"2\" column=\"23\">int</type>"
			+ "<init line=\"2\" column=\"29\"><primary line=\"2\" column=\"29\">0</primary>"
			+ "</init></name-type-init></var-list>");
		
		assertClassContent("4",
			"[Bindable] var a",
			"<var-list line=\"2\" column=\"16\">" +
			"<meta-list line=\"2\" column=\"1\"><meta line=\"2\" column=\"1\">" +
			"<name line=\"2\" column=\"2\">Bindable</name></meta></meta-list>" +
			"<name-type-init line=\"2\" column=\"16\"><name line=\"2\" " +
			"column=\"16\">a</name><type line=\"3\" column=\"1\"></type>" +
			"</name-type-init></var-list>" );
	}
	
	private function assertClassContent(message:String, 
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
		
		var result:String = ASTUtil.convert(parser.parseClassContent());
		
		Assert.assertEquals("<content line=\"2\" column=\"1\">" + 
			expected + "</content>", result);
	}
}
}