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
		public var touchBringToFront:Boolean
		
		protected var _ctrlButtonInitType:String

		

		public function get ctrlButtonInitType():String		{			return _ctrlButtonInitType;		}
		
		public static const CTRLBUTTON_TYPE_BY_TEXTURE		:String = "byTexture"
		public static const CTRLBUTTON_TYPE_BY_OBJECT		:String = "byObject"
		
		protected var _upTexture:Texture
		public function get upTexture():Texture	{return _upTexture;	}
		
		protected var _downTexture:Texture
		public function get downTexture():Texture{ return _downTexture;}
		
		protected var _obj:DisplayObject
		public function get obj():DisplayObject { return _obj;}
		
			
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
		public function setCtrlButtonInitByObject( obj:DisplayObject ):void
		{
			if(obj!=null){
				_obj = obj
				_ctrlButtonInitType = CTRLBUTTON_TYPE_BY_OBJECT
			}
		}
	}
}