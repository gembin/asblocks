package org.teotigraphix.asblocks.impl
{

import org.teotigraphix.as3parser.core.ASTPrinter;
import org.teotigraphix.as3parser.core.SourceCode;
import org.teotigraphix.as3parser.impl.AS3Parser;
import org.teotigraphix.as3parser.impl.AS3Scanner;

public class BaseASFactoryTest
{
	protected var printer:ASTPrinter;
	
	protected var factory:ASFactory;
	
	protected var project:ASProject;
	
	protected var parser:AS3Parser;
	
	protected var scanner:AS3Scanner;
	
	[Before]
	public function setUp():void
	{
		parser = new AS3Parser();
		scanner = parser.scanner as AS3Scanner;
		printer = new ASTPrinter(new SourceCode());
		factory = new ASFactory();
		project = new ASProject(factory);
	}
}
}