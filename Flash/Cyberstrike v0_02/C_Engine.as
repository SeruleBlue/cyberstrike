package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	import characters.*;
	import moves.*;

	public class C_Engine extends MovieClip
	{
		private var container:C_Container;
		private var gameState:int = 0;
		
		public var keyState:Object = new Object();
		public var keyActive:int;		// which key is down (Keyboard.X, etc)
		public var freeKey:Boolean = true;
		public var fingerUp:Boolean = true;
		private var keysDown:int;
		
		public var soundMan:C_SoundManager;
		
		public function C_Engine()
		{
			addEventListener(Event.ENTER_FRAME, step);
			addEventListener(Event.ADDED_TO_STAGE, init);
			
			keyState[Keyboard.Q] = false;
			keyState[Keyboard.W] = false;
			keyState[Keyboard.E] = false;
			keyState[Keyboard.A] = false;
			keyState[Keyboard.S] = false;
			keyState[Keyboard.D] = false;
			keyState[Keyboard.Z] = false;
			keyState[Keyboard.SPACE] = false;
			
			soundMan = new C_SoundManager(this);
			
			container = new Battle();
			container.x = 400;	container.y = 300;
			addChild(container);
			(container as Battle).setEngine(this)

			var cSerule:A_Character = new Serule((container as Battle), 1);
			var cKazan:A_Character = new Kazan((container as Battle), 0);
			var cBailey:A_Character = new Bailey((container as Battle), 2);
			var cEnemyA:A_Character = new BlurusMkI((container as Battle), 0);
			var cEnemyB:A_Character = new SeekerMkI((container as Battle), 1);
			var cEnemyC:A_Character = new BlurusMkI((container as Battle), 2);

			(container as Battle).startBattle([cKazan, cSerule, cBailey], [cEnemyA, cEnemyB, cEnemyC], 0);
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyboardUp);
		}
		
		private function onKeyboardDown(e:KeyboardEvent):void
		{
			if (keyState[e.keyCode] != null && !keyState[e.keyCode])
			{
				keyState[e.keyCode] = true;
				keysDown++;
				freeKey = keysDown <= 1;
				keyActive = e.keyCode;
			}
		}
		
		private function onKeyboardUp(e:KeyboardEvent):void
		{
			if (keyState[e.keyCode] != null && keyState[e.keyCode])
			{
				keyState[e.keyCode] = false;
				keysDown--;
				freeKey = keysDown <= 1;
			}
			fingerUp = true;
			keyActive = -1;
		}
		
		private function step(e:Event):void
		{
			container.step(e);
		}
	}
}