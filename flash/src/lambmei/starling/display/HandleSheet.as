package lambmei.starling.display
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class HandleSheet extends Sprite
	{
		private var _selected:Boolean
		private var _contents:DisplayObject
		
		private var _ctrlButton:DisplayObject
		private var _selectedGroup:Sprite
		
		private var _touchBringToFront:Boolean
		public function get touchBringToFront():Boolean
		{
			return _touchBringToFront;
		}

		public function set touchBringToFront(value:Boolean):void
		{
			_touchBringToFront = value;
		}

		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if(value!=_selected){
				_selected = value;
				
			}
			
		}
		private static const CTRL_BUTTON_NAME:String = "ctrlBtn"
		
		public static const ALIGN_CENTER:String = "center"
		public static const ALIGN_LT:String = "LT"
		
		private var _useCtrlButton:Boolean
		
		
		public function get useCtrlButton():Boolean
		{
			return _useCtrlButton;
		}
		
//		public function set useCtrlButton(value:Boolean):void
//		{
//			_useCtrlButton = value;
//		}
		
		
		
		
		public function HandleSheet(contents:DisplayObject=null)
		{
			addEventListener(TouchEvent.TOUCH, onTouch);
			useHandCursor = true;
			
			_touchBringToFront = true
			
			if (contents)
			{
				var _w:Number = contents.width
				var _h:Number = contents.height
				var _halfW:Number = _w/2
				var _halfH:Number= _h/2
				//將物件置中
				contents.x = int(_halfW * -1);
				contents.y = int(_halfH * -1);
				addChild(contents);
				_contents = contents
				
			}			
			
			//init SelectGroup
			_selectedGroup = new Sprite()			
			this.addChild(this._selectedGroup);
		}
		
		
		

		
		public function setCtrlButtonInitByTexture(upTexture:Texture , downTexture:Texture = null ):void
		{
			_useCtrlButton = true
			
			if ( upTexture !=null)
			{
				_ctrlButton = new Button(upTexture,CTRL_BUTTON_NAME,downTexture);
				
				setCtrlButtonInitByObject(_ctrlButton )
			}else{
				throw new ArgumentError("Texture is Null!")
			}
		}
		/** 設定控制按鈕 by 物件 可以是 image sprite button **/
		public function setCtrlButtonInitByObject( obj:DisplayObject ):void
		{
			_useCtrlButton = true
			
			if (_contents)
			{
				_ctrlButton = obj
				
				
				var _w:Number = _contents.width
				var _h:Number = _contents.height
				var _halfW:Number = _w/2
				var _halfH:Number= _h/2
				//放置右上角
				_ctrlButton.x = int(_halfW)
				_ctrlButton.y = - int(_halfH)
				
				//置中對齊
				_ctrlButton.x -= int(_ctrlButton.width/2)
				_ctrlButton.y -= int(_ctrlButton.height/2)
				
				_selectedGroup.addChild(_ctrlButton)
			}
		}
		
		
		/** 單隻手指使用控制按鈕 放大縮小旋轉 **/
		private function resizeAndRotationByCtrlButton(touches:Vector.<Touch>):void
		{
			
				var touchA:Touch = touches[0];
				var touchB:Touch = touchA.clone();		//模擬B點		
				var n = touchA.getLocation(this);
				//鏡射A點坐標
				touchB.globalX = n.x * 1
				touchB.globalY = n.y * -1
							
				var currentPosA:Point  = touchA.getLocation(this);
				var previousPosA:Point = touchA.getPreviousLocation(this);
				
				//鏡射A點
				var currentPosB:Point  = currentPosA.clone();
				currentPosB.x *=-1;
				currentPosB.y *=-1;				
				//鏡射A點
				var previousPosB:Point  = previousPosA.clone();
				previousPosB.x *=-1;
				previousPosB.y *=-1;
				
				var currentVector:Point  = currentPosA.subtract(currentPosB);
				var previousVector:Point = previousPosA.subtract(previousPosB);
				
				var currentAngle:Number  = Math.atan2(currentVector.y, currentVector.x);
				var previousAngle:Number = Math.atan2(previousVector.y, previousVector.x);
				
				var deltaAngle:Number = currentAngle - previousAngle;
				
				// rotate
				rotation += deltaAngle;
				
				// scale
				var sizeDiff:Number = currentVector.length / previousVector.length;
				scaleX *= sizeDiff;
				scaleY *= sizeDiff;
				
				//_ctrlButton 保持原比例
				if(_ctrlButton){
					_ctrlButton.scaleX /= sizeDiff
					_ctrlButton.scaleY /= sizeDiff
				}
				
				
			
		}
		
		/** 使用兩隻手指 使用放大縮小旋轉 保留官方功能 **/
		private function resizeAndRotationByTwoFingers(touches:Vector.<Touch>):void
		{
			//保留官方原本兩隻手指操作的功能
			// two fingers touching -> rotate and scale
			var touchA:Touch = touches[0];
			var touchB:Touch = touches[1];
			
			var currentPosA:Point  = touchA.getLocation(parent);
			var previousPosA:Point = touchA.getPreviousLocation(parent);
			var currentPosB:Point  = touchB.getLocation(parent);
			var previousPosB:Point = touchB.getPreviousLocation(parent);
			
			var currentVector:Point  = currentPosA.subtract(currentPosB);
			var previousVector:Point = previousPosA.subtract(previousPosB);
			
			var currentAngle:Number  = Math.atan2(currentVector.y, currentVector.x);
			var previousAngle:Number = Math.atan2(previousVector.y, previousVector.x);
			var deltaAngle:Number = currentAngle - previousAngle;
			
			// update pivot point based on previous center
			var previousLocalA:Point  = touchA.getPreviousLocation(this);
			var previousLocalB:Point  = touchB.getPreviousLocation(this);
			trace(previousLocalA , previousLocalB)
			
			pivotX = (previousLocalA.x + previousLocalB.x) * 0.5;
			pivotY = (previousLocalA.y + previousLocalB.y) * 0.5;
			
			// update location based on the current center
			x = (currentPosA.x + currentPosB.x) * 0.5;
			y = (currentPosA.y + currentPosB.y) * 0.5;
			
			// rotate
			rotation += deltaAngle;
			
			// scale
			var sizeDiff:Number = currentVector.length / previousVector.length;
			scaleX *= sizeDiff;
			scaleY *= sizeDiff;
		}
		
		/**檢查是否touch 控制按鈕**/
		private function isTouchCtrlButton(target:*):Boolean
		{			
			
			var _do		:DisplayObject
			var _doc	:DisplayObjectContainer

			if(_ctrlButton is  DisplayObjectContainer){
				_doc = _ctrlButton as DisplayObjectContainer
				return _doc.contains(target)
			} 
			else if(_ctrlButton is DisplayObject)
			{
				_do = _ctrlButton as DisplayObjectContainer
				return _do == target
			} 
			return false			
		}

		private function onTouch(event:TouchEvent):void
		{
			var touches:Vector.<Touch> = event.getTouches(this, TouchPhase.MOVED);
			var touch:Touch		
			
			touch = event.getTouch(this, TouchPhase.BEGAN);			
			onTouchBegan(touch)
			
			//一隻手指
			if (touches.length == 1)
			{
								
				//檢查是否是Ctrl
				if(isTouchCtrlButton(event.target) )
				{
					
					resizeAndRotationByCtrlButton(touches)
					
					
				}else{
					//一隻手指平移
					var delta:Point = touches[0].getMovement(parent);
					
					x += delta.x;
					y += delta.y;
				}				
				
			}
			else if (touches.length == 2)
			{
				resizeAndRotationByTwoFingers(touches)
			}
			
			
			touch  = event.getTouch(this, TouchPhase.ENDED);
			onTouchEnd(touch)
			
			
			
			//if (touch && touch.tapCount == 2)
			//				parent.addChild(this); // bring self to front
			
			// enable this code to see when you're hovering over the object
			//			 touch = event.getTouch(this, TouchPhase.HOVER);            
			//			 alpha = touch ? 0.8 : 1.0;
			
		}
		private function onTouchBegan(touch:Touch)
		{
			
		}
		
		
		/**當touch結束**/
		private function onTouchEnd(touch:Touch){
//			_touchBringToFront
		}
		
		
		
		public override function dispose():void
		{
			removeEventListener(TouchEvent.TOUCH, onTouch);
			if(_contents){
				_contents.dispose()
			}
			super.dispose();
		}
	}
}
import lambmei.starling.display.HandleSheet;

