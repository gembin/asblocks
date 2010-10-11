package testSuites
{

import org.as3commons.asblocks.TestASFactory;
import org.as3commons.asblocks.impl.TestASProject;
import org.as3commons.asblocks.impl.TestArrayAccessExpressionNode;
import org.as3commons.asblocks.impl.TestArrayLiteralNode;
import org.as3commons.asblocks.impl.TestAssignmentNodes;
import org.as3commons.asblocks.impl.TestBinaryExpressionNode;
import org.as3commons.asblocks.impl.TestBooleanLiteralNode;
import org.as3commons.asblocks.impl.TestBreakStatementNode;
import org.as3commons.asblocks.impl.TestClassTypeNode;
import org.as3commons.asblocks.impl.TestCompilationUnitNode;
import org.as3commons.asblocks.impl.TestConditionalExpressionNode;
import org.as3commons.asblocks.impl.TestContinueStatementNode;
import org.as3commons.asblocks.impl.TestDeclarationStatementNode;
import org.as3commons.asblocks.impl.TestDefaultXMLNamespaceStatementNode;
import org.as3commons.asblocks.impl.TestDoWhileStatementNode;
import org.as3commons.asblocks.impl.TestDocCommentNode;
import org.as3commons.asblocks.impl.TestExpressionNodes;
import org.as3commons.asblocks.impl.TestFieldAccessExpressionNode;
import org.as3commons.asblocks.impl.TestFieldNode;
import org.as3commons.asblocks.impl.TestForEachInStatementNode;
import org.as3commons.asblocks.impl.TestForInStatementNode;
import org.as3commons.asblocks.impl.TestForStatementNode;
import org.as3commons.asblocks.impl.TestFunctionCommon;
import org.as3commons.asblocks.impl.TestFunctionTypeNode;
import org.as3commons.asblocks.impl.TestIfStatementNode;
import org.as3commons.asblocks.impl.TestInterfaceTypeNode;
import org.as3commons.asblocks.impl.TestInvocationExpressionNode;
import org.as3commons.asblocks.impl.TestLiteralNodes;
import org.as3commons.asblocks.impl.TestMemberNode;
import org.as3commons.asblocks.impl.TestMetaDataNode;
import org.as3commons.asblocks.impl.TestMethodNode;
import org.as3commons.asblocks.impl.TestNewExpressionNode;
import org.as3commons.asblocks.impl.TestPackageNode;
import org.as3commons.asblocks.impl.TestPrefixExpressionNode;
import org.as3commons.asblocks.impl.TestStatementList;
import org.as3commons.asblocks.impl.TestSuperStatementNode;
import org.as3commons.asblocks.impl.TestSwitchStatementNode;
import org.as3commons.asblocks.impl.TestThisStatementNode;
import org.as3commons.asblocks.impl.TestThrowStatementNode;
import org.as3commons.asblocks.impl.TestTokenBoundaries;
import org.as3commons.asblocks.impl.TestTryStatementNode;
import org.as3commons.asblocks.impl.TestTypeNode;
import org.as3commons.asblocks.impl.TestVectorExpressionNode;
import org.as3commons.asblocks.impl.TestWhileStatementNode;
import org.as3commons.asblocks.impl.TestWithStatementNode;
import org.as3commons.mxmlblocks.impl.TestApplicationTypeNode;
import org.as3commons.mxmlblocks.impl.TestAttributeNode;
import org.as3commons.mxmlblocks.impl.TestTagListNode;
import org.as3commons.mxmlblocks.impl.TestXMLNamespaceNode;

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
	public var testDocCommentNode:TestDocCommentNode;
	public var testDoWhileStatementNode:TestDoWhileStatementNode;
	public var testFieldAccessExpressionNode:TestFieldAccessExpressionNode;
	public var testForEachInStatementNode:TestForEachInStatementNode;
	public var testForInStatementNode:TestForInStatementNode;
	public var testForStatementNode:TestForStatementNode;
	public var testFunctionCommon:TestFunctionCommon;
	public var testFunctionTypeNode:TestFunctionTypeNode;
	//public var testFunctionLiteralNode:TestFunctionLiteralNode;
	public var testIfStatementNode:TestIfStatementNode;
	public var testInterfaceNodeType:TestInterfaceTypeNode;
	public var testInvocationExpressionNode:TestInvocationExpressionNode;
	
	public var testMemberNode:TestMemberNode;
	public var testMetaDataNode:TestMetaDataNode;
	public var testNewExpressionNode:TestNewExpressionNode;
	
	public var testSuperStatementNode:TestSuperStatementNode;
	public var testSwitchStatementNode:TestSwitchStatementNode;
	public var testThisStatementNode:TestThisStatementNode;
	public var testThrowStatementNode:TestThrowStatementNode;
	public var testTryStatementNode:TestTryStatementNode;
	
	public var testWhileStatementNode:TestWhileStatementNode;
	public var testWithStatementNode:TestWithStatementNode;
	
	public var testTokenBoundaries:TestTokenBoundaries;
	public var testFieldNode:TestFieldNode;
	public var testMethodNode:TestMethodNode;
	public var testPrefixExpressionNode:TestPrefixExpressionNode;
	public var testStatementList:TestStatementList;
	public var testVectorExpressionNode:TestVectorExpressionNode;
	
	// MXML
	public var testMXMLApplicationNode:TestApplicationTypeNode;
	public var testAttributeNode:TestAttributeNode;
	public var testTagListNode:TestTagListNode;
	public var testXMLNamespaceNode:TestXMLNamespaceNode;
}
}