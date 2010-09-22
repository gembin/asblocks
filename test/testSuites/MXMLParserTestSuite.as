package testSuites
{

import org.as3commons.asblocks.parser.impl.TestMXMLNonASDocComment;
import org.as3commons.asblocks.parser.impl.TestMXMLNonBound;
import org.as3commons.asblocks.parser.impl.TestMXMLScanner;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class MXMLParserTestSuite
{
	public var testMXMScanner:TestMXMLScanner;
	public var testMXMLNonBound:TestMXMLNonBound;
	public var testMXMLNonASDocComment:TestMXMLNonASDocComment;
}
}