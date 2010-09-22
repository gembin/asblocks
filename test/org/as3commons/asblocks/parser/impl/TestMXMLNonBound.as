package org.as3commons.asblocks.parser.impl
{
import flexunit.framework.Assert;

import org.as3commons.asblocks.parser.api.IScanner;
import org.as3commons.asblocks.utils.ASTUtil;

public class TestMXMLNonBound
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
	public function test_parseCompilationUnit():void
	{
		var lines:Array =
			[
				"<?xml version=\"1.0\" encoding=\"utf-8\"?>",
				"<Application>", 
				"</Application>", 
				"__END__"
			];
		
		scanner.setLines(Vector.<String>(lines));
		
		var result:String = ASTUtil.convert(parser.parseCompilationUnit());
		
		Assert.assertEquals("<compilation-unit line=\"-1\" column=\"-1\">" +
			"<proc-inst line=\"1\" column=\"1\">&lt;?xml version=\"1.0\" " +
			"encoding=\"utf-8\"?&gt;</proc-inst><tag-list line=\"2\" column=\"1\">" +
			"<local-name line=\"2\" column=\"2\">Application</local-name>" +
			"</tag-list></compilation-unit>", result);
	}
	
	[Test]
	public function test_parseTagList():void
	{
		var lines:Array =
			[
				"<Application width=\"420\" height=\"420\">", 
				"    <Button id=\"button\"/>",
				"</Application>", 
				"__END__"
			];
		
		scanner.setLines(Vector.<String>(lines));
		
		parser.nextToken(); // into <
		
		var result:String = ASTUtil.convert(parser.parseTagList());
		
		Assert.assertEquals("<tag-list line=\"1\" column=\"1\">"
			+ "<local-name line=\"1\" column=\"2\">Application"
			+ "</local-name><att line=\"1\" column=\"14\">"
			+ "<name line=\"1\" column=\"14\">width</name>"
			+ "<value line=\"1\" column=\"20\">420</value></att>"
			+ "<att line=\"1\" column=\"26\"><name line=\"1\" "
			+ "column=\"26\">height</name><value line=\"1\" column=\"33\">"
			+ "420</value></att><tag-list line=\"2\" column=\"5\">"
			+ "<local-name line=\"2\" column=\"6\">Button</local-name>"
			+ "<att line=\"2\" column=\"13\"><name line=\"2\" column=\"13\">"
			+ "id</name><value line=\"2\" column=\"16\">button</value></att>"
			+ "</tag-list></tag-list>", result);
	}
	
	[Test]
	public function test_parseTagList_attributeSate():void
	{
		var lines:Array =
			[
				"<Application alpha.disabled=\"0.5\">", 
				"</Application>", 
				"__END__"
			];
		
		scanner.setLines(Vector.<String>(lines));
		
		parser.nextToken(); // into <
		
		var result:String = ASTUtil.convert(parser.parseTagList());
		
		Assert.assertEquals("<tag-list line=\"1\" column=\"1\"><local-name line=\"1\" "
			+ "column=\"2\">Application</local-name><att line=\"1\" "
			+ "column=\"14\"><name line=\"1\" column=\"14\">alpha</name>"
			+ "<value line=\"1\" column=\"29\">0.5</value><state line=\"1\" "
			+ "column=\"20\">disabled</state></att></tag-list>", result);
	}
}
}