package testSuites
{

import org.as3commons.asblocks.parser.impl.TestASDocParser;
import org.as3commons.asblocks.parser.impl.TestASDocScanner;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class ASDocParserTestSuite
{
	public var testASDocScanner:TestASDocScanner;
	public var testASDocParser:TestASDocParser;
}
}