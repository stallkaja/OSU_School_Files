--CS 381 HW 2
--James Stallkamp
--Part 1
type Prog = [Cmd]
data Cmd = LD Int
                | ADD
                | MULT
                | DUP
                deriving Show
type Stack = [Int]

sem :: Prog -> Maybe Stack -> Maybe Stack

semCmd :: Cmd -> Maybe Stack -> Maybe Stack

semCmd (LD i) (Just st) = Just (i : st)

semCmd (ADD) (Just st) = if length st < 2 then Nothing
                                 else Just (((st !! 0) + (st !! 1)) : drop 2 st)

semCmd (MULT) (Just st) = if length st < 2 then Nothing
                                 else Just (((st !! 0) * (st !! 1)) : drop 2 st)
semCmd (DUP) (Just st) = if length st < 1 then Nothing
                                 else Just ((st !! 0) : st)

sem [] (Just st) = Just st
sem (x:xs) (st) = sem xs (semCmd x st)

--Test
--sem test1 (just([]))
test1 = [LD 3,DUP,ADD,DUP,MULT]
--[36] was returned

--sem test2 (just([]))
--test2 = [LD 3,ADD]
-- exception error returned
--

--Part 2
--a
type ProgM = [CmdMacro]
type Macros = [(String,ProgM)]
data CmdMacro = LDM Int
                        | ADDM
                        | MULTM
                        | DUPM
                        | DEF (String,ProgM)
                        | Call String
                        deriving Show

--b
type State = (Macros, [Int])

type DM = Maybe State -> Maybe State

--c
semCmd2 :: CmdMacro -> DM
semCmd2 (LDM x) ( Just (mac,list)) = Just (mac, x:list)
semCmd2 (ADDM) (Just (mac,list)) = if length list < 2 then Nothing
                                                        else Just (mac,(((list !! 0 + list !! 1)) : drop 2(list)))
semCmd2 (MULTM) (Just (mac,list)) = if length list < 2 then Nothing
                                                        else Just (mac,(((list !! 0 + list !! 1)) : drop 2(list)))
semCmd2 (DUPM) (Just (mac,list)) = if null list then Nothing
                                        else Just (mac,list ++ [list !! 0])
semCmd2 (DEF (str,pro)) (Just (mac,list)) = Just ((str,pro):mac,list)
--semCmd2 (CALL str) (Just(mac,list)) = if isNothing(lookup str mac) then Nothing

sem2 :: ProgM -> DM
sem2 [] (Just finalList) = Just finalList
sem2 (x:xs) (finalList) = sem2 xs (semCmd2 x finalList)


testThis = sem2 [LDM 1] (Just([("so",[LDM 1])],[]))

--Part 3
data CmdD = Pen Mode
			| MoveTo Int Int
			| Seq CmdD CmdD
				
data Mode = Up | Down
			deriving (Show, Eq)
	
type StateD = (Mode,Int,Int)
type Line = (Int, Int, Int, Int);
type Lines = [Line]
	
	
semS :: CmdD -> StateD -> (StateD, Lines)

semS (Pen m) (mo,x,y) = ((m,x,y),[])
	
semS (MoveTo xn yn) (mo,x,y) = if mo == Up then ((Up,xn,yn),[])
									else ((Down,xn,yn),(x,y,xn,yn) : [])
	
semS (Seq cm1 cm2) sta = (fst (semS cm2 (fst(semS cm1 sta))),(snd (semS cm1 sta)) ++ snd(semS cm2 (fst(semS cm1 sta)))) 
								
									
sem' :: CmdD -> Lines
	
sem' x = snd(semS x (Up, 0, 0))