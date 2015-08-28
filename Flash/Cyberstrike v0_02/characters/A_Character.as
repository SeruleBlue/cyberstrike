package characters
{
	import flash.display.MovieClip;
	import flash.events.Event;

	public class A_Character
	{
		public var battle:Battle;
		public var UIdisp:MovieClip;	// UI element (GPD or EID)
		
		protected var B:int = 0, A:int = 1,
					  C:int = 2, L:int = 3,		// ACTIVE, BASE, CURENT, LEVEL
					  W:int = 0, S:int = 3,		// WADS (moves)
					  D:int = 2;
		
		public var avatar:MovieClip;		// MovieClip that represents this character
		public var avatarIndex:int;
		public var cName:String = "Default C";
		public var lvl:int = 1;
		public var isPC:Boolean;
												//				ACTIVE/CURRENT -> NOW/MAX
		public var  HP:Array = [0, 0, 0, 0];	// B A C L
		public var ATK:Array = [0, 0, 0, 0];	// B   C L
		public var DEF:Array = [0, 0, 0, 0];	// B   C L
		public var MAG:Array = [0, 0, 0, 0];	// B   C L
		public var MGR:Array = [0, 0, 0, 0];	// B   C L
		public var ACC:Array = [0, 0, 0, 0];	// B   C L
		public var EVA:Array = [0, 0, 0, 0];	// B   C L
		public var SPD:Array = [0, 0, 0, 0];	// B   C L
		public var OVR:Array = [0, 0, 0, 0];	// B A C L
		public var AGG:Array = [0, 0, 0, 0];	// B   C L
		public var LUK:Array = [0, 0, 0, 0];	// B   C L

		// Full ATB is 10 (10 seconds)
		public var ATB:Array = [0, 0, 0, 0];	// B A C L		INIT/NOW/MAX/CHRG		INIT - first move ATB amount
		public var atbReady:Boolean;
		
		public var ELEMOD:Array = [1, 1, 1, 1];
		protected var FIRE:int = 0, ICE:int = 1, LIG:int = 2, WAT:int = 3;
		
		public var cState:String;	// "IDLE", "CAST", "GO", "FLINCH", "KO"
		public var flinch:int;
		
		public var ocDrain:Number = -1;		// -- TODO set, balance
		public var ocActive:Boolean;
		
		public var MODS:Array = [];		// passive, buffs, debuffs
		public var MOVES:Array = [null, null, null, null];	// list of moves (use WADS), length 4
		public var currMove:int = -1;
		
		public var tgt:A_Character = null;
		public var selfParty:Array = null;
		public var tgtParty:Array = null;
		
		public function A_Character(_battle:Battle, _avatarIndex:int)
		{
			battle = _battle;
			avatarIndex = _avatarIndex;
			// -- set stats in specific Character implementations
		}
		
		public function levelUp(moveInd:int):void
		{
			lvl++;
			// -- TODO MOVES[moveInd].levelUp()
		}

		// update all stats (call when battle starts, adding/removing buff/debuff, etc.)
		// startup = TRUE if battle is starting
		public function updateStats(startup:Boolean = false):void
		{
			HP[C] = HP[B] + (HP[L] * (lvl-1));
			
			if (startup)
			{
				cState = "IDLE";
				HP[A] = HP[C];		// hp = hpMax
				ATB[A] = 0;
				ATB[C] = ATB[B];	// ATB length = battle start ATB
				//OVR[A] = 0;		// keep persistent between battles
				atbReady = false;
				flinch = 0;
				MODS = [];			// -- TODO include passive if applicable
				currMove = -1;
				tgt = null;
				selfParty = null;
				tgtParty = null;
				
				avatar = isPC ? battle.ACT_P[avatarIndex] : battle.ACT_E[avatarIndex];
				trace("Set avatar to " + avatar);
			}
			ATK[C] = ATK[B] + (ATK[L] * (lvl-1));
			DEF[C] = DEF[B] + (DEF[L] * (lvl-1));
			MAG[C] = MAG[B] + (MAG[L] * (lvl-1));
			MGR[C] = MGR[B] + (MGR[L] * (lvl-1));
			ACC[C] = ACC[B] + (ACC[L] * (lvl-1));
			EVA[C] = EVA[B] + (EVA[L] * (lvl-1));
			SPD[C] = SPD[B] + (SPD[L] * (lvl-1));
			OVR[C] = OVR[B] + (OVR[L] * (lvl-1));
			AGG[C] = AGG[B] + (AGG[L] * (lvl-1));
			LUK[C] = LUK[B] + (LUK[L] * (lvl-1));
			
			ATB[L] = .03333 * (SPD[C] / SPD[B]);		// normal ATB charge

			// -- TODO check all mods and further modify stats as appropriate
		}
		
		// updates flinch and animation
		// returns true if flinch is > 0
		public function updateFlinch():Boolean
		{
			if (flinch > 0)
			{
				flinch--;
				// -- TODO revert visual state to pre-flinch
			}
			return flinch > 0;
		}
		
		// aka step function
		// updates ATB bar with current charge rate
		// returns true if ATB bar is full
		public function updateATB():Boolean
		{
			if (ocActive)
			{
				OVR[A] += ocDrain;
				if (OVR[A] < 0)
				{
					OVR[A] = 0;
					ocActive = false;
				}
			}
			
			if (atbReady) return true;
			if (ATB[A] < ATB[C])			// if now < max
			{
				ATB[A] += ATB[L] * (ocActive ? 2 : 1);	// now += charge		TODO make OC a buff
				if (ATB[A] >= ATB[C])		// if now >= max
				{
					ATB[A] = ATB[C];		// now = max
					atbReady = true;
					updateState();
				}
			}
			return atbReady;
		}
		
		public function cast(_move:int, _tgt:A_Character, _selfParty:Array, _tgtParty:Array):void
		{
			currMove = _move;
			tgt = _tgt;
			selfParty = _selfParty;
			tgtParty = _tgtParty;
			updateState();
		}
		
		public function updateState():void
		{
			if (currMove == -1) return;

			switch (cState)
			{
				case "IDLE":		// from atbReady to channeling				
					cState = "CAST";
					ATB[C] = MOVES[currMove].ATB[0];
					battle.CONSOLE.updateText("<< " + cName + " >> starts to cast " + MOVES[currMove].mName + "!");
				break;
				case "CAST":		// from channeling to casting
					cState = "GO";
					battle.CONSOLE.updateText("<< " + cName + " >> casts " + MOVES[currMove].mName + "!");
					MOVES[currMove].cast(this, tgt, selfParty, tgtParty);		// CAST MOVE
					ATB[C] = MOVES[currMove].ATB[1];
				break;
				case "GO":			// from casting to waiting
					cState = "IDLE";
					ATB[C] = MOVES[currMove].ATB[2];
					currMove = -1;
				break;
			}

			atbReady = false;
			ATB[A] = 0;
		}
		
		public function changeHP(amt:Number):void
		{
			HP[A] += amt;
			if (amt < 0)
				battle.CONSOLE.updateText("<< " + cName + " >> just took " + Math.round(-amt) + " damage!");
			else
				battle.CONSOLE.updateText("<< " + cName + " >> just healed for " + Math.round(amt) + " HP!");
			if (HP[A] < 0)				// set min
			{
				HP[A] = 0;
				battle.CONSOLE.updateText("<< " + cName + " >> had its HP reduced to 0!");
				avatar.visible = false;
			}
			else if (HP[A] > HP[C])		// set max
				HP[A] = HP[C];
			if (amt < 0 && UIdisp)
				UIdisp.shake();
			avatar.addChild(new UI_DamagePopup(avatar, amt));
			flinch = 7;
			
			// -- TODO finish overclock
			if (!ocActive && amt < 0)
			{
				OVR[A] += -amt * 2;
				//OVR[A] += -amt * .75;
				if (OVR[A] > 400)
					OVR[A] = 400;
			}
		}
	}
}
