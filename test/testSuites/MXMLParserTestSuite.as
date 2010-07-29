package testSuites
{

import org.teotigraphix.as3parser.impl.TestMXMLNonASDocComment;
import org.teotigraphix.as3parser.impl.TestMXMLNonBound;
import org.teotigraphix.as3parser.impl.TestMXMLScanner;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class MXMLParserTestSuite
{
	public var testMXMScanner:TestMXMLScanner;
	public var testMXMLNonBound:TestMXMLNonBound;
	public var testMXMLNonASDocComment:TestMXMLNonASDocComment;
}
}