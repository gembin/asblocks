package org.teotigraphix.as3parser.impl
{
import flexunit.framework.Assert;

import org.teotigraphix.as3parser.utils.ASTUtil;

public class AbstractStatementTest
{
	protected var parser:AS3Parser;
	
	[Before]
	public function setUp():void
	{
		parser = new AS3Parser();
	}
	
	protected function assertStatement(message:String, input:String, expected:String):void
	{
		var lines:Array = 
			[
				input,
				"__END__"
			];
		
		parser.scanner.setLines(ASTUtil.toVector(lines));
		
		parser.nextToken();
		
		var result:String = ASTUtil.convert(parser.parseStatement());
		Assert.assertEquals(message, expected, result);
	}
}
}