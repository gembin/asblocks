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

import org.teotigraphix.as3nodes.impl.ParserFactory;
import org.teotigraphix.as3parser.api.IParser;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.utils.ASTUtil;

/**
 * A utility class to parse actionscript3 fragements that don't start
 * at the <code>AS3NodeKind.COMPILATION_UNIT</code>.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class AS3FragmentParser
{
	//--------------------------------------------------------------------------
	//
	//  Public Class :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Parses a <code>AS3NodeKind.STATEMENT</code> node.
	 * 
	 * @param statement A String statement to be parsed into AST.
	 * @return Returns a <code>AS3NodeKind.STATEMENT</code> node.
	 */
	public static function parseStatement(statement:String):IParserNode
	{
		var parser:AS3Parser = new AS3Parser();
		
		var lines:Array = 
			[
				statement
			];
		
		parser.scanner.setLines(ASTUtil.toVector(lines));
		parser.nextToken();
		var node:IParserNode = parser.parseStatement();
		return node;
	}
	
	/**
	 * Parses a <code>AS3NodeKind.PRIMARY</code> node.
	 * 
	 * @param statement A String statement to be parsed into AST.
	 * @return Returns a <code>AS3NodeKind.PRIMARY</code> node.
	 */
	public static function parsePrimaryExpression(expression:String):IParserNode
	{
		var parser:AS3Parser = new AS3Parser();
		
		var lines:Array = 
			[
				expression
			];
		
		parser.scanner.setLines(ASTUtil.toVector(lines));
		parser.nextToken();
		var node:IParserNode = parser.parsePrimaryExpression();
		return node;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * Parses a <code>AS3NodeKind.EXPRESSION</code> node.
	 * 
	 * @param statement A String statement to be parsed into AST.
	 * @return Returns a <code>AS3NodeKind.EXPRESSION</code> node.
	 */
	public static function parseExpression(expression:String):IParserNode
	{
		var parser:AS3Parser = new AS3Parser();
		
		var lines:Array = 
			[
				expression
			];
		
		parser.scanner.setLines(ASTUtil.toVector(lines));
		parser.nextToken();
		var node:IParserNode = parser.parseExpression();
		return node;
	}
	
	/**
	 * Parses a <code>AS3NodeKind.EXPRESSION_LIST</code> node.
	 * 
	 * @param statement A String statement to be parsed into AST.
	 * @return Returns a <code>AS3NodeKind.EXPRESSION_LIST</code> node.
	 */
	public static function parseExpressionList(expression:String):IParserNode
	{
		var i:int, j:int
		
		var parser:AS3Parser = new AS3Parser();
		
		var lines:Array = 
			[
				expression
			];
		
		parser.scanner.setLines(ASTUtil.toVector(lines));
		parser.nextToken();
		var node:IParserNode = parser.parseExpressionList();
		return node;
	}
	
	/**
	 * Parses a <code>AS3NodeKind.CONDITION</code> node.
	 * 
	 * @param statement A String statement to be parsed into AST.
	 * @return Returns a <code>AS3NodeKind.CONDITION</code> node.
	 */
	public static function parseCondition(condition:String):IParserNode
	{
		var parser:AS3Parser = new AS3Parser();
		
		var lines:Array = 
			[
				"(" + condition + ")",
				"__END__"
			];
		
		parser.scanner.setLines(ASTUtil.toVector(lines));
		parser.nextToken();
		// /condition
		var node:IParserNode = parser.parseCondition();
		return node;
	}
}
}