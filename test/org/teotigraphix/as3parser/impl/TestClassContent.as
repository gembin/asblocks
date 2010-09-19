package org.teotigraphix.as3parser.impl
{
import flexunit.framework.Assert;

import org.teotigraphix.asblocks.utils.ASTUtil;

public class TestClassContent
{
	private var parser:AS3Parser;
	
	[Before]
	public function setUp():void
	{
		parser = new AS3Parser();
	}
	
	[Test]
	public function testConditionalCompilation():void
	{
		assertClassContent( "with conditional compilation",
			"CONFIG::DEBUG { function output():String { return null; } } ",
			"<config line=\"2\" column=\"1\">" +
			"<name line=\"-1\" column=\"-1\">DEBUG</name><function line=\"2\" " +
			"column=\"1\"><accessor-role line=\"2\" column=\"26\"></accessor-role>" +
			"<name line=\"2\" column=\"26\">output</name><parameter-list line=\"2\" " +
			"column=\"32\"></parameter-list><type line=\"2\" column=\"35\">String" +
			"</type><block line=\"2\" column=\"42\"><return line=\"2\" column=\"44\">" +
			"<null line=\"2\" column=\"51\">null</null></return></block></function>" +
			"</config>" );
	}
	
	[Test]
	public function testConstDeclarations():void
	{
		assertClassContent("1",
			"const a",
			"<field-list line=\"2\" column=\"1\"><field-role line=\"2\" " +
			"column=\"1\"><const line=\"2\" column=\"1\"></const></field-role>" +
			"<name-type-init line=\"2\" column=\"7\"><name line=\"2\" column=\"7\">" +
			"a</name></name-type-init></field-list>");
		
		assertClassContent("2",
			"public const a",
			"<field-list line=\"2\" column=\"1\"><mod-list line=\"2\" column=\"1\">" +
			"<mod line=\"2\" column=\"1\">public</mod></mod-list><field-role " +
			"line=\"2\" column=\"8\"><const line=\"2\" column=\"8\"></const>" +
			"</field-role><name-type-init line=\"2\" column=\"14\"><name " +
			"line=\"2\" column=\"14\">a</name></name-type-init></field-list>");
		
		assertClassContent("3",
			"public static const a : int = 0",
			"<field-list line=\"2\" column=\"1\"><mod-list line=\"2\" " +
			"column=\"1\"><mod line=\"2\" column=\"1\">public</mod><mod " +
			"line=\"2\" column=\"8\">static</mod></mod-list><field-role " +
			"line=\"2\" column=\"15\"><const line=\"2\" column=\"15\">" +
			"</const></field-role><name-type-init line=\"2\" column=\"21\">" +
			"<name line=\"2\" column=\"21\">a</name><type line=\"2\" " +
			"column=\"25\">int</type><init line=\"2\" column=\"31\">" +
			"<number line=\"2\" column=\"31\">0</number></init></name-type-init>" +
			"</field-list>");
		
		assertClassContent("4",
			"[Bindable] const a",
			"<field-list line=\"2\" column=\"1\"><meta-list line=\"2\" " +
			"column=\"1\"><meta line=\"2\" column=\"1\"><name line=\"2\" " +
			"column=\"2\">Bindable</name></meta></meta-list><field-role " +
			"line=\"2\" column=\"12\"><const line=\"2\" column=\"12\"></const>" +
			"</field-role><name-type-init line=\"2\" column=\"18\"><name " +
			"line=\"2\" column=\"18\">a</name></name-type-init></field-list>");
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
	public function testMethodBug1():void
	{
		assertClassContent("1",
			"model_internal static function initRemoteClassAliasSingle( cz : Class ) : void { } ",
			"<function line=\"2\" column=\"1\">" +
			"<mod-list line=\"2\" column=\"1\"><mod line=\"2\" column=\"1\">model_internal" +
			"</mod><mod line=\"2\" column=\"16\">static</mod></mod-list><accessor-role " +
			"line=\"2\" column=\"32\"></accessor-role><name line=\"2\" column=\"32\">" +
			"initRemoteClassAliasSingle</name><parameter-list line=\"2\" column=\"58\">" +
			"<parameter line=\"2\" column=\"60\"><name-type-init line=\"2\" " +
			"column=\"60\"><name line=\"2\" column=\"60\">cz</name><type line=\"2\" " +
			"column=\"65\">Class</type></name-type-init></parameter></parameter-list>" +
			"<type line=\"2\" column=\"75\">void</type><block line=\"2\" column=\"80\">" +
			"</block></function>");
	}
	
	[Test]
	public function testMethods():void
	{
		assertClassContent("1",
			"function a(){}",
			"<function line=\"2\" column=\"1\"><accessor-role line=\"2\" " +
			"column=\"10\"></accessor-role><name line=\"2\" column=\"10\">a" +
			"</name><parameter-list line=\"2\" column=\"11\"></parameter-list>" +
			"<block line=\"2\" column=\"13\"></block></function>");

		assertClassContent("2",
			"function set a( value : int ) : void {}",
			"<function line=\"2\" column=\"1\">" +
			"<accessor-role line=\"2\" column=\"10\"><set line=\"2\" column=\"10\">" +
			"</set></accessor-role><name line=\"2\" column=\"14\">a</name>" +
			"<parameter-list line=\"2\" column=\"15\"><parameter line=\"2\" " +
			"column=\"17\"><name-type-init line=\"2\" column=\"17\"><name line=\"2\" " +
			"column=\"17\">value</name><type line=\"2\" column=\"25\">int</type>" +
			"</name-type-init></parameter></parameter-list><type line=\"2\" " +
			"column=\"33\">void</type><block line=\"2\" column=\"38\"></block>" +
			"</function>");
		
		assertClassContent("3",
			"function get a() : int {}",
			"<function line=\"2\" column=\"1\"><accessor-role line=\"2\" " +
			"column=\"10\"><get line=\"2\" column=\"10\"></get></accessor-role>" +
			"<name line=\"2\" column=\"14\">a</name><parameter-list line=\"2\" " +
			"column=\"15\"></parameter-list><type line=\"2\" column=\"20\">int" +
			"</type><block line=\"2\" column=\"24\"></block></function>");
		
		assertClassContent("function with default parameter",
			"public function newLine ( height : * = '' ) : void { } ",
			"<function line=\"2\" column=\"1\"><mod-list line=\"2\" column=\"1\">" +
			"<mod line=\"2\" column=\"1\">public</mod></mod-list><accessor-role " +
			"line=\"2\" column=\"17\"></accessor-role><name line=\"2\" column=\"17\">" +
			"newLine</name><parameter-list line=\"2\" column=\"25\"><parameter " +
			"line=\"2\" column=\"27\"><name-type-init line=\"2\" column=\"27\">" +
			"<name line=\"2\" column=\"27\">height</name><type line=\"2\" " +
			"column=\"36\">*</type><init line=\"2\" column=\"40\"><string " +
			"line=\"2\" column=\"40\">''</string></init></name-type-init>" +
			"</parameter></parameter-list><type line=\"2\" column=\"47\">void" +
			"</type><block line=\"2\" column=\"52\"></block></function>");
		
		assertClassContent("4",
			"/** Asdoc comment. */ public function a ( ) : void { }",
			"<function line=\"2\" column=\"23\"><as-doc line=\"2\" " +
			"column=\"1\">/** Asdoc comment. */</as-doc><mod-list line=\"2\" " +
			"column=\"23\"><mod line=\"2\" column=\"23\">public</mod>" +
			"</mod-list><accessor-role line=\"2\" column=\"39\"></accessor-role>" +
			"<name line=\"2\" column=\"39\">a</name><parameter-list line=\"2\" " +
			"column=\"41\"></parameter-list><type line=\"2\" column=\"47\">void" +
			"</type><block line=\"2\" column=\"52\"></block></function>");
		
		assertClassContent("5",
			"public function log ( message : String , ... rest ) : void { } ",
			"<function line=\"2\" column=\"1\">" +
			"<mod-list line=\"2\" column=\"1\"><mod line=\"2\" column=\"1\">" +
			"public</mod></mod-list><accessor-role line=\"2\" column=\"17\">" +
			"</accessor-role><name line=\"2\" column=\"17\">log</name><parameter-list " +
			"line=\"2\" column=\"21\"><parameter line=\"2\" column=\"23\">" +
			"<name-type-init line=\"2\" column=\"23\"><name line=\"2\" column=\"23\">" +
			"message</name><type line=\"2\" column=\"33\">String</type></name-type-init>" +
			"</parameter><parameter line=\"2\" column=\"42\"><rest line=\"2\" " +
			"column=\"46\">rest</rest></parameter></parameter-list><type line=\"2\" " +
			"column=\"55\">void</type><block line=\"2\" column=\"60\"></block>" +
			"</function>");
	}
	
	[Test]
	public function testVarDeclarations():void
	{
		assertClassContent("1",
			"var a",
			"<field-list line=\"2\" column=\"1\"><field-role line=\"2\" " +
			"column=\"1\"><var line=\"2\" column=\"1\"></var></field-role>" +
			"<name-type-init line=\"2\" column=\"5\"><name line=\"2\" " +
			"column=\"5\">a</name></name-type-init></field-list>" );
		
		assertClassContent("2",
			"public var a;",
			"<field-list line=\"2\" column=\"1\"><mod-list line=\"2\" " +
			"column=\"1\"><mod line=\"2\" column=\"1\">public</mod></mod-list>" +
			"<field-role line=\"2\" column=\"8\"><var line=\"2\" column=\"8\">" +
			"</var></field-role><name-type-init line=\"2\" column=\"12\">" +
			"<name line=\"2\" column=\"12\">a</name></name-type-init></field-list>");
		
		assertClassContent("3",
			"public static var a : int = 0",
			"<field-list line=\"2\" column=\"1\"><mod-list line=\"2\" column=\"1\">" +
			"<mod line=\"2\" column=\"1\">public</mod><mod line=\"2\" column=\"8\">" +
			"static</mod></mod-list><field-role line=\"2\" column=\"15\"><var " +
			"line=\"2\" column=\"15\"></var></field-role><name-type-init line=\"2\" " +
			"column=\"19\"><name line=\"2\" column=\"19\">a</name><type line=\"2\" " +
			"column=\"23\">int</type><init line=\"2\" column=\"29\"><number line=\"2\" " +
			"column=\"29\">0</number></init></name-type-init></field-list>");
		
		assertClassContent("4",
			"[Bindable] var a",
			"<field-list line=\"2\" column=\"1\"><meta-list line=\"2\" " +
			"column=\"1\"><meta line=\"2\" column=\"1\"><name line=\"2\" " +
			"column=\"2\">Bindable</name></meta></meta-list><field-role " +
			"line=\"2\" column=\"12\"><var line=\"2\" column=\"12\"></var>" +
			"</field-role><name-type-init line=\"2\" column=\"16\"><name " +
			"line=\"2\" column=\"16\">a</name></name-type-init></field-list>" );
	}
	
	private function assertClassContent(message:String, 
										input:String, 
										expected:String):void
	{
		var lines:Array = ["{", input, "}", "__END__"];
		
		parser.scanner.setLines(Vector.<String>(lines));
		parser.nextToken(); // first call
		var result:String = ASTUtil.convert(parser.parseTypeContent());
		
		Assert.assertEquals("<content line=\"1\" column=\"1\">" + 
			expected + "</content>", result);
	}
}
}