////////////////////////////////////////////////////////////////////////////////
// Copyright 2010 Michael Schmalle - Teoti Graphix, LLC
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
// http://www.apache.org/licenses/LICENSE-2.0 
// 
// Unless required by applicable law or agreed to in writing, software 
// distributed under the License is distributed on an "AS IS" BASIS, 
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and 
// limitations under the License
// 
// Author: Michael Schmalle, Principal Architect
// mschmalle at teotigraphix dot com
////////////////////////////////////////////////////////////////////////////////

package org.teotigraphix.as3parser.impl
{

import org.flexunit.Assert;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.core.SourceCode;
import org.teotigraphix.asblocks.impl.ASTPrinter;
import org.teotigraphix.asblocks.utils.ASTUtil;

/**
 * A <code>parseCompilationUnit()</code> unit test.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class TestCompilationUnit
{
	private var parser:AS3Parser;
	
	private var scanner:AS3Scanner;
	
	[Before]
	public function setUp():void
	{
		parser = new AS3Parser();
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
			"<content line=\"1\" column=\"19\"><import line=\"1\" column=\"21\">" +
			"<type line=\"1\" column=\"28\">my.other.C</type></import><import " +
			"line=\"1\" column=\"40\"><type line=\"1\" column=\"47\">my.other.D" +
			"</type></import><class line=\"1\" column=\"66\"><mod-list line=\"1\" " +
			"column=\"59\"><mod line=\"1\" column=\"59\">public</mod></mod-list>" +
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
			"column=\"66\">flash_proxy</name></use><class line=\"1\" " +
			"column=\"86\"><mod-list line=\"1\" column=\"79\"><mod line=\"1\" " +
			"column=\"79\">public</mod></mod-list><name line=\"1\" " +
			"column=\"92\">A</name><content line=\"1\" column=\"94\">" +
			"</content></class></content></package></compilation-unit>");
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
			"<class line=\"1\" column=\"60\"><mod-list line=\"1\" column=\"53\">" +
			"<mod line=\"1\" column=\"53\">public</mod></mod-list><name " +
			"line=\"1\" column=\"66\">A</name><content line=\"1\" column=\"68\">" +
			"</content></class></content></package></compilation-unit>");
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
			"column=\"1\"><name line=\"1\" column=\"9\">my.domain</name>" +
			"<content line=\"1\" column=\"19\"><class line=\"1\" column=\"36\">" +
			"<mod-list line=\"1\" column=\"21\"><mod line=\"1\" column=\"21\">" +
			"public</mod><mod line=\"1\" column=\"28\">dynamic</mod></mod-list>" +
			"<name line=\"1\" column=\"42\">A</name><content line=\"1\" " +
			"column=\"44\"></content></class></content></package>" +
			"</compilation-unit>");
	}
	
	[Test]
	public function testPackageNameWithClassModifiersAndExtends():void
	{
		var input:String = "package my.domain { public dynamic class A extends B { } } ";
		assertCompilationUnitPrint(input);
		assertCompilationUnit("1", input,
			"<compilation-unit line=\"-1\" column=\"-1\"><package line=\"1\" " +
			"column=\"1\"><name line=\"1\" column=\"9\">my.domain</name>" +
			"<content line=\"1\" column=\"19\"><class line=\"1\" column=\"36\">" +
			"<mod-list line=\"1\" column=\"21\"><mod line=\"1\" column=\"21\">" +
			"public</mod><mod line=\"1\" column=\"28\">dynamic</mod>" +
			"</mod-list><name line=\"1\" column=\"42\">A</name><extends " +
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
			"column=\"1\"><name line=\"1\" column=\"9\">my.domain</name>" +
			"<content line=\"1\" column=\"19\"><class line=\"1\" column=\"36\">" +
			"<mod-list line=\"1\" column=\"21\"><mod line=\"1\" column=\"21\">" +
			"public</mod><mod line=\"1\" column=\"28\">dynamic</mod>" +
			"</mod-list><name line=\"1\" column=\"42\">A</name><extends " +
			"line=\"1\" column=\"44\"><type line=\"1\" column=\"52\">B</type>" +
			"</extends><implements line=\"1\" column=\"54\"><type line=\"1\" " +
			"column=\"65\">IA</type><type line=\"1\" column=\"69\">IB</type>" +
			"</implements><content line=\"1\" column=\"72\"></content></class>" +
			"</content></package></compilation-unit>");
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
			"column=\"8\"><content line=\"1\" column=\"23\"><class line=\"1\" " +
			"column=\"39\"><mod-list line=\"1\" column=\"25\"><mod line=\"1\" " +
			"column=\"25\">public</mod></mod-list><name line=\"1\" column=\"53\">" +
			"A</name><content line=\"1\" column=\"63\"></content></class>" +
			"</content></package></compilation-unit>");
	}
	
	[Test]
	public function testGarbageCommentsExtends():void
	{
		var input:String = " package { public class A extends /*foo*/ B {} } ";
		assertCompilationUnitPrint(input);
		assertCompilationUnit("1", input,
			"<compilation-unit line=\"-1\" column=\"-1\"><package line=\"1\" " +
			"column=\"2\"><content line=\"1\" column=\"10\"><class line=\"1\"" +
			" column=\"19\"><mod-list line=\"1\" column=\"12\"><mod line=\"1\" " +
			"column=\"12\">public</mod></mod-list><name line=\"1\" " +
			"column=\"25\">A</name><extends line=\"1\" column=\"27\"><type " +
			"line=\"1\" column=\"43\">B</type></extends><content line=\"1\" " +
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
			"column=\"2\"><content line=\"1\" column=\"10\"><class line=\"1\" " +
			"column=\"19\"><mod-list line=\"1\" column=\"12\"><mod line=\"1\" " +
			"column=\"12\">public</mod></mod-list><name line=\"1\" column=\"25\">" +
			"A</name><extends line=\"1\" column=\"27\"><type line=\"1\" " +
			"column=\"43\">B</type></extends><implements line=\"1\" column=\"45\">" +
			"<type line=\"1\" column=\"66\">IBar</type><type line=\"1\" " +
			"column=\"82\">IBing</type></implements><content line=\"1\" " +
			"column=\"88\"></content></class></content></package>" +
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
			"column=\"2\"><content line=\"1\" column=\"10\"><class line=\"1\" " +
			"column=\"30\"><meta-list line=\"1\" column=\"12\"><meta line=\"1\" " +
			"column=\"12\"><name line=\"1\" column=\"13\">MetaData</name></meta>" +
			"</meta-list><mod-list line=\"1\" column=\"23\"><mod line=\"1\" " +
			"column=\"23\">public</mod></mod-list><name line=\"1\" column=\"36\">" +
			"A</name><content line=\"1\" column=\"38\"></content></class>" +
			"</content></package></compilation-unit>");
	}
	
	[Test]
	public function testPackageMetaDataWithComment():void
	{
		var input:String = " package { /** Metadata comment. */ [MetaData] /** Class comment. */ public class A { } } ";
		assertCompilationUnitPrint(input);
		assertCompilationUnit("1", input,
			"<compilation-unit line=\"-1\" column=\"-1\"><package line=\"1\" " +
			"column=\"2\"><content line=\"1\" column=\"10\"><class line=\"1\" " +
			"column=\"77\"><meta-list line=\"1\" column=\"37\"><meta line=\"1\" " +
			"column=\"37\"><as-doc line=\"1\" column=\"12\">/** Metadata comment. */" +
			"</as-doc><name line=\"1\" column=\"38\">MetaData</name></meta>" +
			"</meta-list><as-doc line=\"1\" column=\"48\">/** Class comment. */" +
			"</as-doc><mod-list line=\"1\" column=\"70\"><mod line=\"1\" " +
			"column=\"70\">public</mod></mod-list><name line=\"1\" column=\"83\">" +
			"A</name><content line=\"1\" column=\"85\"></content></class>" +
			"</content></package></compilation-unit>");
	}
	
	[Test]
	public function testPackageMetaDataWithParameters():void
	{
		var input:String = " package { /** Meta comment. */  [MetaData(name=\"aName\", included=false, rate=42, false)] public class A { } } ";
		assertCompilationUnitPrint(input);
		assertCompilationUnit("1", input,
			"<compilation-unit line=\"-1\" column=\"-1\"><package line=\"1\" " +
			"column=\"2\"><content line=\"1\" column=\"10\"><class line=\"1\" " +
			"column=\"98\"><meta-list line=\"1\" column=\"34\"><meta line=\"1\" " +
			"column=\"34\"><as-doc line=\"1\" column=\"12\">/** Meta comment. */" +
			"</as-doc><name line=\"1\" column=\"35\">MetaData</name>" +
			"<parameter-list line=\"1\" column=\"43\"><parameter line=\"1\" " +
			"column=\"44\"><name line=\"1\" column=\"44\">name</name><string " +
			"line=\"1\" column=\"49\">\"aName\"</string></parameter><parameter " +
			"line=\"1\" column=\"58\"><name line=\"1\" column=\"58\">included" +
			"</name><false line=\"1\" column=\"67\">false</false></parameter>" +
			"<parameter line=\"1\" column=\"74\"><name line=\"1\" column=\"74\">" +
			"rate</name><number line=\"1\" column=\"79\">42</number></parameter>" +
			"<parameter line=\"1\" column=\"83\"><value line=\"1\" column=\"83\">" +
			"false</value></parameter></parameter-list></meta></meta-list>" +
			"<mod-list line=\"1\" column=\"91\"><mod line=\"1\" column=\"91\">" +
			"public</mod></mod-list><name line=\"1\" column=\"104\">A</name>" +
			"<content line=\"1\" column=\"106\"></content></class></content>" +
			"</package></compilation-unit>");
	}
	
	[Test]
	public function testPackageAsDoc():void
	{
		var input:String = " package { /** A Class asdoc comment. */ public class A { } } ";
		assertCompilationUnitPrint(input);
		assertCompilationUnit("1", input,
			"<compilation-unit line=\"-1\" column=\"-1\"><package line=\"1\" " +
			"column=\"2\"><content line=\"1\" column=\"10\"><class line=\"1\" " +
			"column=\"49\"><as-doc line=\"1\" column=\"12\">/** A Class asdoc " +
			"comment. */</as-doc><mod-list line=\"1\" column=\"42\"><mod " +
			"line=\"1\" column=\"42\">public</mod></mod-list><name line=\"1\" " +
			"column=\"55\">A</name><content line=\"1\" column=\"57\"></content>" +
			"</class></content></package></compilation-unit>");
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
			"column=\"1\"><name line=\"1\" column=\"9\">my.domain</name>" +
			"<content line=\"1\" column=\"19\"><interface line=\"1\" " +
			"column=\"28\"><mod-list line=\"1\" column=\"21\"><mod line=\"1\" " +
			"column=\"21\">public</mod></mod-list><name line=\"1\" " +
			"column=\"38\">A</name><content line=\"1\" column=\"40\">" +
			"</content></interface></content></package></compilation-unit>");
	}
	
	[Test]
	public function testPackageNameWithInterfaceModifiersAndExtends():void
	{
		var input:String = "package my.domain { public interface IA extends IB, IC { } } ";
		assertCompilationUnitPrint(input);
		assertCompilationUnit("1", input,
			"<compilation-unit line=\"-1\" column=\"-1\"><package line=\"1\" " +
			"column=\"1\"><name line=\"1\" column=\"9\">my.domain</name><content " +
			"line=\"1\" column=\"19\"><interface line=\"1\" column=\"28\">" +
			"<mod-list line=\"1\" column=\"21\"><mod line=\"1\" column=\"21\">" +
			"public</mod></mod-list><name line=\"1\" column=\"38\">IA</name>" +
			"<extends line=\"1\" column=\"41\"><type line=\"1\" column=\"49\">" +
			"IB</type><type line=\"1\" column=\"53\">IC</type></extends><content " +
			"line=\"1\" column=\"56\"></content></interface></content>" +
			"</package></compilation-unit>");
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