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
package com.myavatareditor.avatarcore {
	
	/**
	 * A utility class that's simply a generic object that implements
	 * IClonable. As a clonable object it plays well meta values in
	 * objects of the Avatar Core framework since clones of those 
	 * objects will be able to have copies of metadata objects rather
	 * than references.
	 * @author Trevor McCauley; www.senocular.com
	 */
	public dynamic class Metadata implements IClonable {
		
		/**
		 * Copies memebers from one object to another.
		 */
		private static function copyObjectMembers(fromObj:Object, toObj:Object):void {
			var key:String;
			for (key in fromObj){
				try {
					toObj[key] = copyValue(fromObj[key]);
				}catch(error:*){}
			}
		}
		
		/**
		 * Copies a value. If value is a primitive value, that value is
		 * returned. If the value is an object implements a clone method, 
		 * it will be used to create a copy.  If there is no clone method, a 
		 * new instance of the object is created from it's constructor and 
		 * dynamic properties are copied. If all attempts fail, a reference 
		 * to the original object rather than a copy is returned.
		 */
		public static function copyValue(value:*):* {
			if (value == null) return null;
			var copy:Object;
			
			// handle primitives that are not referenced
			// cannot be copied or have special copy calls
			switch(typeof value){
				case "number":
				case "string":
				case "boolean":
				case "function":{
					return value;
					break;
				}
				case "xml":{
					try {
						return value.copy();
					}catch (error:*){ }
					break;
				}
			}
			
			// try to clone
			if ("clone" in value){
				try {
					copy = value.clone();
				}catch (error:*){ }
			}
			
			// try to create new from constructor
			if (!copy){
				try {
					copy = new value.constructor();
				}catch (error:*){ }
			}
			
			// if copy made, copy members into the copy
			if (copy){
				copyObjectMembers(value, copy);
				return copy;
			}
			
			// if copy not created
			// return a reference to the original
			return copy || value;
		}
		
		/**
		 * Constructor for Metadata objects.
		 */
		public function Metadata() {
			super();
		}
		
		/**
		 * Creates a copy of this Metadata object.  Since Metadata is a
		 * dynamic class, only dynamic properties are copied by this
		 * implementation of clone.  The copy is deep, so other objects
		 * within this object will be attempted to be copied as well.
		 * @return A copy of this instance.
		 */
		public function clone(copyInto:Object = null):Object {
			var copy:Metadata = (copyInto) ? copyInto as Metadata : new Metadata();
			if (copy == null) return null;
			
			copyObjectMembers(this, copy);
			return copy;
		}
		
	}

}