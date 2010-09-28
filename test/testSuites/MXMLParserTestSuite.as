package testSuites
{

import org.as3commons.mxmlblocks.parser.impl.TestMXMLCompilationUnit;
import org.as3commons.mxmlblocks.parser.impl.TestMXMLScanner;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class MXMLParserTestSuite
{
	public var testMXMLCompilationUnit:TestMXMLCompilationUnit;
	public var testMXMScanner:TestMXMLScanner;
	//public var testMXMLNonBound:TestMXMLNonBound;
	//public var testMXMLNonASDocComment:TestMXMLNonASDocComment;
}
}