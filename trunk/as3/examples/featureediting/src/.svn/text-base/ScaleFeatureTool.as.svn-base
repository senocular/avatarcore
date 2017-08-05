package {
	
	import com.myavatareditor.avatarcore.display.ArtSprite;
	import com.myavatareditor.avatarcore.display.MirroredArtSprite;
	import com.myavatareditor.avatarcore.Feature;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * Scales a feature based on a selected ArtSprite.
	 * @author Trevor McCauley; www.senocular.com
	 */
	public class ScaleFeatureTool implements IFeatureTool {
		
		private var selectedArtSprite:ArtSprite; // sprite being modified
		private var startFeatureScaleX:Number;
		private var startFeatureScaleY:Number;
		private var startRotation:Number;
		private var startScalePoint:Point;
		
		public function ScaleFeatureTool(){}
		
		public function startAction(artSprite:ArtSprite):void {
			selectedArtSprite = artSprite;
			
			// save the current scaleX and scaleY values of the
			// current feature so that they can be used as a base
			// for changing when scaling
			startFeatureScaleX = selectedArtSprite.feature.adjust.scaleX;
			startFeatureScaleY = selectedArtSprite.feature.adjust.scaleY;
			
			// rotation is saved as a way to generate the mouse
			// scale point relative to the sprite's rotation
			startRotation = selectedArtSprite.rotation;
			
			// get the scale point where the art sprite was clicked
			// moving closer to the center of the sprite from this point 
			// will scale down while moving away will scale up
			startScalePoint = getMouseScalePoint();
			
			// in the case that the center point of the art sprite - or some
			// location close to it - is clicked when first using this tool,
			// it could create an abnormally large and sensitive scaling ratio
			// where little mouse movements create very large scales. To protect
			// against this, limit the minimal points of the start scale point
			var sensitivity:Number = 10;
			if (Math.abs(startScalePoint.x) < sensitivity){
				startScalePoint.x = (startScalePoint.x < 0) ? -sensitivity : sensitivity;
			}
			if (Math.abs(startScalePoint.y) < sensitivity){
				startScalePoint.y = (startScalePoint.y < 0) ? -sensitivity : sensitivity;
			}
		}
		
		public function whileAction():void {
			
			// get the current scale point and use the ratio
			// of movement from the start scale point to modify
			// the original feature scale to get the new scale
			var scalePoint:Point = getMouseScalePoint();
			var feature:Feature = selectedArtSprite.feature;
			feature.adjust.scaleX = startFeatureScaleX * scalePoint.x/startScalePoint.x;
			feature.adjust.scaleY = startFeatureScaleY * scalePoint.y/startScalePoint.y;
			feature.redraw();
		}
		
		public function endAction():void {
			
			// clear references
			selectedArtSprite = null;
			startScalePoint = null;
		}
		
		/**
		 * Gets the location of the mouse within the rotation coordinate
		 * space of the selected art sprite.
		 */
		private function getMouseScalePoint():Point {
			
			// scaling is based on the position of the mouse from
			// the center poitn of the selected art sprite
			var scalePoint:Point = new Point();
			scalePoint.x = selectedArtSprite.parent.mouseX - selectedArtSprite.x;
			scalePoint.y = selectedArtSprite.parent.mouseY - selectedArtSprite.y;
			
			// to make scaling go in the direction of the selected sprite
			// the mouse position will need to be rotated to match
			// the rotation of the sprite
			var rotationMatrix:Matrix = new Matrix();
			rotationMatrix.rotate(-startRotation * Math.PI/180);
			return rotationMatrix.transformPoint(scalePoint);
		}
	}
}