package {
	
	import com.myavatareditor.avatarcore.Color;
	import com.myavatareditor.avatarcore.Feature;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * A button for assigning colors to a feature.
	 */
	public class ColorWellButton extends Sprite {
		
		private var feature:Feature; // feature to modify when clicked
		private var color:Color; // the library color for the feature to reference when updated
		
		public function ColorWellButton(feature:Feature, color:Color){
			this.feature = feature;
			this.color = color;
			
			// since Color instances are colorTransform instances
			// they can be used to set Transform.colorTransform directly
			transform.colorTransform = this.color;
			
			buttonMode = true;
			addEventListener(MouseEvent.CLICK, clickToUpdateHandler, false, 0, true);
		}
		
		private function clickToUpdateHandler(event:MouseEvent):void {
			
			// set referenced avatar feature to reference the 
			// color specified by this button when it was created
			feature.colorName = color.name;
		}
	}
}