package org.teotigraphix.as3parser.impl
{

import flexunit.framework.Assert;

import org.teotigraphix.as3parser.utils.ASTUtil;

public class TestInterface
{
	private var parser:AS3ParserOLD;
	
	[Before]
	public function setUp():void
	{
		parser = new AS3ParserOLD();
	}
	
	[Test]
	public function testExtends():void
	{
		assertPackageContent( "1",
			"public interface A extends B { } ",
			"<content line=\"2\" column=\"1\"><interface line=\"2\" column=\"18\">"
			+ "<name line=\"2\" column=\"18\">A</name><mod-list line=\"2\" column=\"1\">"
			+ "<mod line=\"2\" column=\"1\">public</mod>"
			+ "</mod-list><extends line=\"2\" column=\"28\">B</extends>"
			+ "<content line=\"2\" column=\"32\"></content></interface></content>" );
		
		assertPackageContent( "",
			"   public interface ITimelineEntryRenderer extends IFlexDisplayObject, IDataRenderer{}",
			"<content line=\"2\" column=\"4\"><interface line=\"2\" column=\"21\"><name line=\"2\" "
			+ "column=\"21\">ITimelineEntryRenderer</name><mod-list line=\"2\" column=\"4\">"
			+ "<mod line=\"2\" column=\"4\">public</mod></mod-list><extends line=\"2\" "
			+ "column=\"52\">IFlexDisplayObject</extends><extends line=\"2\" column=\"72\">"
			+ "IDataRenderer</extends><content line=\"2\" column=\"86\">"
			+ "</content></interface></content>" );
	}
	
	[Test]
	public function testInclude():void
	{
		assertPackageContent( "1",
			"public interface A extends B { include \"ITextFieldInterface.asz\" } ",
			"<content line=\"2\" column=\"1\"><interface line=\"2\" column=\"18\">"
			+ "<name line=\"2\" column=\"18\">A</name><mod-list line=\"2\" column=\"1\">"
			+ "<mod line=\"2\" column=\"1\">public</mod></mod-list>"
			+ "<extends line=\"2\" column=\"28\">"
			+ "B</extends><content line=\"2\" column=\"32\"><include line=\"2\" column=\"32\">"
			+ "<primary line=\"2\" column=\"40\">\"ITextFieldInterface.asz\"</primary>"
			+ "</include></content></interface></content>" );
	}
	
	private function assertPackageContent(message:String, 
										  input:String, 
										  expected:String):void
	{
		var lines:Array =
			[
				"{",
				input,
				"}",
				"__END__"
			];
		
		parser.scanner.setLines(ASTUtil.toVector(lines));
		
		parser.nextToken(); // first call
		parser.nextToken(); // skip {
		
		Assert.assertEquals(expected, ASTUtil.convert(parser.parsePackageContent()));
	}
}
}