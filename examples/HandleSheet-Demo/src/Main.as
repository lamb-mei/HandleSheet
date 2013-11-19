package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import handlesheet.examples.MainView;
	
	import starling.core.Starling;
	

	//width="550", height="400",
	[SWF( frameRate="30",width="1000", height="700", backgroundColor="#4a4137")]
	public class Main extends Sprite
	{
		public function Main()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			//Init Starling
			Starling.handleLostContext = true;
			var starling:Starling = new Starling(MainView, stage);
			
			starling.simulateMultitouch = true
			starling.antiAliasing = 1;
			starling.start();
		}
	}
}