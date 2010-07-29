package org.teotigraphix.as3dom.impl
{

import flexunit.framework.Assert;

import org.teotigraphix.as3dom.api.IASProject;
import org.teotigraphix.as3dom.api.ICompilationUnit;

public class TestASProject
{
	private var project:ASProject;
	
	[Before]
	public function setUp():void
	{
		var factory:ASFactory = new ASFactory();
		
		project = factory.newEmptyASProject(".") as ASProject;
	}
	
	[Test]
	public function testProperties():void
	{
		var project:ASProject = new ASProject(new ASFactory());
		
		Assert.assertNotNull(project.classPaths);
		Assert.assertNull(project.compilationUnits);
		Assert.assertNull(project.output);
		project.output = "src";
		Assert.assertEquals("src", project.output);
	}
	
	[Test]
	public function test_add_removeClassPath():void
	{
		// test addClassPath()
		Assert.assertNotNull(project.classPaths);
		project.addClassPath("/mycomputer/somwhere1/src");
		project.addClassPath("/mycomputer/somwhere2/src");
		Assert.assertNotNull(project.classPaths);
		Assert.assertEquals(2, project.classPaths.length);
		Assert.assertEquals("/mycomputer/somwhere1/src", project.classPaths[0]);
		Assert.assertEquals("/mycomputer/somwhere2/src", project.classPaths[1]);
		
		// test removeClassPath()
		project.removeClassPath("/mycomputer/somwhere1/src");
		Assert.assertEquals(1, project.classPaths.length);
		project.removeClassPath("/mycomputer/blah/src");
		Assert.assertEquals(1, project.classPaths.length);
		Assert.assertEquals("/mycomputer/somwhere2/src", project.classPaths[0]);
		project.removeClassPath("/mycomputer/somwhere2/src");
		Assert.assertEquals(0, project.classPaths.length);
	}
	
	//[Test]
	public function test_add_removeCompilationUnit():void
	{
		
	}
	
	[Test]
	public function test_newClass():void
	{
		//var clazz:ICompilationUnit = project.newClass("my.domain.Test");
		//Assert.assertNotNull(clazz);
	}
	
	//[Test]
	public function test_newInterface():void
	{
		
	}
}
}