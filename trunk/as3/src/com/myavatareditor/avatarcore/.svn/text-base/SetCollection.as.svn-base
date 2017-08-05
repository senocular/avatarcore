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
	 * A common base class for collections used in feature definitions. When
	 * a feature definition defines different objects in a collection for an 
	 * avatar, they are stored within a collection of the type SetCollection.
	 * @author Trevor McCauley; www.senocular.com
	 */
	public class SetCollection extends Collection {
		
		/**
		 * Name of the default item in the set for cases when
		 * a feature does not specify a reference to one of
		 * the set items (or its own) explicitly.
		 */
		public function get defaultName():String { return _defaultName; }
		public function set defaultName(value:String):void {
			_defaultName = value;
		}
		private var _defaultName:String;
		
		/**
		 * @inheritDoc
		 */
		public override function getPropertiesAsAttributesInXML():Object {
			var obj:Object = super.getPropertiesAsAttributesInXML();
			obj.defaultName = true;
			return obj;
		}
		
		/**
		 * Constructor for creating new SetCollection instances.
		 */
		public function SetCollection() {
			super();
		}
		
		/**
		 * Creates and returns a copy of the SetCollection object.
		 * @return A copy of this SetCollection object.
		 */
		override public function clone(copyInto:Object = null):Object {
			var copy:SetCollection = (copyInto) ? copyInto as SetCollection : new SetCollection();
			if (copy == null) return null;
			super.clone(copy);
			
			copy._defaultName = _defaultName;
			return copy;
		}
	}
}