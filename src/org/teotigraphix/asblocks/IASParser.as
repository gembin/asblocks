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

package org.teotigraphix.asblocks
{

import org.teotigraphix.as3parser.api.ISourceCode;
import org.teotigraphix.asblocks.api.ICompilationUnit;

/**
 * Parse an entire ActionScript source file from the given 
 * <code>ISourceCode</code>, returning an <code>ICompilationUnit</code> 
 * which details the type  contained in the file.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public interface IASParser
{
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Parses the <code>ISourceCode</code>'s source code data.
	 * 
	 * @param code An <code>ISourceCode</code> instance holding the source
	 * code or fileName to parse into an <code>ICompilationUnit</code>.
	 * @return An <code>ICompilationUnit</code> detailing the source code.
	 * @throws org.teotigraphix.asblocks.ASBlocksSyntaxError
	 */
	function parse(code:ISourceCode):ICompilationUnit;
	
	/**
	 * Parses the <code>String</code> source code data.
	 * 
	 * @param source The <code>String</code> source code.
	 * @return An <code>ICompilationUnit</code> detailing the source code.
	 * @throws org.teotigraphix.asblocks.ASBlocksSyntaxError
	 */
	function parseString(source:String):ICompilationUnit;
}
}