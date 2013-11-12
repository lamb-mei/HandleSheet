package lambmei.starling.display
{
	import flash.geom.Point;
	
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class HandleSheet extends Sprite
	{
		private var _selected:Boolean
		private var _contents:DisplayObject
		
		private var _ctrlButton:Button
		private var _selectedGroup:Sprite
		
		
		public static const CtrlButtonAlign_CENTER:String = "center"	
		public static const CtrlButtonAlign_LT:String = "LT"
		
		private var _useCtrlButton:Boolean
		
		
		public function HandleSheet(contents:DisplayObject=null)
		{
			addEventListener(TouchEvent.TOUCH, onTouch);
			useHandCursor = true;
			
			
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
		
		public function get useCtrlButton():Boolean
		{
			return _useCtrlButton;
		}
		
		public function set useCtrlButton(value:Boolean):void
		{
			_useCtrlButton = value;
		}
		
		public function setCtrlButtonInitTexture(upTexture:Texture , downTexture:Texture):void
		{
			useCtrlButton = true
			
			if (_contents && upTexture!=null)
			{
				_ctrlButton = new Button(upTexture,"ctrlBtn",downTexture);
				
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
		private function onTouch(event:TouchEvent):void
		{
			var touches:Vector.<Touch> = event.getTouches(this, TouchPhase.MOVED);
			
			
			//一隻手指
			if (touches.length == 1)
			{
				
				//使用控制按鈕 點到ＢＵＴＴＯＮ
				if(event.target == _ctrlButton){
					
					
					var touchA:Touch = touches[0];
					
					//var topStage:Point = this.localToGlobal(new Point(0, 0));
					var touchB:Touch = touchA.clone();
					
					//變成固定點 但應該不能用固
					/*
					var b:Button= new Button()
					b.touchable=false
					b.width = b.height = 10
					this.addChild(b)	
					
					b.x = touchA.globalX
					b.y = touchA.globalY
					*/	
					var n = touchA.getLocation(this);
					
					touchB.globalX = n.x * 1
					touchB.globalY = n.y * -1
					
					//touchB.globalX = 
					//					trace(this.x,this.y)
					//					trace(touchA)
					//											trace(touchA.globalX , touchA.globalY)
					//					trace("-----------")					
					
					//var touchB:Touch = new Touch(1);
					
					var currentPosA:Point  = touchA.getLocation(this);
					var previousPosA:Point = touchA.getPreviousLocation(this);
					var currentPosB:Point  = currentPosA.clone();
					currentPosB.x *=-1;
					currentPosB.y *=-1;
					
					//var previousPosB:Point = touchB.getPreviousLocation(parent);
					var previousPosB:Point  = previousPosA.clone();
					previousPosB.x *=-1;
					previousPosB.y *=-1;
					
					var currentVector:Point  = currentPosA.subtract(currentPosB);
					var previousVector:Point = previousPosA.subtract(previousPosB);
					
					var currentAngle:Number  = Math.atan2(currentVector.y, currentVector.x);
					var previousAngle:Number = Math.atan2(previousVector.y, previousVector.x);
					
					var deltaAngle:Number = currentAngle - previousAngle;
					
					// update pivot point based on previous center
					var previousLocalA:Point  = touchA.getPreviousLocation(this);
					var previousLocalB:Point  = touchB.getPreviousLocation(this);
					//pivotX = (previousLocalA.x + previousLocalB.x) * 0.5;
					//pivotY = (previousLocalA.y + previousLocalB.y) * 0.5;
					
					
					// update location based on the current center
					//x = (currentPosA.x + currentPosB.x) * 0.5;
					//y = (currentPosA.y + currentPosB.y) * 0.5;
					
					// rotate
					rotation += deltaAngle;
					
					// scale
					var sizeDiff:Number = currentVector.length / previousVector.length;
					scaleX *= sizeDiff;
					scaleY *= sizeDiff;
					_ctrlButton.scaleX /= sizeDiff
					_ctrlButton.scaleY /= sizeDiff
					//					
					
					
				}else{
					//一隻手指平移
					var delta:Point = touches[0].getMovement(parent);
					
					x += delta.x;
					y += delta.y;
				}
				
				
			}
			else if (touches.length == 2)
			{
				
				// two fingers touching -> rotate and scale
				var touchA:Touch = touches[0];
				var touchB:Touch = touches[1];
				trace("touchA" , touchA)
				trace("touchB" , touchB)
				
				var currentPosA:Point  = touchA.getLocation(parent);
				var previousPosA:Point = touchA.getPreviousLocation(parent);
				var currentPosB:Point  = touchB.getLocation(parent);
				var previousPosB:Point = touchB.getPreviousLocation(parent);
				trace(currentPosA , currentPosB)
				
				
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
				trace("----")
			}
			
			var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
			
			//if (touch && touch.tapCount == 2)
			//				parent.addChild(this); // bring self to front
			
			// enable this code to see when you're hovering over the object
			//			 touch = event.getTouch(this, TouchPhase.HOVER);            
			//			 alpha = touch ? 0.8 : 1.0;
			
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

