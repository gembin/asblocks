package org.teotigraphix.asblocks.impl
{

import org.teotigraphix.as3parser.core.ASTPrinter;
import org.teotigraphix.as3parser.core.SourceCode;

public class BaseASFactoryTest
{
	protected var printer:ASTPrinter;
	
	protected var factory:ASFactory;
	protected var project:ASProject;
	
	[Before]
	public function setUp():void
	{
		printer = new ASTPrinter(new SourceCode());
		factory = new ASFactory();
		project = new ASProject(factory);
	}
}
}