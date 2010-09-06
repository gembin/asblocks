package testSuites
{

import org.teotigraphix.asblocks.TestASFactory;
import org.teotigraphix.asblocks.impl.TestASProject;
import org.teotigraphix.asblocks.impl.TestClassTypeNode;
import org.teotigraphix.asblocks.impl.TestCompilationUnitNode;
import org.teotigraphix.asblocks.impl.TestExpressionNodes;
import org.teotigraphix.asblocks.impl.TestInterfaceTypeNode;
import org.teotigraphix.asblocks.impl.TestLiteralNodes;
import org.teotigraphix.asblocks.impl.TestPackageNode;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class AS3BlocksTestSuite
{
	public var testASFactory:TestASFactory;
	public var testASProject:TestASProject;
	public var testCompilationUnitNode:TestCompilationUnitNode;
	public var testPackageNode:TestPackageNode;
	public var testClassTypeNode:TestClassTypeNode;
	public var testInterfaceNodeType:TestInterfaceTypeNode;
	
	public var testExpressionNodes:TestExpressionNodes;
	public var testLiteralNodes:TestLiteralNodes;
}
}