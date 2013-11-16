package lambmei.starling.display
{
	import flash.geom.Point;
	import flash.system.System;
	
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	[Event(name="handleSheetSelected"		,type="starling.events.Event")]
	
	/**
	 * Handle the display of sheet in Starling
	 *
	 * @author lamb-mei 羊小咩
	 * 
	 * 為了解決單手控制物件移動放大縮小
	 * 
	 * Copyright (C) 2013, lamb-mei
	 * http://blog.lamb-mei.com
	 */
	public class HandleSheet extends Sprite
	{
		//var
		
		/**外框線寬度**/
		protected var _thickness:Number = 2
		public function get thickness():Number { return _thickness; }
		public function set thickness(value:Number):void{_thickness = value;}
		
		/**外框線顏色**/
		protected var _lineColor:uint = 0xffffff
		public function get lineColor():uint { return _lineColor;}
		public function set lineColor(value:uint):void { _lineColor = value;}
		
		/** 最小SIZE **/		
		protected var _minSize:Number	//預設 NaN
		public function get minSize():Number{ return _minSize;}		
		public function set minSize(value:Number):void{_minSize = value;}
		
		/** 最大可縮放的SIZE **/
		protected var _maxSize:Number	//預設 NaN
		public function get maxSize():Number{return _maxSize;}		
		public function set maxSize(value:Number):void { _maxSize = value; }
		
		/** 點擊 將物件移動到前方 **/
		protected var _touchBringToFront:Boolean
		public function get touchBringToFront():Boolean { return _touchBringToFront;}
		public function set touchBringToFront(value:Boolean):void{ _touchBringToFront = value; }
		
		/** 冒泡傳遞事件 預設為false 打開會使用較多的記憶體 **/
		protected var _dispatchEventBubbles:Boolean
		public function get dispatchEventBubbles():Boolean { return _dispatchEventBubbles;}
		public function set dispatchEventBubbles(value:Boolean):void{ _dispatchEventBubbles = value; }
		
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
		
		
		protected var _ctrlButtonInitType:String
		public function get ctrlButtonInitType():String		{			return _ctrlButtonInitType;		}
		
			
		
		//Const Vars
		protected static const CTRL_BUTTON_NAME:String = "HandlectrlBtn"
		public static const ALIGN_CENTER:String = "center"
		public static const ALIGN_LT:String = "LT"
		
		public static const EVENT_SELECTED:String = "handleSheetSelected"
		
		//UI
		protected var _contents:DisplayObject		
		protected var _ctrlButton:DisplayObject
		protected var _selectedGroup:Sprite
		protected var _shape:Shape
		
		
		public function HandleSheet(contents:DisplayObject,conf:HandleSheetConfig=null)
		{
			addEventListener(TouchEvent.TOUCH, onTouch);
			useHandCursor = true;
			
			_touchBringToFront = true
			
			if (contents)
			{
				var _container:Sprite = new Sprite()
				_container.addChild(contents)
				
				var _w:Number = _container.width
				var _h:Number = _container.height
				var _halfW:Number = _w/2
				var _halfH:Number= _h/2
				//將物件置中
				_container.x = int(_halfW * -1);
				_container.y = int(_halfH * -1);
				addChild(_container);
				_contents = _container
				
				
			}			
			//init SelectGroup
			initSelectedGroup()
			
			if(conf!=null){
				_thickness			 = conf.thickness
				_lineColor			 = conf.lineColor
				_minSize			 = conf.minSize
				_maxSize			 = conf.maxSize
				_touchBringToFront	 = conf.touchBringToFront
				_dispatchEventBubbles	 = conf.dispatchEventBubbles
				
				
				switch(conf.ctrlButtonInitType){
					case HandleSheetConfig.CTRLBUTTON_TYPE_BY_TEXTURE:
						this.setCtrlButtonInitByTexture(conf.upTexture , conf.downTexture)
						break
					case HandleSheetConfig.CTRLBUTTON_TYPE_BY_OBJECT:
						this.setCtrlButtonInitByObject(conf.obj)
						break
					case HandleSheetConfig.CTRLBUTTON_TYPE_BY_FACTORY:
						this.setCtrlButtonInitByFactory(conf.factory)
						break
				}
			}
		}
		
		/** 初始化選擇的群組**/
		protected function initSelectedGroup():void
		{
			
			_selectedGroup = new Sprite()		
			this.addChild(this._selectedGroup);
			
			_shape = new Shape()	
			
			_selectedGroup.addChild(_shape)				
			_selectedGroup.visible = _selected
			
		}
		
		/**重新計算**/
		protected function render(sizeDiff:Number , deltaAngle:Number):void
		{
			rotation += deltaAngle;
			
			var _sizeRate:Number = scaleX * sizeDiff;
			
			var isMinSize:Boolean = _minSize > 0 && _minSize > _sizeRate
			var isMaxSize:Boolean = _maxSize > 0 && _sizeRate > _maxSize
			//在範圍內才縮放
			if(!(isMinSize || isMaxSize)){
				
				if(sizeDiff != Infinity){
					updateSize(sizeDiff)
				}
				
			}
			updateLine(scaleX)
		}
		
		
		protected function updateSize(sizeDiff:Number):void
		{
			scaleX *= sizeDiff;
			scaleY *= sizeDiff;
			
			//_ctrlButton 保持原比例
			if(_ctrlButton){
				_ctrlButton.scaleX /= sizeDiff
				_ctrlButton.scaleY /= sizeDiff				
				//size 變更後需要重新定位
				updateCtrlButtonPosition()
			}
		}
		
		/**計算CtrlButton 放置位置**/
		protected function updateCtrlButtonPosition():void
		{
			if(_contents && _ctrlButton){
				
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
				
			}
		}
		
		/**更新框線**/
		protected function updateLine(sizeRate:Number):void
		{
			if(_contents && _shape){
					_shape.graphics.clear();
					System.gc();
					
					var _w:Number = _contents.width
					var _h:Number = _contents.height
					var _halfW:Number = _w/2
					var _halfH:Number= _h/2
					
					_shape.graphics.lineStyle(_thickness / sizeRate ,_lineColor);
					//_shape.graphics.drawRoundRect( -_halfW, -_halfH, _w, _h, 10 );
					_shape.graphics.drawRect(-_halfW, -_halfH, _w, _h);
					
					//trace("scale",scale)
					
			}
		}
		
		/** 設定控制按鈕 by Texture 至少需要UP 狀態 **/
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
		
		/** 
		 *	設定控制按鈕 by 物件 可以是 image sprite button
		 *	讓 Obj 可以重覆使用 
		 **/
		public function setCtrlButtonInitByFactory( factory:Function ):void			
		{
			var obj:DisplayObject
			if(factory !=null){
				obj = factory()
				if(obj is DisplayObject && obj !=null){
					setCtrlButtonInitByObject( obj )
					return
				}else{
					throw new ArgumentError("factory return not DisplayObject")
				}
			}else{
				throw new ArgumentError("factory not Defined")
			}
		}
		
		/** 
		 * 設定控制按鈕 by 物件 可以是 image sprite button 
		 * 物件因DisplayObject限制不能跟其他 HandleSheet 共用
		 * **/
		public function setCtrlButtonInitByObject( obj:DisplayObject ):void
		{
			_useCtrlButton = true
			
			if (_contents)
			{
				//避免讓外部物件Size != 1 影響計算
				var _container:Sprite = new Sprite()
				_container.addChild(obj)
				_ctrlButton = _container
				//定位
				updateCtrlButtonPosition()
								
				_selectedGroup.addChild(_ctrlButton)
			}else{
				throw new ArgumentError("Obj is Null!")
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
					
				render(1, 0)
				dispatchEventWith(EVENT_SELECTED , _dispatchEventBubbles)
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
			//rotation += deltaAngle;
			
			// scale
			var sizeDiff:Number = currentVector.length / previousVector.length;
//			scaleX *= sizeDiff;
//			scaleY *= sizeDiff;
			
			render(sizeDiff , deltaAngle)
			
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
//			rotation += deltaAngle;
			
			// scale
			var sizeDiff:Number = currentVector.length / previousVector.length;
//			scaleX *= sizeDiff;
//			scaleY *= sizeDiff;
			
			render(sizeDiff , deltaAngle)
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

