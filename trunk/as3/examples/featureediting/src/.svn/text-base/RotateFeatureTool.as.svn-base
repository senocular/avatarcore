package {
	
	import com.myavatareditor.avatarcore.display.ArtSprite;
	import com.myavatareditor.avatarcore.display.MirroredArtSprite;
	import com.myavatareditor.avatarcore.Feature;
	
	/**
	 * Rotates a feature based on a selected ArtSprite.
	 * @author Trevor McCauley; www.senocular.com
	 */
	public class RotateFeatureTool implements IFeatureTool {
		
		private var selectedArtSprite:ArtSprite; // sprite being modified
		private var startMouseRotation:Number; // rotation based on mouse position
		private var startFeatureRotation:Number; // rotation based on feature adjust
		
		public function RotateFeatureTool(){}
		
		public function startAction(artSprite:ArtSprite):void {
			selectedArtSprite = artSprite;
			
			// save the rotations both from the feature and derived
			// from the mouse. Differences in the mouse rotation will
			// be used to add to the start feature rotation
			startFeatureRotation = selectedArtSprite.feature.adjust.rotation;
			startMouseRotation = getMouseRotation();
		}
		
		public function whileAction():void {
			var feature:Feature = selectedArtSprite.feature;
			
			// reverse the application of rotation for mirrored sprites
			if (selectedArtSprite is MirroredArtSprite){
				feature.adjust.rotation = startFeatureRotation + startMouseRotation - getMouseRotation();
			}else{
				feature.adjust.rotation = startFeatureRotation - startMouseRotation + getMouseRotation();
			}
			
			feature.redraw();
		}
		
		public function endAction():void {
			
			// clear references
			selectedArtSprite = null;
		}
		
		/**
		 * Returns the rotation of the mouse position with respect to
		 * the current selected art sprite.
		 */
		private function getMouseRotation():Number {
			
			// get the rotation of the mouse with respect
			// to the center of the selected art sprite
			var dx:Number = selectedArtSprite.parent.mouseX - selectedArtSprite.x;
			var dy:Number = selectedArtSprite.parent.mouseY - selectedArtSprite.y;
			return Math.atan2(dy, dx) * 180/Math.PI;
		}
	}
}