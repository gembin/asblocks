package org.teotigraphix.asblocks.impl
{

import org.teotigraphix.asblocks.api.IArrayAccessExpression;
import org.teotigraphix.asblocks.api.IExpression;
import org.teotigraphix.as3parser.api.IParserNode;

/**
 * The <code>IArrayAccessExpression</code> implementation.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class ArrayAccessExpressionNode extends ExpressionNode 
	implements IArrayAccessExpression
{
	//--------------------------------------------------------------------------
	//
	//  IArrayAccessExpression API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  target
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IArrayAccessExpression#target
	 */
	public function get target():IExpression
	{
		return ExpressionBuilder.build(node.getFirstChild());
	}
	
	/**
	 * @private
	 */	
	public function set target(value:IExpression):void
	{
		node.setChildAt(value.node, 0);
	}
	
	//----------------------------------
	//  subscript
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.asblocks.api.IArrayAccessExpression#subscript
	 */
	public function get subscript():IExpression
	{
		return ExpressionBuilder.build(node.getLastChild());
	}
	
	/**
	 * @private
	 */	
	public function set subscript(value:IExpression):void
	{
		node.setChildAt(value.node, 1);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function ArrayAccessExpressionNode(node:IParserNode)
	{
		super(node);
	}
}
}