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
 * A <code>try{} catch(e:Error) {} finally {}</code> statement unit test.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class TestTryCatchFinallyStatement extends AbstractStatementTest
{	
	[Test]
	public function testFullFeatured():void
	{
		var input:String = "try { } catch ( e1 : IOError ) { } catch ( e2 : Error ) { } finally { }";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<try-stmnt line=\"1\" column=\"1\"><try line=\"1\" column=\"1\">" +
			"<block line=\"1\" column=\"5\"></block></try><catch line=\"1\" " +
			"column=\"9\"><name line=\"1\" column=\"17\">e1</name><type line=\"1\" " +
			"column=\"22\">IOError</type><block line=\"1\" column=\"32\">" +
			"</block></catch><catch line=\"1\" column=\"36\"><name line=\"1\" " +
			"column=\"44\">e2</name><type line=\"1\" column=\"49\">Error</type>" +
			"<block line=\"1\" column=\"57\"></block></catch><finally line=\"1\" " +
			"column=\"61\"><block line=\"1\" column=\"69\"></block>" +
			"</finally></try-stmnt>");
	}
	
	[Test]
	public function testTry():void
	{
		var input:String = "try {trace( true ); }";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<try-stmnt line=\"1\" column=\"1\"><try line=\"1\" column=\"1\">" +
			"<block line=\"1\" column=\"5\"><expr-stmnt line=\"1\" column=\"6\">" +
			"<call line=\"1\" column=\"11\"><primary line=\"1\" column=\"6\">trace" +
			"</primary><arguments line=\"1\" column=\"11\"><true line=\"1\" " +
			"column=\"13\">true</true></arguments></call></expr-stmnt></block>" +
			"</try></try-stmnt>");
	}
	
	[Test]
	public function testFinally():void
	{
		var input:String = "try { } finally { trace( true ); }";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<try-stmnt line=\"1\" column=\"1\"><try line=\"1\" column=\"1\">" +
			"<block line=\"1\" column=\"5\"></block></try><finally line=\"1\" " +
			"column=\"9\"><block line=\"1\" column=\"17\"><expr-stmnt line=\"1\" " +
			"column=\"19\"><call line=\"1\" column=\"24\"><primary line=\"1\" " +
			"column=\"19\">trace</primary><arguments line=\"1\" column=\"24\">" +
			"<true line=\"1\" column=\"26\">true</true></arguments></call></expr-stmnt>" +
			"</block></finally></try-stmnt>");
	}
	
	[Test]
	public function testCatch():void
	{
		var input:String = "try { } catch( e : Error ) { trace( true ); }";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<try-stmnt line=\"1\" column=\"1\"><try line=\"1\" column=\"1\">" +
			"<block line=\"1\" column=\"5\"></block></try><catch line=\"1\" " +
			"column=\"9\"><name line=\"1\" column=\"16\">e</name><type line=\"1\" " +
			"column=\"20\">Error</type><block line=\"1\" column=\"28\"><expr-stmnt " +
			"line=\"1\" column=\"30\"><call line=\"1\" column=\"35\"><primary line=\"1\" " +
			"column=\"30\">trace</primary><arguments line=\"1\" column=\"35\">" +
			"<true line=\"1\" column=\"37\">true</true></arguments></call></expr-stmnt>" +
			"</block></catch></try-stmnt>");
	}
}
}