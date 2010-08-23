package org.teotigraphix.as3blocks.impl
{

import org.teotigraphix.as3blocks.api.IArrayAccessExpressionNode;
import org.teotigraphix.as3blocks.api.IExpressionNode;
import org.teotigraphix.as3parser.api.IParserNode;

/**
 * TODO DOCME
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class ArrayAccessExpressionNode extends ExpressionNode 
	implements IArrayAccessExpressionNode
{
	//--------------------------------------------------------------------------
	//
	//  IArrayAccessExpressionNode API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  target
	//----------------------------------
	
	/**
	 * doc
	 */
	public function get target():IExpressionNode
	{
		//return ExpressionBuilder.build(node.getFirstChild());
		return ExpressionBuilder.build(node.getChild(0));
	}
	
	/**
	 * @private
	 */	
	public function set target(value:IExpressionNode):void
	{
		var ast:IParserNode = ExpressionNode(value).node
		//node.setChildWithTokens(0, ast);
	}
	
	//----------------------------------
	//  subscript
	//----------------------------------
	
	/**
	 * doc
	 */
	public function get subscript():IExpressionNode
	{
		return ExpressionBuilder.build(node.getLastChild());
	}
	
	/**
	 * @private
	 */	
	public function set subscript(value:IExpressionNode):void
	{
		var ast:IParserNode = ExpressionNode(value).node
		//node.setChildWithTokens(1, ast);
	}
	
	public function ArrayAccessExpressionNode(node:IParserNode)
	{
		super(node);
	}
}
}