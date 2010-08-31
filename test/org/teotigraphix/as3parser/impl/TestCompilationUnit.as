package org.teotigraphix.as3parser.impl
{

import org.flexunit.Assert;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.core.ASTPrinter;
import org.teotigraphix.as3parser.core.SourceCode;
import org.teotigraphix.as3parser.utils.ASTUtil;

public class TestCompilationUnit
{
	private var parser:AS3Parser2;
	
	private var scanner:AS3Scanner;
	
	[Before]
	public function setUp():void
	{
		parser = new AS3Parser2();
		scanner = parser.scanner as AS3Scanner;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Package
	//
	//--------------------------------------------------------------------------
	
	[Test]
	public function testDefaultEmptyPackage():void
	{
		var input:String = " package { } ";
		assertCompilationUnitPrint(input);
		assertCompilationUnit("1", input,
			"<compilation-unit line=\"-1\" column=\"-1\"><package line=\"1\" " +
			"column=\"2\"><content line=\"1\" column=\"10\"></content>" +
			"</package></compilation-unit>");
	}
	
	[Test]
	public function testAsDocDefaultEmptyPackage():void
	{
		var input:String = "/*** ASDoc doc */ package { } ";
		assertCompilationUnitPrint(input);
		assertCompilationUnit("1", input,
			"<compilation-unit line=\"-1\" column=\"-1\"><as-doc line=\"1\" " +
			"column=\"1\">/*** ASDoc doc */</as-doc><package line=\"1\" " +
			"column=\"19\"><content line=\"1\" column=\"27\"></content>" +
			"</package></compilation-unit>");
	}
	
	[Test]
	public function testCommentPackageName():void
	{
		var input:Array = ["// one skip", "// two skip", " package my.domain {  } "];
		
		parser.scanner.setLines(Vector.<String>(input));
		
		var ast:IParserNode = parseArrayCompilationUnit(input);
		var printer:ASTPrinter = createPrinter();
		printer.print(ast);
		
		Assert.assertEquals(
			"<compilation-unit line=\"-1\" column=\"-1\"><package line=\"3\" " +
			"column=\"2\"><name line=\"3\" column=\"10\">my.domain</name>" +
			"<content line=\"3\" column=\"20\"></content></package>" +
			"</compilation-unit>",
			ASTUtil.convert(ast));
		
		Assert.assertEquals(
			"// one skip\n// two skip\n package my.domain {  } ",
			printer.flush());
	}
	
	[Test]
	public function testBlockCommentPackageName():void
	{
		var input:Array = ["/* one skip ", " line rest */", "// one skip", 
			"// two skip", " package my.domain {  } "];
		
		parser.scanner.setLines(Vector.<String>(input));
		
		var ast:IParserNode = parseArrayCompilationUnit(input);
		var printer:ASTPrinter = createPrinter();
		printer.print(ast);
		var result:String = ASTUtil.convert(ast);
		
		Assert.assertEquals(
			"<compilation-unit line=\"-1\" column=\"-1\"><package line=\"5\" " +
			"column=\"2\"><name line=\"5\" column=\"10\">my.domain</name>" +
			"<content line=\"5\" column=\"20\"></content></package>" +
			"</compilation-unit>",
			result);
		
		Assert.assertEquals(
			"/* one skip \n line rest */\n// one skip\n// two skip\n package my.domain {  } ",
			printer.flush());
	}
	
	[Test]
	public function testPackageImports():void
	{
		var input:String = "package my.domain { import my.other.C; import my.other.D; public class A { } } ";
		assertCompilationUnitPrint(input);
		assertCompilationUnit("1", input,
			"<compilation-unit line=\"-1\" column=\"-1\"><package line=\"1\" " +
			"column=\"1\"><name line=\"1\" column=\"9\">my.domain</name>" +
			"<content line=\"1\" column=\"19\"><import line=\"1\" " +
			"column=\"21\"><type line=\"1\" column=\"28\">my.other.C</type>" +
			"</import><import line=\"1\" column=\"40\"><type line=\"1\" " +
			"column=\"47\">my.other.D</type></import><mod line=\"1\" " +
			"column=\"59\">public</mod><class line=\"1\" column=\"66\">" +
			"<name line=\"1\" column=\"72\">A</name><content line=\"1\" " +
			"column=\"74\"></content></class></content></package>" +
			"</compilation-unit>");
	}
	
	[Test]
	public function testPackageUses():void
	{
		var input:String = "package my.domain { import flash.util.flash_proxy; use namespace flash_proxy; public class A { } } ";
		assertCompilationUnitPrint(input);
		assertCompilationUnit("1", input,
			"<compilation-unit line=\"-1\" column=\"-1\"><package line=\"1\" " +
			"column=\"1\"><name line=\"1\" column=\"9\">my.domain</name>" +
			"<content line=\"1\" column=\"19\"><import line=\"1\" column=\"21\">" +
			"<type line=\"1\" column=\"28\">flash.util.flash_proxy</type>" +
			"</import><use line=\"1\" column=\"52\"><name line=\"1\" " +
			"column=\"66\">flash_proxy</name></use><mod line=\"1\" " +
			"column=\"79\">public</mod><class line=\"1\" column=\"86\">" +
			"<name line=\"1\" column=\"92\">A</name><content line=\"1\" " +
			"column=\"94\"></content></class></content></package>" +
			"</compilation-unit>");
	}
	
	[Test]
	public function testPackageIncludes():void
	{
		var input:String = "package my.domain { include '../myother.Include.as' public class A { } } ";
		assertCompilationUnitPrint(input);
		assertCompilationUnit("1", input,
			"<compilation-unit line=\"-1\" column=\"-1\"><package line=\"1\" " +
			"column=\"1\"><name line=\"1\" column=\"9\">my.domain</name><content " +
			"line=\"1\" column=\"19\"><include line=\"1\" column=\"21\"><string " +
			"line=\"1\" column=\"29\">'../myother.Include.as'</string></include>" +
			"<mod line=\"1\" column=\"53\">public</mod><class line=\"1\" " +
			"column=\"60\"><name line=\"1\" column=\"66\">A</name><content " +
			"line=\"1\" column=\"68\"></content></class></content></package>" +
			"</compilation-unit>");
	}
	
	//--------------------------------------------------------------------------
	//
	//  Class
	//
	//--------------------------------------------------------------------------
	
	[Test]
	public function testDefaultPackageWithClass():void
	{
		var input:String = " package { class A {} } ";
		assertCompilationUnitPrint(input);
		assertCompilationUnit("1", input,
			"<compilation-unit line=\"-1\" column=\"-1\"><package line=\"1\" " +
			"column=\"2\"><content line=\"1\" column=\"10\"><class line=\"1\" " +
			"column=\"12\"><name line=\"1\" column=\"18\">A</name><content line=\"1\" " +
			"column=\"20\"></content></class></content></package></compilation-unit>");
	}
	
	[Test]
	public function testPackageNameWithClass():void
	{
		var input:String = " package my.domain { class A {} } ";
		assertCompilationUnitPrint(input);
		assertCompilationUnit("1", input,
			"<compilation-unit line=\"-1\" column=\"-1\"><package line=\"1\" " +
			"column=\"2\"><name line=\"1\" column=\"10\">my.domain</name>" +
			"<content line=\"1\" column=\"20\"><class line=\"1\" column=\"22\">" +
			"<name line=\"1\" column=\"28\">A</name><content line=\"1\" " +
			"column=\"30\"></content></class></content>" +
			"</package></compilation-unit>");
	}
	
	[Test]
	public function testPackageNameWithClassModifiers():void
	{
		var input:String = "package my.domain { public dynamic class A {} } ";
		assertCompilationUnitPrint(input);
		assertCompilationUnit("1", input,
			"<compilation-unit line=\"-1\" column=\"-1\"><package line=\"1\" " +
			"column=\"1\"><name line=\"1\" column=\"9\">my.domain</name><content " +
			"line=\"1\" column=\"19\"><mod line=\"1\" column=\"21\">public</mod>" +
			"<mod line=\"1\" column=\"28\">dynamic</mod><class line=\"1\" " +
			"column=\"36\"><name line=\"1\" column=\"42\">A</name><content " +
			"line=\"1\" column=\"44\"></content></class></content></package>" +
			"</compilation-unit>");
	}
	
	[Test]
	public function testPackageNameWithClassModifiersAndExtends():void
	{
		var input:String = "package my.domain { public dynamic class A extends B { } } ";
		assertCompilationUnitPrint(input);
		assertCompilationUnit("1", input,
			"<compilation-unit line=\"-1\" column=\"-1\"><package line=\"1\" " +
			"column=\"1\"><name line=\"1\" column=\"9\">my.domain</name><content " +
			"line=\"1\" column=\"19\"><mod line=\"1\" column=\"21\">public</mod>" +
			"<mod line=\"1\" column=\"28\">dynamic</mod><class line=\"1\" " +
			"column=\"36\"><name line=\"1\" column=\"42\">A</name><extends " +
			"line=\"1\" column=\"44\"><type line=\"1\" column=\"52\">B</type>" +
			"</extends><content line=\"1\" column=\"54\"></content></class>" +
			"</content></package></compilation-unit>");
	}
	
	[Test]
	public function testFullFeaturedClass():void
	{
		var input:String = "package my.domain { public dynamic class A extends B implements IA, IB { } } ";
		assertCompilationUnitPrint(input);
		assertCompilationUnit("1", input,
			"<compilation-unit line=\"-1\" column=\"-1\"><package line=\"1\" " +
			"column=\"1\"><name line=\"1\" column=\"9\">my.domain</name><content " +
			"line=\"1\" column=\"19\"><mod line=\"1\" column=\"21\">public</mod>" +
			"<mod line=\"1\" column=\"28\">dynamic</mod><class line=\"1\" " +
			"column=\"36\"><name line=\"1\" column=\"42\">A</name><extends line=\"1\" " +
			"column=\"44\"><type line=\"1\" column=\"52\">B</type></extends>" +
			"<implements line=\"1\" column=\"54\"><type line=\"1\" column=\"65\">" +
			"IA</type><type line=\"1\" column=\"69\">IB</type></implements>" +
			"<content line=\"1\" column=\"72\"></content></class></content>" +
			"</package></compilation-unit>");
	}
	
	//----------------------------------
	//  Extra
	//----------------------------------
	
	[Test]
	public function testGarbageComments():void
	{
		var input:String = "/*foo*/package /*bar*/{ public /*baz*/class /*bing*/A /*bang*/{/*ring*/} /*rang*/ }//boom  ";
		assertCompilationUnitPrint(input);
		assertCompilationUnit("1", input,
			"<compilation-unit line=\"-1\" column=\"-1\"><package line=\"1\" " +
			"column=\"8\"><content line=\"1\" column=\"23\"><mod line=\"1\" " +
			"column=\"25\">public</mod><class line=\"1\" column=\"39\"><name " +
			"line=\"1\" column=\"53\">A</name><content line=\"1\" column=\"63\">" +
			"</content></class></content></package></compilation-unit>");
	}
	
	[Test]
	public function testGarbageCommentsExtends():void
	{
		var input:String = " package { public class A extends /*foo*/ B {} } ";
		assertCompilationUnitPrint(input);
		assertCompilationUnit("1", input,
			"<compilation-unit line=\"-1\" column=\"-1\"><package line=\"1\" " +
			"column=\"2\"><content line=\"1\" column=\"10\"><mod line=\"1\" " +
			"column=\"12\">public</mod><class line=\"1\" column=\"19\"><name " +
			"line=\"1\" column=\"25\">A</name><extends line=\"1\" column=\"27\">" +
			"<type line=\"1\" column=\"43\">B</type></extends><content line=\"1\" " +
			"column=\"45\"></content></class></content></package>" +
			"</compilation-unit>");
	}
	
	[Test]
	public function testGarbageCommentsExtendsImplements():void
	{
		var input:String = " package { public class A extends /*foo*/ B implements /*ifoo,*/ IBar, /*IBaz,*/ IBing {} } ";
		assertCompilationUnitPrint(input);
		assertCompilationUnit("1", input,
			"<compilation-unit line=\"-1\" column=\"-1\"><package line=\"1\" " +
			"column=\"2\"><content line=\"1\" column=\"10\"><mod line=\"1\" " +
			"column=\"12\">public</mod><class line=\"1\" column=\"19\"><name " +
			"line=\"1\" column=\"25\">A</name><extends line=\"1\" column=\"27\">" +
			"<type line=\"1\" column=\"43\">B</type></extends><implements " +
			"line=\"1\" column=\"45\"><type line=\"1\" column=\"66\">IBar</type>" +
			"<type line=\"1\" column=\"82\">IBing</type></implements><content " +
			"line=\"1\" column=\"88\"></content></class></content></package>" +
			"</compilation-unit>");
	}
	
	// TODO move to classCOntent
	
	
	[Test]
	public function testPackageMetaData():void
	{
		var input:String = " package { [MetaData] public class A { } } ";
		assertCompilationUnitPrint(input);
		assertCompilationUnit("1", input,
			"<compilation-unit line=\"-1\" column=\"-1\"><package line=\"1\" " +
			"column=\"2\"><content line=\"1\" column=\"10\"><meta line=\"1\" " +
			"column=\"12\"><name line=\"1\" column=\"13\">MetaData</name>" +
			"</meta><mod line=\"1\" column=\"23\">public</mod><class line=\"1\" " +
			"column=\"30\"><name line=\"1\" column=\"36\">A</name><content " +
			"line=\"1\" column=\"38\"></content></class></content></package>" +
			"</compilation-unit>");
	}
	
	[Test]
	public function testPackageMetaDataWithParameters():void
	{
		var input:String = " package { [MetaData(name=\"aName\", included=false, rate=42, false)] public class A { } } ";
		assertCompilationUnitPrint(input);
		assertCompilationUnit("1", input,
			"<compilation-unit line=\"-1\" column=\"-1\"><package line=\"1\" " +
			"column=\"2\"><content line=\"1\" column=\"10\"><meta line=\"1\" " +
			"column=\"12\"><name line=\"1\" column=\"13\">MetaData</name>" +
			"<parameter-list line=\"1\" column=\"21\"><parameter line=\"1\" " +
			"column=\"22\"><name line=\"1\" column=\"22\">name</name><string " +
			"line=\"1\" column=\"27\">\"aName\"</string></parameter><parameter " +
			"line=\"1\" column=\"36\"><name line=\"1\" column=\"36\">included" +
			"</name><false line=\"1\" column=\"45\">false</false></parameter>" +
			"<parameter line=\"1\" column=\"52\"><name line=\"1\" column=\"52\">" +
			"rate</name><number line=\"1\" column=\"57\">42</number></parameter>" +
			"<parameter line=\"1\" column=\"61\"><value line=\"1\" column=\"61\">" +
			"false</value></parameter></parameter-list></meta><mod line=\"1\" " +
			"column=\"69\">public</mod><class line=\"1\" column=\"76\"><name " +
			"line=\"1\" column=\"82\">A</name><content line=\"1\" column=\"84\">" +
			"</content></class></content></package></compilation-unit>");
	}
	
	[Test]
	public function testPackageAsDoc():void
	{
		var input:String = " package { /** A Class asdoc comment. */ public class A { } } ";
		assertCompilationUnitPrint(input);
		assertCompilationUnit("1", input,
			"<compilation-unit line=\"-1\" column=\"-1\"><package line=\"1\" " +
			"column=\"2\"><content line=\"1\" column=\"10\"><mod line=\"1\" " +
			"column=\"42\">public</mod><class line=\"1\" column=\"49\"><as-doc " +
			"line=\"1\" column=\"12\">/** A Class asdoc comment. */</as-doc>" +
			"<name line=\"1\" column=\"55\">A</name><content line=\"1\" " +
			"column=\"57\"></content></class></content></package>" +
			"</compilation-unit>");
	}
	
	//--------------------------------------------------------------------------
	//
	//  Interface
	//
	//--------------------------------------------------------------------------
	
	[Test]
	public function testDefaultPackageWithInterface():void
	{
		var input:String = " package { interface IA {} } ";
		assertCompilationUnitPrint(input);
		assertCompilationUnit("1", input,
			"<compilation-unit line=\"-1\" column=\"-1\"><package line=\"1\" " +
			"column=\"2\"><content line=\"1\" column=\"10\"><interface line=\"1\" " +
			"column=\"12\"><name line=\"1\" column=\"22\">IA</name><content " +
			"line=\"1\" column=\"25\"></content></interface></content></package>" +
			"</compilation-unit>");
	}
	
	[Test]
	public function testPackageNameWithInterface():void
	{
		var input:String = " package my.domain { interface IA {} } ";
		assertCompilationUnitPrint(input);
		assertCompilationUnit("1", input,
			"<compilation-unit line=\"-1\" column=\"-1\"><package line=\"1\" " +
			"column=\"2\"><name line=\"1\" column=\"10\">my.domain</name>" +
			"<content line=\"1\" column=\"20\"><interface line=\"1\" " +
			"column=\"22\"><name line=\"1\" column=\"32\">IA</name><content " +
			"line=\"1\" column=\"35\"></content></interface></content></package>" +
			"</compilation-unit>");
	}
	
	[Test]
	public function testPackageNameWithInterfaceModifiers():void
	{
		var input:String = "package my.domain { public interface A {} } ";
		assertCompilationUnitPrint(input);
		assertCompilationUnit("1", input,
			"<compilation-unit line=\"-1\" column=\"-1\"><package line=\"1\" " +
			"column=\"1\"><name line=\"1\" column=\"9\">my.domain</name><content " +
			"line=\"1\" column=\"19\"><mod line=\"1\" column=\"21\">public</mod>" +
			"<interface line=\"1\" column=\"28\"><name line=\"1\" column=\"38\">" +
			"A</name><content line=\"1\" column=\"40\"></content></interface>" +
			"</content></package></compilation-unit>");
	}
	
	[Test]
	public function testPackageNameWithInterfaceModifiersAndExtends():void
	{
		var input:String = "package my.domain { public interface IA extends IB, IC { } } ";
		assertCompilationUnitPrint(input);
		assertCompilationUnit("1", input,
			"<compilation-unit line=\"-1\" column=\"-1\"><package line=\"1\" " +
			"column=\"1\"><name line=\"1\" column=\"9\">my.domain</name><content " +
			"line=\"1\" column=\"19\"><mod line=\"1\" column=\"21\">public</mod>" +
			"<interface line=\"1\" column=\"28\"><name line=\"1\" column=\"38\">" +
			"IA</name><extends line=\"1\" column=\"41\"><type line=\"1\" " +
			"column=\"49\">IB</type><type line=\"1\" column=\"53\">IC</type>" +
			"</extends><content line=\"1\" column=\"56\"></content></interface>" +
			"</content></package></compilation-unit>");
	}
	
	
	
	protected function assertCompilationUnitPrint(input:String):void
	{
		var printer:ASTPrinter = createPrinter();
		printer.print(parseCompilationUnit(input));
		var result:String = printer.flush();
		Assert.assertEquals(input, result);
	}
	
	protected function assertCompilationUnit(message:String, 
											 input:String, 
											 expected:String):void
	{
		var result:String = ASTUtil.convert(parseCompilationUnit(input));
		Assert.assertEquals(message, expected, result);
	}
	
	protected function parseCompilationUnit(input:String):IParserNode
	{
		parser.scanner.setLines(Vector.<String>([input]));
		return parser.parseCompilationUnit();
	}
	
	protected function parseArrayCompilationUnit(input:Array):IParserNode
	{
		parser.scanner.setLines(Vector.<String>(input));
		return parser.parseCompilationUnit();
	}
	
	protected function createPrinter():ASTPrinter
	{
		return new ASTPrinter(new SourceCode());
	}
}
}