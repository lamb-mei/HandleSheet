package handlesheet.examples 
{
	
	import lambmei.starling.display.HandleSheet;
	import lambmei.starling.display.HandleSheetConfig;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	
	public class MainView extends Sprite
	{
		/**
		 * Constructor.
		 */
		
		[Embed(source="/../assets/images/atlas.png")]
		private static const ICONS_IMAGE:Class;
		
		[Embed(source="/../assets/images/atlas.xml",mimeType="application/octet-stream")]
		private static const ICONS_XML:Class;
		
		
		private var _textureAtlas:TextureAtlas
		
		
		private var lastSelect:HandleSheet
		
		public function MainView()
		{
			
			_textureAtlas = new TextureAtlas(Texture.fromBitmap(new ICONS_IMAGE(), false), XML(new ICONS_XML()));
			
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		
		/**
		 * Where the magic happens. Start after the main class has been added
		 * to the stage so that we can access the stage property.
		 */
		protected function addedToStageHandler(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			var texture:Texture
			var hs:HandleSheet
			var _contents:DisplayObject
			
			/** HandeSheet 1 **/
			_contents = new Image(_textureAtlas.getTexture("lamb-mei"))
			hs = new HandleSheet(_contents)
			//使用 Texture
			hs.setCtrlButtonInitByTexture(_textureAtlas.getTexture("CtrlButton/0000"))
			hs.addEventListener(HandleSheet.EVENT_SELECTED, onSelect);
			hs.x = 120
			hs.y = 150
			addChild(hs)
			
			
			/** HandeSheet 2 **/
			_contents = new Image(_textureAtlas.getTexture("facebook"))			
			hs = new HandleSheet(_contents)
			//使用  down Texture 
			hs.setCtrlButtonInitByTexture(_textureAtlas.getTexture("CtrlButton/0000"), _textureAtlas.getTexture("CtrlButton/0001"))
			//啟用  dispatchEventBubbles 可以只註冊再上層
			hs.dispatchEventBubbles = true
			// Line style
			hs.thickness = 5				
			hs.lineColor = 0xF7BD19				
			hs.x = 320
			hs.y = 150
			addChild(hs)
			
			
			/** HandeSheet 3 **/
			_contents = new Image(_textureAtlas.getTexture("MuttonHotPot"))
			_contents.width = _contents.height = 120
			hs = new HandleSheet(_contents)						
			hs.dispatchEventBubbles = true			
			// Size Limit
			hs.minSize = 0.5
			hs.maxSize = 2.5			
			//Do not Auto Bring to Front
			hs.touchBringToFront = false				
			hs.x = 520
			hs.y = 150
			addChild(hs)
			
			
			/** HandeSheet 4 **/
			_contents = new Image(_textureAtlas.getTexture("yahoo"))
			hs = new HandleSheet(_contents)
			hs.dispatchEventBubbles = true	
			//Create Coustom CtrlButton						
			function imgFactory():Image{
				var img:Image = new Image(_textureAtlas.getTexture("selected-page-symbol"))
				img.width = 20
				img.height = 20
				return img
			}				
			hs.setCtrlButtonInitByFactory(imgFactory)		
			
			hs.x = 740
			hs.y = 150
			addChild(hs)
			
			
			
			/* init Muti By Config */	
			
			//Conf 1
			var conf1:HandleSheetConfig = new HandleSheetConfig()
			conf1.setCtrlButtonInitByTexture(_textureAtlas.getTexture("CtrlButton/0000"), _textureAtlas.getTexture("CtrlButton/0001")) 
			conf1.dispatchEventBubbles = true	
			conf1.minSize = 0.5
			conf1.lineColor = 0xFF0000
			
			//Conf 2	
			var conf2:HandleSheetConfig = new HandleSheetConfig()
			conf2.dispatchEventBubbles = true	
			function imgFactory1():Image{
				var img:Image = new Image(_textureAtlas.getTexture("selected-page-symbol"))
				img.width = 30
				img.height = 30
				return img
			}
			conf2.maxSize = 2
			conf2.setCtrlButtonInitByFactory(imgFactory)		
			
			
			var i:int = 0
			var textureGroup:Array = ["google","picasa" ,"twitter","wordpress","youtube","livejournal"]
			for each(var textureName:String in textureGroup)
			{
				var row:int = i/3 >>0 
				
				_contents = new Image(_textureAtlas.getTexture(textureName))
				
				var useConf:HandleSheetConfig = row == 0 ? conf1 : conf2
				hs = new HandleSheet(_contents , useConf)
				
				
				hs.x = 120 + (200 * (i%3))
				hs.y = 350 + (180 * row )
				i++	
					addChild(hs)
			}
			
			//可以捕捉到 dispatchEventBubbles 為  true 物件發出的EVENT
			addEventListener(HandleSheet.EVENT_SELECTED, onCatchDispatchEvent);
		}
		
		
		
		
		protected function onCatchDispatchEvent(event:Event):void
		{
			if(event.target is HandleSheet){
				if(lastSelect!=null && event.target != lastSelect){
					lastSelect.selected = false
				}
				lastSelect = event.target as HandleSheet
				event.stopImmediatePropagation()
			}
		}
		protected function onSelect(event:Event):void
		{
			//			trace(event.target)
			if(event.target is HandleSheet){
				
				if(lastSelect!=null && event.target != lastSelect){
					lastSelect.selected = false
				}
				
				
				lastSelect = event.target as HandleSheet
			}
		}
	}
}
import handlesheet.examples;

