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

/**
 * A <code>;</code> statement unit test.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class TestExpression extends AbstractStatementTest
{
	[Test]
	public function testAddExpression():void
	{
		assertStatement( "1",
			"5+6",
			"<add line=\"1\" column=\"1\"><number line=\"1\" "
			+ "column=\"1\">5</number><op line=\"1\" "
			+ "column=\"2\">+</op><number line=\"1\" column=\"3\">6</number></add>" );
	}
	
	[Test]
	public function testAndExpression():void
	{
		assertStatement( "1",
			"5&&6",
			"<and line=\"1\" column=\"1\"><number line=\"1\" column=\"1\">5</number>"
			+ "<op line=\"1\" column=\"2\">&&</op>"
			+ "<number line=\"1\" column=\"4\">6</number></and>" );
	}
	
	[Test]
	public function testAssignmentExpression():void
	{
		assertStatement( "1",
			"x+=6",
			"<assign line=\"1\" column=\"1\"><primary line=\"1\" column=\"1\">x"
			+ "</primary><op line=\"1\" column=\"2\">+=</op><number line=\"1\" "
			+ "column=\"4\">6</number></assign>" );
	}
	
	[Test]
	public function testBitwiseAndExpression():void
	{
		assertStatement( "1",
			"5&6",
			"<b-and line=\"1\" column=\"1\"><number line=\"1\" column=\"1\">5"
			+ "</number><op line=\"1\" column=\"2\">&</op><number line=\"1\" "
			+ "column=\"3\">6</number></b-and>" );
	}
	
	[Test]
	public function testBitwiseOrExpression():void
	{
		assertStatement( "1",
			"5|6",
			"<b-or line=\"1\" column=\"1\"><number line=\"1\" column=\"1\">5"
			+ "</number><op line=\"1\" column=\"2\">|</op><number line=\"1\" "
			+ "column=\"3\">6</number></b-or>" );
	}
	
	[Test]
	public function testBitwiseXorExpression():void
	{
		assertStatement( "1",
			"5^6",
			"<b-xor line=\"1\" column=\"1\"><number line=\"1\" column=\"1\">5"
			+ "</number><op line=\"1\" column=\"2\">^</op><number line=\"1\" "
			+ "column=\"3\">6</number></b-xor>" );
	}
	
	[Test]
	public function testConditionalExpression():void
	{
		assertStatement( "1",
			"true?5:6",
			"<conditional line=\"1\" column=\"5\"><true line=\"1\" column=\"1\">"
			+ "true</true><number line=\"1\" column=\"6\">5"
			+ "</number><number line=\"1\" column=\"8\">6" + "</number></conditional>" );
	}
	
	[Test]
	public function testEncapsulated():void
	{
		assertStatement( "",
			"(dataProvider as ArrayCollection) = null",
			"<assign line=\"1\" column=\"1\"><primary line=\"1\" column=\"1\">" +
			"<encapsulated line=\"1\" column=\"1\"><relation line=\"1\" " +
			"column=\"2\"><primary line=\"1\" column=\"2\">dataProvider</primary>" +
			"<op line=\"1\" column=\"15\">as</op><primary line=\"1\" column=\"18\">" +
			"ArrayCollection</primary></relation></encapsulated></primary><op " +
			"line=\"1\" column=\"35\">=</op><null line=\"1\" column=\"37\">null" +
			"</null></assign>" );
	}
	
	[Test]
	public function testEqualityExpression():void
	{
		assertStatement( "1",
			"5&&6,5&&9",
			"<expr-list line=\"1\" column=\"1\"><and line=\"1\" column=\"1\">"
			+ "<number line=\"1\" column=\"1\">5</number><op line=\"1\" column=\"2\">"
			+ "&&</op><number line=\"1\" column=\"4\">6</number></and><and line=\"1\" "
			+ "column=\"6\"><number line=\"1\" column=\"6\">5</number><op line=\"1\" "
			+ "column=\"7\">&&</op><number line=\"1\" column=\"9\">9</number></and></expr-list>" );
	}
	
	[Test]
	public function testMulExpression():void
	{
		assertStatement( "1",
			"5/6",
			"<mul line=\"1\" column=\"1\"><number line=\"1\" column=\"1\">5"
			+ "</number><op line=\"1\" column=\"2\">/</op><number line=\"1\" "
			+ "column=\"3\">6</number></mul>" );
	}
	
	[Test]
	public function testNewExpression():void
	{
		assertStatement( "",
			"new Event()",
			"<primary line=\"1\" column=\"1\"><new line=\"1\" column=\"1\">" +
			"<call line=\"1\" column=\"10\"><primary line=\"1\" column=\"5\">" +
			"Event</primary><arguments line=\"1\" column=\"10\"></arguments>" +
			"</call></new></primary>" );
		
		assertStatement( "",
			"new Event(\"lala\")",
			"<primary line=\"1\" column=\"1\"><new line=\"1\" column=\"1\">" +
			"<call line=\"1\" column=\"10\"><primary line=\"1\" column=\"5\">" +
			"Event</primary><arguments line=\"1\" column=\"10\"><string line=\"1\" " +
			"column=\"11\">\"lala\"</string></arguments></call></new></primary>" );
	}
	
	[Test]
	public function testOrExpression():void
	{
		assertStatement( "1",
			"5||6",
			"<or line=\"1\" column=\"1\"><number line=\"1\" column=\"1\">5"
			+ "</number><op line=\"1\" column=\"2\">||</op><number line=\"1\" "
			+ "column=\"4\">6</number></or>" );
	}
	
	[Test]
	public function testRelationalExpression():void
	{
		assertStatement( "1",
			"5<=6",
			"<relation line=\"1\" column=\"1\"><number line=\"1\" column=\"1\">5"
			+ "</number><op line=\"1\" column=\"2\">&lt;=</op><number line=\"1\" "
			+ "column=\"4\">6</number></relation>" );
	}
	
	[Test]
	public function testShiftExpression():void
	{
		assertStatement( "1",
			"5<<6",
			"<shift line=\"1\" column=\"1\"><number line=\"1\" column=\"1\">5"
			+ "</number><op line=\"1\" column=\"2\">&lt;&lt;</op><number line=\"1\" "
			+ "column=\"4\">6</number></shift>" );
	}
	
	[Test]
	public function testSuperiorInferiorXMLBug():void
	{
		assertStatement( "1",
			"a < 11 && b > 11",
			"<and line=\"1\" column=\"1\"><relation line=\"1\" column=\"1\">" +
			"<primary line=\"1\" column=\"1\">a</primary><op line=\"1\" " +
			"column=\"3\">&lt;</op><number line=\"1\" column=\"5\">11" +
			"</number></relation><op line=\"1\" column=\"8\">&&</op>" +
			"<relation line=\"1\" column=\"11\"><primary line=\"1\" " +
			"column=\"11\">b</primary><op line=\"1\" column=\"13\">&gt;" +
			"</op><number line=\"1\" column=\"15\">11</number>" +
			"</relation></and>" );
	}
	
	[Test]
	public function testE4XAttribute():void
	{
		assertStatement("1",
			"myXML.attributeName",
			"<dot line=\"1\" column=\"6\"><primary line=\"1\" " +
			"column=\"1\">myXML</primary><primary line=\"1\" " +
			"column=\"7\">attributeName</primary></dot>");
		
		assertStatement("2",
			"myXML.@attributeName",
			"<dot line=\"1\" column=\"6\"><primary line=\"1\" column=\"1\">" +
			"myXML</primary><e4x-attr line=\"1\" column=\"7\"><name " +
			"line=\"1\" column=\"8\">attributeName</name></e4x-attr></dot>");
		
		assertStatement("3",
			"myXML.@*",
			"<dot line=\"1\" column=\"6\"><primary line=\"1\" column=\"1\">" +
			"myXML</primary><e4x-attr line=\"1\" column=\"7\"><star line=\"1\" " +
			"column=\"8\">*</star></e4x-attr></dot>");

	}
}
}