/*
Run this script to have the current timeline's named symbols
placed in an Avatar XML document displayed in the Output
panel.
*/

var comments = "";
main();

function main(){
	// clear prior output text
	fl.outputPanel.clear();
	
	// main Definitions object to convert to XML
	var def = {xmlns:"com.myavatareditor.avatarcore"};
	
	// the src map will let us know which library
	// items have src values so the avatar features
	// won't need to include their own
	var elems = getElements();
	var indexMap = buildIndexMap(elems);
	var srcMap = {};
	def.Library = getLibraryFromLibrary(indexMap, srcMap);
	def.Avatar = getAvatarFromTimeline(elems, indexMap, srcMap);
	
	if (def.Library && def.Avatar){
		def.Avatar.libraryName = def.Library.name;
	}
	
	// output
	if (comments)
		fl.trace(comments);
	fl.trace( objectToXML(def, "Definition") );
}

function buildIndexMap(elems){
	var indexMap = {};
	if (elems == undefined) return indexMap;
	
	var elem;
	var index = 0;
	
	// create a copy to reverse
	// element order is opposite stacking
	elems = elems.concat();
	elems.reverse();
	
	var i, n = elems.length;
	for (i=0; i<n; i++){
		elem = elems[i];
		if (elem instanceof Instance && elem.name != null){
			indexMap[elem.name] = index;
			index++;
		}
	}
	return indexMap;
}

function getLibraryFromLibrary(indexMap, srcMap){
	if (indexMap == undefined) indexMap = {};
	if (srcMap == undefined) srcMap = {};
	
	var lib = fl.getDocumentDOM().library;
	var sel = lib.getSelectedItems();
	var library = {};
	
	var err_invalidSelection = "<!-- A Library node wasn't generated since there\n"
			+ "\twas an invalid selection made in the library -->\n";
	var err_noSelection = "<!-- A Library node wasn't generated since no\n"
			+ "\tselection made in the library -->\n";
	var err_noFeatures = "<!-- A Library node wasn't generated since no feature\n"
			+ "\tdefinitions were found in the library selection -->\n";
	
	// all folders in selected folder are feature names
	// all clips in those folders are art
	var libMap = mapLibraryItems(sel, true);
	
	if (libMap == null){
		comments += err_noSelection;
		return null;
	}
	
	var folderName;
	var features;
	
	// first folder in the map should be
	// the single, selected folder in which
	// feature folders reside
	for (folderName in libMap.folders){
		library.name = folderName;
		features = libMap.folders[folderName].folders;
		break;
	}
	
	if (features == undefined){
		comments += err_invalidSelection;
		return null;
	}
	
	// create the FeatureDefinition and Art nodes
	// based on the hierarchy of the library selection
	var definitionName;
	var symbolName;
	var symbol;
	var items;
	var definitions = [];
	for (folderName in features){
		
		// feature definition object
		definition = {
			name:folderName,
			artSet:{
				Art:[]
			}
		};
		
		// set zIndex if available from indexMap
		if (!isNaN(indexMap[folderName])){
			definition.artSet.zIndex = indexMap[folderName];
		}
		
		// add Art items
		items = features[folderName].items
		for (symbolName in items){
			symbol = items[symbolName].self;
			definition.artSet.Art.push({
				name:symbolName,
				src:symbol.linkageClassName
			});
			srcMap[symbolName] = symbol.linkageClassName;
		}
		
		// log feature definition in definitions list
		definitions.push(definition);
	}
	
	if (!definitions.length){
		comments += err_noFeatures;
		return null;
	}
	
	library.FeatureDefinition = definitions;
	return library;
}

function mapLibraryItems(items, normalize){
	if (items == undefined || !items.length) return null;
	if (normalize == undefined) normailze = false;
	
	var map = {
		folders:{}
	};
	var path;
	var pathParts;
	var pathPartName;
	var item;
	var itemName;
	var container;
	
	var i, n = items.length;
	var ii, nn;
	for (i=0; i<n; i++){
		item = items[i];
		path = item.name;
		if (path == undefined) continue;
		
		// generate folder path list
		pathParts = path.split("/");
		itemName = pathParts.pop();
		if (!itemName) continue;
		
		// create folder path in map
		container = map;
		nn = pathParts.length;
		for (ii=0; ii<nn; ii++){
			pathPartName = pathParts[ii];
			if (container.folders[pathPartName] == null){
				container.folders[pathPartName] = {
					folders:{}
				};
			}
			container = container.folders[pathPartName];
		}
		
		// put item in respective container
		if (item instanceof FolderItem){
			if (container.folderItems == null){
				container.folderItems = {};
			}
			container.folderItems[itemName] = {
				self:item
			};
		}else if (item instanceof LibraryItem){
			if (container.items == null){
				container.items = {};
			}
			container.items[itemName] = {
				self:item
			};
		}
	}
	
	// get rid of common root directory structure
	if (normalize){
		var root = map;
		var child;
		
		// loop through the child folders
		// of a map, removing each if there's
		// only one path
		while(root.folders != undefined 
			  && root.items == undefined
			  && root.folderItems == undefined){
			
			// expect only one child folder path
			for (child in root.folders){
				root = root.folders[child];
				break;
			}
			
			if (root == undefined){
				root = map;
				break;
			}
		}
		
		map = root;
	}
	
	return map;
}

function getAvatarFromTimeline(elems, indexMap, srcMap){
	if (indexMap == undefined) indexMap = {};
	if (srcMap == undefined) srcMap = {};
	
	var tl = fl.getDocumentDOM().getTimeline();
	
	var err_noElements = "<!-- An Avatar node wasn't generated since there\n"
			+ "\twere no objects on the timeline to read -->\n";
	
	var artObj;
	var adjustObj;
	var featureObjs = [];
	var elem;
	
	// loop through elemetns on the timeline
	// and grab respective art and adjust data
	var i, n = elems.length;
	for (i=0; i<n; i++){
		elem = elems[i];
		if (elem instanceof Instance && elem.name){
			artObj = {};
			artObj.name = getFeatureNameFromLibraryItem(elem.libraryItem);
			
			// set zIndex if available from indexMap
			if (!isNaN(indexMap[elem.name])){
				artObj.zIndex = indexMap[elem.name];
			}
			
			// create adjustement object it needed
			if (elem.x || elem.y || elem.rotation){
				adjustObj = {};
				if (elem.x) adjustObj.x = elem.x;
				if (elem.y) adjustObj.y = elem.y;
				if (elem.rotation) adjustObj.rotation = elem.rotation;
			}else{
				adjustObj = null;
			}
			
			// only include src if not linking to library item (via srcMap)
			if (elem.libraryItem.linkageClassName && srcMap[artObj.name] == undefined) {
				artObj.src = elem.libraryItem.linkageClassName;
			}
			
			featureObjs.push( {name:elem.name, art:artObj, adjust:adjustObj} );
		}
	}
	
	if (!featureObjs.length){
		comments += err_noElements;
		return null;
	}
	
	return {Feature:featureObjs, name:tl.name};
}

function getFeatureNameFromLibraryItem(libraryItem){
	// name of containing folder
	var pathParts = libraryItem.name.split("/");
	return pathParts.pop();
}

function getElements(){
	var tl = fl.getDocumentDOM().getTimeline();
	
	var elems = [];
	var layerElems;
	
	var li, ln;
	for(li=0, ln=tl.layers.length; li<ln; li++){
		layerElems = tl.layers[li].frames[tl.currentFrame].elements;
		layerElems.reverse();
		elems = elems.concat(layerElems); 
	}
	return elems;
}

function objectToXML(obj, name, indent){
	if (indent == null) indent = "";
	
	var children = "";
	var childIndent = indent;
	var node = "";
	
	if (name){
		node = indent + "<" + name;
		childIndent += "\t";
	}
	
	var prop, value;
	for (prop in obj){
		value = obj[prop];
		if (value instanceof Array){
			if (children) children += "\n";
			children += arrayToXML(value, prop, childIndent);
		}else if (value instanceof Object){
			if (children) children += "\n";
			children += objectToXML(value, prop, childIndent);
		}else if (value != null && node) {
			node += " " + prop + "=\"" + value + "\"";
		}
	}
	
	if (node){
		if (children){
			node += ">\n" + children
				+ "\n" + indent + "</" + name + ">";
		}else{
			node += " />";
		}
		return node;
	}
	
	return children;
}

function arrayToXML(arr, name, indent){
	if (indent == null) indent = "";
	var xml = "";
	var i, n = arr.length;
	for(i=0; i<n; i++){
		if (xml) xml += "\n";
		xml += objectToXML(arr[i], name, indent)
	}
	
	return xml;
}