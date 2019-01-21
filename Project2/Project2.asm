TITLE Program 2		(Project2.asm)

; Author: Bryce Hahn
; Course/Project ID: CS 271 Project 2
; Date: 1/11/2019
; Description:
;	This program will print out a Fibonacci sequence
;		request the user to input how many Fibonacci numbers are
;		to be printed. The prompt the user to enter a range these
;		numbers will be calculated between [0-51] for example.	I
;		will then process the inputs and ensure they are proper
;		parameters. Print the numbers out, 5 per line with proper
;		spacing to form left aligned collumns (EC) I also do 
;		something incredible, I.E. changing the background and
;		foreground colors (MORE EC PLZ)

INCLUDE Irvine32.inc

;-----------------------;
;    Var Declaration    ;
;-----------------------;
.data

project			BYTE	"-	 Fibonacci Numbers   --   Bryce Hahn  -", 0
intro_1			BYTE	"Welcome to the Fibonacci Calculator! I will take in a number to signify how ", 0	; Intro 1 
intro_2			BYTE	"many Fibonacci terms you wish me to print.  Extra Credit: My background color ", 0	; Intro 2
intro_3			BYTE	"and text color changes!", 0														; Intro 3
intro_4			BYTE	"Welcome, ", 0
prompt_1		BYTE	"Please input your name: ", 0														; Prompt for users name firstly
prompt_2		BYTE	"Please enter how many numbers you wish be printed (between 1 and 46): ", 0			; Prompt for fib numbers count
prompt_3		BYTE	"Do you want to run the program again? (enter 1 for yes)", 0						; Prompt the user to run again
failed_input_1	BYTE	"The entered number was above the provided range!", 0								; Warn the user that they can't input such a RIDICULOUSLY high number
failed_input_2	BYTE	"The entered number was bellow the provided range!", 0								; Warn the user that they can't input such a CRAZY low number
outro_1			BYTE	"Outputting the Fibonacci Sequence:", 0												; Start the calc section with letting the user know it's printing
finished		BYTE	"Thank you for using my program! Goodbye, ", 0										; Thank the user and say goodbye by name input
spacer			BYTE	" ", 0																				; Pre-allocated variable to properize the spacings of the outputs
large_spacer	BYTE	"         ", 0

MAXFIB			=		46																					; The maximum amount of fib numbers that will be alloud to be calculated
MINFIB			=		1																					; The minimum amount of fib numbers that will be alloud to be calculated (and that can be...)
userinput		BYTE	21 DUP(0)																			; Byte array for the username input

byteCount		DWORD	?																					; used for holding information about user inputting a string
username		DWORD	?																					; User inputed name
num_of_fibs		DWORD	?																					; User inputed number to be calculated
num_on_line		DWORD	?																					; Keep tabs on how many numbers have been printed on a single line
current			DWORD	?																					; Keep tabs on the current calculated fib number in the loop
last			DWORD	?																					; Keep tabs on the last fib number to calc the up next one
tmp				DWORD	?																					; for swapping current and last fib numbers
loop_count		DWORD	?																					; var to keep track of loop iteration count
mult			DWORD	10																					; multiplier to see how many spaces to add
keep_going		DWORD	?																					; User inputed responce to run again

;------------------------;
;    Code Declaration    ;
; This section is where	 ;
; the bulk of the program;
; is going to be writen  ;
;------------------------;
.code
;---------------------------------------------------------------;
;	main PROC will be called once the program is run, this		;
;	is where we can call other processes so that we aren't		;
;	crowded into the main function like this (GROSS), so we		;
;	will implement this into further projects.					;
;---------------------------------------------------------------;
main PROC
		mov		eax, lightGray + (blue * 16); color varaibles consist of: black, white, brown, yellow, blue, green, cyan, red, magenta, gray, lightBlue, lightGreen, lightCyan, lightRed, lightMagenta, and lightGray.
		call	setTextColor				; EXTRA CREDIT: change background and foreground colors
		mov		edx, OFFSET intro_1			; print the program introduction (Called only once when the program starts since the user doesn't need to see this after they restart)
		call	WriteString
		call	CrLf						; new line
		mov		edx, OFFSET intro_2			; print the program introduction part 2
		call	WriteString
		call	CrLf						; new line
		mov		edx, OFFSET intro_3			; print the extra credit section of the intro
		call	WriteString
		call	CrLf						; new line

;---------------------------------------------------------------;
;	The Inputs label will be the start of the program,			;
;	where we will prompt the user to input their 2 integers		;
;	into our num1 and num2 DWORDS. This will also be jumped		;
;	back into when the user states they wish to restart the		;
;	program.													;
;---------------------------------------------------------------;
Inputs:	
		mov		edx, OFFSET prompt_1		; prompt the user for their name
		call	WriteString
		mov		edx, OFFSET userinput
		mov		ecx, SIZEOF	userinput
		call	ReadString
		mov		byteCount, eax

		mov		edx, OFFSET intro_4
		call	WriteString
		mov		edx, OFFSET userinput
		call	WriteString

		mov		edx, OFFSET prompt_2		; prompt the user for how many fib numbers they wish printed
		call	CrLf
		call	WriteString
		call	ReadInt						; read in the user input
		mov		num_of_fibs, eax			; move the input val to num_of_fibs

		mov		eax, num_of_fibs			; move the num_of_fibs to int reg
		cmp		eax, MAXFIB					; compare int reg val (num user wants to print) to the max val
		jg		HigherInput					; if greater than, jump to higher input failure label
		cmp		eax, MINFIB					; compare int reg val (num user wants to print) to the min val
		jl		LowerInput					; if less than, jump to lower input failure label
		je		Case1						; if the user is equal to the min, aka 1, go to case 1
		cmp		eax, 2						; if the user entered 2
		je		Case2						; jump to special case 2
		cmp		eax, 3						; if the user entered 3
		je		Case3						; jump to special case 3
		jmp		Calculations				; else, its within min and max, so jump to calculations

;---------------------------------------------------------------;
;	The Lower/Higher Inputs labels will be jumped to when the 	;
;	user inputs a faulty second integer, because it was above 	;
;	the first given integer. This will warn the user to input 	;
;	a proper lower int, then ask for a new int, and check if	;
;	the new int is above num1. If successful, will jump the		;
;	user to the calculations label.								;
;---------------------------------------------------------------;
LowerInput:
		mov		edx, OFFSET failed_input_2
		call	WriteString
		call	CrLf
		jmp		Inputs

HigherInput:
		mov		edx, OFFSET failed_input_1
		call	WriteString
		call	CrLf
		jmp		Inputs

;---------------------------------------------------------------;
;	The Calculations label will be the bulk of the process,		;
;	where we calculate the different math operations, and		;
;	output them (very smoothly with proper symbols) to the		;
;	output.														;
;---------------------------------------------------------------;
Calculations:
		mov		edx, OFFSET outro_1
		call	WriteString					; output to the user we are printing the numbers now..
		call	CrLf
		mov		eax, 1
		call	WriteDec
		mov		edx, OFFSET large_spacer
		call	WriteString


		mov		ecx, num_of_fibs			; set ecx to num_of_fibs for looping
		mov		current, 1					; always start off the sequence at 1
		mov		num_on_line, 1				; always start off the sequence at 1 on the line
		mov		last, 0						; start the last fib number off with 0 (0 + 1) = 1
		mov		loop_count, 1				; always start off the sequence at 1 (cause 1 is already printed)
		fib_loop:
			mov		eax, last
			add		eax, current
			call	WriteDec

			mov		tmp, eax				; next itteration eax value will be the current
			mov		eax, current			; next itteration this will be last
			mov		last, eax				; FINAL: place the current itterations fib value into the next itterations last fib value
			mov		eax, tmp				; put tmp back in eax
			mov		current, eax			; FINAL: place the current itterations print value into the next itterations current fib value
			
			; EXTRA CREDIT: space out the 5 numbers into left aligned columns
			mov		ecx, 11
			mov		eax, 1
			space:
				;mul		mult
				cmp		ebx, eax
				;jge		skip
				mov		edx, OFFSET spacer	; move the spacing into string register
				call	WriteString			; add spacing
				;skip:
					loop	space			; couldn't get this to work due to the jump byte limitation :(

			add		num_on_line, 1			; add 1 to how many numbers of the sequence are printed on a line
			cmp		num_on_line, 5			; compare 5 to num_on_line
			je		reset_line				; if there are 5 on a line, reset to a new line
			jl		finishingUP				; if not 5, finish up the loop

			reset_line:
				mov		num_on_line, 0
				call	CrLf
				jmp		finishingUP

			finishingUP:
				add		loop_count, 1		; set our temp holder val to +1 so we can get one iteration closer to the fib num
				mov		eax, loop_count
				cmp		eax, num_of_fibs	; if eax >= num_of_fibs
				jge		RunAgain			; jump out of calculations and ask to run again?
				jl		endOfLoop

			endOfLoop:
				loop	fib_loop
			

;---------------------------------------------------------------;
;	The Case1 label will only be called if the user enteres		;
;	1 as their number of fibonacci sequencings to print.		;
;---------------------------------------------------------------;
Case1:
	mov		current, 1					; start the sequence off as 1
	mov		eax, current				; move the current to a print register
	call	WriteDec						; print out
	call	CrLf							; sequence is done so new line
	jmp		RunAgain						; jump to the end of the program, ask if they wanna start over

;---------------------------------------------------------------;
;	The Case2 label will only be called if the user enteres		;
;	2 as their number of fibonacci sequencings to print.		;
;---------------------------------------------------------------;
Case2:
	mov		current, 1					; start the sequence off as 1
	mov		eax, current				; move the current to a print register
	call	WriteDec						; print
	mov		edx, OFFSET large_spacer		; set the spacing dword to a string register
	call	WriteString						; print out to organize outputs
	mov		eax, current				; back to integers, next up is 1 (cause 0 + 1 = 1)
	call	WriteDec						; print
	call	CrLf							; sequence is done so new line
	jmp		RunAgain						; jump to the end of the program, ask if they wanna start over

;---------------------------------------------------------------;
;	The Case3 label will only be called if the user enteres		;
;	3 as their number of fibonacci sequencings to print.		;
;---------------------------------------------------------------;
Case3:
	mov		current, 1					; start the sequence off as 1
	mov		eax, current				; move the current to a print register
	call	WriteDec						; print
	mov		edx, OFFSET large_spacer		; set the spacing dword to a string register
	call	WriteString						; print out to organize outputs
	mov		eax, current				; back to integers, next up is 1 (cause 0 + 1 = 1)
	call	WriteDec						; print
	mov		edx, OFFSET large_spacer		; set the spacing dword to a string register
	call	WriteString						; print spacing
	mov		current, 2					; back to integers, next up is 2 (cause 1 + 1 = 2)
	mov		eax, current				; move ints to integer register
	call	WriteDec						; print
	call	CrLf							; sequence is done, new line
	jmp		RunAgain						; jump to end of program, ask if they wanna start over

;---------------------------------------------------------------;
;	The RunAgain label will test to see if the user is			;
;	wanting to run the process one more time, which is 1		;
;	is inputed, will jump the user back into the				;
;	introduction where the user will be asked to input more		;
;	integers. If anything else is answered, the program will	;
;	exit to the OS.												;
;---------------------------------------------------------------;
RunAgain:
		call	CrLf
		mov		edx, OFFSET prompt_3		; run again prompt
		call	WriteString
		call	ReadInt						; read in the user input for an answer
		mov		keep_going, eax				; move the user input to a readable register

		cmp		eax, 1						; compare if the user input was a '1'
		je		Inputs						; Jumps to int inputs if wanted, else end program

	; exit the program
		mov		edx, OFFSET finished		; program is done message
		call	CrLf						; add an extra new line for good looks
		call	WriteString
		mov		edx, OFFSET userinput
		call	WriteString
		call	CrLf
	exit									; close program, return to OS
main ENDP									; the main PROC is finished, this symbolyses that we are done with the proc


END main									; the symbolyses that the main program is finished