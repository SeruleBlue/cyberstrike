package characters
{
	import moves.BlurusArcI;

	public class BlurusMkI extends A_Character
	{
		
		public function BlurusMkI(_battle:Battle, _avatarIndex:int)
		{
			super(_battle, _avatarIndex);
			
			cName = "Blurus Mk.I";

		//		   B    A	C  L
			 HP = [600,	0,	0,  0    ];	
			ATK = [ 15,	0,	0,  0    ];	
			DEF = [ 17,	0,	0,  0    ];	
			MAG = [  9,	0,	0,  0    ];	
			MGR = [ 10,	0,	0,  0    ];		
			ACC = [ 15,	0,	0,  0    ];	
			EVA = [ 15,	0,	0,  0    ];	
			SPD = [  5,	0,	0,  0    ];	
			OVR = [  0,	0,	0,  0    ];		
			AGG = [  0,	0,	0,  0    ];	
			LUK = [  0,	0,	0,  0    ];	
			ATB = [  9,	0,	0,  0    ];	
						
			MOVES = [new BlurusArcI(), new BlurusArcI(), new BlurusArcI(), new BlurusArcI()];
		}
	}
}