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

package org.teotigraphix.as3parser.utils
{

import flash.utils.getDefinitionByName;

/**
 * A utility class for dealing with files and their data.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class FileUtil
{
	//--------------------------------------------------------------------------
	//
	//  Public Class :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Reads a File from the filesystem and returns the data as a String Vector.
	 * 
	 * <p><strong>Note:</strong> The method will replace all <strong>\r\n</strong> 
	 * characters with <strong>'\n'</strong> before it splits the data into lines.</p>
	 * 
	 * @param filePath A String indicating the path to the File to open and read.
	 * @return A String Vector of file lines split by the <strong>\n</strong> character.
	 * @throws Error Definition flash.filesystem.File not found, import AIR library
	 * @throws Error File does not exist
	 */
	public static function readLines(filePath:String):Vector.<String>
	{
		var fileClass:Class = getDefinitionByName("flash.filesystem.File") as Class;
		var fileStreamClass:Class = getDefinitionByName("flash.filesystem.FileStream") as Class;
		
		if (!fileClass)
		{
			throw new Error("Definition flash.filesystem.File not found, import AIR library");
		}
		
		var file:Object = new fileClass(filePath);
		if (!file.exists)
		{
			throw new Error("'" + filePath + "' does not exist");
		}
		
		var stream:Object = new fileStreamClass();
		stream.open(file, "read");
		
		var data:String = stream.readUTFBytes(stream.bytesAvailable);
		data = data.replace(/\r\n/g, "\n");
		
		return Vector.<String>(data.split("\n"));
	}
}
}