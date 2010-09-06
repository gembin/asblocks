package org.teotigraphix.asblocks.impl
{

import org.teotigraphix.asblocks.api.ICompilationUnit;
import org.teotigraphix.asblocks.ASFactory;

public class ASProject
{
	private var factory:ASFactory;
	
	public function ASProject(factory:ASFactory)
	{
		this.factory = factory;
	}
	
	public function newClass(qualifiedName:String):ICompilationUnit
	{
		var cu:ICompilationUnit = factory.newClass(qualifiedName);
		addCompilationUnit(cu);
		return cu;
	}
	
	public function newInterface(qualifiedName:String):ICompilationUnit
	{
		var cu:ICompilationUnit = factory.newInterface(qualifiedName);
		addCompilationUnit(cu);
		return cu;
	}
	
	//----------------------------------
	//  compilationUnits
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _compilationUnits:Vector.<ICompilationUnit>;
	
	/**
	 * doc
	 */
	public function get compilationUnits():Vector.<ICompilationUnit>
	{
		return _compilationUnits;
	}
	
	
	public function addCompilationUnit(unit:ICompilationUnit):void
	{
		if (!_compilationUnits)
		{
			_compilationUnits = new Vector.<ICompilationUnit>();
		}
		
		_compilationUnits.push(unit);
	}
}
}