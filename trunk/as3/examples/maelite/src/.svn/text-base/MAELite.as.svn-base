package {
	
	import com.myavatareditor.avatarcore.*;
	import com.myavatareditor.avatarcore.display.*;
	import com.myavatareditor.avatarcore.xml.*;
	import flash.display.*
	import flash.events.*;
	import flash.filters.*;
	import flash.net.*;
	import flash.text.*;
	
	// force inclusion of some classes that may only
	// have been referenced in XML
	Mirror; Constrain; SourceToStyle; CopyColor; Metadata;
	
	/**
	 * Document class for My Avatar Editor Lite (built with the
	 * Avatar Core framework).  This class consists mostly of 
	 * methods for building the GUI.  Most interaction with the
	 * avatar - where avatar values are actually edited - are 
	 * handled within individual button classes.
	 */
	public class MAELite extends Sprite {
		
		private var libraryURL:String = "maelite_library.xml"; // library XML file
		private var libraryLoader:URLLoader = new URLLoader(); // loads library XML
		private var xmlParser:XMLDefinitionParser = new XMLDefinitionParser(); // parses XML
		
		private var library:Library; // stores loaded, parsed library
		private var selectedDefinition:FeatureDefinition; // current feature being edited
		private var currentTypePage:int = 0; // current page in type selection
		
		private var avatar:Avatar; // stores avatar
		private var avatarDisplay:AvatarDisplay; // displays avatar on screen
		
		// default avatar definition as XML. This is not self-contained
		// depending on a library for visual assets. Some names are numeric
		// since these are the identifiers given to collection objects if
		// not given explicit names (0-based indices are used)
		// Adjust objects are kept in the avatar.  Art and color are
		// referenced through definitions in the library.
		private var defaultAvatarXML:XML = 
			<Avatar xmlns="com.myavatareditor.avatarcore">
				<Feature name="glasses" artName="0" colorName="0">
					<adjust y="1" scale="1"/>
				</Feature>
				<Feature name="nose" artName="0">
					<adjust y="30" scale="0.6"/>
				</Feature>
				<Feature name="mustache" artName="0">
					<adjust y="53.75" scale="0.63"/>
				</Feature>
				<Feature name="hairOrnaments" artName="0" />
				<Feature name="hair" artName="0" colorName="1"/>
				<Feature name="eyebrows" artName="0" colorName="1">
					<adjust x="8.75" y="-19.8" scale="0.625" rotation="56.82"/>
				</Feature>
				<Feature name="eyes" artName="0" colorName="0">
					<adjust x="9" y="0.33" scale="0.68" rotation="34.93"/>
				</Feature>
				<Feature name="mouth" artName="0" colorName="0">
					<adjust y="61.22" scale="0.61"/>
				</Feature>
				<Feature name="mole" artName="0">
					<adjust x="-53.25" y="46.67" scale="0.83"/>
				</Feature>
				<Feature name="beard" artName="0" colorName="0">
					<adjust y="92"/>
				</Feature>
				<Feature name="face" artName="0" />
				<Feature name="head" artName="0" colorName="0" />
			</Avatar>;
			
		/**
		 * Entry point for My Avatar Editor Lite application.
		 */
		public function MAELite(){
			
			// generate the hardcoded avatar instance
			// this cannot be rendered until the library is loaded
			avatar = xmlParser.parse(defaultAvatarXML) as Avatar;
			
			// load in the external library XML
			// when complete, the UI will initialize
			libraryLoader.addEventListener(Event.COMPLETE, libraryLoadedHandler);
			libraryLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, trace);
			libraryLoader.addEventListener(IOErrorEvent.IO_ERROR, trace);
			libraryLoader.load(new URLRequest(libraryURL));
		}
		
		/**
		 * Event handler signaling the successful completion of
		 * loading the library XML.
		 */
		private function libraryLoadedHandler(event:Event):void {
			
			// parse the loaded library XML and set the
			// pre-defined avatar to reference it
			var libraryXML:XML = new XML(libraryLoader.data);
			
			library = xmlParser.parse(libraryXML) as Library;
			avatar.library = library;
			
			// create an avatar display to show the
			// avatar on the left side of the screen
			avatarDisplay = new AvatarDisplay(avatar);
			avatarDisplay.x = 115;
			avatarDisplay.y = 205;
			avatarDisplay.scaleX = .9;
			avatarDisplay.scaleY = .9;
			avatarDisplay.filters = [new DropShadowFilter(2, 45, 0, 0.5, 2, 2)];
			addChild(avatarDisplay);
			
			// setup the rest of the GUI based
			// on the definitions in the library
			// they determine what the avatar can
			// select for its features
			initializeGUI();
		}
		
		/**
		 * Intializes the GUI as a one-time setup.
		 */
		private function initializeGUI():void {
			initializeButtonGroups();
			
			// get all FeatureDefinition objects from the library
			// these are the possible feature variations for the
			// avatar and is used to generate the GUI
			var definitions:Array = library.getItemsByType(FeatureDefinition);
			buildFeatureGroup(definitions);
			buildDefinitionSelection(definitions[0] as FeatureDefinition);
		}
		
		/**
		 * Initializes the property values (and related) for the ButtonGroup
		 * objects used to contain selection buttons.
		 */
		private function initializeButtonGroups():void {
			
			// bottom row of feature buttons to select
			// which feature to edit
			featureGroup.columnWidth = 43;
			featureGroup.maxColumns = 100;
			featureGroup.buttonMode = true;
			featureGroup.addEventListener(MouseEvent.CLICK, selectFeatureHandler);
			
			// main, middle selection for art type
			typeGroup.columnWidth = 65;
			typeGroup.rowHeight = 65;
			typeGroup.maxColumns = 3;
			typeGroup.maxChildren = 12;
			// arrows for paging through art types
			typePagePrevButton.buttonMode = true;
			typePageNextButton.buttonMode = true;
			typePagePrevButton.addEventListener(MouseEvent.CLICK, newTypePageHandler);
			typePageNextButton.addEventListener(MouseEvent.CLICK, newTypePageHandler);
			
			// top right color selections
			colorGroup.columnWidth = 25;
			colorGroup.rowHeight = 25;
			colorGroup.maxColumns = 4;
			
			// adjustment buttons to the right
			adjustGroup.columnWidth = 48;
			adjustGroup.rowHeight = 52;
			adjustGroup.maxColumns = 2;
		}
		
		/**
		 * A one-time creation step for creating Feature selection buttons
		 * for the featureGroup.
		 */
		private function buildFeatureGroup(definitions:Array):void {
			
			// rebuilding from scratch; remove all previous
			featureGroup.removeAllChildren();
			
			// for each definition, create a FeatureButton button
			// in the featureGroup container and give it a 
			// thumbnail child using ThumbnailArtSprite
			var button:FeatureButton;
			var definition:FeatureDefinition;
			var arts:Array;
			
			var i:int, n:int = definitions.length;
			for (i=0; i<n; i++){
				
				definition = definitions[i] as FeatureDefinition;
				
				// only create a button if more than one Art
				// is available for selection
				arts = definition.artSet.getItemsByType(Art);
				if (arts.length > 1){
					button = new FeatureButton();
					button.name = definition.name;
					button.mouseChildren = false;
					button.addChild(new ThumbnailArtSprite(definition));
					featureGroup.addChild( button );
				}
			}
		}
		
		/**
		 * Rebuilds button groups based on a newly selected FeatureDefinition
		 * from the featureGroup.
		 */
		private function buildDefinitionSelection(definition:FeatureDefinition):void {
			
			// Builds the GUI based on the supplied FeatureDefinition
			// that value becomes selectedDefinition
			selectedDefinition = definition;
			buildTypeGroup(selectedDefinition, 0); // start with first page
			buildColorGroup(selectedDefinition);
			buildAdjustGroup(selectedDefinition);
		}
		
		/**
		 * Builds the button selections for the typeGroup. Type (Art) 
		 * selections are read from the library based off of the
		 * supplied FeatureDefinition.
		 */
		private function buildTypeGroup(definition:FeatureDefinition, page:int = 0):void {
			
			// rebuilding from scratch; remove all previous
			typeGroup.removeAllChildren();
			
			// display the art type buttons based on those within
			// the definition's artSet
			var feature:Feature = avatar.getItemByName(definition.name) as Feature;
			var button:ArtTypeButton;
			
			var types:Array = definition.artSet.getItemsByType(Art);
			var i:int, n:int = types.length;
			
			// since there are more art types than there are room
			// for buttons, the buttons need to be paged. First the
			// page value passed in is validated, then used in a loop
			// to create the ArtTypeButtons for that page
			// The ArtTypeButton class contains the logic for changing
			// the Art for the current feature
			
			// keep page within allowed values
			var lastPage:int = Math.ceil(n/typeGroup.maxChildren) - 1;
			if (page < 0) currentTypePage = 0;
			else if (page > lastPage) currentTypePage = lastPage;
			else currentTypePage = page;
			
			// determine start and end points for loop
			var startIndex:int = currentTypePage * typeGroup.maxChildren;
			var endIndex:int = startIndex + typeGroup.maxChildren;
			if (n > endIndex) n = endIndex;
				
			// create buttons in loop
			for (i=startIndex; i<n; i++){
				button = new ArtTypeButton(feature, types[i] as Art, definition);
				typeGroup.addChild( button );
			}
			
			// update the current page display text
			typePageText.text = (currentTypePage + 1) + "/" + (lastPage + 1);
		}
		
		/**
		 * Builds the button selections for the colorGroup. Color 
		 * selections are read from the library based off of the
		 * supplied FeatureDefinition.
		 */
		private function buildColorGroup(definition:FeatureDefinition):void {
			
			// rebuilding from scratch; remove all previous
			colorGroup.removeAllChildren();
			
			// for each color in the colorSet of the definition
			// create a ColorWellButton in the colorGroup container
			// The ColorWellButton class contains the logic for changing
			// the Color for the current feature
			var feature:Feature = avatar.getItemByName(definition.name) as Feature;
			var button:ColorWellButton;
			
			var colors:Array = definition.colorSet.getItemsByType(Color);
			var i:int, n:int = colors.length;
			for (i=0; i<n; i++){
				button = new ColorWellButton(feature, colors[i] as Color);
				colorGroup.addChild( button );
			}
		}
		
		/**
		 * Builds the button selections for the adjustGroup. Adjust 
		 * selections are read from the library based off of the
		 * supplied FeatureDefinition.  Specifically, for the Adjust
		 * options, a Constrain within the FeatureDefinition's behaviors
		 * list is used, and only the ranges it contains will have
		 * buttons created for them.
		 */
		private function buildAdjustGroup(definition:FeatureDefinition):void {
			
			// rebuilding from scratch; remove all previous
			adjustGroup.removeAllChildren();
			
			// get all the constrains in the behaviors collection of the
			// definition, accounting for the case where there are multiple,
			// and use the last if any exist to generate adjust buttons
			// The AdjustButton class contains the logic for changing
			// the Adjust for the current feature
			var constrains:Array = definition.behaviors.getItemsByType(Constrain);
			var n:int = constrains.length;
			if (n > 0){
				
				var constrain:Constrain = constrains[n - 1] as Constrain; // last constrain
				var feature:Feature = avatar.getItemByName(definition.name) as Feature;
				var range:Range;
				var button:AdjustButton;
				
				// vertical
				range = constrain.y;
				if (range){
					button = new AdjustButton(feature, "y", -range.stepSpan);
					adjustGroup.addChild( button );
					button = new AdjustButton(feature, "y", range.stepSpan);
					adjustGroup.addChild( button );
				}
				
				// horizontal
				range = constrain.x;
				if (range){
					button = new AdjustButton(feature, "x", -range.stepSpan);
					adjustGroup.addChild( button );
					button = new AdjustButton(feature, "x", range.stepSpan);
					adjustGroup.addChild( button );
				}
				
				// size
				range = constrain.scale;
				if (range){
					button = new AdjustButton(feature, "scale", -range.stepSpan);
					adjustGroup.addChild( button );
					button = new AdjustButton(feature, "scale", range.stepSpan);
					adjustGroup.addChild( button );
				}
				
				// rotation
				range = constrain.rotation;
				if (range){
					button = new AdjustButton(feature, "rotation", -range.stepSpan);
					adjustGroup.addChild( button );
					button = new AdjustButton(feature, "rotation", range.stepSpan);
					adjustGroup.addChild( button );
				}
			}
		}
		
		/**
		 * Event handler used when a new feature is selected by the
		 * user from the featureGroup.
		 */
		private function selectFeatureHandler(event:MouseEvent):void {
			
			// button names match the names of the 
			// FeatureDefinition instances in the library
			var name:String = DisplayObject(event.target).name;
			buildDefinitionSelection(library.getItemByName(name) as FeatureDefinition);
		}
		
		/**
		 * Event handler used when a user changes the page of
		 * the typeGroup for Art selection.
		 */
		private function newTypePageHandler(event:MouseEvent):void {
			
			// depending on which arrow instance was pushed, increment
			// or decrement the current page being displayed for
			// the type group (Art selection)
			var direction:int = (event.currentTarget == typePagePrevButton) ? -1 : 1;
			buildTypeGroup(selectedDefinition, currentTypePage + direction);
		}
	}
}