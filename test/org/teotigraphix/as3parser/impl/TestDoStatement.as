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
 * A <code>do{}</code> and <code>do{} while()</code> statement unit test.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class TestDoStatement extends AbstractStatementTest
{
	[Test]
	public function testDo():void
	{
		var input:String = "do{ trace( i ); } while( i++ );";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<do line=\"1\" column=\"1\"><block line=\"1\" column=\"3\"><call " +
			"line=\"1\" column=\"10\"><primary line=\"1\" column=\"5\">trace</primary>" +
			"<arguments line=\"1\" column=\"10\"><primary line=\"1\" column=\"12\">i" +
			"</primary></arguments></call></block><condition line=\"1\" column=\"24\">" +
			"<post-inc line=\"1\" column=\"27\"><primary line=\"1\" column=\"26\">i" +
			"</primary></post-inc></condition></do>");
	}
	
	[Test]
	public function testDoWithEmptyStatement():void
	{
		var input:String = "do ; while( i++ ); ";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<do line=\"1\" column=\"1\"><stmt-empty line=\"1\" column=\"4\">;" +
			"</stmt-empty><condition line=\"1\" column=\"11\"><post-inc line=\"1\" " +
			"column=\"14\"><primary line=\"1\" column=\"13\">i</primary></post-inc>" +
			"</condition></do>");
	}
	
	[Test]
	public function testDoWithoutBlock():void
	{
		var input:String = "do trace( i ); while( i++ ); ";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<do line=\"1\" column=\"1\"><call line=\"1\" column=\"9\"><primary " +
			"line=\"1\" column=\"4\">trace</primary><arguments line=\"1\" column=\"9\">" +
			"<primary line=\"1\" column=\"11\">i</primary></arguments></call><condition " +
			"line=\"1\" column=\"21\"><post-inc line=\"1\" column=\"24\"><primary " +
			"line=\"1\" column=\"23\">i</primary></post-inc></condition></do>");
	}
}
}