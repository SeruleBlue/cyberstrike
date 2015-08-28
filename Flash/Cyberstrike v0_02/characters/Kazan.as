package characters
{
	import moves.Lightning;
	import moves.DefaultPhysical;
	import moves.Cure;

	public class Kazan extends A_Character
	{
		
		public function Kazan(_battle:Battle, _avatarIndex:int)
		{
			super(_battle, _avatarIndex);
			
			cName = "Kazan";
			isPC = true;
			
		//		   B    A	C  L
			 HP = [475,	0,	0, 62.5  ];	
			ATK = [ 12,	0,	0,  4.125];	
			DEF = [ 20,	0,	0,  5.625];	
			MAG = [  9,	0,	0,  3.125];	
			MGR = [ 18,	0,	0,  5.250];	
			ACC = [ 15,	0,	0,  0    ];	
			EVA = [  6,	0,	0,  0    ];	
			SPD = [  2,	0,	0,  0.100];	
			OVR = [100,	0,	0,  6.250];	
			AGG = [  0,	0,	0,  0    ];	
			LUK = [  0,	0,	0,  0    ];	
			ATB = [  8,	0,	0,  0    ];	
				
			MOVES = [new DefaultPhysical(), new DefaultPhysical(), new Cure(), new Lightning()];
		}
	}
}