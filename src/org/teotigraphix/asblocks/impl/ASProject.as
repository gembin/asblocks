package org.teotigraphix.asblocks.impl
{

import org.teotigraphix.asblocks.api.ICompilationUnitNode;

public class ASProject
{
	private var factory:ASFactory;
	
	public function ASProject(factory:ASFactory)
	{
		this.factory = factory;
	}
	
	public function newClass(qualifiedName:String):ICompilationUnitNode
	{
		var cu:ICompilationUnitNode = factory.newClass(qualifiedName);
		addCompilationUnit(cu);
		return cu;
	}
	
	public function newInterface(qualifiedName:String):ICompilationUnitNode
	{
		var cu:ICompilationUnitNode = factory.newInterface(qualifiedName);
		addCompilationUnit(cu);
		return cu;
	}
	
	//----------------------------------
	//  compilationUnits
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _compilationUnits:Vector.<ICompilationUnitNode>;
	
	/**
	 * doc
	 */
	public function get compilationUnits():Vector.<ICompilationUnitNode>
	{
		return _compilationUnits;
	}
	
	
	public function addCompilationUnit(unit:ICompilationUnitNode):void
	{
		if (!_compilationUnits)
		{
			_compilationUnits = new Vector.<ICompilationUnitNode>();
		}
		
		_compilationUnits.push(unit);
	}
}
}