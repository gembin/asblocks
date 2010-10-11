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

package org.as3commons.asblocks.parser.impl
{

import org.flexunit.Assert;
import org.as3commons.asblocks.utils.ASTUtil;

/**
 * Tests all expressions.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class TestExpression extends AbstractStatementTest
{
	[Test]
	/**
	 * Level 13
	 */
	public function testAssignmentExpression():void
	{
		assertStatement("assign",
			"x=1",
			"<assignment line=\"1\" column=\"1\"><primary line=\"1\" " +
			"column=\"1\">x</primary><assign line=\"1\" column=\"2\">=</assign>" +
			"<number line=\"1\" column=\"3\">1</number></assignment>");
		
		assertStatement("star-assign",
			"x*=1",
			"<assignment line=\"1\" column=\"1\"><primary line=\"1\" " +
			"column=\"1\">x</primary><star-assign line=\"1\" column=\"2\">*=</star-assign>" +
			"<number line=\"1\" column=\"4\">1</number></assignment>");
		
		assertStatement("div-assign",
			"x/=1",
			"<assignment line=\"1\" column=\"1\"><primary line=\"1\" " +
			"column=\"1\">x</primary><div-assign line=\"1\" column=\"2\">/=</div-assign>" +
			"<number line=\"1\" column=\"4\">1</number></assignment>");
		
		assertStatement("mod-assign",
			"x%=1",
			"<assignment line=\"1\" column=\"1\"><primary line=\"1\" " +
			"column=\"1\">x</primary><mod-assign line=\"1\" column=\"2\">%=</mod-assign>" +
			"<number line=\"1\" column=\"4\">1</number></assignment>");
		
		assertStatement("plus-assign",
			"x+=1",
			"<assignment line=\"1\" column=\"1\"><primary line=\"1\" " +
			"column=\"1\">x</primary><plus-assign line=\"1\" column=\"2\">+=</plus-assign>" +
			"<number line=\"1\" column=\"4\">1</number></assignment>");
		
		assertStatement("minus-assign",
			"x-=1",
			"<assignment line=\"1\" column=\"1\"><primary line=\"1\" " +
			"column=\"1\">x</primary><minus-assign line=\"1\" column=\"2\">-=</minus-assign>" +
			"<number line=\"1\" column=\"4\">1</number></assignment>");
		
		assertStatement("sl-assign",
			"x<<=1",
			"<assignment line=\"1\" column=\"1\"><primary line=\"1\" column=\"1\">" +
			"x</primary><sl-assign line=\"1\" column=\"2\">&lt;&lt;=</sl-assign>" +
			"<number line=\"1\" column=\"5\">1</number></assignment>");
		
		assertStatement("sr-assign",
			"x>>=1",
			"<assignment line=\"1\" column=\"1\"><primary line=\"1\" column=\"1\">" +
			"x</primary><sr-assign line=\"1\" column=\"2\">&gt;&gt;=</sr-assign>" +
			"<number line=\"1\" column=\"5\">1</number></assignment>");
		
		assertStatement("bsr-assign",
			"x>>>=1",
			"<assignment line=\"1\" column=\"1\"><primary line=\"1\" column=\"1\">" +
			"x</primary><bsr-assign line=\"1\" column=\"2\">&gt;&gt;&gt;=</bsr-assign>" +
			"<number line=\"1\" column=\"6\">1</number></assignment>");
		
		assertStatement("band-assign",
			"x&=1",
			"<assignment line=\"1\" column=\"1\"><primary line=\"1\" column=\"1\">" +
			"x</primary><band-assign line=\"1\" column=\"2\">&=</band-assign>" +
			"<number line=\"1\" column=\"4\">1</number></assignment>");
		
		assertStatement("bxor-assign",
			"x^=1",
			"<assignment line=\"1\" column=\"1\"><primary line=\"1\" column=\"1\">" +
			"x</primary><bxor-assign line=\"1\" column=\"2\">^=</bxor-assign>" +
			"<number line=\"1\" column=\"4\">1</number></assignment>");
		
		assertStatement("bor-assign",
			"x|=1",
			"<assignment line=\"1\" column=\"1\"><primary line=\"1\" column=\"1\">" +
			"x</primary><bor-assign line=\"1\" column=\"2\">|=</bor-assign>" +
			"<number line=\"1\" column=\"4\">1</number></assignment>");
		
		assertStatement("land-assign",
			"x&&=1",
			"<assignment line=\"1\" column=\"1\"><primary line=\"1\" column=\"1\">" +
			"x</primary><land-assign line=\"1\" column=\"2\">&&=</land-assign>" +
			"<number line=\"1\" column=\"5\">1</number></assignment>");
		
		assertStatement("lor-assign",
			"x||=1",
			"<assignment line=\"1\" column=\"1\"><primary line=\"1\" column=\"1\">" +
			"x</primary><lor-assign line=\"1\" column=\"2\">||=</lor-assign>" +
			"<number line=\"1\" column=\"5\">1</number></assignment>");
	}
	
	[Test]
	/**
	 * Level 12
	 */
	public function testConditionalExpression():void
	{
		assertStatement("conditional",
			"true?5:6",
			"<conditional line=\"1\" column=\"5\"><true line=\"1\" column=\"1\">" +
			"true</true><number line=\"1\" column=\"6\">5</number><number " +
			"line=\"1\" column=\"8\">6</number></conditional>");
	}
	
	[Test]
	/**
	 * Level 11
	 */
	public function testOrExpression():void
	{
		assertStatement("lor",
			"5||6",
			"<or line=\"1\" column=\"1\"><number line=\"1\" column=\"1\">5" +
			"</number><lor line=\"1\" column=\"2\">||</lor><number line=\"1\" " +
			"column=\"4\">6</number></or>");
	}
	
	[Test]
	/**
	 * Level 10
	 */
	public function testAndExpression():void
	{
		assertStatement("land",
			"5&&6",
			"<and line=\"1\" column=\"1\"><number line=\"1\" column=\"1\">" +
			"5</number><land line=\"1\" column=\"2\">&&</land><number line=\"1\" " +
			"column=\"4\">6</number></and>");
	}
	
	[Test]
	/**
	 * Level 9
	 */
	public function testBitwiseOrExpression():void
	{
		assertStatement("bor",
			"5|6",
			"<b-or line=\"1\" column=\"1\"><number line=\"1\" column=\"1\">5"
			+ "</number><bor line=\"1\" column=\"2\">|</bor><number line=\"1\" "
			+ "column=\"3\">6</number></b-or>");
	}
	
	[Test]
	/**
	 * Level 8
	 */
	public function testBitwiseXorExpression():void
	{
		assertStatement("bxor",
			"5^6",
			"<b-xor line=\"1\" column=\"1\"><number line=\"1\" column=\"1\">5"
			+ "</number><bxor line=\"1\" column=\"2\">^</bxor><number line=\"1\" "
			+ "column=\"3\">6</number></b-xor>");
	}
	
	[Test]
	/**
	 * Level 7
	 */
	public function testBitwiseAndExpression():void
	{
		assertStatement("band",
			"5&6",
			"<b-and line=\"1\" column=\"1\"><number line=\"1\" column=\"1\">5"
			+ "</number><band line=\"1\" column=\"2\">&</band><number line=\"1\" "
			+ "column=\"3\">6</number></b-and>");
	}
	
	[Test]
	/**
	 * Level 6
	 */
	public function testEqualityExpression():void
	{
		assertStatement("equal",
			"5==5",
			"<equality line=\"1\" column=\"1\"><number line=\"1\" column=\"1\">" +
			"5</number><equal line=\"1\" column=\"2\">==</equal><number line=\"1\" " +
			"column=\"4\">5</number></equality>");
		
		assertStatement("not-equal",
			"5!=5",
			"<equality line=\"1\" column=\"1\"><number line=\"1\" column=\"1\">" +
			"5</number><not-equal line=\"1\" column=\"2\">!=</not-equal><number " +
			"line=\"1\" column=\"4\">5</number></equality>");
		
		assertStatement("strict-equal",
			"5===5",
			"<equality line=\"1\" column=\"1\"><number line=\"1\" column=\"1\">" +
			"5</number><strict-equal line=\"1\" column=\"2\">===</strict-equal>" +
			"<number line=\"1\" column=\"5\">5</number></equality>");
		
		assertStatement("strict-not-equal",
			"5!==5",
			"<equality line=\"1\" column=\"1\"><number line=\"1\" column=\"1\">" +
			"5</number><strict-not-equal line=\"1\" column=\"2\">!==</strict-not-equal>" +
			"<number line=\"1\" column=\"5\">5</number></equality>");
	}
	
	[Test]
	/**
	 * Level 5
	 */
	public function testRelationalExpression():void
	{
		assertStatement("in",
			"'a' in obj",
			"<relational line=\"1\" column=\"1\"><string line=\"1\" column=\"1\">" +
			"'a'</string><in line=\"1\" column=\"5\">in</in><primary " +
			"line=\"1\" column=\"8\">obj</primary></relational>");
		
		assertStatement("lt",
			"5<5",
			"<relational line=\"1\" column=\"1\"><number line=\"1\" column=\"1\">" +
			"5</number><lt line=\"1\" column=\"2\">&lt;</lt><number line=\"1\" " +
			"column=\"3\">5</number></relational>");
		
		assertStatement("le",
			"5<=5",
			"<relational line=\"1\" column=\"1\"><number line=\"1\" column=\"1\">5" +
			"</number><le line=\"1\" column=\"2\">&lt;=</le><number line=\"1\" " +
			"column=\"4\">5</number></relational>");
		
		assertStatement("gt",
			"5>5",
			"<relational line=\"1\" column=\"1\"><number line=\"1\" column=\"1\">5" +
			"</number><gt line=\"1\" column=\"2\">&gt;</gt><number line=\"1\" " +
			"column=\"3\">5</number></relational>");
		
		assertStatement("ge",
			"5>=5",
			"<relational line=\"1\" column=\"1\"><number line=\"1\" column=\"1\">5" +
			"</number><ge line=\"1\" column=\"2\">&gt;=</ge><number line=\"1\" " +
			"column=\"4\">5</number></relational>");
		
		assertStatement("is",
			"obj is Class",
			"<relational line=\"1\" column=\"1\"><primary line=\"1\" column=\"1\">obj" +
			"</primary><is line=\"1\" column=\"5\">is</is><primary line=\"1\" " +
			"column=\"8\">Class</primary></relational>");
		
		assertStatement("as",
			"obj as Class",
			"<relational line=\"1\" column=\"1\"><primary line=\"1\" column=\"1\">obj" +
			"</primary><as line=\"1\" column=\"5\">as</as><primary line=\"1\" " +
			"column=\"8\">Class</primary></relational>");
		
		assertStatement("instanceof",
			"obj instanceof Class",
			"<relational line=\"1\" column=\"1\"><primary line=\"1\" column=\"1\">obj" +
			"</primary><instance-of line=\"1\" column=\"5\">instanceof</instance-of>" +
			"<primary line=\"1\" column=\"16\">Class</primary></relational>");
	}
	
	[Test]
	/**
	 * Level 4
	 */
	public function testShiftExpression():void
	{
		assertStatement("sl",
			"5<<6",
			"<shift line=\"1\" column=\"1\"><number line=\"1\" column=\"1\">5</number>" +
			"<sl line=\"1\" column=\"2\">&lt;&lt;</sl><number line=\"1\" column=\"4\">" +
			"6</number></shift>");
		
		assertStatement("sr",
			"5>>6",
			"<shift line=\"1\" column=\"1\"><number line=\"1\" column=\"1\">5</number>" +
			"<sr line=\"1\" column=\"2\">&gt;&gt;</sr><number line=\"1\" column=\"4\">" +
			"6</number></shift>");
		
		assertStatement("ssl",
			"5<<<6",
			"<shift line=\"1\" column=\"1\"><number line=\"1\" column=\"1\">5</number>" +
			"<ssl line=\"1\" column=\"2\">&lt;&lt;&lt;</ssl><number line=\"1\" " +
			"column=\"5\">6</number></shift>");
		
		assertStatement("bsr",
			"5>>>6",
			"<shift line=\"1\" column=\"1\"><number line=\"1\" column=\"1\">5</number>" +
			"<bsr line=\"1\" column=\"2\">&gt;&gt;&gt;</bsr><number line=\"1\" " +
			"column=\"5\">6</number></shift>");
	}
	
	/**
	 * Level 3
	 */
	public function testAdditiveExpression():void
	{
		assertStatement("plus",
			"5+6",
			"<additive line=\"1\" column=\"1\"><number line=\"1\" column=\"1\">" +
			"5</number><plus line=\"1\" column=\"2\">+</plus><number " +
			"line=\"1\" column=\"3\">6</number></additive>");
		
		assertStatement("minus",
			"5-6",
			"<additive line=\"1\" column=\"1\"><number line=\"1\" column=\"1\">" +
			"5</number><minus line=\"1\" column=\"2\">-</minus><number line=\"1\" " +
			"column=\"3\">6</number></additive>");
	}
	
	/**
	 * Level 2
	 */
	[Test]
	public function testMultiplicativeExpression():void
	{
		assertStatement("star",
			"5*6",
			"<multiplicative line=\"1\" column=\"1\"><number line=\"1\" " +
			"column=\"1\">5</number><star line=\"1\" column=\"2\">*</star>" +
			"<number line=\"1\" column=\"3\">6</number></multiplicative>");
		
		assertStatement("div",
			"5/6",
			"<multiplicative line=\"1\" column=\"1\"><number line=\"1\" " +
			"column=\"1\">5</number><div line=\"1\" column=\"2\">/</div>" +
			"<number line=\"1\" column=\"3\">6</number></multiplicative>");
		
		assertStatement("mod",
			"5%6",
			"<multiplicative line=\"1\" column=\"1\"><number line=\"1\" " +
			"column=\"1\">5</number><mod line=\"1\" column=\"2\">%</mod>" +
			"<number line=\"1\" column=\"3\">6</number></multiplicative>");
	}
	
	/**
	 * Level 1
	 */
	[Test]
	public function testUnaryExpression():void
	{
		assertStatement("pre-inc",
			"++i",
			"<pre-inc line=\"1\" column=\"3\"><primary line=\"1\" column=\"3\">i" +
			"</primary></pre-inc>");
		
		assertStatement("post-inc",
			"i++",
			"<post-inc line=\"1\" column=\"2\"><primary line=\"1\" column=\"1\">" +
			"i</primary></post-inc>");
		
		assertStatement("pre-dec",
			"--i",
			"<pre-dec line=\"1\" column=\"1\"><primary line=\"1\" column=\"3\">" +
			"i</primary></pre-dec>");
		
		assertStatement("post-dec",
			"i--",
			"<post-dec line=\"1\" column=\"2\"><primary line=\"1\" column=\"1\">" +
			"i</primary></post-dec>");
		
		assertStatement("delete",
			"delete obj.field",
			"<delete line=\"1\" column=\"8\"><dot line=\"1\" column=\"11\"><primary " +
			"line=\"1\" column=\"8\">obj</primary><primary line=\"1\" column=\"12\">" +
			"field</primary></dot></delete>");
		
		assertStatement("void",
			"void x",
			"<void line=\"1\" column=\"6\"><primary line=\"1\" column=\"6\">" +
			"x</primary></void>");
		
		assertStatement("typeof",
			"typeof obj",
			"<typeof line=\"1\" column=\"8\"><primary line=\"1\" column=\"8\">" +
			"obj</primary></typeof>");
		
		assertStatement("not",
			"!obj",
			"<not line=\"1\" column=\"2\"><primary line=\"1\" column=\"2\">" +
			"obj</primary></not>");
		
		assertStatement("bnot",
			"~x",
			"<b-not line=\"1\" column=\"2\"><primary line=\"1\" column=\"2\">" +
			"x</primary></b-not>");
	}
	
	[Test]
	public function testEncapsulated():void
	{
		assertStatement( "",
			"(dataProvider as ArrayCollection) = null",
			"<assignment line=\"1\" column=\"1\">" +
			"<encapsulated line=\"1\" column=\"1\"><relational line=\"1\" " +
			"column=\"2\"><primary line=\"1\" column=\"2\">dataProvider</primary>" +
			"<as line=\"1\" column=\"15\">as</as><primary line=\"1\" column=\"18\">" +
			"ArrayCollection</primary></relational></encapsulated>" +
			"<assign line=\"1\" column=\"35\">=</assign><null line=\"1\" " +
			"column=\"37\">null</null></assignment>" );
	}
	
	[Test]
	public function testNewExpression():void
	{
		assertStatement( "",
			"new Event()",
			"<new line=\"1\" column=\"1\">" +
			"<call line=\"1\" column=\"10\"><primary line=\"1\" column=\"5\">" +
			"Event</primary><arguments line=\"1\" column=\"10\"></arguments>" +
			"</call></new>" );
		
		assertStatement( "",
			"new Event(\"lala\")",
			"<new line=\"1\" column=\"1\">" +
			"<call line=\"1\" column=\"10\"><primary line=\"1\" column=\"5\">" +
			"Event</primary><arguments line=\"1\" column=\"10\"><string line=\"1\" " +
			"column=\"11\">\"lala\"</string></arguments></call></new>" );
	}
	
	[Test]
	public function testNewVectorExpression():void
	{
		var input:String = "new Vector.<String>(true, 255);";
		assertStatementPrint(input);
		assertStatement("1",
			input,
			"<new line=\"1\" column=\"1\">" +
			"<call line=\"1\" column=\"5\"><vector line=\"1\" column=\"5\"><type " +
			"line=\"1\" column=\"13\">String</type></vector><arguments line=\"1\" " +
			"column=\"20\"><true line=\"1\" column=\"21\">true</true><number line=\"1\" " +
			"column=\"27\">255</number></arguments></call></new>");
	}
	
	[Test]
	public function testSuperiorInferiorXMLBug():void
	{
		assertStatement("1",
			"a < 11 && b > 11",
			"<and line=\"1\" column=\"1\"><relational line=\"1\" column=\"1\">" +
			"<primary line=\"1\" column=\"1\">a</primary><lt line=\"1\" " +
			"column=\"3\">&lt;</lt><number line=\"1\" column=\"5\">11</number>" +
			"</relational><land line=\"1\" column=\"8\">&&</land><relational " +
			"line=\"1\" column=\"11\"><primary line=\"1\" column=\"11\">b" +
			"</primary><gt line=\"1\" column=\"13\">&gt;</gt><number line=\"1\" " +
			"column=\"15\">11</number></relational></and>");
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
	
	override protected function assertStatement(message:String, 
												input:String, 
												expected:String):void
	{
		var result:String = ASTUtil.convert(parseStatement(input));
		Assert.assertEquals(message, "<expr-stmnt line=\"1\" column=\"1\">" +
			expected + "</expr-stmnt>", result);
	}
}
}