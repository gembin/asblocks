package org.teotigraphix.as3nodes.impl
{

import org.teotigraphix.as3nodes.api.IFieldNode;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3nodes.api.Modifier;
import org.teotigraphix.as3parser.api.IParserNode;

public class FieldNode extends VariableNode implements IFieldNode
{
	
	//----------------------------------
	//  isPublic
	//----------------------------------
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IVisible#isPublic
	 */
	public function get isPublic():Boolean
	{
		return hasModifier(Modifier.PUBLIC);
	}
	
	//----------------------------------
	//  isStatic
	//----------------------------------
	
	public function get isStatic():Boolean
	{
		return hasModifier(Modifier.STATIC);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function FieldNode(node:IParserNode, parent:INode)
	{
		super(node, parent);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden Protected :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	override protected function compute():void
	{
		super.compute();
		
		// computeModifierList()
	}
}
}