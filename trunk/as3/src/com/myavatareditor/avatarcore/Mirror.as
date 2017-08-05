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
	
	import com.myavatareditor.avatarcore.Feature;
	import com.myavatareditor.avatarcore.display.ArtSprite;
	import com.myavatareditor.avatarcore.display.MirroredArtSprite;
	
	/**
	 * A behavior that creates a mirrored duplicate (along y axis) of a
	 * feature's art.  This allows characteristics like eyes to be both
	 * graphically similar and to be altered in a synchronous fashion. This is
	 * not necessarily a piece of the core framework, but an extension of it.
	 * As such, if referenced only in XML, you will need to be sure to include
	 * a reference of the class in your SWF so that it gets compiled into
	 * the SWF bytecode and is accessible when the XML is parsed.
	 * @author Trevor McCauley; www.senocular.com
	 */
	public class Mirror implements IBehavior {
		
		public static const X_AXIS:String = "x";
		public static const Y_AXIS:String = "y";
		
		/**
		 * The name of the Mirror instance so that it can be easily
		 * referenced in a behaviors collection.
		 */
		public function get name():String { return _name; }
		public function set name(value:String):void {
			_name = value;
		}
		private var _name:String;
		
		/**
		 * Specifies which axis to be used when mirroring. By default
		 * this is the y axis.  The possible values are Mirror.X_AXIS
		 * ("x") and Mirror.Y_AXIS ("y").
		 */
		public function get axis():String {
			return _axis;
		}
		public function set axis(value:String):void {
			_axis = (value == null || value.toLowerCase() == Y_AXIS) ? Y_AXIS : X_AXIS;
		}
		private var _axis:String = Y_AXIS;
		
		/**
		 * Constructor for creating new Mirror instances.
		 */
		public function Mirror(axis:String = Y_AXIS) {
			this.axis = axis;
		}
		
		public function getArtSprites(feature:Feature, sprites:Array):Array {
			
			// add additional sprites (the same ones again) for the mirror
			var origArt:ArtSprite;
			var mirrorArt:MirroredArtSprite;
			var i:int = sprites.length;
			while (i--){
				origArt = sprites[i] as ArtSprite;
				mirrorArt = new MirroredArtSprite(origArt.art, feature, origArt);
				sprites.push(mirrorArt);
			}
			return sprites;
		}
		
		public function drawArtSprite(artSprite:ArtSprite):void {
			var mirrorArt:MirroredArtSprite = artSprite as MirroredArtSprite;
			if (mirrorArt){
				if (_axis == Y_AXIS){
					mirrorArt.x = -mirrorArt.x;
					mirrorArt.scaleX = -mirrorArt.scaleX;
				}else{
					mirrorArt.y = -mirrorArt.y;
					mirrorArt.scaleY = -mirrorArt.scaleY;
				}
				mirrorArt.rotation = -mirrorArt.rotation;
			}
		}
		
		/**
		 * Creates and returns a copy of the Mirror object.
		 * @return A copy of this Mirror object.
		 */
		public function clone(copyInto:Object = null):Object {
			var copy:Mirror = (copyInto) ? copyInto as Mirror : new Mirror();
			if (copy == null) return null;
			
			copy._axis = _axis
			copy._name = _name;
			return copy;
		}
	}
}