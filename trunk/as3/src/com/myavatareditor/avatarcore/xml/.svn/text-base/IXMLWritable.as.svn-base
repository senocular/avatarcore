/*
Copyright (c) 2010 Trevor McCauley

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE. 
*/
package com.myavatareditor.avatarcore.xml {
	
	/**
	 * An API that guides XML creation through the XMLDefinitionWriter
	 * class.  If an object is of the type IXMLWritable, the
	 * XMLDefinitionWriter class will use the functions in this
	 * interface to guide the XML creation process for the class instance
	 * that is being written.  Otherwise XMLDefinitionWriter will use
	 * its own default process.
	 * @author Trevor McCauley; www.senocular.com
	 */
	public interface IXMLWritable {
		
		/**
		 * Provides an XML representation of an object being written to XML.  
		 * If the return value is null, the XML for the class instance
		 * is created automatically by the XMLDefinitionWriter class.
		 * At that point getPropertiesIgnoredByXML and
		 * getPropertiesAsAttributesInXML are used to drive that
		 * process.
		 * @return An XML version of the class as it should be
		 * represented within XML produced by XMLDefinitionWriter, or
		 * null if XMLDefinitionWriter should write the XML itself.
		 */
		function getObjectAsXML():XML;
		
		/**
		 * Specifies which object properties are omitted from XML.
		 * If getObjectAsXML returns null, this method is used by
		 * XMLDefinitionWriter to get the class members of the
		 * object that are not written to XML. The object returned
		 * by this method should contain the names (keys) of each
		 * member not to be written.  Their values can be anything
		 * but the value of 1 is typical.
		 * @return An object with name value pairs where the names
		 * are the names of the class members not to be written to
		 * XML. For example {foo:1, bar:1} means that the foo and bar
		 * values of the respective instance will not be written to
		 * XML.
		 */
		function getPropertiesIgnoredByXML():Object;
		
		/**
		 * Specifies which object properties are defined as attributes
		 * in XML. If getObjectAsXML returns null, this method is used
		 * by XMLDefinitionWriter to get the class members of the
		 * object that are created as attributes.  By default, class
		 * members are written as child elements.  Members specified
		 * as attributes should contain primitive values such as
		 * numbers, strings, or booleans. The object returned
		 * by this method should contain the names (keys) of each
		 * member not to be written.  Their values can be anything
		 * but the value of 1 is typical.
		 * @return An object with name value pairs where the names
		 * are the names of the class members to be written as
		 * attributes.  For example {foo:1, bar:1} means that the foo
		 * and bar values of the respective instance will be written
		 * as attributes in the generated XML.
		 */
		function getPropertiesAsAttributesInXML():Object;
		
		/**
		 * Specifies the default values of properties within an object.
		 * When an object is being written to XML, if it's property
		 * values match the default values defined by this call for that
		 * property, that property will not be written to XML.  This 
		 * reduces unnecessary XML elements and attributes which would
		 * otherwise do nothing but specify a value which already exists
		 * by default.
		 * @return An object with name value pairs where the names
		 * are the names of the class members and the values are the
		 * default values of those members.
		 */
		function getDefaultPropertiesInXML():Object;
	}
}