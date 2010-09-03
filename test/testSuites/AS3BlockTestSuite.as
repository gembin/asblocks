package testSuites
{

import org.teotigraphix.asblocks.impl.TestCompilationUnitNode;
import org.teotigraphix.asblocks.impl.TestExpressionNodes;
import org.teotigraphix.asblocks.impl.TestLiteralNodes;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class AS3BlockTestSuite
{
	public var testCompilationUnitNode:TestCompilationUnitNode;
	public var testExpressionNodes:TestExpressionNodes;
	public var testLiteralNodes:TestLiteralNodes;
}
}