# MazeSolver
This is a Verilog program which is designed to solve a maze probleme using Wall Follower Algorithm. The input is a matrix full of 1s(wall) and 0s(walk space) and the position of begining. The porpose of the algorithm is to exit the puzzle.

[RO]

maze.v:
	Explicarea algoritmului: Am considerat urmatoarele operatii : 0-sus, 1-stanga, 2-jos, 3-dreapta. Am facut urmatoarea observatie referitoare la pozitia
din care vine algoritmul: Intotodeauna trebuie sa se uite in dreapta lui, apoi in fata lui, apoi in stanga lui; daca nu gaseste in acestea 3 trb sa se intoarca.
Deci in functie de directia pe care o are prima cautare va fi la dreapta acestuia, apoi se incrementeaza cu 1 pana cand se gaseste continuarea. (daca vin de sus
ma uit la stanga, daca vin de jos ma uit la dreapta, daca vin de la dreapta ma uit in jos, daca vin de la stanga ma uit in sus). 
	
Starile automatului:
'define start				0		//stare de start in care imi setez valorile de row si col cu cele initiale si fac scrierea maze_we
'define try_around			1		//stare de incerca a casutelor alaturate
'define up_move				2		//stare in care se incearca mutarea in sus
'define left_move			3		//stare in care se incearca mutarea la stanga
'define down_move			4		//stare in care se incearca mutarea in jos
'define right_move 			5		//stare in care se incearca mutarea in dreapta
'define check_empty			6		//verific daca mutarea este disponibila (maze_in == 0) altfel se reintoarce la starea try_around
'define move_and_check_end		7		//stare in care se modifica noua directie, se trece la urmatoarea stare de cautare in acea directie si de verificare daca s-a ajuns la finalul labiritului
'define finish				8		//stare de finish maze in care trebuie schimabta valoarea lui done in 1 pentru a opri loopul format de blocul always cu posedge clk (nu mai intra in if)

'start:begin									
		maze_we=1;			//modific casuta prin care deja am trecut
		row=starting_row;		//setez startul in row si col
		col=starting_col;
		next_state = 'try_around;	//trec la starea urmatoare		
end

'try_around:begin								
		case(dir)					//in functie de conventia explicata mai sus aleg in ce parte sa se uite
			0:begin
				next_state = 'up_move;
			end
			1:begin
				next_state = 'left_move;
			end
			2:begin
				next_state = 'down_move;
			end
			3:begin
				next_state = 'right_move;	
			end
		endcase
		dir = (dir + 1) % 4;				//incrementez directia si ma asigur ca daca trece de 3 se face din nou 0
end

'up_move:begin									
		maze_oe=1;					//setez noile pozitii si le retin pe cele vechi
		dir_check=0;
		row_copy = row;
		col_copy = col;
		row=row-1;
		next_state = 'check_empty;			//trec in starea de testare
		
end

//ASEMENEA PENTRU DOWN LEFT RIGHT

'check_empty:begin							
		if(maze_in == 0) begin				//daca maze_in == 0 e casuta libera(labirint) astfel pot trece in starea de test si move 
			next_state = 'move_and_check_end;
			maze_we = 1;
		end else begin					//daca maze_in == 1 inseamna ca este perete deci ma reintorc in try_around pentru a incerca urmatoarea directie valabila
			row = row_copy;
			col = col_copy;
			next_state = 'try_around;
		end
end

'move_and_check_end:begin				 			
		dir = dir_check;				//noua directie trebuie modificata cu cea din dir_check (dir actuala este data de directia in care ajung in casuta)
		if(col_copy == col && row_copy == row-1)begin	//se continua cu o noua mutare prima verificare fiind la dreapta directiei	
			next_state = 'left_move;
			end
		if(col_copy == col+1 && row_copy == row)begin		
			next_state = 'up_move;
			end
		if(col_copy == col-1 && row_copy == row)begin		
			next_state = 'down_move;
			end
		if(col_copy == col && row_copy == row+1 )begin		
			next_state = 'right_move;
			end
		if(row==0 || row==63 || col==0 || col==63)	//se verifica daca s-a ajuns la margine
			next_state = 'finish;
			
end

'finish: done = 1;						//done = 1 se termina automatul(deci s-a ajuns la margine)




Automat graf:


			start --------------> try_around -----------> 2/3/4/5 -------------> check_empty ---------------> move_and_check_end ---------------> finish
						 ^			 ^			 |				 |		
						 |      		 |			 |				 |	
						 |_______________________|_______________________|				 |					
						        		 |_______________________________________________________|


