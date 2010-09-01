package org.teotigraphix.as3parser.impl
{

import flexunit.framework.Assert;

import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.core.ASTPrinter;
import org.teotigraphix.as3parser.core.SourceCode;
import org.teotigraphix.as3parser.utils.ASTUtil;

public class TestPackageContent
{
	private var parser:AS3Parser2;
	
	[Before]
	public function setUp():void
	{
		parser = new AS3Parser2();
	}
	
	[Test]
	public function testClass_():void
	{
		
	}
	
	[Test]
	public function testClass():void
	{
		var input:String = "public class A { }";
		assertPackagePrint(input);
		assertPackageContent("1", input,
			"<content line=\"1\" column=\"1\"><mod line=\"1\" column=\"2\">" +
			"public</mod><class line=\"1\" column=\"9\"><name line=\"1\" " +
			"column=\"15\">A</name><content line=\"1\" column=\"17\">" +
			"</content></class></content>");
	}
	
	[Test]
	public function testClassWithAsDoc():void
	{
		var input:String = "/** AsDoc */ public class A { }";
		assertPackagePrint(input);
		assertPackageContent("1", input,
			"<content line=\"1\" column=\"1\"><mod line=\"1\" column=\"15\">" +
			"public</mod><class line=\"1\" column=\"22\"><as-doc line=\"1\" " +
			"column=\"2\">/** AsDoc */</as-doc><name line=\"1\" column=\"28\">" +
			"A</name><content line=\"1\" column=\"30\"></content></class>" +
			"</content>");
	}
	
	[Test]
	public function testClassWithFullFeaturedVar():void
	{
		var input:String = " public class A { public var myVar:int = 42; }";
		assertPackagePrint(input);
		assertPackageContent("1", input,
			"<content line=\"1\" column=\"1\"><mod line=\"1\" column=\"3\">" +
			"public</mod><class line=\"1\" column=\"10\"><name line=\"1\" " +
			"column=\"16\">A</name><content line=\"1\" column=\"18\">" +
			"<var-list line=\"1\" column=\"20\"><mod line=\"1\" column=\"20\">" +
			"public</mod><name-type-init line=\"1\" column=\"31\"><name " +
			"line=\"1\" column=\"31\">myVar</name><type line=\"1\" column=\"37\">" +
			"int</type><init line=\"1\" column=\"43\"><number line=\"1\" " +
			"column=\"43\">42</number></init></name-type-init></var-list>" +
			"</content></class></content>");
	}
	
	[Test]
	public function testClassWithFullFeaturedVarWithMetaData():void
	{
		var input:String = " public class A { [MetaData] public var myVar:int = 42; }";
		assertPackagePrint(input);
		assertPackageContent("1", input,
			"<content line=\"1\" column=\"1\"><mod line=\"1\" column=\"3\">" +
			"public</mod><class line=\"1\" column=\"10\"><name line=\"1\" " +
			"column=\"16\">A</name><content line=\"1\" column=\"18\"><var-list " +
			"line=\"1\" column=\"31\"><meta line=\"1\" column=\"20\"><name line=\"1\" " +
			"column=\"21\">MetaData</name></meta><mod line=\"1\" column=\"31\">" +
			"public</mod><name-type-init line=\"1\" column=\"42\"><name line=\"1\" " +
			"column=\"42\">myVar</name><type line=\"1\" column=\"48\">int</type>" +
			"<init line=\"1\" column=\"54\"><number line=\"1\" column=\"54\">42" +
			"</number></init></name-type-init></var-list></content>" +
			"</class></content>");
	}
	
	[Test]
	public function testClassWithFullFeaturedVarWithAsDoc():void
	{
		var input:String = " public class A { /** A var comment. */ public var myVar:int = 42; }";
		assertPackagePrint(input);
		assertPackageContent("1", input,
			"<content line=\"1\" column=\"1\"><mod line=\"1\" column=\"3\">public" +
			"</mod><class line=\"1\" column=\"10\"><name line=\"1\" column=\"16\">" +
			"A</name><content line=\"1\" column=\"18\"><var-list line=\"1\" " +
			"column=\"42\"><as-doc line=\"1\" column=\"20\">/** A var comment. */" +
			"</as-doc><mod line=\"1\" column=\"42\">public</mod><name-type-init " +
			"line=\"1\" column=\"53\"><name line=\"1\" column=\"53\">myVar</name>" +
			"<type line=\"1\" column=\"59\">int</type><init line=\"1\" column=\"65\">" +
			"<number line=\"1\" column=\"65\">42</number></init></name-type-init>" +
			"</var-list></content></class></content>");
	}
	
	[Test]
	public function testClassWithFullFeaturedVarWithMetaDataAsDocAndAsDoc():void
	{
		var input:String = " public class A { /** A metadata comment. */ [MetaData] /** A var comment. */ public var myVar:int = 42; }";
		assertPackagePrint(input);
		assertPackageContent("1", input,
			"<content line=\"1\" column=\"1\"><mod line=\"1\" column=\"3\">" +
			"public</mod><class line=\"1\" column=\"10\"><name line=\"1\" " +
			"column=\"16\">A</name><content line=\"1\" column=\"18\"><var-list " +
			"line=\"1\" column=\"80\"><meta line=\"1\" column=\"47\"><as-doc " +
			"line=\"1\" column=\"20\">/** A metadata comment. */</as-doc><name " +
			"line=\"1\" column=\"48\">MetaData</name></meta><as-doc line=\"1\" " +
			"column=\"58\">/** A var comment. */</as-doc><mod line=\"1\" " +
			"column=\"80\">public</mod><name-type-init line=\"1\" column=\"91\">" +
			"<name line=\"1\" column=\"91\">myVar</name><type line=\"1\" " +
			"column=\"97\">int</type><init line=\"1\" column=\"103\"><number " +
			"line=\"1\" column=\"103\">42</number></init></name-type-init>" +
			"</var-list></content></class></content>");
	}
	
	[Test]
	public function testClassWithMetadata():void
	{
		var input:String = "[Bindable(name=\"abc\", value=\"123\")] public class A { }";
		assertPackagePrint(input);
		assertPackageContent( "1", input,
			"<content line=\"1\" column=\"1\"><meta line=\"1\" column=\"2\">" +
			"<name line=\"1\" column=\"3\">Bindable</name><parameter-list " +
			"line=\"1\" column=\"11\"><parameter line=\"1\" column=\"12\">" +
			"<name line=\"1\" column=\"12\">name</name><string line=\"1\" " +
			"column=\"17\">\"abc\"</string></parameter><parameter line=\"1\" " +
			"column=\"24\"><name line=\"1\" column=\"24\">value</name><string " +
			"line=\"1\" column=\"30\">\"123\"</string></parameter></parameter-list>" +
			"</meta><mod line=\"1\" column=\"38\">public</mod><class line=\"1\" " +
			"column=\"45\"><name line=\"1\" column=\"51\">A</name><content line=\"1\" " +
			"column=\"53\"></content></class></content>" );
	}
	
	[Test]
	public function testClassWithMetadataComment():void
	{
		var input:String = "/** Comment */ [Bindable] public class A { }";
		assertPackagePrint(input);
		assertPackageContent( "1", input,
			"<content line=\"1\" column=\"1\"><meta line=\"1\" column=\"17\">" +
			"<as-doc line=\"1\" column=\"2\">/** Comment */</as-doc><name " +
			"line=\"1\" column=\"18\">Bindable</name></meta><mod line=\"1\" " +
			"column=\"28\">public</mod><class line=\"1\" column=\"35\"><name " +
			"line=\"1\" column=\"41\">A</name><content line=\"1\" column=\"43\">" +
			"</content></class></content>" );
	}
	
	//[Test]
	public function testClassWithSimpleMetadata():void
	{
		assertPackageContent( "1",
			"[Bindable] public class A { }",
			"<content line=\"2\" column=\"1\"><class line=\"2\" column=\"25\">" +
			"<name line=\"2\" column=\"25\">A</name><meta-list line=\"2\" " +
			"column=\"1\"><meta line=\"2\" column=\"1\"><name line=\"2\" " +
			"column=\"2\">Bindable</name></meta></meta-list><mod-list line=\"2\" " +
			"column=\"12\"><mod line=\"2\" column=\"12\">public</mod></mod-list>" +
			"<content line=\"2\" column=\"29\"></content></class></content>" );
	}
	
	//[Test]
	public function testImports():void
	{
		assertPackageContent( "1",
			"import a.b.c;",
			"<content line=\"2\" column=\"1\"><import line=\"2\" "
			+ "column=\"8\">a.b.c</import></content>" );
		
		assertPackageContent( "2",
			"import a.b.c import x.y.z",
			"<content line=\"2\" column=\"1\"><import line=\"2\" column=\"8\">a.b.c"
			+ "</import><import line=\"2\" column=\"21\">x.y.z</import></content>" );
	}
	
	//[Test]
	public function testInterface():void
	{
		assertPackageContent( "1",
			"public interface A { }",
			"<content line=\"2\" column=\"1\"><interface line=\"2\" column=\"18\">"
			+ "<name line=\"2\" column=\"18\">A</name><mod-list line=\"2\" column=\"1\">"
			+ "<mod line=\"2\" column=\"1\">public</mod>"
			+ "</mod-list><content line=\"2\" column=\"22\">"
			+ "</content></interface></content>" );
	}
	
	//[Test]
	public function testMethodPackages():void
	{
		assertPackageContent( "1",
			"public function a() : void { }",
			"<content line=\"2\" column=\"1\"><function line=\"2\" column=\"28\">"
			+ "<mod-list line=\"2\" column=\"1\"><mod line=\"2\" column=\"1\">public</mod>"
			+ "</mod-list><name line=\"2\" column=\"17\">a</name><parameter-list line=\"2\" "
			+ "column=\"19\"></parameter-list><type line=\"2\" column=\"23\">void</type>"
			+ "<block line=\"2\" column=\"30\"></block></function></content>" );
	}
	
	//[Test]
	public function testUse():void
	{
		assertPackageContent( "1",
			"use namespace myNamespace",
			"<content line=\"2\" column=\"1\"><use line=\"2\" column=\"15\""
			+ ">myNamespace</use></content>" );
	}
	
	//[Test]
	public function testUseNameSpace():void
	{
		assertPackageContent( "1",
			"use namespace mx_internal;",
			"<content line=\"2\" column=\"1\"><use line=\"2\" column=\"15\">" +
			"mx_internal</use></content>" );
	}
	
	
	
	
	
	protected function assertPackagePrint(input:String):void
	{
		var printer:ASTPrinter = createPrinter();
		printer.print(parsePackageContent(input));
		var result:String = printer.flush();
		// remove first and last newline for print purposes
		result = result.substring(1);
		result = result.substring(0, result.length - 1);
		Assert.assertEquals(input, result);
	}
	
	protected function assertPackageContent(message:String, 
											input:String, 
											expected:String):void
	{
		var result:String = ASTUtil.convert(parsePackageContent(input));
		Assert.assertEquals(message, expected, result);
	}
	
	protected function parsePackageContent(input:String):IParserNode
	{
		parser.scanner.setLines(Vector.<String>(["{" + input + "}"]));
		parser.nextToken(); // first call
		//parser.nextToken(); // skip {
		return parser.parsePackageContent();
	}
	
	protected function createPrinter():ASTPrinter
	{
		return new ASTPrinter(new SourceCode());
	}
}
}