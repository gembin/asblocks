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
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.core.SourceCode;
import org.as3commons.asblocks.impl.ASTPrinter;
import org.as3commons.asblocks.utils.ASTUtil;

/*
primary

true
false
null
undefined

string
number
reg-exp
xml

array
object
lambda
throw
new
encapsulated

*/

/**
 * A <code>AS3Parser.parsePrimaryExpression()</code> expression unit test.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class TestPrimaryExpression
{
	private var parser:AS3Parser;
	
	[Before]
	public function setUp():void
	{
		parser = new AS3Parser();
	}
	
	[Test]
	public function testPrimary():void
	{
		assertPrimary("myObj", "myObj");
		assertPrimaryPrint("myObj");
	}
	
	[Test]
	public function testBooleans():void
	{
		assertPrimaryPrint("true");
		assertPrimaryType("true", "true", "true");
		
		assertPrimaryPrint("false");
		assertPrimaryType("false", "false", "false");
	}
	
	[Test]
	public function testNull():void
	{
		assertPrimaryPrint("null");
		assertPrimaryType("null", "null", "null");
	}
	
	[Test]
	public function testUndefined():void
	{
		assertPrimaryPrint("undefined");
		assertPrimaryType("undefined", "undefined", "undefined");
	}
	
	[Test]
	public function testStrings():void
	{
		assertPrimaryPrint("\"string\"");
		assertPrimaryType("string", "\"string\"", "\"string\"");
		
		assertPrimaryPrint("'string'");
		assertPrimaryType("string", "'string'", "'string'");
	}
	
	[Test]
	public function testNumbers():void
	{
		assertNumber("1", "1");
		assertPrimaryPrint("1");
		
		assertNumber("0xff", "0xff");
		assertPrimaryPrint("0xff");
		
		assertNumber("0420", "0420");
		assertPrimaryPrint("0420");
		
		assertNumber(".42E2", ".42E2");
		assertPrimaryPrint(".42E2");
	}
	
	[Test]
	public function testInfinity():void
	{
		assertNumber("Infinity", "Infinity");
		assertPrimaryPrint("Infinity");
		
		assertNumber("-Infinity", "-Infinity");
		assertPrimaryPrint("-Infinity");
	}
	
	[Test]
	public function testRegularExpression():void
	{
		// TODO impl unit test
	}
	
	[Test]
	public function testXML():void
	{
		// TODO impl unit test
	}
	
	[Test]
	public function testArrayLiteral():void
	{
		var input:String = "[1,2,3]";
		assertPrimaryPrint(input);
		assertTopPrimary(input,
			"<array line=\"1\" column=\"1\">" +
			"<number line=\"1\" column=\"2\">1</number><number line=\"1\" " +
			"column=\"4\">2</number><number line=\"1\" column=\"6\">3</number>" +
			"</array>");
		
		input = "[ 1\t, 2\n , 3 ]";
		assertPrimaryPrint(input);
		assertTopPrimary(input,
			"<array line=\"1\" column=\"1\"><number line=\"1\" column=\"3\">1" +
			"</number><number line=\"1\" column=\"7\">2</number><number line=\"2\" " +
			"column=\"4\">3</number></array>");
	}
	
	[Test]
	public function testObjectLiteral():void
	{
		var input:String = "{a:1,b:2}";
		assertPrimaryPrint(input);
		assertTopPrimary( input,
			"<object line=\"1\" column=\"1\">" +
			"<prop line=\"1\" column=\"2\"><name line=\"1\" column=\"2\">a</name>" +
			"<value line=\"1\" column=\"4\"><number line=\"1\" column=\"4\">1" +
			"</number></value></prop><prop line=\"1\" column=\"6\"><name line=\"1\" " +
			"column=\"6\">b</name><value line=\"1\" column=\"8\"><number line=\"1\" " +
			"column=\"8\">2</number></value></prop></object>");
		
		input = "{ a :\t 1 ,\n b : 2 }";
		assertPrimaryPrint(input);
		assertTopPrimary( input,
			"<object line=\"1\" column=\"1\"><prop line=\"1\" column=\"3\">" +
			"<name line=\"1\" column=\"3\">a</name><value line=\"1\" column=\"8\">" +
			"<number line=\"1\" column=\"8\">1</number></value></prop><prop line=\"2\" " +
			"column=\"2\"><name line=\"2\" column=\"2\">b</name><value line=\"2\" " +
			"column=\"6\"><number line=\"2\" column=\"6\">2</number></value>" +
			"</prop></object>");
	}
	
	[Test]
	public function testFunctionLiteral():void
	{
		var input:String = "function ( a : Object ) : * \n{ \ntrace('test'); }";
		assertPrimaryPrint(input);
		assertTopPrimary( input,
			"<lambda line=\"1\" column=\"1\"><parameter-list line=\"1\" " +
			"column=\"10\"><parameter line=\"1\" column=\"12\"><name-type-init " +
			"line=\"1\" column=\"12\"><name line=\"1\" column=\"12\">a</name>" +
			"<type line=\"1\" column=\"16\">Object</type></name-type-init>" +
			"</parameter></parameter-list><type line=\"1\" column=\"27\">*" +
			"</type><block line=\"2\" column=\"1\"><expr-stmnt line=\"3\" " +
			"column=\"1\"><call line=\"3\" column=\"6\"><primary line=\"3\" " +
			"column=\"1\">trace</primary><arguments line=\"3\" column=\"6\">" +
			"<string line=\"3\" column=\"7\">'test'</string></arguments></call>" +
			"</expr-stmnt></block></lambda>");
	}
	
	[Test]
	public function testNewLiteral():void
	{
		var input:String = "new ClassA()";
		assertPrimaryPrint(input);
		assertTopPrimary( input,
			"<new line=\"1\" column=\"1\"><call line=\"1\" column=\"11\">" +
			"<primary line=\"1\" column=\"5\">ClassA</primary><arguments " +
			"line=\"1\" column=\"11\"></arguments></call></new>");
	}
	
	[Test]
	public function testEncapsulatedLiteral():void
	{
		var input:String = "( world as Ball )";
		assertPrimaryPrint(input);
		assertTopPrimary( input,
			"<encapsulated line=\"1\" column=\"1\"><relational line=\"1\" " +
			"column=\"3\"><primary line=\"1\" column=\"3\">world</primary><as " +
			"line=\"1\" column=\"9\">as</as><primary line=\"1\" column=\"12\">" +
			"Ball</primary></relational></encapsulated>");
		
		input = "( \"world\" in myBall )";
		assertPrimaryPrint(input);
		assertTopPrimary( input,
			"<encapsulated line=\"1\" " +
			"column=\"1\"><relational line=\"1\" column=\"3\"><string " +
			"line=\"1\" column=\"3\">\"world\"</string><in line=\"1\" " +
			"column=\"11\">in</in><primary line=\"1\" column=\"14\">myBall" +
			"</primary></relational></encapsulated>");
	}
	
	//--------------------------------------------------------------------------
	//
	//  Private Utility :: Methods
	//
	//--------------------------------------------------------------------------
	
	private function assertNumber(input:String, 
								  expected:String):void
	{
		parser.scanner.setLines(Vector.<String>([input]));
		parser.nextToken(); // first call
		var result:String = ASTUtil.convert(parser.parsePrimaryExpression());
		Assert.assertEquals("<number line=\"1\" column=\"1\">" + 
			expected + "</number>", result);
	}
	
	private function assertPrimaryType(type:String,
									   input:String, 
									   expected:String):void
	{
		parser.scanner.setLines(Vector.<String>([input]));
		parser.nextToken(); // first call
		var result:String = ASTUtil.convert(parser.parsePrimaryExpression());
		Assert.assertEquals("<" + type + " line=\"1\" column=\"1\">" + 
			expected + "</" + type + ">", result);
	}
	
	private function assertPrimary(input:String, 
								   expected:String):void
	{
		parser.scanner.setLines(Vector.<String>([input]));
		parser.nextToken(); // first call
		var result:String = ASTUtil.convert(parser.parsePrimaryExpression());
		Assert.assertEquals("<primary line=\"1\" column=\"1\">" + 
			expected + "</primary>", result);
	}
	
	private function assertTopPrimary(input:String, 
									  expected:String):void
	{
		parser.scanner.setLines(Vector.<String>(input.split("\n")));
		parser.nextToken(); // first call
		var result:String = ASTUtil.convert(parser.parsePrimaryExpression());
		Assert.assertEquals(expected, result);
	}
	
	private function assertPrimaryPrint(input:String):void
	{
		var printer:ASTPrinter = createPrinter();
		printer.print(parsePrimary(input));
		Assert.assertEquals(input, printer.flush());
	}
	
	private function parsePrimary(input:String):IParserNode
	{
		parser.scanner.setLines(Vector.<String>([input]));
		parser.nextToken();
		return parser.parsePrimaryExpression();
	}
	
	private function createPrinter():ASTPrinter
	{
		return new ASTPrinter(new SourceCode());
	}
}
}