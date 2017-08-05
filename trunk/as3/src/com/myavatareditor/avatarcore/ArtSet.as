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
	 * A collection of Art objects for feature definitions. When
	 * a feature definition defines different art variations for
	 * an avatar, they are stored within the artSet collection.
	 * Defaults for some Art definitions (zIndex, colorize) can be
	 * defined in a ArtSet first which then get applied to Art
	 * instances when added to the art set collection.
	 * @author Trevor McCauley; www.senocular.com
	 */
	public class ArtSet extends SetCollection {
		
		/**
		 * Default zIndex for child Art objects if their
		 * zIndex is NaN when added to the ArtSet.
		 */
		public function get zIndex():Number { return _zIndex; }
		public function set zIndex(value:Number):void {
			_zIndex = value;
		}
		private var _zIndex:Number; // default: NaN
		
		/**
		 * Default colorize for child Art objects if their
		 * colorize is NaN when added to the ArtSet.
		 */
		public function get colorize():Number { return _colorize; }
		public function set colorize(value:Number):void {
			_colorize = value;
		}
		private var _colorize:Number; // default: NaN
		
		/**
		 * Default smoothing for child Art objects if their
		 * smoothing is NaN when added to the ArtSet.
		 */
		public function get smoothing():Number { return _smoothing; }
		public function set smoothing(value:Number):void {
			_smoothing = smoothing;
		}
		private var _smoothing:Number;
		
		/**
		 * Name of the default style for Art the set for cases when
		 * a feature does not specify a reference to one 
		 * explicitly.
		 */
		public function get defaultStyleName():String { return _defaultStyleName; }
		public function set defaultStyleName(value:String):void {
			_defaultStyleName = value;
		}
		private var _defaultStyleName:String;
		
		/**
		 * Constructor for new ArtSet instances.
		 */
		public function ArtSet() {
			super();
		}
		
		/**
		 * Creates and returns a copy of the ArtSet object.
		 * @return A copy of this ArtSet object.
		 */
		override public function clone(copyInto:Object = null):Object {
			var copy:ArtSet = (copyInto) ? copyInto as ArtSet : new ArtSet();
			if (copy == null) return null;
			super.clone(copy);
			
			copy._colorize = _colorize;
			copy._defaultStyleName = _defaultStyleName;
			copy._smoothing = _smoothing;
			copy._zIndex = _zIndex;
			return copy;
		}
		 
		/**
		 * Custom addItem that assigns default colorize and
		 * zIndex values to added Art objects when their values are
		 * undefined.
		 * @param	item Item to be added to the art set collection.
		 * @return The collection item added.
		 */
		public override function addItem(item:*):* {
			
			// assign default properties to added art
			if (item is Art) {
				var artItem:Art = item as Art;
				artItem.assignDefaults(_zIndex, _colorize, _smoothing);
			}
			
			return super.addItem(item);
		}
	}
}