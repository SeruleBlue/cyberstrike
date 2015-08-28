package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.ui.Keyboard;
	import characters.*;
	import moves.*;

	public class Battle extends C_Container
	{
		public var eng:C_Engine;
		
		// constants
		private var INTRO:int = 0, LOOP:int = 1, DEFEAT:int = 2, VICTORY:int = 3;
		private var B:int = 0, A:int = 1,
					C:int = 2, L:int = 3,		// ACTIVE, BASE, CURENT, LEVEL
					W:int = 0, S:int = 3,		// WADS (moves)
					D:int = 2;
		private var FIRE:int = 0, ICE:int = 1, LIG:int = 2, WAT:int = 3;
		// constants

		public var battleState:int = INTRO;
		public var introCounter:int = 60;		// temporary variable
		
		public var PARTYp:Array;		// party of player characters
		public var PARTYe:Array;		// party of enemy characters
		
		private var PARTYa:Array;		// all participants
		
		public var leader:int;				// party leader
		public var activeC:int = -1;			// active party member
		
		// -- UI elements
		public var UI_GPD:Array = [null, null, null];
		public var UI_EID:Array = [null, null, null];
		public var UI_ALL:Array;
		
		public var ACT_E:Array = [null, null, null];
		public var ACT_P:Array = [null, null, null];
		public var ACT_A:Array = [null, null, null];
		
		public function Battle()
		{
		}
		
		public function setEngine(_eng:C_Engine):void
		{
			eng = _eng;
		}
		
		// expect array size of 3
		public function startBattle(partyP:Array, partyE:Array, _leader:int):void
		{
			battleState = INTRO;
			introCounter = 60;		// temporary variable
			
			UI_CSD.init(this);
			
			// init party arrays
			PARTYp = partyP;
			PARTYe = partyE;
			leader = _leader;
			activeC = -1;

			// init Actor MCs
			ACT_E[0] = Cinematic.actorE0;
			ACT_E[1] = Cinematic.actorE1;
			ACT_E[2] = Cinematic.actorE2;
			ACT_P[0] = Cinematic.actorP0;
			ACT_P[1] = Cinematic.actorP1;
			ACT_P[2] = Cinematic.actorP2;
			ACT_A = ACT_P.concat(ACT_E);
			
			var i;
			PARTYa = PARTYp.concat(PARTYe);
			for (i = 0; i < 6; i++)
				if (PARTYa[i])
					PARTYa[i].updateStats(true);
			
			UI_GPD[0] = UI_gpdLeft;
			UI_GPD[0].setCharacter(PARTYp[0]);
			
			UI_GPD[1] = UI_gpdCenter;
			UI_GPD[1].setCharacter(PARTYp[1]);

			UI_GPD[2] = UI_gpdRight;
			UI_GPD[2].setCharacter(PARTYp[2]);

			for (i = 0; i < 3; i++)
			{
				ACT_P[i].visible = false;
				if (PARTYa[i])
				{
					ACT_P[i].visible = true;
					ACT_P[i].eid.visible = false;
					ACT_P[i].tf_name.visible = true;
					ACT_P[i].tf_name.text = PARTYa[i].cName;
					try
					{
						ACT_P[i].actor.gotoAndStop(PARTYa[i].cName);
					} catch (err:Error)
					{
						ACT_P[i].actor.gotoAndStop("default");
					}
				}
				ACT_E[i].visible = false;
				if (PARTYa[i+3])
				{
					ACT_E[i].visible = true;
					UI_EID[i] = ACT_E[i].eid;
					UI_EID[i].setCharacter(PARTYa[i+3]);
					UI_EID[i].visible = true;
					UI_EID[i].main.tf_key.text = (i == 0 ? "A" : (i == 1 ? "W" : "D"));
					ACT_E[i].tf_name.visible = false;
				}
			}

			UI_ALL = UI_GPD.concat(UI_EID);
				
			CONSOLE.updateText("<< Nash >> Setting up Databattle.");
		}
		
		override public function step(e:Event):Boolean
		{
			var i:int, j:int, k:int;
			var char:A_Character;
			
			for (i = 0; i < 6; i++)
				if (UI_ALL[i])
					UI_ALL[i].step();
			
			switch (battleState)
			{
				// -----------------------------------------------------------------
				case INTRO:
					if (introCounter % 15 == 0)
						CONSOLE.updateText("<< Nash >> Waiting to start... (" + introCounter + ")");
					if (--introCounter == 0)
					{
						battleState = LOOP;
						// -- TODO update visuals
						CONSOLE.updateText("<< Nash >> Beginning Databattle.");
					}
				break;
				// -----------------------------------------------------------------
				case LOOP:
					var allPCKO:Boolean = true;
					var allNPCKO:Boolean = true;

				
					for (i = 0; i < 6; i++)		// loop through all Characters
					{
						char = PARTYa[i];
						// null check
						if (!char)
							continue;
						// check if active HP is 0
						if (char.HP[A] <= 0)
							continue;
						char.isPC ? allPCKO = false : allNPCKO = false;
						// update flinch
						if (char.updateFlinch() && !char.atbReady)	// if character is still flinching
							continue;
						// update ATB bar
						if (!char.updateATB())				// if character's ATB bar is not full
							continue;
						if (char.isPC)		// if PC
						{
							if (activeC == -1)				// no other ready party members
							{
								activeC = i;
								UI_CSD.setCharacter(char, i);
								ACT_P[i].ui_active.visible = true;
							}
							if (char != PARTYa[activeC])		// quit if this is not the active PC
							//if (char != ACT_P[activeC])		// quit if this is not the active PC
								continue;
							// -- TODO interpret keyboard input, etc.
							
							if (eng.freeKey && eng.fingerUp)
							{
								if (UI_CSD.updateState(eng.keyActive))
									eng.fingerUp = false;
								
								/*var m:int = -1;
								if (eng.keyState[Keyboard.W])		m = 0;
								else if (eng.keyState[Keyboard.A])	m = 1;
								else if (eng.keyState[Keyboard.D])	m = 2;
								else if (eng.keyState[Keyboard.S])	m = 3;
								if (m != -1)
								{
									if (char.MOVES[m].tgtSelf)
										char.cast(m, PARTYp[(Math.random() > .5 ? 0 : 1)], null, null);		// -- TODO select target
									else
										char.cast(m, PARTYe[1], null, null);								// -- TODO select target
									activeC = -1;
									ACT_P[i].spellbox.setSpell(char.MOVES[m].mName);
									ACT_P[i].ui_active.visible = false;
									UI_CSD.setCharacter(null);
									eng.fingerUp = false;
								}*/
							}
							
							//char.cast(0, PARTYe[1], null, null);
							//active = -1;
							//ACT_P[i].ui_active.visible = false;
						}
						else				// if NPC
						{
							// -- TODO choose best AI move
								var m:int = int(Math.random() * 4);
								var t:int = int(Math.random() * 3);
								if (char.MOVES[m].tgtSelf)						// -- TODO fix
								{
									if (PARTYe[t].HP[A] > 0)
										char.cast(m, PARTYe[t], null, null);
									else
										continue;
								}
								else
									char.cast(m, PARTYp[t], null, null);
								ACT_E[i-3].spellbox.setSpell(char.MOVES[0].mName);
						}
					}	// end for loop (Characters)
					
					// -- TODO listen for keystrokes
					// -- TODO update battle cinematics
					
					if (allPCKO)
					{
						CONSOLE.updateText("<< Nash >> All PC's have been devirtualized!");
						battleState = DEFEAT;
						Cinematic.stop();
					}
					else if (allNPCKO)
					{
						CONSOLE.updateText("<< Nash >> All NPC's have been defeated!");
						battleState = VICTORY;
						Cinematic.stop();
					}
				break;	// end case LOOP
				// -----------------------------------------------------------------
			}
				
			return completed;
		}
		
		// -- TODO destructor/disabler
	}
}
