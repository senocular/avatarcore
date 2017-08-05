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
	import com.myavatareditor.avatarcore.Range;
	import com.myavatareditor.avatarcore.display.ArtSprite;
	import flash.display.Sprite;
	
	/**
	 * An adjustment (position, scale, and rotation) constraint
	 * behavior for features.  Constrains are applied to all art
	 * assets in an art group as though they were one. 
	 * @author Trevor McCauley; www.senocular.com
	 */
	public class Constrain implements IBehavior {
		
		/**
		 * The name of the Constrain instance so that it can be easily
		 * referenced in a behaviors collection.
		 */
		public function get name():String { return _name; }
		public function set name(value:String):void {
			_name = value;
		}
		private var _name:String;
		
		/**
		 * The possible range of x values for art sprites. When set
		 * a clone of the original Range value is saved.
		 */
		public function get x():Range { return _x; }
		public function set x(value:Range):void {
			_x = value ? value.clone() as Range : null;
		}
		private var _x:Range;
		
		/**
		 * The possible range of y values for art sprites. When set
		 * a clone of the original Range value is saved.
		 */
		public function get y():Range { return _y; }
		public function set y(value:Range):void {
			_y = value ? value.clone() as Range : null;
		}
		private var _y:Range;
		
		/**
		 * The possible range of scaleX values for art sprites. Scale
		 * constraints are calculated based on absolute values
		 * where both negative and positive scales are constrained
		 * within the positive ranges of the range value
		 * (with negative scales remaining negative). When set
		 * a clone of the original Range value is saved.
		 */
		public function get scaleX():Range { 
			if (_scale != null) _scale = null;
			return _scaleX;
		}
		public function set scaleX(value:Range):void {
			if (_scale != null) _scale = null;
			_scaleX = value ? value.clone() as Range : null;
		}
		private var _scaleX:Range;
		
		/**
		 * The possible range of scaleY values for art sprites. Scale
		 * constraints are calculated based on absolute values
		 * where both negative and positive scales are constrained
		 * within the positive ranges of the range value
		 * (with negative scales remaining negative). When set
		 * a clone of the original Range value is saved.
		 */
		public function get scaleY():Range {
			if (_scale != null) _scale = null;
			return _scaleY;
		}
		public function set scaleY(value:Range):void {
			if (_scale != null) _scale = null;
			_scaleY = value ? value.clone() as Range : null;
		}
		private var _scaleY:Range;
		
		/**
		 * An alternate Range object representing both the scaleX and scaleY
		 * ranges to be used within a Constrain in place of scaleX and scaleY
		 * when defined (non-null).  The scale is defined automatically, if not
		 * already, whenever its value is accessed or set. When first
		 * accessed in this manner, if both scaleX and scaleY is defined, scale
		 * will be represent their averages. If only one is defined, scale will 
		 * take on the value of that range which is defined. If both are not
		 * defined (null), scale remains null until explicitly set. If at any 
		 * point in time the value of scaleX or scaleY is set or accessed,
		 * scale automatically becomes null.
		 */
		public function get scale():Range {
			if (_scale == null){
				if (_scaleX){
					if (_scaleY){
						_scale = new Range(
							(_scaleX.min + _scaleY.min)/2,
							(_scaleX.max + _scaleY.max)/2,
							int((_scaleX.steps + _scaleY.steps)/2)
						);
					}else{
						_scale = _scaleX.clone() as Range;
					}
				}else if (_scaleY){
					_scale = _scaleY.clone() as Range;
				}
			}
			return _scale;
		}
		public function set scale(value:Range):void {
			_scale = value ? value.clone() as Range : null;
		}
		private var _scale:Range;
		
		/**
		 * The possible range of rotation values for art sprites. When set
		 * a clone of the original Range value is saved.
		 */
		public function get rotation():Range { return _rotation; }
		public function set rotation(value:Range):void {
			_rotation = value ? value.clone() as Range : null;
		}
		private var _rotation:Range;
		
		/**
		 * Constructor for creating new Constraint instances.
		 * @param	position Position rectagnle value.
		 * @param	scaleX ScaleX range value.
		 * @param	scaleY ScaleY range value.
		 * @param	rotation Rotation range value.
		 */
		public function Constrain(x:Range = null, y:Range = null, scaleX:Range = null, scaleY:Range = null, rotation:Range = null) {
			this.x = x;
			this.y = y;
			this.scaleX = scaleX;
			this.scaleY = scaleY;
			this.rotation = rotation;
		}
		
		/**
		 * Returns the same sprites defined by the feature.
		 * @param	feature
		 * @param	sprites
		 * @return
		 */
		public function getArtSprites(feature:Feature, sprites:Array):Array {
			return sprites;
		}
		
		/**
		 * Confines sprites within the region specified by the 
		 * constrain properties. This will only  work if the feature
		 * is using its own adjust and not a feature definition's.
		 * @param	artSprite The art sprite being drawn.
		 */
		public function drawArtSprite(artSprite:ArtSprite):void {
			if (artSprite == null || artSprite.feature == null) return;
			
			// constraints will only
			var feature:Feature = artSprite.feature;
			var adjust:Adjust = feature.adjust;
			
			// validate adjust; without it, cannot continue
			if (adjust == null) return;
			
			var newValue:Number; // x, y, scaleX, scaleY, rotation
			
			// position
			// x value
			if (_x){
				newValue = adjust.x;
				
				// steps/clamp
				newValue = _x.stepValue(newValue);
				// set
				if (adjust.x != newValue){
					adjust.x = newValue;
				}
			}
			
			// y value
			if (_y){
				newValue = adjust.y;
				
				// steps/clamp
				newValue = _y.stepValue(newValue);
				// set
				if (adjust.y != newValue){
					adjust.y = newValue;
				}
			}
			
			// rotation
			if (_rotation){
				newValue = adjust.rotation;
				
				// steps/clamp
				newValue = _rotation.stepValue(newValue);
				// set
				if (adjust.rotation != newValue){
					adjust.rotation = newValue;
				}
			}
			
			// scale
			// mirror properties used to handle negative scale values
			// otherwise everything is treated as positive
			// if scale is defined, it will be used over scaleX/Y
			var scaleRange:Range;
			
			// scaleX
			scaleRange = _scale ? _scale : _scaleX;
			if (scaleRange){
				newValue = Math.abs(adjust.scaleX);
				
				// steps/clamp
				newValue = scaleRange.stepValue(newValue);
				// set
				if (adjust.scaleX != newValue){
					adjust.scaleX = newValue;
				}
			}
			
			// scaleY
			scaleRange = _scale ? _scale : _scaleY;
			if (scaleRange){
				newValue = Math.abs(adjust.scaleY);
				
				// steps/clamp
				newValue = scaleRange.stepValue(newValue);
				// set
				if (adjust.scaleY != newValue){
					adjust.scaleY = newValue;
				}
			}
			
			// reapply transform matrix to show adjust changes
			artSprite.transform.matrix = feature.getRenderedAdjust().getMatrix();
		}
		
		/**
		 * Creates and returns a copy of the Constrain object.
		 * @return A copy of this Constrain object.
		 */
		public function clone(copyInto:Object = null):Object {
			var copy:Constrain = (copyInto) ? copyInto as Constrain : new Constrain();
			if (copy == null) return null;
			
			if (_x) copy._x = _x.clone() as Range;
			if (_y) copy._y = _y.clone() as Range;
			if (_scaleX) copy._scaleX = _scaleX.clone() as Range;
			if (_scaleY) copy._scaleY = _scaleY.clone() as Range;
			if (_scale) copy._scale = _scale.clone() as Range;
			if (_rotation) copy._rotation = _rotation.clone() as Range;
			return copy;
		}
	}
}