package 
{
	
	import flash.display.MovieClip;
	import characters.A_Character;
	import flash.ui.Keyboard;
	
	// Character Specific Display
	public class UI_CSD extends MovieClip
	{
		private var battle:Battle;
		private var char:A_Character;		// active Character
		private var charIndex:int = -1;		// index of Character in PARTY_A
		private var cMove:int = -1;			// index of chosen move 0-4
		private var cTgt:int = -1;			// index of chosen target 0-3
		
		public var csdState:String = "IDLE";
		//				IDLE
		//				  |
		// 		PARTY---MAIN------ITEM
		//				  |			|
		//			   TARGETM	 TARGETI
		
		public function UI_CSD()
		{
			visible = false;
		}
		
		public function init(_battle:Battle):void
		{
			battle = _battle;
			csdState = "IDLE";
			updateState();
		}
		
		// isInternal only TRUE when called from updateState
		public function setCharacter(_char:A_Character, index:int = -1, isInternal:Boolean = false):void
		{
			char = _char;
			charIndex = index;
			if (char)
				battle.eng.soundMan.playSound("SFX_readyBeep");
			csdState = "MAIN";
			cMove = cTgt = -1;
			if (!isInternal)
				updateState();
		}
		
		// set key to Keyboard.X, etc.
		// returns TRUE if a valid key was pressed
		public function updateState(key:int = -1):Boolean
		{
			if (!char)
			{
				csdState = "IDLE";
				visible = false;
				return false;
			}
			
			var pressed:Boolean;
			
			// key input
			if (key != -1)
			{
				if (key == Keyboard.SPACE)
				{
					if (char.OVR[1] == 400)
						char.ocActive = true;
				}
				else
				switch (csdState)
				{
					case "MAIN":
						if (key == Keyboard.W || key == Keyboard.A || key == Keyboard.D || key == Keyboard.S)
						{
							if (key == Keyboard.W)		cMove = 0;
							else if (key == Keyboard.A) cMove = 1;
							else if (key == Keyboard.D)	cMove = 2;
							else						cMove = 3;
							csdState = "TARGETM";
							pressed = true;
						}
					break;
					case "TARGETM":
						if (key == Keyboard.Z)
						{
							csdState = "MAIN";
							cMove = -1;
							pressed = true;
						}
						else if (key == Keyboard.W || key == Keyboard.A || key == Keyboard.D)
						{
							if (key == Keyboard.W && HexW.visible)		cTgt = 1;
							else if (key == Keyboard.A && HexA.visible) cTgt = 0;
							else if (key == Keyboard.D && HexD.visible)	cTgt = 2;
							if (cTgt != -1)
							{
								csdState = "IDLE";
								pressed = true;
								char.cast(cMove, (char.MOVES[cMove].tgtSelf ? battle.PARTYp[cTgt] : battle.PARTYe[cTgt]), null, null);		// -- TODO finish
							}
						}
					break;
				}
			}
			
			visible = csdState != "IDLE";
			tf_s.visible = HexS.visible = csdState != "TARGETM" && csdState != "TARGETI";

			// visual updates
			switch (csdState)
			{
				case "IDLE":
					battle.activeC = -1;
					battle.ACT_A[charIndex].spellbox.setSpell(char.MOVES[cMove].mName);
					battle.ACT_A[charIndex].ui_active.visible = false;
					setCharacter(null, -1, true);
				break;
				case "MAIN":
					HexW.visible = tf_w.visible = true;
					HexA.visible = tf_a.visible = true;
					HexS.visible = tf_s.visible = true;
					HexD.visible = tf_d.visible = true;
					HexZ.visible = tf_z.visible = false;
					tf_w.text = char.MOVES[0].mName;
					tf_a.text = char.MOVES[1].mName;
					tf_d.text = char.MOVES[2].mName;
					tf_s.text = char.MOVES[3].mName;
				break;
				case "TARGETM":
					HexZ.visible = tf_z.visible = true;
					tf_z.text = "Cancel";
					var party:Array = char.MOVES[cMove].tgtSelf ? battle.PARTYp : battle.PARTYe;
					if (party[0] && party[0].HP[1] > 0)
					{
						tf_a.text = party[0].cName;
						HexA.visible = tf_a.visible = true;
					}
					else
					{
						HexA.visible = tf_a.visible = false;
					}
					if (party[1] && party[1].HP[1] > 0)
					{
						tf_w.text = party[1].cName;
						HexW.visible = tf_w.visible = true;
					}
					else
					{
						HexW.visible = tf_w.visible = false;
					}
					if (party[2] && party[2].HP[1] > 0)
					{
						tf_d.text = party[2].cName;
						HexD.visible = tf_d.visible = true;
					}
					else
					{
						HexD.visible = tf_d.visible = false;
					}
				break;
			}
			return pressed;
		}
	}
}
