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
	
	import com.myavatareditor.avatarcore.Collection;
	import com.myavatareditor.avatarcore.ICollection;
	import com.myavatareditor.avatarcore.debug.print;
	import com.myavatareditor.avatarcore.debug.PrintLevel;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	/**
	 * A generic XML parser for parsing XML into an object of its respective
	 * type. Classes specified within XML must be able to be instantiated
	 * without constructor arguments as they are not supplied when instances
	 * are created by the parser. Attributes and child elements within a
	 * parent elements match the properties of that parent element's
	 * class.  If the parent element does not have a property of that
	 * name, the value is ignored.  Child elements may not be ignored
	 * if the parent class is an ICollection at which point the child
	 * is converted to an object and added to the parent as a collection
	 * item.  For nodes with ref attributes, their values become a
	 * previously defined element's value with the matching name
	 * attribute value.
	 * @author Trevor McCauley; www.senocular.com
	 */
	public class XMLDefinitionParser {
		
		private static const refns:Namespace = new Namespace("com.myavatareditor.avatarcore.xml");
		
		private var referenceLookup:Object;
		private var typeCache:Object;
		private var memberCache:Object;
		
		public function XMLDefinitionParser() {
			super();
		}
		
		/**
		 * Parses the content of an XML node into an existing object.
		 * It is assumed that the target object has the properties to 
		 * facilitate the properties defined in XML or is of the type
		 * ICollection to be able to store non-property definitions
		 * within an internal list in the object.
		 * @param	node The XML to parse.
		 * @param	target The object to parse the XML definition into.
		 */
		public function parseInto(node:XML, target:Object):void {
			setup();
			parseNodeInto(node, target);
			cleanup();
		}
		
		/**
		 * Parses the content of an XML node into an object and returns it.
		 * It is assumed that the created object has the properties to 
		 * facilitate the properties defined in XML or is of the type
		 * ICollection to be able to store non-property definitions
		 * within an internal list in the object.
		 * @param	node The XML to parse.
		 * @return	The object created as a result of parsing the XML.
		 */
		public function parse(node:XML):Object {
			setup();
			var result:Object = createObject(node);
			cleanup();
			
			return result;
		}
		
		/**
		 * Defines persistent variables used within a parse operation
		 * such as lookup and cache objects.
		 */
		private function setup():void {
			referenceLookup = {};
			typeCache = {};
			memberCache = {};
		}
		
		/**
		 * Clears persistent variables used within a parse operation
		 * such as lookup and cache objects.
		 */
		private function cleanup():void {
			referenceLookup = null;
			typeCache = null;
			memberCache = null;
		}
		
		private function parseNodeInto(node:XML, target:Object, className:String = null):void {
			if (node == null || target == null) return;
			
			// use type/member caches to make definition
			// lookup faster
			if (className == null){
				className = getQualifiedClassName(target);
			}
			if (className in typeCache == false){
				var typeInfo:XML = describeType(target);
				typeCache[className] = typeInfo;
				memberCache[className] = typeInfo..variable + typeInfo..accessor + typeInfo..method;
			}
			var targetType:XML = typeCache[className];
			var targetMembers:XMLList = memberCache[className];
			
			// assign attributes first pass for any
			// dependencies on contained objects
			assignAttributes(target, node);
			
			var element:XML;
			var attsParsed:Boolean;
			var elemName:String;
			var memberType:String;
			var ref:Object;
			var children:XMLList;
			var firstChild:XML;
			var instance:Object;
			for each(element in node.elements()){
				
				attsParsed = false;
				elemName = element.localName();
				
				// check to see if the name of the element exists
				// as a property of the target object. If so, the
				// value of the XML element will be assigned to
				// that property
				if (elemName in target){
					memberType = targetMembers.(attribute("name") == elemName).@type.toString();
					
					// ----------------------------------------------
					// referencing a pre-created object
					// in the XML if defined
					ref = referenceLookup[element.@refns::ref] as Object;
					if (ref == null && element.@refns::ref != undefined){
						print("Parsing XML; couldn't find referenced object named '"+element.@ref+"' for "+elemName, PrintLevel.WARNING, this);
					}
					if (ref) {
						
						try {
							target[elemName] = ref;
						}catch (error:Error){
							print("Parsing XML; couldn't assign an XML-generated reference object to an object property ("+error+")", PrintLevel.ERROR, this);
						}
						
					}else{
						// normal, non-referenced definition
						
						children = element.children();
						
						// A new object value; there should only be
						// one node; others, if present, are ignored
						var numChildren:int = children.length();
						if (numChildren != 0) {
							
							firstChild = children[0];
							
							// ----------------------------------------------
							// for simple text elements, the text is
							// converted to a primitive value
							if (numChildren == 1 && firstChild.nodeKind() == "text"){
								
								assignPrimitiveValue(target, elemName, firstChild.toString());
							
							
							// ----------------------------------------------
							// if the first and only node is of the target type,
							// that full object is the target property's full definition
							}else if (numChildren == 1 && firstChild.name().toString() == memberType) {
								
								// create definition from first child element as object
								try {
									target[elemName] = createObject(firstChild);
								}catch (error:Error){
									// likely a type error where createObject
									// created an instance of an incompatible type
									print("Parsing XML; couldn't assign an XML-generated object to an object property ("+error+")", PrintLevel.ERROR, this);
								}
								
								
							// ----------------------------------------------
							// otherwise parse the nodes into the existing value
							}else{
								
								// create object if null
								if (target[elemName] == null) {
									target[elemName] = getInstanceFromType(memberType);
								}
								
								// parse node into existing value
								if (target[elemName] != null) {
									parseNodeInto(element, target[elemName], memberType);
									attsParsed = true; // parsing automatically parses attributes
								}
							}
						
						// no child elements
						}else {
							
							// create object if null
							if (target[elemName] == null) {
								target[elemName] = getInstanceFromType(memberType);
							}
						}
					}
					
					if (!attsParsed){
						// assign attributes on top of any existing
						// values (node parsing already adds these)
						assignAttributes(target[elemName], element);
					}
					
				
				// property elemName not in target
				}else{
					
					if (target is ICollection) {
					
						// objects can be added as a child
						// of a collection
						instance = createObject(element);
						if (instance){
							ICollection(target).addItem(instance);
						}
						
					}else if (target is DisplayObjectContainer){
						
						// try to add to display list
						instance = createObject(element);
						if (instance is DisplayObject){
							DisplayObjectContainer(target).addChild(instance as DisplayObject);
						}
						
					}else if (targetType.@isDynamic == "true"){
						
						// try adding a dynamic variable
						try {
							instance = createObject(element);
							if (instance){
								target[elemName] = instance;
							}
						}catch(error:Error){}
						
					}
				}
			}
		}
		
		private function createObject(element:XML):Object {
			var qname:QName = element.name();
			var prefix:String = (!qname.uri || qname.uri == "*") ? "" : qname.uri + "::";
			var elemName:String = prefix + qname.localName;
			var instance:Object = getInstanceFromType(elemName);
			if (instance){
				parseNodeInto(element, instance, elemName);
			}
			return instance;
		}
		
		private function getInstanceFromType(type:String):Object {
			var instance:Object;
			var instanceClass:Class;
			try {
				instanceClass = getDefinitionByName(type) as Class;
				instance = new instanceClass();
				
			}catch (error:ArgumentError){
				print("Parsing XML; Class " + type + " cannot be instantiated because it contains required parameters", PrintLevel.WARNING, this);
				return null;
				
			}catch (error:Error){
				// likely to occur if the definition of the class
				// does not exist within the application
				print("Parsing XML; cannot locate definition for " + type, PrintLevel.WARNING, this);
				return null;
			}			
			return instance;
		}
		
		private function assignAttributes(target:Object, element:XML):void {
			if (target == null || element == null) return;
			var att:XML;
			var elemName:String;
			var value:String;
			for each (att in element.attributes()){
				elemName = att.localName();
				value = String(att);
				
				// if an attribute of the name defined by 
				// nameKey is found, be sure to
				// update the referenceLookup table so the object
				// can be referenced through ref attributes
				if (elemName == Collection.nameKey){
					referenceLookup[value] = target;
				}
				
				assignPrimitiveValue(target, elemName, value);
			}
		}
		
		private function assignPrimitiveValue(target:Object, name:String, value:String):void {
			try {
				
				var origValue:* = target[name];
				switch(typeof origValue){
					
					case "boolean":
						value = value.toLowerCase();
						if (value == "0" || value == "false"){
							target[name] = false
						}else{
							target[name] = true;
						}
						break;
						
					case "number":
						if (value.charAt(0) == "#"){
							target[name] = parseInt(value.substr(1), 16);
						}else{
							target[name] = Number(value);
						}
						break;
						
					case "string":
					default:
						target[name] = value;
						break;
				}
			}catch(error:Error){}
		}
	}
}