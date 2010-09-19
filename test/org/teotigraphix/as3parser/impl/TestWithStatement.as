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
 * A <code>with()</code> statement unit test.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class TestWithStatement extends AbstractStatementTest
{
	[Test]
	public function testWith():void
	{
		var input:String = "with ( someOther_mc ) {}";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<with line=\"1\" column=\"1\"><condition line=\"1\" column=\"6\">" +
			"<primary line=\"1\" column=\"8\">someOther_mc</primary></condition>" +
			"<block line=\"1\" column=\"23\"></block></with>");
	}
	
	[Test]
	public function testWithEmpty():void
	{
		var input:String = "with ( someOther_mc ) ;";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<with line=\"1\" column=\"1\"><condition line=\"1\" column=\"6\">" +
			"<primary line=\"1\" column=\"8\">someOther_mc</primary></condition>" +
			"<stmt-empty line=\"1\" column=\"23\">;</stmt-empty></with>");
	}
	
	[Test]
	public function testWithStatements():void
	{
		var input:String = "with ( someOther_mc ) { _y = 50; _x = 50; }";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<with line=\"1\" column=\"1\"><condition line=\"1\" column=\"6\"><primary " +
			"line=\"1\" column=\"8\">someOther_mc</primary></condition><block line=\"1\" " +
			"column=\"23\"><expr-stmnt line=\"1\" column=\"25\"><assignment line=\"1\" " +
			"column=\"25\"><primary line=\"1\" column=\"25\">_y</primary><assign line=\"1\" " +
			"column=\"28\">=</assign><number line=\"1\" column=\"30\">50</number>" +
			"</assignment></expr-stmnt><expr-stmnt line=\"1\" column=\"34\"><assignment " +
			"line=\"1\" column=\"34\"><primary line=\"1\" column=\"34\">_x</primary>" +
			"<assign line=\"1\" column=\"37\">=</assign><number line=\"1\" column=\"39\">50" +
			"</number></assignment></expr-stmnt></block></with>");
	}
}
}