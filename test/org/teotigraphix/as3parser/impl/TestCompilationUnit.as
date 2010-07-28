package org.teotigraphix.as3parser.impl
{

import flexunit.framework.Assert;

import org.teotigraphix.as3parser.utils.ASTUtil;

public class TestCompilationUnit
{
	private var parser:AS3Parser;
	
	private var scanner:AS3Scanner;
	
	[Before]
	public function setUp():void
	{
		parser = new AS3Parser();
		scanner = parser.scanner as AS3Scanner;
	}
	
	[Test]
	public function testDefaultPackage():void
	{
		var lines:Array =
			[
				"package { class A {} } ",
				"__END__"
			];
		
		scanner.setLines(ASTUtil.toVector(lines));
		
		var result:String = ASTUtil.convert(parser.parseCompilationUnit());
		
		Assert.assertEquals("<compilation-unit line=\"-1\" column=\"-1\"><package line=\"1\" " +
			"column=\"1\"><name line=\"1\" column=\"9\"></name><content line=\"1\" " +
			"column=\"11\"><class line=\"1\" column=\"17\"><name line=\"1\" column=\"17\">" +
			"A</name><content line=\"1\" column=\"20\"></content></class></content>" +
			"</package><content line=\"2\" column=\"1\"></content></compilation-unit>",
			result);
	}
	
	[Test]
	public function testEmptyPackage():void
	{
		var lines:Array =
			[
				"package a { } ",
				"__END__"
			];
		
		scanner.setLines(ASTUtil.toVector(lines));
		
		var result:String = ASTUtil.convert(parser.parseCompilationUnit());
		
		Assert.assertEquals("<compilation-unit line=\"-1\" column=\"-1\">"
			+ "<package line=\"1\" column=\"1\">" 
			+ "<name line=\"1\" column=\"9\">a"
			+ "</name><content line=\"1\" column=\"13\">"
			+ "</content></package><content line=\"2\" column=\"1\">"
			+ "</content></compilation-unit>",
			result);
	}
	
	[Test]
	public function testEmptyPackagePlusLocalClass():void
	{
		var lines:Array =
			[
				"package a { } class Local { }",
				"__END__"
			];
		
		scanner.setLines(ASTUtil.toVector(lines));
		
		var result:String = ASTUtil.convert(parser.parseCompilationUnit());
		
		Assert.assertEquals("<compilation-unit line=\"-1\" column=\"-1\">" +
			"<package line=\"1\" column=\"1\"><name line=\"1\" column=\"9\">" +
			"a</name><content line=\"1\" column=\"13\"></content></package>" +
			"<content line=\"1\" column=\"15\"><class line=\"1\" column=\"21\">" +
			"<name line=\"1\" column=\"21\">Local</name><content line=\"1\" " +
			"column=\"29\"></content></class></content></compilation-unit>",
			result);
	}
	
	[Test]
	public function testPackageWithClass():void
	{
		var lines:Array =
			[
				"package a { public class B { } } ",
				"__END__"
			];
		
		scanner.setLines(ASTUtil.toVector(lines));
		
		var result:String = ASTUtil.convert(parser.parseCompilationUnit());
		
		Assert.assertEquals("<compilation-unit line=\"-1\" column=\"-1\">" +
			"<package line=\"1\" column=\"1\"><name line=\"1\" column=\"9\">" +
			"a</name><content line=\"1\" column=\"13\"><class line=\"1\" " +
			"column=\"26\"><name line=\"1\" column=\"26\">B</name><mod-list " +
			"line=\"1\" column=\"13\"><mod line=\"1\" column=\"13\">public" +
			"</mod></mod-list><content line=\"1\" column=\"30\"></content>" +
			"</class></content></package><content line=\"2\" column=\"1\">" +
			"</content></compilation-unit>",
			result);
	}
	
	[Test]
	public function testPackageWithInterface():void
	{
		var lines:Array =
			[
				"package a { public interface B { } } ",
				"__END__"
			];
		
		scanner.setLines(ASTUtil.toVector(lines));
		
		var result:String = ASTUtil.convert(parser.parseCompilationUnit());
		
		Assert.assertEquals("<compilation-unit line=\"-1\" column=\"-1\">" +
			"<package line=\"1\" column=\"1\"><name line=\"1\" column=\"9\">" +
			"a</name><content line=\"1\" column=\"13\"><interface line=\"1\" " +
			"column=\"30\"><name line=\"1\" column=\"30\">B</name><mod-list " +
			"line=\"1\" column=\"13\"><mod line=\"1\" column=\"13\">public" +
			"</mod></mod-list><content line=\"1\" column=\"34\"></content>" +
			"</interface></content></package><content line=\"2\" column=\"1\">" +
			"</content></compilation-unit>",
			result);
	}
}
}