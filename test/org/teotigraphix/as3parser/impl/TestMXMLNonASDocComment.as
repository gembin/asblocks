package org.teotigraphix.as3parser.impl
{
import flexunit.framework.Assert;

import org.teotigraphix.as3parser.api.IScanner;
import org.teotigraphix.asblocks.utils.ASTUtil;

public class TestMXMLNonASDocComment
{
	private var parser:MXMLParser;
	
	private var scanner:IScanner;
	
	[Before]
	public function setUp():void
	{
		parser = new MXMLParser();
		scanner = parser.scanner;
	}
	
	[Test]
	public function test_parseCompilationUnit_noDocOnApplication():void
	{
		var lines:Array =
			[
				"<?xml version=\"1.0\" encoding=\"utf-8\"?>",
				"<!-- no doc -->",
				"<Application>", 
				"</Application>", 
				"__END__"
			];
		
		scanner.setLines(Vector.<String>(lines));
		
		var result:String = ASTUtil.convert(parser.parseCompilationUnit());
		
		Assert.assertEquals("<compilation-unit line=\"-1\" column=\"-1\">"
			+ "<proc-inst line=\"1\" column=\"1\">&lt;?xml "
			+ "version=\"1.0\" encoding=\"utf-8\"?&gt;</proc-inst>"
			+ "<tag-list line=\"3\" column=\"1\"><local-name line=\"3\" "
			+ "column=\"2\">Application</local-name></tag-list>"
			+ "</compilation-unit>", result);
	}
	
	[Test]
	public function test_parseCompilationUnit_noDocOnChild():void
	{
		var lines:Array =
			[
				"<?xml version=\"1.0\" encoding=\"utf-8\"?>",
				"<!-- no doc -->",
				"<Application>", 
				"    <!-- \n",
				"      * no doc \n",
				"     -->",
				"    <s:Button/>",
				"</Application>", 
				"__END__"
			];
		
		scanner.setLines(Vector.<String>(lines));
		
		var result:String = ASTUtil.convert(parser.parseCompilationUnit());
		
		Assert.assertEquals("<compilation-unit line=\"-1\" column=\"-1\">"
			+ "<proc-inst line=\"1\" column=\"1\">&lt;?xml "
			+ "version=\"1.0\" encoding=\"utf-8\"?&gt;</proc-inst>"
			+ "<tag-list line=\"3\" column=\"1\"><local-name line=\"3\" "
			+ "column=\"2\">Application</local-name><tag-list line=\"7\" "
			+ "column=\"5\"><binding line=\"7\" column=\"6\">s</binding>"
			+ "<local-name line=\"7\" column=\"8\">Button</local-name>"
			+ "</tag-list></tag-list></compilation-unit>", result);
	}
}
}