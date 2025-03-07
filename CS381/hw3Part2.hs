-- A
data Shape = X 
		| TD Shape Shape
		| LR Shape Shape
		deriving Show	
		
type boundingBox = (Int,Int)


--B
bbox :: Shape -> boundingBox
bbox (TD x y) = if fst (bbox x) < fst (bbox y) then  (fst (bbox y), ((snd (bbox x)) + (snd (bbox y)))) 
				else (fst (bbox x), ((snd (bbox x)) + (snd (bbox y)))) 
					
bbox (LR x y) = if snd (bbox x) < snd (bbox y) then  (((fst (bbox y)) + (fst (bbox x))), snd (bbox y)) 
				else (((fst (bbox x)) + (fst (bbox y))),snd (bbox x)) 
bbox (X) = (1,1)


--C				
rect :: Shape -> Maybe boundingBox
rect (TD x y) = if (fst (bbox x) == fst(bbox y)) then Just (fst (bbox x),snd(bbox x) + snd(bbox y))
				else Nothing
rect (LR x y) = if (snd (bbox x) == snd(bbox y)) then Just (fst(bbox x) + fst(bbox y),snd (bbox x))
				else Nothing
rect (X) = Just (1,1)					



