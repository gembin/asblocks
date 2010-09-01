package testSuites
{

import org.teotigraphix.as3nodes.impl.TestAccessorNode;
import org.teotigraphix.as3nodes.impl.TestAttributeNode;
import org.teotigraphix.as3nodes.impl.TestCompilationNode;
import org.teotigraphix.as3nodes.impl.TestConstantNode;
import org.teotigraphix.as3nodes.impl.TestFunctionNode;
import org.teotigraphix.as3nodes.impl.TestIdentiferNode;
import org.teotigraphix.as3nodes.impl.TestInterfaceNode;
import org.teotigraphix.as3nodes.impl.TestMethodNode;
import org.teotigraphix.as3nodes.impl.TestPackageNode;
import org.teotigraphix.as3nodes.impl.TestScriptNode;
import org.teotigraphix.as3nodes.impl.TestAS3SourceFile;
import org.teotigraphix.as3nodes.impl.TestSourceFilePackage;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class AS3NodeTestSuite
{
	public var testSourceFileCollection:TestSourceFilePackage;
//	public var testSourceFile:TestAS3SourceFile;
	public var testCompilationNode:TestCompilationNode;
//	public var testPackageNode:TestPackageNode;
	public var testScriptNode:TestScriptNode;
//	public var testInterfaceNode:TestInterfaceNode;
//	public var testIdentiferNode:TestIdentiferNode;
//	public var testAttributeNode:TestAttributeNode;
//	public var testConstantNode:TestConstantNode;
	public var testFunctionNode:TestFunctionNode;
//	public var testAccessorNode:TestAccessorNode;
	public var testMethodNode:TestMethodNode;
}
}