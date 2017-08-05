package {
	
	import com.myavatareditor.avatarcore.*;
	import com.myavatareditor.avatarcore.display.*;
	import com.myavatareditor.avatarcore.xml.*;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	// make sure dependent classes are compiled within SWF
	Mirror; Constrain;
	
	/**
	 * Document class for the feature editing example showing how Adjust
	 * objects can be changed to modify the appearances of Avatar 
	 * Features.  This examples also shows how the sprites that represent
	 * those features can be directly manipulated through mouse interaction.
	 */
	public class FeatureEditing extends Sprite {
	
		private var avatarXML:XML =
			<Avatar xmlns="com.myavatareditor.avatarcore">
				<Feature name="Head">
					<art src="Head" zIndex="0" />
					<adjust />
				</Feature>
				<Feature name="Hair" parentName="Head">
					<art src="Hair" zIndex="4" />
					<adjust y="-40" />
				</Feature>
				<Feature name="Ears" parentName="Head">
					<art src="Ear" zIndex="-1" />
					<adjust x="-40" />
					<behaviors>
						<Mirror />
					</behaviors>
				</Feature>
				<Feature name="Eyes" parentName="Head">
					<art src="Eye" zIndex="1" />
					<adjust x="-10" y="-20" />
					<behaviors>
						<Mirror />
					</behaviors>
				</Feature>
				<Feature name="Nose" parentName="Head">
					<art src="Nose" zIndex="10" />
					<adjust y="10" />
				</Feature>
				<Feature name="Mouth" parentName="Head">
					<art src="Mouth" zIndex="2" />
					<adjust y="40" />
				</Feature>
			</Avatar>;
		
		// for creating and displaying Avatar
		private var xmlParser:XMLDefinitionParser = new XMLDefinitionParser();
		private var avatarDisplay:AvatarDisplay;
		
		// for manipulating Avatar Features
		private var moveTool:MoveFeatureTool = new MoveFeatureTool();
		private var scaleTool:ScaleFeatureTool = new ScaleFeatureTool();
		private var rotateTool:RotateFeatureTool = new RotateFeatureTool();
		private var currentTool:IFeatureTool;
		
		// Timeline objects
		public var toolSelection:MovieClip;
		
		public function FeatureEditing() {
			
			// create the avatar character
			var avatar:Avatar = xmlParser.parse(avatarXML) as Avatar;
			avatarDisplay = new AvatarDisplay(avatar);
			avatarDisplay.x = 150;
			avatarDisplay.y = 150;
			addChildAt(avatarDisplay, 0);
			
			// the default tool is the move tool
			currentTool = moveTool;
			
			// listen for a change in tool selection
			toolSelection.addEventListener(MouseEvent.CLICK, toolChangedHandler, false, 0, true);
			// listen for a selection of an ArtSprite
			avatarDisplay.addEventListener(MouseEvent.MOUSE_DOWN, pressArtSpriteHandler, false, 0, true);
		}
		
		private function toolChangedHandler(event:MouseEvent):void {
			
			// depending on which radio button was selected, change
			// the value of currentTool to match the tool that
			// relates to that button
			switch (event.target.name){
				
				case "scaleRadio":{
					currentTool = scaleTool;
					break;
				}
				
				case "rotateRadio":{
					currentTool = rotateTool;
					break;
				}
				
				case "moveRadio":
				default:{
					currentTool = moveTool;
					break;
				}
			}
		}
		
		private function pressArtSpriteHandler(event:MouseEvent):void {
			
			// use global event handlers to recognize all mouse movements
			// and releases even if ouside the stage
			stage.addEventListener(MouseEvent.MOUSE_MOVE, whileUsingArtSpriteHandler, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, releaseArtSpriteHandler, false, 0, true);
			
			// intialize the current tool when an art sprite is clicked
			currentTool.startAction(event.target as ArtSprite);
		}

		private function whileUsingArtSpriteHandler(event:MouseEvent):void {
			
			// while using the current tool
			currentTool.whileAction();
		}
		
		private function releaseArtSpriteHandler(event:MouseEvent):void {
			
			// remove global movie event handlers
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, whileUsingArtSpriteHandler, false);
			stage.removeEventListener(MouseEvent.MOUSE_UP, releaseArtSpriteHandler, false);
			
			// complete the action of the current tool
			currentTool.endAction();
		}
	}
}