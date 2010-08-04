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
	public function testVector_bug1():void
	{
		var lines:Array =
			[
				"package my.domain {",
				"    public class Test {",
				"        public function getMetaData(name:String):Vector.<IMetaDataNode> {",
				"            var result:Vector.<IMetaDataNode> = new Vector.<IMetaDataNode>();",
				"            return result;",
				"      }",
				"}",
				"}",
				"__END__"
			];
		
		scanner.setLines(ASTUtil.toVector(lines));
		
		var result:String = ASTUtil.convert(parser.parseCompilationUnit());
		
		Assert.assertEquals("<compilation-unit line=\"-1\" column=\"-1\">" +
			"<package line=\"1\" column=\"1\"><name line=\"1\" column=\"9\">" +
			"my.domain</name><content line=\"2\" column=\"5\"><class line=\"2\" " +
			"column=\"18\"><name line=\"2\" column=\"18\">Test</name><mod-list line=\"2\" " +
			"column=\"5\"><mod line=\"2\" column=\"5\">public</mod></mod-list>" +
			"<content line=\"3\" column=\"9\"><function line=\"3\" column=\"73\">" +
			"<mod-list line=\"3\" column=\"9\"><mod line=\"3\" column=\"9\">public</mod>" +
			"</mod-list><name line=\"3\" column=\"25\">getMetaData</name>" +
			"<parameter-list line=\"3\" column=\"37\"><parameter line=\"3\" " +
			"column=\"37\"><name-type-init line=\"3\" column=\"37\"><name line=\"3\" " +
			"column=\"37\">name</name><type line=\"3\" column=\"42\">String</type>" +
			"</name-type-init></parameter></parameter-list><vector line=\"3\" column=\"50\">" +
			"<type line=\"3\" column=\"58\">IMetaDataNode</type></vector><block line=\"4\" " +
			"column=\"13\"><var-list line=\"4\" column=\"17\"><name-type-init line=\"4\"" +
			" column=\"17\"><name line=\"4\" column=\"17\">result</name><vector line=\"4\" " +
			"column=\"24\"><type line=\"4\" column=\"32\">IMetaDataNode</type></vector>" +
			"<init line=\"4\" column=\"49\"><new line=\"4\" column=\"53\"><primary " +
			"line=\"4\" column=\"53\">Vector</primary><arguments line=\"4\" column=\"76\">" +
			"</arguments></new></init></name-type-init></var-list><return line=\"5\" " +
			"column=\"20\"><primary line=\"5\" column=\"20\">result</primary></return>" +
			"</block></function></content></class></content></package><content line=\"9\" " +
			"column=\"1\"></content></compilation-unit>",
			result);
	}
	
	[Test]
	public function testGarbageCommentsExtendsList():void
	{
		var lines:Array =
			[
				"package org.teotigraphix.as3nodes.api {",
				"    public interface IParameterNode extends INode, /*ICommentAware,*/ INameAware {",
				"    }", 
				"}",
				"__END__"
			];
		
		scanner.setLines(ASTUtil.toVector(lines));
		
		var result:String = ASTUtil.convert(parser.parseCompilationUnit());
		
		Assert.assertEquals("<compilation-unit line=\"-1\" column=\"-1\">" +
			"<package line=\"1\" column=\"1\"><name line=\"1\" column=\"9\">" +
			"org.teotigraphix.as3nodes.api</name><content line=\"2\" column=\"5\">" +
			"<interface line=\"2\" column=\"22\"><name line=\"2\" column=\"22\">" +
			"IParameterNode</name><mod-list line=\"2\" column=\"5\"><mod line=\"2\" " +
			"column=\"5\">public</mod></mod-list><extends line=\"2\" column=\"45\">" +
			"INode</extends><extends line=\"2\" column=\"71\">INameAware</extends>" +
			"<content line=\"3\" column=\"5\"></content></interface></content>" +
			"</package><content line=\"5\" column=\"1\"></content></compilation-unit>",
			result);
	}
	
	[Test]
	public function testGarbageCommentsPackage():void
	{
		var lines:Array =
			[
				"/*foo*/package /*bar*/{ public /*baz*/class /*bing*/A /*bang*/{",
				"}/*ring*/", 
				"}//boom ",
				"__END__"
			];
		
		scanner.setLines(ASTUtil.toVector(lines));
		
		var result:String = ASTUtil.convert(parser.parseCompilationUnit());
		
		Assert.assertEquals("<compilation-unit line=\"-1\" column=\"-1\"><package line=\"1\" " +
			"column=\"8\"><name line=\"1\" column=\"23\"></name><content line=\"1\" " +
			"column=\"25\"><class line=\"1\" column=\"53\"><name line=\"1\" column=\"53\">" +
			"A</name><mod-list line=\"1\" column=\"25\"><mod line=\"1\" column=\"25\">" +
			"public</mod></mod-list><content line=\"2\" column=\"1\"></content></class>" +
			"</content></package><content line=\"4\" column=\"1\"></content></compilation-unit>",
			result);
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