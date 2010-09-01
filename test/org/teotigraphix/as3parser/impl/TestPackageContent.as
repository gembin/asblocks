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

import flexunit.framework.Assert;

import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.core.ASTPrinter;
import org.teotigraphix.as3parser.core.SourceCode;
import org.teotigraphix.as3parser.utils.ASTUtil;

/**
 * A <code>parsePackageContent()</code> unit test.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class TestPackageContent
{
	private var parser:AS3Parser;
	
	[Before]
	public function setUp():void
	{
		parser = new AS3Parser();
	}
	
	[Test]
	public function testIncludes():void
	{
		var input:String = "include '..my/Include.as'";
		assertPackagePrint(input);
		assertPackageContent("1", input,
			"<content line=\"1\" column=\"1\"><include line=\"1\" column=\"2\">" +
			"<string line=\"1\" column=\"10\">'..my/Include.as'</string>" +
			"</include></content>" );
		
		input = "include '..my/Include.as' include '..my/Include2.as'";
		assertPackagePrint(input);
		assertPackageContent("2", input,
			"<content line=\"1\" column=\"1\"><include line=\"1\" column=\"2\">" +
			"<string line=\"1\" column=\"10\">'..my/Include.as'</string></include>" +
			"<include line=\"1\" column=\"28\"><string line=\"1\" column=\"36\">" +
			"'..my/Include2.as'</string></include></content>");
		
		input = " class A { include '..my/Include.as' include '..my/Include2.as' } ";
		assertPackagePrint(input);
		assertPackageContent("3", input,
			"<content line=\"1\" column=\"1\"><class line=\"1\" column=\"3\"><name " +
			"line=\"1\" column=\"9\">A</name><content line=\"1\" column=\"11\">" +
			"<include line=\"1\" column=\"13\"><string line=\"1\" column=\"21\">" +
			"'..my/Include.as'</string></include><include line=\"1\" column=\"39\">" +
			"<string line=\"1\" column=\"47\">'..my/Include2.as'</string>" +
			"</include></content></class></content>");
	}
	
	[Test]
	public function testImports():void
	{
		var input:String = "import a.b.c;";
		assertPackagePrint(input);
		assertPackageContent("1", input,
			"<content line=\"1\" column=\"1\"><import line=\"1\" column=\"2\">" +
			"<type line=\"1\" column=\"9\">a.b.c</type></import></content>" );
		
		input = "import a.b.c import x.y.z";
		assertPackagePrint(input);
		assertPackageContent("2", input,
			"<content line=\"1\" column=\"1\"><import line=\"1\" column=\"2\">" +
			"<type line=\"1\" column=\"9\">a.b.c</type></import><import " +
			"line=\"1\" column=\"15\"><type line=\"1\" column=\"22\">x.y.z</type>" +
			"</import></content>");
		
		input = " class A { import a.b.c import x.y.z } ";
		assertPackagePrint(input);
		assertPackageContent("3", input,
			"<content line=\"1\" column=\"1\"><class line=\"1\" column=\"3\">" +
			"<name line=\"1\" column=\"9\">A</name><content line=\"1\" " +
			"column=\"11\"><import line=\"1\" column=\"13\"><type line=\"1\" " +
			"column=\"20\">a.b.c</type></import><import line=\"1\" column=\"26\">" +
			"<type line=\"1\" column=\"33\">x.y.z</type></import></content>" +
			"</class></content>");
	}
	
	[Test]
	public function testUse():void
	{
		var input:String = "use namespace flash_proxy;";
		assertPackagePrint(input);
		assertPackageContent("1", input,
			"<content line=\"1\" column=\"1\"><use line=\"1\" column=\"2\">" +
			"<name line=\"1\" column=\"16\">flash_proxy</name></use></content>" );
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
	public function testInterface():void
	{
		var input:String = "public interface IA { }";
		assertPackagePrint(input);
		assertPackageContent("1", input,
			"<content line=\"1\" column=\"1\"><mod line=\"1\" " +
			"column=\"2\">public</mod><interface line=\"1\" column=\"9\">" +
			"<name line=\"1\" column=\"19\">IA</name><content line=\"1\" " +
			"column=\"22\"></content></interface></content>");
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
	public function testInterfaceWithAsDoc():void
	{
		var input:String = "/** AsDoc */ public interface IA { }";
		assertPackagePrint(input);
		assertPackageContent("1", input,
			"<content line=\"1\" column=\"1\"><mod line=\"1\" column=\"15\">" +
			"public</mod><interface line=\"1\" column=\"22\"><as-doc line=\"1\" " +
			"column=\"2\">/** AsDoc */</as-doc><name line=\"1\" column=\"32\">" +
			"IA</name><content line=\"1\" column=\"35\"></content></interface>" +
			"</content>");
	}
	
	[Test]
	public function testClassWithMetadata():void
	{
		var input:String = "[Bindable(name=\"abc\", value=\"123\")] public class A { }";
		assertPackagePrint(input);
		assertPackageContent("1", input,
			"<content line=\"1\" column=\"1\"><meta line=\"1\" column=\"2\">" +
			"<name line=\"1\" column=\"3\">Bindable</name><parameter-list " +
			"line=\"1\" column=\"11\"><parameter line=\"1\" column=\"12\">" +
			"<name line=\"1\" column=\"12\">name</name><string line=\"1\" " +
			"column=\"17\">\"abc\"</string></parameter><parameter line=\"1\" " +
			"column=\"24\"><name line=\"1\" column=\"24\">value</name><string " +
			"line=\"1\" column=\"30\">\"123\"</string></parameter></parameter-list>" +
			"</meta><mod line=\"1\" column=\"38\">public</mod><class line=\"1\" " +
			"column=\"45\"><name line=\"1\" column=\"51\">A</name><content line=\"1\" " +
			"column=\"53\"></content></class></content>");
	}
	
	[Test]
	public function testClassWithMetadataComment():void
	{
		var input:String = "/** Comment */ [Bindable] public class A { }";
		assertPackagePrint(input);
		assertPackageContent("1", input,
			"<content line=\"1\" column=\"1\"><meta line=\"1\" column=\"17\">" +
			"<as-doc line=\"1\" column=\"2\">/** Comment */</as-doc><name " +
			"line=\"1\" column=\"18\">Bindable</name></meta><mod line=\"1\" " +
			"column=\"28\">public</mod><class line=\"1\" column=\"35\"><name " +
			"line=\"1\" column=\"41\">A</name><content line=\"1\" column=\"43\">" +
			"</content></class></content>" );
	}
	
	//----------------------------------
	// var
	//----------------------------------
	
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
	public function testClassWithFullFeaturedVarWithMultipleMetaDataAndAsDoc():void
	{
		var input:String = " public class A {  [MetaData1][MetaData2][MetaData3] /** A var comment. */ public var myVar:int = 42; }";
		assertPackagePrint(input);
		assertPackageContent("1", input,
			"<content line=\"1\" column=\"1\"><mod line=\"1\" column=\"3\">public" +
			"</mod><class line=\"1\" column=\"10\"><name line=\"1\" column=\"16\">" +
			"A</name><content line=\"1\" column=\"18\"><var-list line=\"1\" " +
			"column=\"77\"><meta line=\"1\" column=\"21\"><name line=\"1\" " +
			"column=\"22\">MetaData1</name></meta><meta line=\"1\" column=\"32\">" +
			"<name line=\"1\" column=\"33\">MetaData2</name></meta><meta " +
			"line=\"1\" column=\"43\"><name line=\"1\" column=\"44\">MetaData3" +
			"</name></meta><as-doc line=\"1\" column=\"55\">/** A var comment. */" +
			"</as-doc><mod line=\"1\" column=\"77\">public</mod><name-type-init " +
			"line=\"1\" column=\"88\"><name line=\"1\" column=\"88\">myVar" +
			"</name><type line=\"1\" column=\"94\">int</type><init line=\"1\" " +
			"column=\"100\"><number line=\"1\" column=\"100\">42</number>" +
			"</init></name-type-init></var-list></content></class></content>");
	}
	
	//----------------------------------
	// const
	//----------------------------------
	
	[Test]
	public function testClassWithFullFeaturedConst():void
	{
		var input:String = " public class A { public static const MY_CONSTANT:int = 42; }";
		assertPackagePrint(input);
		assertPackageContent("1", input,
			"<content line=\"1\" column=\"1\"><mod line=\"1\" column=\"3\">public" +
			"</mod><class line=\"1\" column=\"10\"><name line=\"1\" column=\"16\">" +
			"A</name><content line=\"1\" column=\"18\"><const-list line=\"1\" " +
			"column=\"20\"><mod line=\"1\" column=\"20\">public</mod><mod line=\"1\" " +
			"column=\"27\">static</mod><name-type-init line=\"1\" column=\"40\">" +
			"<name line=\"1\" column=\"40\">MY_CONSTANT</name><type line=\"1\" " +
			"column=\"52\">int</type><init line=\"1\" column=\"58\"><number " +
			"line=\"1\" column=\"58\">42</number></init></name-type-init>" +
			"</const-list></content></class></content>");
	}
	
	//----------------------------------
	// function
	//----------------------------------
	
	[Test]
	public function testClassWithFullFeaturedFunction():void
	{
		var input:String = " public class A { public function myFunction():int { } }";
		assertPackagePrint(input);
		assertPackageContent("1", input,
			"<content line=\"1\" column=\"1\"><mod line=\"1\" column=\"3\">" +
			"public</mod><class line=\"1\" column=\"10\"><name line=\"1\" " +
			"column=\"16\">A</name><content line=\"1\" column=\"18\"><function " +
			"line=\"1\" column=\"20\"><mod line=\"1\" column=\"20\">public</mod>" +
			"<name line=\"1\" column=\"36\">myFunction</name><parameter-list " +
			"line=\"1\" column=\"46\"></parameter-list><type line=\"1\" " +
			"column=\"49\">int</type><block line=\"1\" column=\"53\"></block>" +
			"</function></content></class></content>");
	}
	
	[Test]
	public function testInterfaceWithFullFeaturedFunction():void
	{
		var input:String = " public interface IA { function myFunction():int }";
		assertPackagePrint(input);
		assertPackageContent("1", input,
			"<content line=\"1\" column=\"1\"><mod line=\"1\" " +
			"column=\"3\">public</mod><interface line=\"1\" column=\"10\">" +
			"<name line=\"1\" column=\"20\">IA</name><content line=\"1\" " +
			"column=\"23\"><function line=\"1\" column=\"25\"><name " +
			"line=\"1\" column=\"34\">myFunction</name><parameter-list " +
			"line=\"1\" column=\"44\"></parameter-list><type line=\"1\" " +
			"column=\"47\">int</type></function></content>" +
			"</interface></content>");
	}
	
	[Test]
	public function testClassWithFullFeaturedGetFunction():void
	{
		var input:String = " public class A { public function get myFunction():int { } }";
		assertPackagePrint(input);
		assertPackageContent("1", input,
			"<content line=\"1\" column=\"1\"><mod line=\"1\" column=\"3\">public" +
			"</mod><class line=\"1\" column=\"10\"><name line=\"1\" " +
			"column=\"16\">A</name><content line=\"1\" column=\"18\"><get " +
			"line=\"1\" column=\"20\"><mod line=\"1\" column=\"20\">public" +
			"</mod><name line=\"1\" column=\"40\">myFunction</name>" +
			"<parameter-list line=\"1\" column=\"50\"></parameter-list>" +
			"<type line=\"1\" column=\"53\">int</type><block line=\"1\" " +
			"column=\"57\"></block></get></content></class></content>");
	}
	
	[Test]
	public function testInterfaceWithFullFeaturedGetFunction():void
	{
		var input:String = " public interface IA { function get myFunction():int }";
		assertPackagePrint(input);
		assertPackageContent("1", input,
			"<content line=\"1\" column=\"1\"><mod line=\"1\" column=\"3\">" +
			"public</mod><interface line=\"1\" column=\"10\"><name line=\"1\" " +
			"column=\"20\">IA</name><content line=\"1\" column=\"23\"><get " +
			"line=\"1\" column=\"25\"><name line=\"1\" column=\"38\">" +
			"myFunction</name><parameter-list line=\"1\" column=\"48\">" +
			"</parameter-list><type line=\"1\" column=\"51\">int</type>" +
			"</get></content></interface></content>");
	}
	
	[Test]
	public function testClassWithFullFeaturedSetFunction():void
	{
		var input:String = " public class A { public function set myFunction(" +
			"value:int):void { } }";
		assertPackagePrint(input);
		assertPackageContent("1", input,
			"<content line=\"1\" column=\"1\"><mod line=\"1\" column=\"3\">" +
			"public</mod><class line=\"1\" column=\"10\"><name line=\"1\" " +
			"column=\"16\">A</name><content line=\"1\" column=\"18\"><set " +
			"line=\"1\" column=\"20\"><mod line=\"1\" column=\"20\">public" +
			"</mod><name line=\"1\" column=\"40\">myFunction</name>" +
			"<parameter-list line=\"1\" column=\"50\"><parameter line=\"1\" " +
			"column=\"51\"><name-type-init line=\"1\" column=\"51\">" +
			"<name line=\"1\" column=\"51\">value</name><type line=\"1\" " +
			"column=\"57\">int</type></name-type-init></parameter>" +
			"</parameter-list><type line=\"1\" column=\"62\">void</type>" +
			"<block line=\"1\" column=\"67\"></block></set></content>" +
			"</class></content>");
	}
	
	[Test]
	public function testInterfaceWithFullFeaturedSetFunction():void
	{
		var input:String = " public interface IA { function set myFunction(" +
			"value:int):void }";
		assertPackagePrint(input);
		assertPackageContent("1", input,
			"<content line=\"1\" column=\"1\"><mod line=\"1\" column=\"3\">" +
			"public</mod><interface line=\"1\" column=\"10\"><name line=\"1\" " +
			"column=\"20\">IA</name><content line=\"1\" column=\"23\"><set " +
			"line=\"1\" column=\"25\"><name line=\"1\" column=\"38\">myFunction" +
			"</name><parameter-list line=\"1\" column=\"48\"><parameter " +
			"line=\"1\" column=\"49\"><name-type-init line=\"1\" column=\"49\">" +
			"<name line=\"1\" column=\"49\">value</name><type line=\"1\" " +
			"column=\"55\">int</type></name-type-init></parameter>" +
			"</parameter-list><type line=\"1\" column=\"60\">void</type>" +
			"</set></content></interface></content>");
	}
	
	[Test]
	public function testClassWithFullFeaturedFunctionWithAsDoc():void
	{
		var input:String = " public class A { /** Method comment. */ public function " +
			"myFunction():int { } }";
		assertPackagePrint(input);
		assertPackageContent("1", input,
			"<content line=\"1\" column=\"1\"><mod line=\"1\" column=\"3\">public" +
			"</mod><class line=\"1\" column=\"10\"><name line=\"1\" " +
			"column=\"16\">A</name><content line=\"1\" column=\"18\">" +
			"<function line=\"1\" column=\"43\"><as-doc line=\"1\" " +
			"column=\"20\">/** Method comment. */</as-doc><mod line=\"1\" " +
			"column=\"43\">public</mod><name line=\"1\" column=\"59\">myFunction" +
			"</name><parameter-list line=\"1\" column=\"69\"></parameter-list>" +
			"<type line=\"1\" column=\"72\">int</type><block line=\"1\" " +
			"column=\"76\"></block></function></content></class></content>");
	}
	
	[Test]
	public function testClassWithFullFeaturedFunctionWithMetaDataAsDocAndAsDoc():void
	{
		var input:String = " public class A { /** A metadata comment. */ [MetaData] " +
			"/** A method comment. */ public function myFunction():int { } }";
		assertPackagePrint(input);
		assertPackageContent("1", input,
			"<content line=\"1\" column=\"1\"><mod line=\"1\" column=\"3\">public" +
			"</mod><class line=\"1\" column=\"10\"><name line=\"1\" column=\"16\">" +
			"A</name><content line=\"1\" column=\"18\"><function line=\"1\" " +
			"column=\"83\"><meta line=\"1\" column=\"47\"><as-doc line=\"1\" " +
			"column=\"20\">/** A metadata comment. */</as-doc><name line=\"1\" " +
			"column=\"48\">MetaData</name></meta><as-doc line=\"1\" column=\"58\">" +
			"/** A method comment. */</as-doc><mod line=\"1\" column=\"83\">public" +
			"</mod><name line=\"1\" column=\"99\">myFunction</name><parameter-list " +
			"line=\"1\" column=\"109\"></parameter-list><type line=\"1\" " +
			"column=\"112\">int</type><block line=\"1\" column=\"116\"></block>" +
			"</function></content></class></content>");
	}
	
	//----------------------------------
	// misc
	//----------------------------------
	
	[Test]
	public function testClassWithMultipleMembers():void
	{
		var input:String = " public class A { " +
			"public var myVar:int = 42; " +
			"public static const MY_CONSTANT:int = 42; " +
			"public function myFunction (arg0:int, arg1:String = \"default\", ...rest):void { } " +
			"}";
		assertPackagePrint(input);
		assertPackageContent("1", input,
			"<content line=\"1\" column=\"1\"><mod line=\"1\" column=\"3\">public" +
			"</mod><class line=\"1\" column=\"10\"><name line=\"1\" column=\"16\">A" +
			"</name><content line=\"1\" column=\"18\"><var-list line=\"1\" column=\"20\">" +
			"<mod line=\"1\" column=\"20\">public</mod><name-type-init line=\"1\" " +
			"column=\"31\"><name line=\"1\" column=\"31\">myVar</name><type line=\"1\" " +
			"column=\"37\">int</type><init line=\"1\" column=\"43\"><number line=\"1\" " +
			"column=\"43\">42</number></init></name-type-init></var-list><const-list " +
			"line=\"1\" column=\"47\"><mod line=\"1\" column=\"47\">public</mod><mod " +
			"line=\"1\" column=\"54\">static</mod><name-type-init line=\"1\" column=\"67\">" +
			"<name line=\"1\" column=\"67\">MY_CONSTANT</name><type line=\"1\" " +
			"column=\"79\">int</type><init line=\"1\" column=\"85\"><number line=\"1\" " +
			"column=\"85\">42</number></init></name-type-init></const-list><function " +
			"line=\"1\" column=\"89\"><mod line=\"1\" column=\"89\">public</mod><name " +
			"line=\"1\" column=\"105\">myFunction</name><parameter-list line=\"1\" " +
			"column=\"116\"><parameter line=\"1\" column=\"117\"><name-type-init " +
			"line=\"1\" column=\"117\"><name line=\"1\" column=\"117\">arg0</name>" +
			"<type line=\"1\" column=\"122\">int</type></name-type-init></parameter>" +
			"<parameter line=\"1\" column=\"127\"><name-type-init line=\"1\" " +
			"column=\"127\"><name line=\"1\" column=\"127\">arg1</name><type " +
			"line=\"1\" column=\"132\">String</type><init line=\"1\" column=\"141\">" +
			"<string line=\"1\" column=\"141\">\"default\"</string></init>" +
			"</name-type-init></parameter><parameter line=\"1\" column=\"152\">" +
			"<rest line=\"1\" column=\"155\">rest</rest></parameter></parameter-list>" +
			"<type line=\"1\" column=\"161\">void</type><block line=\"1\" column=\"166\">" +
			"</block></function></content></class></content>");
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