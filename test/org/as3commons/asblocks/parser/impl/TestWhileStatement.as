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
public class TestWhileStatement extends AbstractStatementTest
{
	[Test]
	public function testWhile():void
	{
		var input:String = "while( i++ ){ trace( i ); }";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<while line=\"1\" column=\"1\"><condition line=\"1\" column=\"6\">" +
			"<post-inc line=\"1\" column=\"9\"><primary line=\"1\" column=\"8\">i" +
			"</primary></post-inc></condition><block line=\"1\" column=\"13\">" +
			"<expr-stmnt line=\"1\" column=\"15\"><call line=\"1\" column=\"20\">" +
			"<primary line=\"1\" column=\"15\">trace</primary><arguments line=\"1\" " +
			"column=\"20\"><primary line=\"1\" column=\"22\">i</primary></arguments>" +
			"</call></expr-stmnt></block></while>");
	}
	
	[Test]
	public function testWhileWithLabel():void
	{
		var input:String = "myLoop : while( i++ ){ break myLoop; }";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<label line=\"1\" column=\"8\"><expr-stmnt line=\"1\" column=\"1\">" +
			"<primary line=\"1\" column=\"1\">myLoop</primary></expr-stmnt><while " +
			"line=\"1\" column=\"10\"><condition line=\"1\" column=\"15\"><post-inc " +
			"line=\"1\" column=\"18\"><primary line=\"1\" column=\"17\">i</primary>" +
			"</post-inc></condition><block line=\"1\" column=\"22\"><break line=\"1\" " +
			"column=\"24\"><primary line=\"1\" column=\"30\">myLoop</primary>" +
			"</break></block></while></label>");
	}
	
	[Test]
	public function testWhileWithEmptyStatement():void
	{
		var input:String = "while( i++ ); ";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<while line=\"1\" column=\"1\"><condition line=\"1\" column=\"6\">" +
			"<post-inc line=\"1\" column=\"9\"><primary line=\"1\" column=\"8\">i" +
			"</primary></post-inc></condition><stmt-empty line=\"1\" column=\"13\">;" +
			"</stmt-empty></while>");
	}
	
	[Test]
	public function testWhileWithoutBlock():void
	{
		var input:String = "while( i++ ) trace( i ); ";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<while line=\"1\" column=\"1\"><condition line=\"1\" column=\"6\"><post-inc " +
			"line=\"1\" column=\"9\"><primary line=\"1\" column=\"8\">i</primary></post-inc>" +
			"</condition><expr-stmnt line=\"1\" column=\"14\"><call line=\"1\" column=\"19\">" +
			"<primary line=\"1\" column=\"14\">trace</primary><arguments line=\"1\" " +
			"column=\"19\"><primary line=\"1\" column=\"21\">i</primary></arguments>" +
			"</call></expr-stmnt></while>");
	}
}
}