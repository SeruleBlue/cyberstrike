package characters
{
	import moves.DefaultMagical;
	import moves.Cure;

	public class Bailey extends A_Character
	{
		
		public function Bailey(_battle:Battle, _avatarIndex:int)
		{
			super(_battle, _avatarIndex);
			
			cName = "Bailey";
			isPC = true;
			
		//		   B    A	C  L
			 HP = [280,	0,	0, 55    ];				// -- TODO fix made-up numbers
			ATK = [  3,	0,	0,  1.875];	
			DEF = [  9,	0,	0,  3.750];	
			MAG = [ 18,	0,	0,  5.750];	
			MGR = [ 20,	0,	0,  5.375];	
			ACC = [ 17,	0,	0,  0    ];	
			EVA = [ 17,	0,	0,  0    ];	
			SPD = [ 50,	0,	0,  5.000];	
			OVR = [100,	0,	0,  6.250];	
			AGG = [  0,	0,	0,  0    ];	
			LUK = [  0,	0,	0,  0    ];	
			ATB = [  3,	0,	0,  0    ];	
			
			lvl = 3;	// -- temp
			
			ELEMOD[ICE] = 1.25;
			ELEMOD[LIG] = 1.25;
			
			MOVES = [new Cure(), new DefaultMagical(), new Cure(), new Cure()];
		}
	}
}