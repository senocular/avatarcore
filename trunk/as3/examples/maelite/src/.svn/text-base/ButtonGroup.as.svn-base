package {
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * A container that automatically lays out its children in 
	 * a grid pattern.
	 */
	public class ButtonGroup extends Sprite {
		
		public var columnWidth:Number;
		public var rowHeight:Number;
		public var maxColumns:int;
		public var maxChildren:int;
		
		/**
		 * Constructor for new ButtonGroup instances.
		 * @param	columnWidth The number of pixels horizontally each child has
		 * to be displayed before a new column starts.
		 * @param	rowHeight The number of pixels vertically each child has
		 * to be displayed before a new row starts.
		 * @param	maxColumns The number of children that can be displayed
		 * horizontally before wrapping occurs and a new row is started.
		 * @param	maxChildren The maximum number of children that can be added
		 * to the ButtonGroup at one time.
		 */
		public function ButtonGroup(columnWidth:Number = 100, rowHeight:Number = 100, maxColumns:int = 10, maxChildren:int = -1){
			this.columnWidth = columnWidth;
			this.rowHeight = rowHeight;
			this.maxColumns = maxColumns;
			this.maxChildren = maxChildren;
			
			// cleanup view used to layout on timeline
			removeAllChildren();
			scaleX = scaleY = 1;
		}
		
		/**
		 * Removes all child display objects.
		 */
		public function removeAllChildren():void {
			var i:int = numChildren;
			while (i--) removeChildAt(0);
		}
		
		/**
		 * Adds a child display object to this object's display list and
		 * automatically updates the layout.
		 */
		override public function addChild(child:DisplayObject):DisplayObject {
			if (maxChildren < 0 || numChildren < maxChildren){
				child = super.addChild(child);
				updateLayout();
			}else child = null;
			return child;
		}
		
		/**
		 * Adds a child display object to this object's display list at the
		 * specified index and automatically updates the layout.
		 */
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject {
			if (maxChildren < 0 || numChildren < maxChildren){
				child = super.addChildAt(child, index);
				updateLayout(index);
			}else child = null;
			return child;
		}
		
		/**
		 * Removes a child display object from this object's display list and
		 * automatically updates the layout.
		 */
		override public function removeChild(child:DisplayObject):DisplayObject {
			child = super.removeChild(child);
			updateLayout();
			return child;
		}
		
		/**
		 * Removes a child display object from this object's display list at the
		 * specified index and automatically updates the layout.
		 */
		override public function removeChildAt(index:int):DisplayObject {
			var child:DisplayObject = super.removeChildAt(index);
			updateLayout(index);
			return child;
		}
		
		/**
		 * Updates the layout of the child display objects.
		 */
		private function updateLayout(startIndex:int = 0):void {
			for (var n:int = numChildren; startIndex < n; startIndex++){
				var child:DisplayObject = getChildAt(startIndex);
				var col:int = startIndex % maxColumns;
				var row:int = int(startIndex/maxColumns);
				child.x = col * columnWidth;
				child.y = row * rowHeight;
			}
		}
	}
}