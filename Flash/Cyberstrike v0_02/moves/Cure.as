package moves
{
	import characters.A_Character;

	public class Cure extends A_Move
	{
		public function Cure()
		{
			mName = "Cure";
			nameArr = [mName, "Cura", "Curaga"];

			PHY = [ 0,  0,  0];
			MAG = [14, 18, 22];
			ATB = [2.0, 0.5, 5.0];
			
			tgtSelf = true;
		}
		
		override public function cast(self:A_Character, tgt:A_Character, sParty:Array = null, tParty:Array = null):void
		{
			var heal:Number = calculateHP(self, self, PHY[lvl] > MAG[lvl]);
			trace("<< " + tgt.cName + " >> Was healed " + Math.round(heal) + " from " + self.cName + "'s " + mName + "!");
			tgt.changeHP(heal);
		}
	}
}