--1
data Mode = Down | Up
data Expr = Var | Num | Expr Expr
data Cmd = 	Pen Mode | Moveto Pos Pos |  Define Pars [Inputs] CmdInstructions| Call Vals
data Pos = A Pars | B Vals
type Pars = String
type Vals = Int
type Inputs = Int
type CmdIntstructions = [Cmd]
numbers = numbers

--2
line:: Cmd
line= Def ("line") [x1,x2,y1,y2] [Pen Up, Moveto (B x1) (B y1), Pen Down, Moveto (B x2) (B y2)] 