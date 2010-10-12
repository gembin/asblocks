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

/**
 * A <code>urary</code> statement unit test.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class TestUnaryExpression extends AbstractStatementTest
{
	[Test]
	public function testArrayAccess():void
	{
		var input:String = "x [ 0 ] ";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<expr-stmnt line=\"1\" column=\"1\"><arr-acc line=\"1\" column=\"3\"><primary line=\"1\" column=\"1\">x</primary><number line=\"1\" column=\"5\">0</number></arr-acc></expr-stmnt>");
	}
	
	[Test]
	public function testComplex():void
	{
		var input:String = "a.b['c'].d.e(1)";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<expr-stmnt line=\"1\" column=\"1\"><dot line=\"1\" column=\"2\"><primary line=\"1\" column=\"1\">a</primary><dot line=\"1\" column=\"9\"><arr-acc line=\"1\" column=\"4\"><primary line=\"1\" column=\"3\">b</primary><string line=\"1\" column=\"5\">'c'</string></arr-acc><dot line=\"1\" column=\"11\"><primary line=\"1\" column=\"10\">d</primary><call line=\"1\" column=\"13\"><primary line=\"1\" column=\"12\">e</primary><arguments line=\"1\" column=\"13\"><number line=\"1\" column=\"14\">1</number></arguments></call></dot></dot></dot></expr-stmnt>");
		
		input = "a.b['c']['d'].e(1)";
		assertStatementPrint(input);
		assertStatement("2", input,
			"<expr-stmnt line=\"1\" column=\"1\"><dot line=\"1\" column=\"2\"><primary line=\"1\" column=\"1\">a</primary><dot line=\"1\" column=\"14\"><arr-acc line=\"1\" column=\"4\"><primary line=\"1\" column=\"3\">b</primary><string line=\"1\" column=\"5\">'c'</string><string line=\"1\" column=\"10\">'d'</string></arr-acc><call line=\"1\" column=\"16\"><primary line=\"1\" column=\"15\">e</primary><arguments line=\"1\" column=\"16\"><number line=\"1\" column=\"17\">1</number></arguments></call></dot></dot></expr-stmnt>");
		
		input = "a . b [ 'c' ] [ 'd' ] . e ( 1 )";
		assertStatementPrint(input);
		assertStatement("3", input,
			"<expr-stmnt line=\"1\" column=\"1\"><dot line=\"1\" column=\"3\"><primary line=\"1\" column=\"1\">a</primary><dot line=\"1\" column=\"23\"><arr-acc line=\"1\" column=\"7\"><primary line=\"1\" column=\"5\">b</primary><string line=\"1\" column=\"9\">'c'</string><string line=\"1\" column=\"17\">'d'</string></arr-acc><call line=\"1\" column=\"27\"><primary line=\"1\" column=\"25\">e</primary><arguments line=\"1\" column=\"27\"><number line=\"1\" column=\"29\">1</number></arguments></call></dot></dot></expr-stmnt>");
	}
	
	[Test]
	public function testMethodCall():void
	{
		var input:String = "method ( )";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<expr-stmnt line=\"1\" column=\"1\"><call line=\"1\" column=\"8\"><primary line=\"1\" column=\"1\">method</primary><arguments line=\"1\" column=\"8\"></arguments></call></expr-stmnt>");
		
		input = "method ( 1, \"two\" )";
		assertStatementPrint(input);
		assertStatement("2", input,
			"<expr-stmnt line=\"1\" column=\"1\"><call line=\"1\" column=\"8\"><primary line=\"1\" column=\"1\">method</primary><arguments line=\"1\" column=\"8\"><number line=\"1\" column=\"10\">1</number><string line=\"1\" column=\"13\">\"two\"</string></arguments></call></expr-stmnt>");
	}
	
	[Test]
	public function testMultipleMethodCall():void
	{
		var input:String = "method ( ) ( )";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<expr-stmnt line=\"1\" column=\"1\"><call line=\"1\" column=\"8\"><primary line=\"1\" column=\"1\">method</primary><arguments line=\"1\" column=\"8\"></arguments><arguments line=\"1\" column=\"12\"></arguments></call></expr-stmnt>");
	}
	
	[Test]
	public function testParseUnaryExpressions():void
	{
		assertStatement("1",
			"++x",
			"<expr-stmnt line=\"1\" column=\"1\"><pre-inc line=\"1\" column=\"3\"><primary line=\"1\" column=\"3\">x</primary></pre-inc></expr-stmnt>");
		assertStatement("2",
			"x++",
			"<expr-stmnt line=\"1\" column=\"1\"><post-inc line=\"1\" column=\"2\"><primary line=\"1\" column=\"1\">x</primary></post-inc></expr-stmnt>");
		assertStatement("3",
			"--x",
			"<expr-stmnt line=\"1\" column=\"1\"><pre-dec line=\"1\" column=\"1\"><primary line=\"1\" column=\"3\">x</primary></pre-dec></expr-stmnt>");
		assertStatement("4",
			"x--",
			"<expr-stmnt line=\"1\" column=\"1\"><post-dec line=\"1\" column=\"2\"><primary line=\"1\" column=\"1\">x</primary></post-dec></expr-stmnt>");
		
		// TODO (mschmalle) column is messed up on unary +-
		/*
		assertStatement("5",
			"+x",
			"<expr-stmnt line=\"1\" column=\"1\"><plus line=\"1\" column=\"1\"><primary line=\"1\" column=\"2\">x</primary></plus></expr-stmnt>");
		assertStatement("6",
			"+ x",
			"<expr-stmnt line=\"1\" column=\"1\"><plus line=\"1\" column=\"1\"><primary line=\"1\" column=\"3\">x</primary></plus></expr-stmnt>");
		assertStatement("7",
			"-x",
			"<expr-stmnt line=\"1\" column=\"1\"><minus line=\"1\" column=\"1\"><primary line=\"1\" column=\"2\">x</primary></minus></expr-stmnt>");
		assertStatement("8",
			"- x",
			"<expr-stmnt line=\"1\" column=\"1\"><minus line=\"1\" column=\"1\"><primary line=\"1\" column=\"3\">x</primary></minus></expr-stmnt>");
		assertStatement("9",
			"delete x",
			"<expr-stmnt line=\"1\" column=\"1\"><delete line=\"1\" column=\"1\"><primary line=\"1\" column=\"8\">x</primary></delete></expr-stmnt>");
		assertStatement("10",
			"void x",
			"<expr-stmnt line=\"1\" column=\"1\"><void line=\"1\" column=\"1\"><primary line=\"1\" column=\"6\">x</primary></void></expr-stmnt>");
		assertStatement("11",
			"typeof x",
			"<expr-stmnt line=\"1\" column=\"1\"><typeof line=\"1\" column=\"1\"><primary line=\"1\" column=\"8\">x</primary></typeof></expr-stmnt>");
		assertStatement("12",
			"! x",
			"<expr-stmnt line=\"1\" column=\"1\"><not line=\"1\" column=\"1\"><primary line=\"1\" column=\"3\">x</primary></not></expr-stmnt>");
		assertStatement("13",
			"~ x",
			"<expr-stmnt line=\"1\" column=\"1\"><b-not line=\"1\" column=\"1\"><primary line=\"1\" column=\"3\">x</primary></b-not></expr-stmnt>");
		assertStatement("14",
			"x++",
			"<expr-stmnt line=\"1\" column=\"1\"><post-inc line=\"1\" column=\"2\"><primary line=\"1\" column=\"1\">x</primary></post-inc></expr-stmnt>");
		assertStatement("15",
			"x--",
			"<expr-stmnt line=\"1\" column=\"1\"><post-dec line=\"1\" column=\"2\"><primary line=\"1\" column=\"1\">x</primary></post-dec></expr-stmnt>");
		*/
	}
}
}