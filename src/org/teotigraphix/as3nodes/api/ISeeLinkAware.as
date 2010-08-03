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

package org.teotigraphix.as3nodes.api
{

/**
 * The <strong>ISeeLinkAware</strong> interface creates a contract that allows nodes
 * to specify a String link that uniquely identify them from other nodes.
 * 
 * <p>This interface <strong>requires</strong> the action script @see link 
 * protocol to be returned.</p>
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public interface ISeeLinkAware
{
	/**
	 * Returns a String link that is used in Maps and mirrors the link when using
	 * a see tag in actual <code>ICommentNode</code>s.
	 * 
	 * @return A String locating the node in the session.
	 */
	function toLink():String;
}
}