package lambmei.starling.display
{
	import starling.display.DisplayObject;
	import starling.textures.Texture;

	public class HandleSheetConfig
	{
		/**外框線寬度**/
		public var thickness:Number = 2

		/**外框線顏色**/
		public var lineColor:uint = 0xffffff
			
		/** 最小SIZE **/		
		public var minSize:Number	//預設 NaN
		/** 最大可縮放的SIZE **/
		public var maxSize:Number	//預設 NaN
		
		/** 點擊 將物件移動到前方 **/
		public var touchBringToFront:Boolean = true
		
		/** 冒泡傳遞事件 預設為false 打開會使用較多的記憶體 **/
		public var dispatchEventBubbles:Boolean		
		
		
		protected var _ctrlButtonInitType:String
		public function get ctrlButtonInitType():String		{			return _ctrlButtonInitType;		}
		
		public static const CTRLBUTTON_TYPE_BY_TEXTURE		:String = "byTexture"
		public static const CTRLBUTTON_TYPE_BY_OBJECT		:String = "byObject"
		public static const CTRLBUTTON_TYPE_BY_FACTORY		:String = "byFactory"
		
		protected var _upTexture:Texture
		public function get upTexture():Texture	{return _upTexture;	}
		
		protected var _downTexture:Texture
		public function get downTexture():Texture{ return _downTexture;}
		
		protected var _obj:DisplayObject
		public function get obj():DisplayObject { return _obj;}
		
		protected var _factory:Function
		public function get factory():Function { return _factory;}
			
		
		public function HandleSheetConfig()
		{
			
		}

		public function setCtrlButtonInitByTexture(upTexture:Texture , downTexture:Texture = null ):void
		{
			if(upTexture!=null){
				_upTexture = upTexture
				_downTexture= downTexture
				_ctrlButtonInitType = CTRLBUTTON_TYPE_BY_TEXTURE
			}
		}
		
		public function setCtrlButtonInitByFactory( factory:Function ):void			
		{
			var obj:DisplayObject
			if(factory !=null){
				obj = factory()
				if(obj is DisplayObject && obj !=null){
					
					_factory = factory
					_ctrlButtonInitType = CTRLBUTTON_TYPE_BY_FACTORY
					return
				}else{
					throw new ArgumentError("factory return not DisplayObject")
				}
			}else{
				throw new ArgumentError("factory not Defined")
			}
			
		}
		
		public function setCtrlButtonInitByObject( obj:DisplayObject ):void
		{
			if(obj!=null){
				_obj = obj
				_ctrlButtonInitType = CTRLBUTTON_TYPE_BY_OBJECT
			}
		}
	}
}