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
 * A <code>switch(){case:default:}</code> statement unit test.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class TestSwitchStatement extends AbstractStatementTest
{
	[Test]
	public function testFullFeatured():void
	{
		var input:String = "switch( x ){ case 1 : trace('one'); break; default : trace('unknown'); }";
		assertStatementPrint(input);
		assertStatement("1", input,
			"<switch line=\"1\" column=\"1\"><condition line=\"1\" column=\"7\">" +
			"<primary line=\"1\" column=\"9\">x</primary></condition><cases " +
			"line=\"1\" column=\"12\"><case line=\"1\" column=\"14\"><number " +
			"line=\"1\" column=\"19\">1</number><switch-block line=\"1\" " +
			"column=\"23\"><call line=\"1\" column=\"28\"><primary line=\"1\" " +
			"column=\"23\">trace</primary><arguments line=\"1\" column=\"28\">" +
			"<string line=\"1\" column=\"29\">'one'</string></arguments></call>" +
			"<break line=\"1\" column=\"37\"></break></switch-block></case><case " +
			"line=\"1\" column=\"44\"><default line=\"1\" column=\"44\"></default>" +
			"<switch-block line=\"1\" column=\"54\"><call line=\"1\" column=\"59\">" +
			"<primary line=\"1\" column=\"54\">trace</primary><arguments line=\"1\" " +
			"column=\"59\"><string line=\"1\" column=\"60\">'unknown'</string>" +
			"</arguments></call></switch-block></case></cases></switch>");
		
		input = "switch( x ){ case 1 : break; default:}";
		assertStatementPrint(input);
		assertStatement("2", input,
			"<switch line=\"1\" column=\"1\"><condition line=\"1\" column=\"7\">" +
			"<primary line=\"1\" column=\"9\">x</primary></condition><cases " +
			"line=\"1\" column=\"12\"><case line=\"1\" column=\"14\"><number " +
			"line=\"1\" column=\"19\">1</number><switch-block line=\"1\" " +
			"column=\"23\"><break line=\"1\" column=\"23\"></break></switch-block>" +
			"</case><case line=\"1\" column=\"30\"><default line=\"1\" column=\"30\">" +
			"</default><switch-block line=\"1\" column=\"38\"></switch-block>" +
			"</case></cases></switch>");
	}
}
}