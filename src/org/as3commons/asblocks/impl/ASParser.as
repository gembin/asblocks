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

package org.as3commons.asblocks.impl
{

import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.api.ISourceCode;
import org.as3commons.asblocks.parser.core.SourceCode;
import org.as3commons.asblocks.parser.errors.UnExpectedTokenError;
import org.as3commons.asblocks.parser.impl.AS3Parser;
import org.as3commons.asblocks.IASParser;
import org.as3commons.asblocks.api.ICompilationUnit;
import org.as3commons.asblocks.utils.ASTUtil;

/**
 * Implementation of the <code>IASParser</code> API.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class ASParser implements IASParser
{
	//--------------------------------------------------------------------------
	//
	//  IASParser API :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @copy org.as3commons.asblocks.IASParser#parse()
	 */
	public function parse(code:ISourceCode):ICompilationUnit
	{
		var parser:AS3Parser = ASTUtil.parse(code);
		var ast:IParserNode;
		try
		{
			ast = parser.parseCompilationUnit();
		}
		catch (e:UnExpectedTokenError)
		{
			throw ASTUtil.constructSyntaxError(null, parser, e);
		}
		return new CompilationUnitNode(ast);
	}
	
	/**
	 * @copy org.as3commons.asblocks.IASParser#parseString()
	 */
	public function parseString(source:String):ICompilationUnit
	{
		return parse(new SourceCode(source));
	}
}
}