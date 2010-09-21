package testSuites
{

import org.teotigraphix.asblocks.TestASFactory;
import org.teotigraphix.asblocks.impl.TestASProject;
import org.teotigraphix.asblocks.impl.TestArrayAccessExpressionNode;
import org.teotigraphix.asblocks.impl.TestArrayLiteralNode;
import org.teotigraphix.asblocks.impl.TestAssignmentNodes;
import org.teotigraphix.asblocks.impl.TestBinaryExpressionNode;
import org.teotigraphix.asblocks.impl.TestBooleanLiteralNode;
import org.teotigraphix.asblocks.impl.TestBreakStatementNode;
import org.teotigraphix.asblocks.impl.TestClassTypeNode;
import org.teotigraphix.asblocks.impl.TestCompilationUnitNode;
import org.teotigraphix.asblocks.impl.TestConditionalExpressionNode;
import org.teotigraphix.asblocks.impl.TestContinueStatementNode;
import org.teotigraphix.asblocks.impl.TestDeclarationStatementNode;
import org.teotigraphix.asblocks.impl.TestDefaultXMLNamespaceStatementNode;
import org.teotigraphix.asblocks.impl.TestDoWhileStatementNode;
import org.teotigraphix.asblocks.impl.TestExpressionNodes;
import org.teotigraphix.asblocks.impl.TestFieldAccessExpressionNode;
import org.teotigraphix.asblocks.impl.TestFieldNode;
import org.teotigraphix.asblocks.impl.TestForEachInStatementNode;
import org.teotigraphix.asblocks.impl.TestForInStatementNode;
import org.teotigraphix.asblocks.impl.TestInterfaceTypeNode;
import org.teotigraphix.asblocks.impl.TestLiteralNodes;
import org.teotigraphix.asblocks.impl.TestMemberNode;
import org.teotigraphix.asblocks.impl.TestMethodNode;
import org.teotigraphix.asblocks.impl.TestPackageNode;
import org.teotigraphix.asblocks.impl.TestPrefixExpressionNode;
import org.teotigraphix.asblocks.impl.TestStatementList;
import org.teotigraphix.asblocks.impl.TestTokenBoundaries;
import org.teotigraphix.asblocks.impl.TestTryStatementNode;
import org.teotigraphix.asblocks.impl.TestTypeNode;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class AS3BlocksTestSuite
{
	public var testASFactory:TestASFactory;
	public var testASProject:TestASProject;
	public var testCompilationUnitNode:TestCompilationUnitNode;
	public var testPackageNode:TestPackageNode;
	public var testTypeNode:TestTypeNode;
	public var testClassTypeNode:TestClassTypeNode;
	public var testInterfaceNodeType:TestInterfaceTypeNode;
	
	public var testExpressionNodes:TestExpressionNodes;
	public var testLiteralNodes:TestLiteralNodes;
	
	// 
	public var testArrayAccessExpressionNode:TestArrayAccessExpressionNode;
	public var testArrayLiteralNode:TestArrayLiteralNode;
	public var testAssignmentNodes:TestAssignmentNodes;
	public var testBinaryExpressionNode:TestBinaryExpressionNode;
	public var testBooleanLiteralNode:TestBooleanLiteralNode;
	public var testBreakStatement:TestBreakStatementNode;
	public var testConditionalExpressionNode:TestConditionalExpressionNode;
	public var testContinueStatementNode:TestContinueStatementNode;
	public var testDeclarationStatementNode:TestDeclarationStatementNode;
	public var testDefaultXMLNamespaceStatementNode:TestDefaultXMLNamespaceStatementNode;
	public var testDoWhileStatementNode:TestDoWhileStatementNode;
	public var testFieldAccessExpressionNode:TestFieldAccessExpressionNode;
	public var testForEachInStatementNode:TestForEachInStatementNode;
	public var testForInStatementNode:TestForInStatementNode;
	
	public var testMemberNode:TestMemberNode;
	
	public var testTryStatementNode:TestTryStatementNode;
	
	public var testTokenBoundaries:TestTokenBoundaries;
	public var testFieldNode:TestFieldNode;
	public var testMethodNode:TestMethodNode;
	public var testPrefixExpressionNode:TestPrefixExpressionNode;
	public var testStatementList:TestStatementList;
	
	
}
}