package {
	
	import com.myavatareditor.avatarcore.Feature;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * A button for changing feature adjusts.
	 */
	public class AdjustButton extends MovieClip {
		
		private var feature:Feature; // feature to modify when clicked
		private var adjustProperty:String; // name of the adjust property to change
		private var change:Number; // how much the adjust property is changed
		
		public function AdjustButton(feature:Feature, adjustProperty:String, change:Number){
			this.feature = feature;
			this.adjustProperty = adjustProperty;
			this.change = change;
			
			initializeIcon();
			
			buttonMode = true;
			addEventListener(MouseEvent.CLICK, clickToUpdateHandler, false, 0, true);
		}
		
		private function initializeIcon():void {
			
			// icon display is handled internally and is a part
			// of this movie clip instance.  Each adjustment contains
			// 2 icons starting from frame 1 through to frame 8
			// goto and stop on that frame depending on the
			// adjust property used by this button
			var frameLookup:Object = { y:1, x:3, scale:5, rotation:7 };
			var offset:int = change > 0 ? 1 : 0;
			gotoAndStop(frameLookup[adjustProperty] + offset);
		}
		
		private function clickToUpdateHandler(event:MouseEvent):void {
			
			// adjust and update. Since a property of a property of a
			// Feature is being edited, the Feature.redraw() command
			// must be used to indicate a change has been made
			feature.adjust[adjustProperty] += change;
			feature.redraw();
		}
	}
}