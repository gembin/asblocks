////////////////////////////////////////////////////////////////////////////////
// Copyright 2010 Michael Schmalle - Teoti Graphix, LLC
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
// http://www.apache.org/licenses/LICENSE-2.0 
// 
// Unless required by applicable law or agreed to in writing, software 
// distributed under the License is distributed on an "AS IS" BASIS, 
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and 
// limitations under the License
// 
// Author: Michael Schmalle, Principal Architect
// mschmalle at teotigraphix dot com
////////////////////////////////////////////////////////////////////////////////

package org.as3commons.asblocks.impl
{

import org.as3commons.asblocks.api.IClassPathEntry;
import org.as3commons.asblocks.api.IClassType;
import org.as3commons.asblocks.api.ICompilationUnit;
import org.as3commons.asblocks.api.IInterfaceType;
import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertFalse;
import org.flexunit.asserts.assertNotNull;
import org.flexunit.asserts.assertNull;
import org.flexunit.asserts.assertStrictlyEquals;
import org.flexunit.asserts.assertTrue;

/**
 * Tests the ASProject impl.
 * 
 * @author Michael Schmalle
 */
public class TestASProject extends BaseASFactoryTest
{
	[Test]
	public function test_factory():void
	{
		assertNotNull(project);
		assertNotNull(project.factory);
		assertStrictlyEquals(factory, project.factory);
	}
	
	[Test]
	public function test_compilationUnits():void
	{
		// the project returns a new non modifiable Vector for each read access
		var units:Vector.<ICompilationUnit> = project.compilationUnits;
		// project always has a non null Vector
		assertNotNull(units);	
		assertEquals(0, units.length);
		// add test comp units
		var unit1:ICompilationUnit = project.newClass("my.domain.ClassA");
		var unit2:ICompilationUnit = project.newInterface("my.domain.IInterfaceA");
		var unit3:ICompilationUnit = project.newClass("my.other.domain.ClassB");
		
		units = project.compilationUnits;
		assertEquals(3, units.length);
	}
	
	[Test]
	public function test_classPathEntries():void
	{
		// the project returns a new non modifiable Vector for each read access
		var paths:Vector.<IClassPathEntry> = project.classPathEntries;
		// project always has a non null Vector
		assertNotNull(paths);	
		assertEquals(0, paths.length);
		// add test paths
		var path1:IClassPathEntry = project.addClassPath("/src/one");
		var path2:IClassPathEntry = project.addClassPath("/src/two");
		var path3:IClassPathEntry = project.addClassPath("/src/three");
		
		paths = project.classPathEntries;
		assertEquals(3, paths.length);
	}
	
	[Test]
	public function test_resourceRoots():void
	{
		// the project returns a new non modifiable Vector for each read access
		var roots:Vector.<IResourceRoot> = project.resourceRoots;
		// project always has a non null Vector
		assertNotNull(roots);	
		assertEquals(0, roots.length);
		// add test roots
		project.addResourceRoot(new TestResourceRoot());
		project.addResourceRoot(new TestResourceRoot());
		project.addResourceRoot(new TestResourceRoot());
		
		roots = project.resourceRoots;
		assertEquals(3, roots.length);
	}
	
	[Test]
	public function test_outputLocation():void
	{
		// used the constructor, path should be null
		assertNull(project.outputLocation);
		project.outputLocation = "/someplace/output";
		assertEquals("/someplace/output", project.outputLocation);
		project.outputLocation = null;
		assertNull(project.outputLocation);
	}
	
	[Test]
	public function test_addCompilationUnit():void
	{
		var units:Vector.<ICompilationUnit> = project.compilationUnits;
		assertNotNull(units);	
		assertEquals(0, units.length);
		// create a unit from a String
		var unit:ICompilationUnit = asparser.parseString(
			"package my.domain {\n\tpublic class ClassA {\n\t}\n}");
		// add comp unit
		assertTrue(project.addCompilationUnit(unit));
		units = project.compilationUnits;
		assertEquals(1, units.length);
		assertEquals("my.domain", units[0].packageName);
		assertEquals("ClassA", units[0].typeNode.name);
		// try adding it again
		assertFalse(project.addCompilationUnit(unit));
		// create a type, this adds it auto
		var unit1:ICompilationUnit = project.newClass("my.domain.ClassB");
		// test for correct order
		units = project.compilationUnits;
		assertEquals(2, units.length);
		assertEquals("my.domain", units[1].packageName);
		assertEquals("ClassB", units[1].typeNode.name);
	}
	
	[Test]
	public function test_removeCompilationUnit():void
	{
		var units:Vector.<ICompilationUnit> = project.compilationUnits;
		assertNotNull(units);	
		assertEquals(0, units.length);
		var unit:ICompilationUnit = asparser.parseString(
			"package my.domain {\n\tpublic class ClassA {\n\t}\n}");
		project.addCompilationUnit(unit);
		units = project.compilationUnits;
		assertNotNull(units);
		assertEquals(1, units.length);
		// remove it
		assertTrue(project.removeCompilationUnit(unit));
		units = project.compilationUnits;
		assertNotNull(units);
		assertEquals(0, units.length);
		// try and remove it again
		assertFalse(project.removeCompilationUnit(unit));
	}
	
	[Test]
	public function test_addClassPath():void
	{
		assertNotNull(project.classPathEntries);
		assertNotNull(project.addClassPath("/path1/src"));
		assertNotNull(project.addClassPath("/path2/src"));
		assertNotNull(project.addClassPath("/path3/src"));
		assertNull(project.addClassPath("/path1/src"));
		var entries:Vector.<IClassPathEntry> = project.classPathEntries;
		assertNotNull(entries);
		assertEquals(3, entries.length);
		assertEquals("/path1/src", entries[0].filePath);
		assertEquals("/path2/src", entries[1].filePath);
		assertEquals("/path3/src", entries[2].filePath);
	}
	
	[Test]
	public function test_removeClassPath():void
	{
		assertNotNull(project.classPathEntries);
		assertNotNull(project.addClassPath("/path1/src"));
		assertNotNull(project.addClassPath("/path2/src"));
		assertNotNull(project.addClassPath("/path3/src"));
		var entries:Vector.<IClassPathEntry> = project.classPathEntries;
		assertNotNull(entries);
		assertEquals(3, entries.length);
		assertEquals("/path1/src", entries[0].filePath);
		assertEquals("/path2/src", entries[1].filePath);
		assertEquals("/path3/src", entries[2].filePath);
		assertTrue(project.removeClassPath("/path1/src"));
		assertFalse(project.removeClassPath("/path1/src"));
		entries = project.classPathEntries;
		assertEquals(2, entries.length);
		assertEquals("/path2/src", entries[0].filePath);
		assertEquals("/path3/src", entries[1].filePath);
		assertTrue(project.removeClassPath("/path2/src"));
		assertFalse(project.removeClassPath("/path2/src"));
		entries = project.classPathEntries;
		assertEquals(1, entries.length);
		assertEquals("/path3/src", entries[0].filePath);
		assertTrue(project.removeClassPath("/path3/src"));
		assertFalse(project.removeClassPath("/path3/src"));
		entries = project.classPathEntries;
		assertEquals(0, entries.length);
	}
	
	[Test]
	public function test_addResourceRoot():void
	{
		var roots:Vector.<IResourceRoot> = project.resourceRoots;
		assertNotNull(roots);	
		assertEquals(0, roots.length);
		// add test roots
		var root1:IResourceRoot = new TestResourceRoot();
		var root2:IResourceRoot = new TestResourceRoot();
		var root3:IResourceRoot = new TestResourceRoot();
		project.addResourceRoot(root1);
		project.addResourceRoot(root2);
		project.addResourceRoot(root3);
		
		roots = project.resourceRoots;
		assertEquals(3, roots.length);
	}
	
	[Test]
	public function test_removeResourceRoot():void
	{
		var roots:Vector.<IResourceRoot> = project.resourceRoots;
		assertNotNull(roots);	
		assertEquals(0, roots.length);
		var root1:IResourceRoot = new TestResourceRoot();
		var root2:IResourceRoot = new TestResourceRoot();
		var root3:IResourceRoot = new TestResourceRoot();
		project.addResourceRoot(root1);
		project.addResourceRoot(root2);
		project.addResourceRoot(root3);
		
		assertEquals(3, project.resourceRoots.length);
		project.removeResourceRoot(root1);
		assertEquals(2, project.resourceRoots.length);
		project.removeResourceRoot(root2);
		assertEquals(1, project.resourceRoots.length);
		project.removeResourceRoot(root3);
		assertEquals(0, project.resourceRoots.length);
	}
	
	[Test]
	public function test_newClass():void
	{
		assertNotNull(project.compilationUnits);	
		assertEquals(0, project.compilationUnits.length);
		var unit:ICompilationUnit = project.newClass("my.domain.ClassA");
		assertNotNull(unit.typeNode);
		assertTrue(unit.typeNode is IClassType);
		assertEquals(1, project.compilationUnits.length);
	}
	
	[Test]
	public function test_newInterface():void
	{
		assertNotNull(project.compilationUnits);	
		assertEquals(0, project.compilationUnits.length);
		var unit:ICompilationUnit = project.newInterface("my.domain.IInterfaceA");
		assertNotNull(unit.typeNode);
		assertTrue(unit.typeNode is IInterfaceType);
		assertEquals(1, project.compilationUnits.length);
	}
	
	[Test]
	public function test_readAll():void
	{
		// TODO (mschmalle) impl test_readAll()
	}
	
	[Test]
	public function test_readAllAsync():void
	{
		// TODO (mschmalle) impl test_readAllAsync()
	}
	
	[Test]
	public function test_writeAll():void
	{
		// TODO (mschmalle) impl test_writeAll()
	}
	
	[Test]
	public function test_writeAllAsync():void
	{
		// TODO (mschmalle) impl test_writeAllAsync()
	}
}
}

import org.as3commons.asblocks.impl.ASQName;
import org.as3commons.asblocks.impl.IResourceRoot;

/**
 * @private
 */
class TestResourceRoot implements IResourceRoot
{
	public function TestResourceRoot()
	{
	}

	public function get definitions():Vector.<ASQName>
	{
		return null;
	}
}