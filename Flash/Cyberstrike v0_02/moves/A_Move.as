package moves
{
	import characters.A_Character;

	public class A_Move
	{
		protected var B:int = 0, A:int = 1,
					  C:int = 2, L:int = 3,		// ACTIVE, BASE, CURENT, LEVEL
					  W:int = 0, S:int = 3,		// WADS (moves)
					  D:int = 2;
		
		public var mName:String = "Default M";				// Level 1 name
		public var nameArr:Array = [mName, mName, mName];	// i.e. Thunder, Thundera, Thundaga
		
		public var lvl:int;						// 1-3 inclusive
		
		public var PHY:Array = [0, 0, 0];		// base Physical (index with lvl)
		public var MAG:Array = [0, 0, 0];		// base Magical (index with lvl)
		
		public var ATB:Array = [1, 0.5, 3.5];	// ATB ready (channel), go (cast), cooldown (in seconds) (max 10)
		public var tgtSelf:Boolean;
		
		public var eleAttr:Array = [false, false, false, false];
		protected var FIRE:int = 0, ICE:int = 1, LIG:int = 2, WAT:int = 3;
		
		public var animation:String = "Default";	// which frame label of animation to use

		public function A_Move()
		{
			// -- set stats in specific implementations
		}
		
		// default function removes HP according to standard HP calculations
		public function cast(self:A_Character, tgt:A_Character, sParty:Array = null, tParty:Array = null):void
		{
			// -- override this function
			if (Math.random() > calculateHit(self, tgt))
			{
				trace("<< " + tgt.cName + " >> dodged " + self.cName + "'s " + mName + "!");
				return;
			}
			var dmg:Number = calculateHP(self, tgt, PHY[lvl] > MAG[lvl]);
			trace("<< " + tgt.cName + " >> Took " + Math.round(dmg) + " damage from " + self.cName + "'s " + mName + "!");
			tgt.changeHP(-dmg);
		}

		// returns amount of HP self modifies on tgt
		protected function calculateHP(self:A_Character, tgt:A_Character, isPhys:Boolean):Number
		{
			// BASE * (4.0 + LVLs) * (ATKs/DEFt)
			// BASE * (4.0 + LVLs) * (MAGs/MGRt)
			var raw:Number = (isPhys ? PHY[lvl] : MAG[lvl]) * (4.0 + self.lvl) * ((isPhys ? self.ATK[C] : self.MAG[C]) / (isPhys ? tgt.DEF[C] : tgt.MGR[C]));
			for (var i:int = 0; i < 4; i++)
				if (eleAttr[i])
					raw *= tgt.ELEMOD[i];
			return raw;
		}
		
		// returns chance for self to hit tgt
		protected function calculateHit(self:A_Character, tgt:A_Character):Number
		{
			// ACCs / EVAt
			return self.ACC[C] / tgt.EVA[C];
		}
	}
}