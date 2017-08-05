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
	
	import com.myavatareditor.avatarcore.xml.IXMLWritable;
	import flash.geom.ColorTransform;
	
	/**
	 * Used to describe color transformations applied to avatar art.
	 * The Color class extendeds flash.geom.ColorTransform and contains
	 * the same properties as ColorTransform in addition to a name 
	 * property to allow Color objects to be referenced in collections.
	 * @author Trevor McCauley; www.senocular.com
	 */
	public class Color extends ColorTransform implements IXMLWritable, IClonable {
		
		/**
		 * Name identifier for the Color object.
		 */
		public function get name():String { return _name; }
		public function set name(value:String):void {
			_name = value;
		}
		private var _name:String;
		
		/**
		 * Shortcut to redMultiplier property.
		 */
		public function get rM():Number { return redMultiplier; }
		public function set rM(value:Number):void { redMultiplier = value; }
		/**
		 * Shortcut to greenMultiplier property.
		 */
		public function get gM():Number { return greenMultiplier; }
		public function set gM(value:Number):void { greenMultiplier = value; }
		/**
		 * Shortcut to blueMultiplier property.
		 */
		public function get bM():Number { return blueMultiplier; }
		public function set bM(value:Number):void { blueMultiplier = value; }
		/**
		 * Shortcut to alphaMultiplier property.
		 */
		public function get aM():Number { return alphaMultiplier; }
		public function set aM(value:Number):void { alphaMultiplier = value; }
		/**
		 * Shortcut to redOffset property.
		 */
		public function get r():Number { return redOffset; }
		public function set r(value:Number):void { redOffset = value; }
		/**
		 * Shortcut to greenOffset property.
		 */
		public function get g():Number { return greenOffset; }
		public function set g(value:Number):void { greenOffset = value; }
		/**
		 * Shortcut to blueOffset property.
		 */
		public function get b():Number { return blueOffset; }
		public function set b(value:Number):void { blueOffset = value; }
		/**
		 * Shortcut to alphaOffset property.
		 */
		public function get a():Number { return alphaOffset; }
		public function set a(value:Number):void { alphaOffset = value; }
		
		/**
		 * Constructor for creating new shade instances.
		 */
		public function Color(name:String = null, redMultiplier:Number = 1.0, greenMultiplier:Number = 1.0, blueMultiplier:Number = 1.0, alphaMultiplier:Number = 1.0,
							redOffset:Number = 0, greenOffset:Number = 0, blueOffset:Number = 0, alphaOffset:Number = 0) {
						
			super(redMultiplier, greenMultiplier, blueMultiplier, alphaMultiplier,
				redOffset, greenOffset, blueOffset, alphaOffset);
			if (name) this.name = name;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getObjectAsXML():XML {
			var xml:XML = <Color />;
			if (name){
				xml.@name = name;
			}
			if (redMultiplier == 0 && greenMultiplier == 0 && blueMultiplier == 0 && alphaMultiplier == 1.0){
				xml.@color = "#" + color.toString(16);
			}else{
				if (redMultiplier != 1.0) xml.@redMultiplier = redMultiplier;
				if (greenMultiplier != 1.0) xml.@greenMultiplier = greenMultiplier;
				if (blueMultiplier != 1.0) xml.@blueMultiplier = blueMultiplier;
				if (alphaMultiplier != 1.0) xml.@alphaMultiplier = alphaMultiplier;
				if (redOffset != 0) xml.@redOffset = redOffset;
				if (greenOffset != 0) xml.@greenOffset = greenOffset;
				if (blueOffset != 0) xml.@blueOffset = blueOffset;
				if (alphaOffset != 0) xml.@alphaOffset = alphaOffset;
			}
			return xml;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getPropertiesIgnoredByXML():Object {
			return {};
		}
		
		/**
		 * @inheritDoc
		 */
		public function getPropertiesAsAttributesInXML():Object {
			return {name:1, redMultiplier:1, greenMultiplier:1, blueMultiplier:1, alphaMultiplier:1,
				redOffset:1, greenOffset:1, blueOffset:1, alphaOffset:1};
		}
		
		/**
		 * @inheritDoc
		 */
		public function getDefaultPropertiesInXML():Object {
			return {};
		}
		
		/**
		 * Creates and returns a copy of the Color object.
		 * @return A copy of this Color object.
		 */
		public function clone(copyInto:Object = null):Object {
			var copy:Color = (copyInto) ? copyInto as Color : new Color();
			if (copy == null) return null;
			
			copy.redMultiplier = redMultiplier;
			copy.greenMultiplier = greenMultiplier;
			copy.blueMultiplier = blueMultiplier;
			copy.alphaMultiplier = alphaMultiplier;
			copy.redOffset = redOffset;
			copy.greenOffset = greenOffset;
			copy.blueOffset = blueOffset;
			copy.alphaOffset = alphaOffset;
			copy._name = _name;
			return copy;
		}
	}
}