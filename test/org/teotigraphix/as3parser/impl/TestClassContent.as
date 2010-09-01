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
			"<const-list line=\"2\" column=\"1\"><name-type-init line=\"2\" " +
			"column=\"7\"><name line=\"2\" column=\"7\">a</name></name-type-init>" +
			"</const-list>");
		
		assertClassContent("2",
			"public const a",
			"<const-list line=\"2\" column=\"1\">" +
			"<mod line=\"2\" column=\"1\">public</mod><name-type-init line=\"2\" " +
			"column=\"14\"><name line=\"2\" column=\"14\">a</name></name-type-init>" +
			"</const-list>");
		
		assertClassContent("3",
			"public static const a : int = 0",
			"<const-list line=\"2\" column=\"1\"><mod line=\"2\" column=\"1\">" +
			"public</mod><mod line=\"2\" column=\"8\">static</mod>" +
			"<name-type-init line=\"2\" column=\"21\"><name line=\"2\" " +
			"column=\"21\">a</name><type line=\"2\" column=\"25\">int</type>" +
			"<init line=\"2\" column=\"31\"><number line=\"2\" column=\"31\">" +
			"0</number></init></name-type-init></const-list>");
		
		assertClassContent("4",
			"[Bindable] const a",
			"<const-list line=\"2\" column=\"1\"><meta line=\"2\" column=\"1\">" +
			"<name line=\"2\" column=\"2\">Bindable</name></meta><name-type-init " +
			"line=\"2\" column=\"18\"><name line=\"2\" column=\"18\">a</name>" +
			"</name-type-init></const-list>");
	}
	
	[Test]
	public function testImports():void
	{
		assertClassContent("1",
			"import a.b.c;",
			"<import line=\"2\" column=\"1\"><type line=\"2\" column=\"8\">" +
			"a.b.c</type></import>");
		
		assertClassContent("2",
			"import a.b.c import x.y.z",
			"<import line=\"2\" column=\"1\"><type line=\"2\" column=\"8\">" +
			"a.b.c</type></import><import line=\"2\" column=\"14\"><type " +
			"line=\"2\" column=\"21\">x.y.z</type></import>");
	}
	
	[Test]
	public function testMethods():void
	{
		assertClassContent("1",
			"function a(){}",
			"<function line=\"2\" column=\"1\"><name line=\"2\" column=\"10\">" +
			"a</name><parameter-list line=\"2\" column=\"11\"></parameter-list>" +
			"</function>");

		assertClassContent("2",
			"function set a( value : int ) : void {}",
			"<set line=\"2\" column=\"1\"><name line=\"2\" column=\"14\">a</name>" +
			"<parameter-list line=\"2\" column=\"15\"><parameter line=\"2\" " +
			"column=\"17\"><name-type-init line=\"2\" column=\"17\"><name line=\"2\" " +
			"column=\"17\">value</name><type line=\"2\" column=\"25\">int</type>" +
			"</name-type-init></parameter></parameter-list></set>");
		
		assertClassContent("3",
			"function get a() : int {}",
			"<get line=\"2\" column=\"1\">" +
			"<name line=\"2\" column=\"14\">a</name><parameter-list line=\"2\" " +
			"column=\"15\"></parameter-list></get>");
		
		assertClassContent( "function with default parameter",
			"public function newLine ( height:*='' ):void{}",
			"<function line=\"2\" column=\"1\"><mod line=\"2\" column=\"1\">" +
			"public</mod><name line=\"2\" column=\"17\">newLine</name>" +
			"<parameter-list line=\"2\" column=\"25\"><parameter line=\"2\" " +
			"column=\"27\"><name-type-init line=\"2\" column=\"27\"><name " +
			"line=\"2\" column=\"27\">height</name><type line=\"2\" column=\"34\">" +
			"*</type><init line=\"2\" column=\"36\"><string line=\"2\" " +
			"column=\"36\">''</string></init></name-type-init></parameter>" +
			"</parameter-list><type line=\"2\" column=\"41\">void</type>" +
			"</function>" );
		
		assertClassContent("4",
			"/** Asdoc comment. */ public function a():void{}",
			"<function line=\"2\" column=\"23\"><as-doc line=\"2\" " +
			"column=\"1\">/** Asdoc comment. */</as-doc><mod line=\"2\" " +
			"column=\"23\">public</mod><name line=\"2\" column=\"39\">a</name>" +
			"<parameter-list line=\"2\" column=\"40\"></parameter-list>" +
			"<type line=\"2\" column=\"43\">void</type></function>");
		
		assertClassContent("5",
			"public function log(message:String, ... rest):void{}",
			"<function line=\"2\" column=\"1\"><mod line=\"2\" column=\"1\">" +
			"public</mod><name line=\"2\" column=\"17\">log</name>" +
			"<parameter-list line=\"2\" column=\"20\"><parameter line=\"2\" " +
			"column=\"21\"><name-type-init line=\"2\" column=\"21\"><name " +
			"line=\"2\" column=\"21\">message</name><type line=\"2\" column=\"29\">" +
			"String</type></name-type-init></parameter><parameter line=\"2\" " +
			"column=\"37\"><rest line=\"2\" column=\"41\">rest</rest></parameter>" +
			"</parameter-list><type line=\"2\" column=\"47\">void</type></function>");
	}
	
	[Test]
	public function testVarDeclarations():void
	{
		assertClassContent("1",
			"var a",
			"<var-list line=\"2\" column=\"1\"><name-type-init line=\"2\" " +
			"column=\"5\"><name line=\"2\" column=\"5\">a</name></name-type-init>" +
			"</var-list>" );
		
		assertClassContent("2",
			"public var a;",
			"<var-list line=\"2\" column=\"1\"><mod line=\"2\" column=\"1\">public" +
			"</mod><name-type-init line=\"2\" column=\"12\"><name line=\"2\" " +
			"column=\"12\">a</name></name-type-init></var-list>");
		
		assertClassContent("3",
			"public static var a : int = 0",
			"<var-list line=\"2\" column=\"1\"><mod line=\"2\" column=\"1\">public" +
			"</mod><mod line=\"2\" column=\"8\">static</mod><name-type-init " +
			"line=\"2\" column=\"19\"><name line=\"2\" column=\"19\">a</name>" +
			"<type line=\"2\" column=\"23\">int</type><init line=\"2\" column=\"29\">" +
			"<number line=\"2\" column=\"29\">0</number></init></name-type-init>" +
			"</var-list>");
		
		assertClassContent("4",
			"[Bindable] var a",
			"<var-list line=\"2\" column=\"1\"><meta line=\"2\" column=\"1\">" +
			"<name line=\"2\" column=\"2\">Bindable</name></meta><name-type-init " +
			"line=\"2\" column=\"16\"><name line=\"2\" column=\"16\">a</name>" +
			"</name-type-init></var-list>" );
	}
	
	private function assertClassContent(message:String, 
										input:String, 
										expected:String):void
	{
		var lines:Array = ["{", input, "}", "__END__"];
		
		parser.scanner.setLines(ASTUtil.toVector(lines));
		parser.nextToken(); // first call
		var result:String = ASTUtil.convert(parser.parseTypeContent());
		
		Assert.assertEquals("<content line=\"1\" column=\"1\">" + 
			expected + "</content>", result);
	}
}
}