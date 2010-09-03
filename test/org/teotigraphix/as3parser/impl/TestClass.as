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

import org.teotigraphix.as3parser.utils.ASTUtil;

/**
 * A <code>class</code> unit test.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class TestClass
{
	private var parser:AS3Parser;
	
	[Before]
	public function setUp():void
	{
		parser = new AS3Parser();
	}
	
	[Test]
	public function testExtends():void
	{
		assertPackageContent("1", 
			"public /*foo comment*/class A { } ",
			"<content line=\"1\" column=\"1\"><class line=\"2\" column=\"23\">" +
			"<mod line=\"2\" column=\"1\">public</mod><name line=\"2\" " +
			"column=\"29\">A</name><content line=\"2\" column=\"31\"></content>" +
			"</class></content>");
		
		assertPackageContent("2", 
			"public class A extends B { } ",
			"<content line=\"1\" column=\"1\"><class line=\"2\" column=\"8\">" +
			"<mod line=\"2\" column=\"1\">public</mod><name line=\"2\" " +
			"column=\"14\">A</name><extends line=\"2\" column=\"16\"><type " +
			"line=\"2\" column=\"24\">B</type></extends><content line=\"2\" " +
			"column=\"26\"></content></class></content>");
		
		assertPackageContent("3",
			"public class A extends com.adobe::B { } ",
			"<content line=\"1\" column=\"1\"><class line=\"2\" column=\"8\">" +
			"<mod line=\"2\" column=\"1\">public</mod><name line=\"2\" " +
			"column=\"14\">A</name><extends line=\"2\" column=\"16\"><type " +
			"line=\"2\" column=\"24\">com.adobe::B</type></extends><content " +
			"line=\"2\" column=\"37\"></content></class></content>");
	}
	
	[Test]
	public function testFinalClass():void
	{
		assertPackageContent("1",
			"public final class Title{ }",
			"<content line=\"1\" column=\"1\"><class line=\"2\" column=\"14\">" +
			"<mod line=\"2\" column=\"1\">public</mod><mod line=\"2\" " +
			"column=\"8\">final</mod><name line=\"2\" column=\"20\">Title" +
			"</name><content line=\"2\" column=\"25\"></content>" +
			"</class></content>");
	}
	
	[Test]
	public function testFullFeatured():void
	{
		assertPackageContent("1",
			"public class A extends B implements C,D { } ",
			"<content line=\"1\" column=\"1\"><class line=\"2\" column=\"8\">" +
			"<mod line=\"2\" column=\"1\">public</mod><name line=\"2\" " +
			"column=\"14\">A</name><extends line=\"2\" column=\"16\">" +
			"<type line=\"2\" column=\"24\">B</type></extends><implements " +
			"line=\"2\" column=\"26\"><type line=\"2\" column=\"37\">C</type>" +
			"<type line=\"2\" column=\"39\">D</type></implements><content " +
			"line=\"2\" column=\"41\"></content></class></content>");
	}
	
	[Test]
	public function testImplementsList():void
	{
		assertPackageContent("1",
			"public class A implements B,C { } ",
			"<content line=\"1\" column=\"1\"><class line=\"2\" column=\"8\">" +
			"<mod line=\"2\" column=\"1\">public</mod><name line=\"2\" " +
			"column=\"14\">A</name><implements line=\"2\" column=\"16\">" +
			"<type line=\"2\" column=\"27\">B</type><type line=\"2\" " +
			"column=\"29\">C</type></implements><content line=\"2\" " +
			"column=\"31\"></content></class></content>");
	}

	[Test]
	public function testImplementsSingle():void
	{
		assertPackageContent("1",
			"public class A implements B { } ",
			"<content line=\"1\" column=\"1\"><class line=\"2\" column=\"8\">" +
			"<mod line=\"2\" column=\"1\">public</mod><name line=\"2\" " +
			"column=\"14\">A</name><implements line=\"2\" column=\"16\">" +
			"<type line=\"2\" column=\"27\">B</type></implements><content " +
			"line=\"2\" column=\"29\"></content></class></content>");
	}
	
	[Test]
	public function testImportInsideClass():void
	{
		assertPackageContent("1",
			"public final class Title{ import lala.lala; }",
			"<content line=\"1\" column=\"1\"><class line=\"2\" column=\"14\">" +
			"<mod line=\"2\" column=\"1\">public</mod><mod line=\"2\" " +
			"column=\"8\">final</mod><name line=\"2\" column=\"20\">Title" +
			"</name><content line=\"2\" column=\"25\"><import line=\"2\" " +
			"column=\"27\"><type line=\"2\" column=\"34\">lala.lala</type>" +
			"</import></content></class></content>");
	}
	
	[Test]
	public function testInclude():void
	{
		assertPackageContent("1",
			"public class A extends B { include \"ITextFieldInterface.asz\" } ",
			"<content line=\"1\" column=\"1\"><class line=\"2\" column=\"8\">" +
			"<mod line=\"2\" column=\"1\">public</mod><name line=\"2\" " +
			"column=\"14\">A</name><extends line=\"2\" column=\"16\"><type " +
			"line=\"2\" column=\"24\">B</type></extends><content line=\"2\" " +
			"column=\"26\"><include line=\"2\" column=\"28\"><string line=\"2\" " +
			"column=\"36\">\"ITextFieldInterface.asz\"</string></include>" +
			"</content></class></content>");
	}

	private function assertPackageContent(message:String, 
										  input:String, 
										  expected:String):void
	{
		var lines:Array = ["{", input, "}" ];
		
		parser.scanner.setLines(ASTUtil.toVector(lines));
		parser.nextToken(); // first call
		var result:String = ASTUtil.convert(parser.parsePackageContent());
		
		Assert.assertEquals(expected, result);
	}
}
}