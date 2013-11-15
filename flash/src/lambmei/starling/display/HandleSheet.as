package lambmei.starling.display
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.system.System;
	
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.utils.Line;
	
	public class HandleSheet extends Sprite
	{
		
		/** 點擊 將物件移動到前方 **/
		protected var _touchBringToFront:Boolean		
		public function get touchBringToFront():Boolean { return _touchBringToFront;}
		public function set touchBringToFront(value:Boolean):void{ _touchBringToFront = value; }
		
		/** 是否選擇 **/
		protected var _selected:Boolean
		public function get selected():Boolean { return _selected;}		
		public function set selected(value:Boolean):void
		{
			if(value!=_selected){
				_selected = value;
				_selectedGroup.visible = _selected
			}
		}
		
		/** 是否有使用 控制按鈕 Read Only **/	
		protected var _useCtrlButton:Boolean
		public function get useCtrlButton():Boolean
		{
			return _useCtrlButton;
		}
		
//		public function set useCtrlButton(value:Boolean):void
//		{
//			_useCtrlButton = value;
//		}
		
		//Const Vars
		protected static const CTRL_BUTTON_NAME:String = "HandlectrlBtn"
		public static const ALIGN_CENTER:String = "center"
		public static const ALIGN_LT:String = "LT"
		
		
		
		//UI
		protected var _contents:DisplayObject		
		protected var _ctrlButton:DisplayObject
		protected var _selectedGroup:Sprite
		protected var _shape:Shape
		
		
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
			initSelectedGroup()
		}
		
		/** 初始化選擇的群組**/
		protected function initSelectedGroup():void
		{
			
			_selectedGroup = new Sprite()		
			this.addChild(this._selectedGroup);
			
			_shape = new Shape()	
			updateLine()
			_selectedGroup.addChild(_shape)				
			_selectedGroup.visible = _selected
			
		}
		
		/**重新計算**/
		protected function render(scale=1):void
		{
			updateLine(scale)
		}
		
		/**更新框線**/
		protected function updateLine(scale=1):void
		{
			if(_contents && _shape){
				_shape.graphics.lineStyle(10,0xFFffFF);
					_shape.graphics.clear();
					
					System.gc();
					
					var _w:Number = _contents.width
					var _h:Number = _contents.height
					var _halfW:Number = _w/2
					var _halfH:Number= _h/2
					
					_shape.graphics.lineStyle(2 * scale,0xFFFFFF);
					//_shape.graphics.drawRoundRect( -_halfW, -_halfH, _w, _h, 10 );
					_shape.graphics.drawRect(-_halfW, -_halfH, _w, _h);
					
					//trace("scale",scale)
					
			}
		}
		
		

		
		public function setCtrlButtonInitByTexture(upTexture:Texture , downTexture:Texture = null ):void
		{
			_useCtrlButton = true
			
			if ( upTexture !=null)
			{
				_ctrlButton = new Button(upTexture,"",downTexture);
				
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
		
		
		protected function onTouch(event:TouchEvent):void
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
				}
				else
				{
					//一隻手指平移
					var delta:Point = touches[0].getMovement(parent);
					
					x += delta.x;
					y += delta.y;
				}				
			}
			else if (touches.length == 2)
			{
				//兩隻手指
				resizeAndRotationByTwoFingers(touches)
			}
			
			
			touch  = event.getTouch(this, TouchPhase.ENDED);
			onTouchEnd(touch)
			
			
			
		}
		
		/**當touch開始**/
		protected function onTouchBegan(touch:Touch):void
		{
			//touch 開始要做的事情
			if(touch){
				if(_touchBringToFront){				
					parent.addChild(this);				
				}			
				selected = true
			}
			
		}
		
		/**當touch結束**/
		protected function onTouchEnd(touch:Touch):void
		{
			
		}
		
		/**檢查是否touch 控制按鈕**/
		protected function isTouchCtrlButton(target:*):Boolean
		{			
			
			var _do		:DisplayObject
			var _doc	:DisplayObjectContainer
			
			if(_ctrlButton is  DisplayObjectContainer){
				_doc = _ctrlButton as DisplayObjectContainer
				return _doc.contains(target)
			} 
			else if(_ctrlButton is DisplayObject)
			{
				_do = _ctrlButton as DisplayObject
				return _do == target
			} 
			return false			
		}

		
		
		/** 單隻手指使用控制按鈕 放大縮小旋轉 **/
		protected function resizeAndRotationByCtrlButton(touches:Vector.<Touch>):void
		{
			
			var touchA:Touch = touches[0];
			var touchB:Touch = touchA.clone();		//模擬B點		
			var n:Point = touchA.getLocation(this);
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
			
			render(_ctrlButton.scaleX)
			
		}
		
		/** 使用兩隻手指 使用放大縮小旋轉 保留官方功能 **/
		protected function resizeAndRotationByTwoFingers(touches:Vector.<Touch>):void
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
			
			render(_ctrlButton.scaleX)
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

