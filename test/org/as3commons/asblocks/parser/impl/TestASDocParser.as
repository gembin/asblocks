package org.as3commons.asblocks.parser.impl
{

import flexunit.framework.Assert;

import org.as3commons.asblocks.impl.ASTPrinter;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.core.SourceCode;
import org.as3commons.asblocks.utils.ASTUtil;

public class TestASDocParser
{
	private var parser:ASDocParser;
	
	private var scanner:ASDocScanner;
	
	[Before]
	public function setUp():void
	{
		parser = new ASDocParser();
		scanner = parser.scanner as ASDocScanner;
	}
	
	[Test]
	public function test_parseBody():void
	{
		var input:String = "A document comment description.";
		
		var ast:IParserNode = ASDocFragmentParser.parseBody(input);
		
		var result:String = ASTUtil.convert(ast, false);
		Assert.assertEquals("<body><text-block><text>A document comment description." +
			"</text></text-block></body>", result);
	}
	
	[Test]
	public function test_parseBodyWithNL():void
	{
		var input:String = "A document comment description\nwith a second line.";
		
		var ast:IParserNode = ASDocFragmentParser.parseBody(input);
		
		var result:String = ASTUtil.convert(ast, false);
		Assert.assertEquals("<body><text-block><text>A document comment description</text>" +
			"<nl></nl><text>with a second line.</text></text-block></body>", result);
	}
	
	[Test]
	public function test_shortNoSpace():void
	{
		var input:Array =
			[
				"/**A short comment.*/"
			];
		
		assertPrint(input);
		assertComment("1", 
			input,
			"<compilation-unit><description><body><text-block><text>A short comment." +
			"</text></text-block></body></description></compilation-unit>");
	}
	
	[Test]
	public function test_MultipleLines():void
	{
		var input:Array =
			[
				"/**",
				" * A short comment",
				" * on another line.",
				" */"
			];
		
		assertPrint(input);
		assertComment("1",
			input,
			"<compilation-unit><description><body><text-block><text> A short comment" +
			"</text><nl></nl><text> on another line.</text><nl></nl></text-block>" +
			"</body></description></compilation-unit>");
	}
	
	[Test]
	public function test_MultipleLinesAndPara():void
	{
		var input:Array =
			[
				"/**",
				" * A short comment",
				" * on another line.",
				" * ",
				" * <p>A paragraph 1.</p>",
				" * ",
				" * <p>A paragraph 2.</p>",
				" */"
			];
		
		assertPrint(input);
		assertComment("1",
			input,
			"<compilation-unit><description><body><text-block><text> A short comment" +
			"</text><nl></nl><text> on another line.</text><nl></nl><text> </text><nl>" +
			"</nl><text> &lt;p&gt;A paragraph 1.&lt;/p&gt;</text><nl></nl><text> </text>" +
			"<nl></nl><text> &lt;p&gt;A paragraph 2.&lt;/p&gt;</text><nl></nl>" +
			"</text-block></body></description></compilation-unit>");
	}
	
	//[Test]
	public function test_InlineTags():void
	{
		var input:Array =
			[
				"/**",
				" * A short comment",
				" * on {@link another} line.",
				" */"
			];
		
		assertPrint(input);
		assertComment("1",
			input,
			"");
	}
	
	[Test]
	public function test_parseMultiParasAndCodeBlocks():void
	{
		var input:Array =
			[
				"/**", 
				" * A short <code>document()</code> comment",
				" * span 2.", 
				" * ",
				" * <p>Long <code>document()</code> description.</p>", 
				" * ",
				" * <p>Long <code>create()</code> description two.</p>", 
				" */"
			];
		
		assertPrint(input);
		assertComment("1",
			input,
			"<compilation-unit><description><body><text-block><text> A short </text>" +
			"</text-block><code-block><text>document()</text></code-block><text-block>" +
			"<text> comment</text><nl></nl><text> span 2.</text><nl></nl><text> " +
			"</text><nl></nl><text> &lt;p&gt;Long </text></text-block><code-block>" +
			"<text>document()</text></code-block><text-block><text> description." +
			"&lt;/p&gt;</text><nl></nl><text> </text><nl></nl><text> &lt;p&gt;Long " +
			"</text></text-block><code-block><text>create()</text></code-block>" +
			"<text-block><text> description two.&lt;/p&gt;</text><nl></nl></text-block>" +
			"</body></description></compilation-unit>");
	}
	
	[Test]
	public function test_parseMultiParasAndCodeBlocksAndDocTags():void
	{
		var input:Array =
			[
				"/**", 
				" * A short <code>document()</code> comment",
				" * span 2.", 
				" * ",
				" * <p>Long <code>document()</code> description.</p>", 
				" * ",
				" * <p>Long <code>create()</code> description two.</p>", 
				" * ",
				" * @author The <code>document()</code> Author", 
				" * @private",
				" */"
			];
		
		assertPrint(input);
		assertComment("1",
			input,
			"<compilation-unit><description><body><text-block><text> A short " +
			"</text></text-block><code-block><text>document()</text></code-block>" +
			"<text-block><text> comment</text><nl></nl><text> span 2.</text>" +
			"<nl></nl><text> </text><nl></nl><text> &lt;p&gt;Long </text>" +
			"</text-block><code-block><text>document()</text></code-block>" +
			"<text-block><text> description.&lt;/p&gt;</text><nl></nl><text> " +
			"</text><nl></nl><text> &lt;p&gt;Long </text></text-block><code-block>" +
			"<text>create()</text></code-block><text-block><text> description " +
			"two.&lt;/p&gt;</text><nl></nl><text> </text><nl></nl><text> </text>" +
			"</text-block></body><doctag-list><doctag><name>author</name><body>" +
			"<text-block><text> The </text></text-block><code-block><text>document()" +
			"</text></code-block><text-block><text> Author</text><nl></nl><text> " +
			"</text></text-block></body></doctag><doctag><name>private</name>" +
			"</doctag></doctag-list></description></compilation-unit>");
	}
	
	[Test]
	public function test_parseMultiParasAndPreBlock():void
	{
		var input:Array =
			[
				"/**", 
				" * A short <code>document()</code> comment",
				" * span 2.", 
				" * ",
				" * <p>Long <code>document()</code> description.</p>", 
				" * ",
				" * <pre>",
				" * class HelloWorld {",
				" *    public function HelloWorld() {",
				" *    }",
				" * }</pre>", 
				" */"
			];
		
		assertPrint(input);
		assertComment("1",
			input,
			"<compilation-unit><description><body><text-block><text> A short </text>" +
			"</text-block><code-block><text>document()</text></code-block><text-block>" +
			"<text> comment</text><nl></nl><text> span 2.</text><nl></nl><text> </text>" +
			"<nl></nl><text> &lt;p&gt;Long </text></text-block><code-block><text>" +
			"document()</text></code-block><text-block><text> description.&lt;/p&gt;" +
			"</text><nl></nl><text> </text><nl></nl><text> </text></text-block>" +
			"<pre-block><text> class HelloWorld {</text><nl></nl>" +
			"<text>    public function HelloWorld() {</text><nl></nl><text>    }</text>" +
			"<nl></nl><text> }</text></pre-block></body></description></compilation-unit>");
	}
	
	[Test]
	public function test_parsePreBlockWithXML():void
	{
		var input:Array =
			[
				"/**", 
				" * A short <code>document()</code> comment",
				" * span 2.", 
				" * ",
				" * <pre>",
				" * <s:Rect>",
				" *    <s:fill>",
				" *    </s:fill>",
				" * </s:Rect>",
				" * </pre>", 
				" */"
			];
		
		assertPrint(input);
		assertComment("1",
			input,
			"<compilation-unit><description><body><text-block><text> A short </text>" +
			"</text-block><code-block><text>document()</text></code-block><text-block>" +
			"<text> comment</text><nl></nl><text> span 2.</text><nl></nl><text> </text>" +
			"<nl></nl><text> </text></text-block><pre-block><text> &lt;s:Rect&gt;</text>" +
			"<nl></nl><text>    &lt;s:fill&gt;</text><nl></nl><text>    &lt;/s:fill&gt;" +
			"</text><nl></nl><text> &lt;/s:Rect&gt;</text><nl></nl><text> </text>" +
			"</pre-block></body></description></compilation-unit>");
	}
	
	protected function assertPrint(input:Array):void
	{
		var printer:ASTPrinter = createPrinter();
		printer.print(parse(input));
		Assert.assertEquals(input.join("\n"), printer.flush());
	}
	
	protected function assertComment(message:String, 
									 input:Array, 
									 expected:String):void
	{
		var result:String = ASTUtil.convert(parse(input), false);
		Assert.assertEquals(message, expected, result);
	}
	
	protected function parse(input:Array):IParserNode
	{
		parser.scanner.setLines(Vector.<String>(input));
		return parser.parseCompilationUnit();
	}
	
	protected function createPrinter():ASTPrinter
	{
		return new ASTPrinter(new SourceCode());
	}
}
}