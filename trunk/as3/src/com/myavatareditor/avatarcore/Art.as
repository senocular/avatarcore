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
	 * Represents the characteristics of the visual art used
	 * to graphically represent the different features of an
	 * avatar.  The Art class is also a collection allowing it
	 * to contain other objects, namely other Art objects.  This
	 * allows one Art object to be a container for multiple Art
	 * instances if a feature requires more than one art asset
	 * to represent it visually.  If an Art object is being used
	 * in that fashion, its own art definitions are ignored and
	 * only the Art instances it contains are used as feature art.
	 * @author Trevor McCauley; www.senocular.com
	 */
	public class Art extends Collection {
		
		/**
		 * Horizontal location (offset) of the art graphics
		 * within an art sprite. This value should be set 
		 * before the art is drawn in an art sprite. If changed
		 * while the art is being displayed for an avatar, the
		 * effects will not be seen until the feature art is
		 * rebuilt.  By changing this value you're effectively
		 * changing the registration point (the point around which
		 * transformations occur) for the art.
		 */
		public function get x():Number { return _x; }
		public function set x(value:Number):void {
			_x = value;
		}
		private var _x:Number = 0;
		
		/**
		 * Vertical location (offset) of the art graphics
		 * within an art sprite. This value should be set 
		 * before the art is drawn in an art sprite. If changed
		 * while the art is being displayed for an avatar, the
		 * effects will not be seen until the feature art is
		 * rebuilt.  By changing this value you're effectively
		 * changing the registration point (the point around which
		 * transformations occur) for the art.
		 */
		public function get y():Number { return _y; }
		public function set y(value:Number):void {
			_y = value;
		}
		private var _y:Number = 0;
		
		/**
		 * Arrangement value to be used in determining the stacking
		 * order of all the art composed within an AvatarDisplay instance.
		 * The higher the zIndex, the higher the art in the stacking
		 * order.  If two objects share the same zIndex, there is no
		 * guarantee as to the order of their arrangement.  You should
		 * always specify unique zIndex values for avatar art.
		 */
		public function get zIndex():Number { return _zIndex; }
		public function set zIndex(value:Number):void {
			_zIndex = value;
		}
		private var _zIndex:Number; // default NaN
		
		/**
		 * The art source. This can be either a class name or a
		 * URL referencing a loaded asset such as a JPEG file. When
		 * loaded, the src value assumed first to be a class name
		 * for a DisplayObject (or BitmapData) instance.  If that fails,
		 * the value is loaded as a url.  For multiframe content, you
		 * can specify a destination frame by following the src 
		 * value with a hash (#) followed by the desired frame
		 * number or label. For example, src="eyes.swf#12" will 
		 * will first try to create a new eyes.swf instance. When
		 * that fails, eyes.swf will be loaded as an external asset.
		 * When complete, it will goto and stop at frame 12.
		 */
		public function get src():Object { return _src; }
		public function set src(value:Object):void {
			_src = value;
		}
		private var _src:Object;
		
		/**
		 * The source of the thumbnail to be used for previewing the
		 * art for the user. This can be either a class name or a
		 * URL referencing a loaded asset. Management of a thumbnail
		 * is handled independently by the developer; the framework does 
		 * not necessarily internally depend on or otherwise use this value.
		 */
		public function get thumbnail():String { return _thumbnail; }
		public function set thumbnail(value:String):void {
			_thumbnail = value;
		}
		private var _thumbnail:String;
		
		/**
		 * Indicates whether or not the art is colorized when
		 * a color is applied to the art's feature. Any non-zero
		 * value means that coloring will be applied.  The default
		 * is NaN which allows it.  The value of colorize is a 
		 * Number rather than a Boolean to facilitate the inheritance
		 * of the colorize value to child Art objects.  If a container
		 * Art object has a non-NaN value, that value is copied to the
		 * child Art objects within its collection.
		 */
		public function get colorize():Number { return _colorize; }
		public function set colorize(value:Number):void {
			_colorize = value;
		}
		private var _colorize:Number; // Number instead of Boolean for inheritance (NaN recognition)
		
		/**
		 * Indicates whether or not bitmaps loaded from an external
		 * source use smoothed pixels. When smoothing is NaN (default)
		 * or non-zero, smoothing is turned on.
		 */
		public function get smoothing():Number { return _smoothing; }
		public function set smoothing(value:Number):void {
			_smoothing = smoothing;
		}
		private var _smoothing:Number;
		
		/**
		 * The style name for the art.  In specifying a style, you
		 * limit the use of the art to only features with the same
		 * artStyle defined. By default both Art.style and 
		 * Feature.artStyle are null, so all art is used.  Whenever
		 * one or the other is changed, the art will be ignored unless
		 * it's value of style matches the feature's.  This is an
		 * optional property that is used for more advanced control
		 * over the application of feature art.
		 */
		public function get style():String { return _style; }
		public function set style(value:String):void {
			_style = value;
		}
		private var _style:String;
		
		/**
		 * Constructor for creating new Art instances.
		 * @param name Name of the instance. This is used to relate
		 * Feature art and FeatureDefinition art.
		 * @param src Source of the art content.
		 */
		public function Art(name:String = null, src:Object = null) {
			if (name) this.name = name;	
			if (src) this.src = src;	
		}
		
		override public function toString():String {
			return "[Art name=\"" + name + "\"]";
		}
		
		/**
		 * Creates and returns a copy of the Art object.
		 * If the Art object has any Art children in its
		 * collection, they are also cloned and placed
		 * within the cloned Art's collection.
		 * @return A copy of this Color object.
		 */
		override public function clone(copyInto:Object = null):Object {
			var copy:Art = (copyInto) ? copyInto as Art : new Art();
			if (copy == null) return null;
			super.clone(copy);
			
			copy._x = _x;
			copy._y = _y;
			copy._zIndex = _zIndex;
			copy._src = _src;
			copy._thumbnail = _thumbnail;
			copy._colorize = _colorize;
			copy._smoothing = _smoothing;
			copy._style = _style;
			return copy;
		}
		
		public override function getPropertiesAsAttributesInXML():Object {
			var obj:Object = super.getPropertiesAsAttributesInXML();
			obj.x = 1;
			obj.y = 1;
			obj.zIndex = 1;
			obj.src = 1;
			obj.thumbnail = 1;
			obj.colorize = 1;
			obj.smoothing = 1;
			obj.style = 1;
			return obj;
		}
		public override function getDefaultPropertiesInXML():Object {
			var obj:Object = super.getPropertiesAsAttributesInXML();
			obj.x = 0;
			obj.y = 0;
			return obj;
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
			item = super.addItem(item);
			if (item is Art) {
				var artItem:Art = item as Art;
				var childIndex:int = collection.indexOf(artItem);
				artItem.assignDefaults(_zIndex, _colorize, _smoothing, childIndex);
			}
			
			return item;
		}
		
		/**
		 * Assigns values passed as defaults to the art object if
		 * they're not already defined.  If the collection of the
		 * art object has any art objects within, they are assigned
		 * defaults as well.
		 * @param	zIndex Default zIndex.
		 * @param	colorize Default colorize.
		 * @param	smoothing Default smoothing.
		 * @param	incrementMap An object used to handle child zIndex
		 * incrementing.  The map stores offsets to use for zIndex based
		 * on style values.
		 */
		public function assignDefaults(zIndex:Number = Number.NaN, colorize:Number = Number.NaN, smoothing:Number = Number.NaN, incrementMap:Object = null):void {
			
			if (isNaN(zIndex) == false && isNaN(_zIndex)) {
				
				if (incrementMap){
					
					// auto-increment zIndex
					var styleKey:Object = String(style); // null becomes "null"
					if (styleKey in incrementMap == false){
						incrementMap[styleKey] = zIndex;
					}else{
						incrementMap[styleKey]++;
					}
					
					_zIndex = incrementMap[styleKey];
					
				}else{
					
					// direct copy zIndex
					_zIndex = zIndex;
				}
			}
			
			if (isNaN(colorize) == false && isNaN(_colorize)) {
				_colorize = colorize;
			}
			
			if (isNaN(smoothing) == false && isNaN(_smoothing)) {
				_smoothing = smoothing;
			}
			
			// assign defaults to child Art items in collection
			var children:Array = this.collection;
			var childArt:Art;
			var childMap:Object = {};
			var i:int, n:int = children.length;
			for (i=0; i<n; i++) {
				childArt = children[i] as Art;
				if (childArt){
					childArt.assignDefaults(zIndex, colorize, smoothing, childMap);
				}
			}
		}
	}
}