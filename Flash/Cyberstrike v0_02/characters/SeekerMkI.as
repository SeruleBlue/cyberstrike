package characters
{
	import moves.Lightning;
	import moves.Cure;
	import moves.DefaultMagical;

	public class SeekerMkI extends A_Character
	{
		
		public function SeekerMkI(_battle:Battle, _avatarIndex:int)
		{
			super(_battle, _avatarIndex);
			
			cName = "Seeker Mk.I";

		//		   B    A	C  L
			 HP = [400,	0,	0,  0    ];	
			ATK = [  8,	0,	0,  0    ];	
			DEF = [ 11,	0,	0,  0    ];	
			MAG = [ 13,	0,	0,  0    ];	
			MGR = [ 17,	0,	0,  0    ];		
			ACC = [ 20,	0,	0,  0    ];	
			EVA = [ 10,	0,	0,  0    ];	
			SPD = [  5,	0,	0,  0    ];	
			OVR = [  0,	0,	0,  0    ];		
			AGG = [  0,	0,	0,  0    ];	
			LUK = [  0,	0,	0,  0    ];	
			ATB = [  6,	0,	0,  0    ];	
						
			MOVES = [new Lightning(), new DefaultMagical(), new Cure(), new DefaultMagical()];
		}
	}
}