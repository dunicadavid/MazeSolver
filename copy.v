`timescale 1ns / 1ps

module maze(
input 		clk,
input[5:0] 	starting_col, starting_row, 		// indicii punctului de start
input 		maze_in, 							// ofera informa?ii despre punctul de coordonate [row, col]
output reg[5:0] row, col, 							// selecteaza un rând si o coloana din labirint
output reg	maze_oe,							// output enable (activeaza citirea din labirint la rândul ?i coloana date) - semnal sincron	
output reg	maze_we, 							// write enable (activeaza scrierea în labirint la rândul ?i coloana  date) - semnal sincron
output reg	done=0);		 						// ie?irea din labirint a fost gasita; semnalul ramane activ 

//TODO implementare

parameter width = 4;
reg[5:0] prev_row,prev_col;
integer i=0,ii=0;
//reg been=0;
reg [width-1:0] state, next;
//reg oe_n,we_n;

`define start	0
`define look	1	//ma uit la cruce
`define check	2	//vad daca-i perete sau drum	
`define back	3
`define right 	4
`define down	5
`define left	6
`define up		7
`define move	8	//ma intorc din perete
`define done	9
`define degeaba	10

always @(posedge clk)begin

	if(!done) begin
		state<=next;
//		oe_n<=maze_oe;
//		we_n<=maze_we;
   end

end


always @(*) begin

next=`start;
maze_oe=0;
maze_we=0;


case(state)
	`start:begin
		
		maze_we=1;
		row=starting_row;
		col=starting_col;
//		prev_row=row;			//n-ar trebui sa am nevoie
//		prev_col=col;
		next=`look;
		
	end
	
	`look:begin
	
		case(i)				//numerotez starile i sa-mi indice unde sa ma uit
		
			0:begin
				next=`up;
				i=i+1;
			end
			1:begin
				next=`left;
				i=i+1;
			end
						//nu stiu cat de ok e ordinea...
			2:begin
				next=`down;
				i=i+1;
			end
				
			3:begin
				next=`right;	
				i=i+1;
			end
							
		
		endcase
		
	end
	
	`right:begin
		ii=3;
		prev_row=row;
		prev_col=col;
		maze_oe=1;
		
		col=col+1;
		next=`degeaba;
	end
	
	`down:begin
		ii=2;
		prev_row=row;			//ma uit pe fiecare directie si verific
		prev_col=col;
		maze_oe=1;
		
		row=row+1;
		next=`degeaba;
	end
	
	`left:begin
		ii=1;
		prev_row=row;
		prev_col=col;
		maze_oe=1;
		
		col=col-1;
		next=`degeaba;
	end
	
	`up:begin
		ii=0;
		prev_row=row;
		prev_col=col;
		maze_oe=1;
		
		row=row-1;
		next=`degeaba;
	end
	
	`degeaba:begin
		next=`check;
		if(i>3)
			i=0;
	end
	
	`check:begin			//verific valoarea din casuta
		
		//maze_oe=1;
		
		if(maze_in==1)		//ma intorc daca dau in perete
			next=`back;
		else begin
			next=`move;		//dau de 0 ma mut acolo
			maze_we=1;
		end
			//tre sa fac ceva cu been 
	end
	
	`back:begin
		row=prev_row;
		col=prev_col;
		
		if(i>3)
			i=0;
		
		next=`look; 		//ma intorc si ma uit mai departe la celelalte directii
	end
	
	`move:begin			
		i=0;				//dupa fiecare mutare tre sa ma uit din nou
		//been=1;			//sa mai fac un if care sa-mi zica daca am mai fost pe-acolo, 0 are prioritate fata de 2
				//o sa pun instant 2 cand ma mut, tre sa fac asta si la start si la done
		
		if(prev_row==row-1 && prev_col==col)begin		//vin de sus ma uit la stanga
			next=`left;
			i=ii;
			end
		if(prev_col==col+1 && prev_row==row)begin		//vin din dreapta ma uit in sus
			next=`up;
			i=ii;
			end
		if(prev_col==col-1 && prev_row==row)begin		//vin din stanga ma uit in jos
			next=`down;
			i=ii;
			end
		if(prev_row==row+1 && prev_col==col)begin		//vin de jos la uit la dreapta
			next=`right;
			i=ii;
			end
		if(row==0 || row==63 || col==0 || col==63)
			next=`done;
			
	end
	
	
	`done: begin
				//ar trebui sa verific asta la fiecare move
		done=1;
		next=`start;

	end


endcase
end



endmodule