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
 * A <code>try{} catch(e:Error) {} finally {}</code> statement unit test.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class TestTryCatchFinallyStatement extends AbstractStatementTest
{
	[Test]
	public function testCatch():void
	{
		var input:String = "catch( e : Error ) {trace( true ); }";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<catch line=\"1\" column=\"1\"><name line=\"1\" column=\"8\">e</name>" +
			"<type line=\"1\" column=\"12\">Error</type><block line=\"1\" " +
			"column=\"20\"><call line=\"1\" column=\"26\"><primary line=\"1\" " +
			"column=\"21\">trace</primary><arguments line=\"1\" column=\"26\">" +
			"<true line=\"1\" column=\"28\">true</true></arguments></call>" +
			"</block></catch>");
	}
	
	[Test]
	public function testFinally():void
	{
		var input:String = "finally {trace( true ); }";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<finally line=\"1\" column=\"1\"><block line=\"1\" column=\"9\">" +
			"<call line=\"1\" column=\"15\"><primary line=\"1\" column=\"10\">" +
			"trace</primary><arguments line=\"1\" column=\"15\"><true line=\"1\" " +
			"column=\"17\">true</true></arguments></call></block></finally>");
	}
	
	[Test]
	public function testTry():void
	{
		var input:String = "try {trace( true ); }";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<try line=\"1\" column=\"1\"><block line=\"1\" column=\"5\">" +
			"<call line=\"1\" column=\"11\"><primary line=\"1\" column=\"6\">" +
			"trace</primary><arguments line=\"1\" column=\"11\"><true line=\"1\" " +
			"column=\"13\">true</true></arguments></call></block></try>");
	}
}
}