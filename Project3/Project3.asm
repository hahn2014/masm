TITLE Program 3		(Project3.asm)

; Author: Bryce Hahn
; Course/Project ID: CS 271 Project 3
; Date: 1/21/2019
; Description:
;	This program will continuously ask for the user to
;		input negative numbers until a positive number
;		is entered. Once the positive number is entered
;		it will output how many negatives were inputed,
;		the sum of the negative numbers, and the average
;		of the negative numbers (Both whole number and 
;		floating point average .001)

INCLUDE Irvine32.inc

;-----------------------;
;    Var Declaration    ;
;-----------------------;
.data

project			BYTE	"-	 Integer Accumulator   --   Bryce Hahn  -", 0
intro_1			BYTE	"Welcome to the Integer Accumulator! I will take in a negative number until ", 0	; Intro 1 
intro_2			BYTE	"a positive number is inputed. I will then calculate the number of negatives ", 0	; Intro 2
intro_3			BYTE	"inputed, the sum of the inputs, and the average negative number (both whole ", 0	; Intro 3
intro_4			BYTE	"and floating point).", 0															; Intro 4
EC_intro_1		BYTE	"EC: I print the line numbers when taking in user inputs!", 0						; EC
EC_intro_2		BYTE	"EC: I output the floating point average as well!", 0								; EC
EC_intro_3		BYTE	"EC: I change my background color and text color!", 0								; EC
prompt_1		BYTE	"Please input your name: ", 0														; Prompt for users name firstly
prompt_2		BYTE	"Welcome, ", 0																		; Greet the user
prompt_3		BYTE	"Please enter a negative number [-100, -1]: ", 0									; Prompt for a negative number
prompt_4		BYTE	"Do you want to run the program again? (enter 1 for yes)", 0						; Prompt the user to run again
failed_input_1	BYTE	"The entered number was a positive num, calculating now...", 0						; Warn the user that they can't input such a RIDICULOUSLY high number
failed_input_2	BYTE	"The entered number was bellow the provided range!", 0								; Warn the user that they can't input such a CRAZY low number
outro_1			BYTE	"---  Outputting your negative results  ---", 0										; Start the calc section with letting the user know it's printing
outro_2			BYTE	"The negative input count: ", 0
outro_3			BYTE	"The negative sum: ", 0
outro_4			BYTE	"The negative average: ", 0
outro_5			BYTE	"EC: The negative floating point average: ", 0
outro_fail		BYTE	"Look here ya little smartass, I said input negative numbers... You put in 0 -.-", 0; Give a message for putting no negative numbers
finished		BYTE	"Thank you for using my program! Goodbye, ", 0										; Thank the user and say goodbye by name input
line_num_in		BYTE	"[", 0
line_num_fin	BYTE	"] -  ", 0
dot_string		BYTE	".", 0

MAXNUM			=		-1																					; The maximum range of negative numbers
MINNUM			=		-100																				; The minimum range we want to calculate
userinput		BYTE	21 DUP(0)																			; Byte array for the username input

byteCount		DWORD	?																					; used for holding information about user inputting a string
keep_going		DWORD	?																					; User inputed responce to run again
negative_cur	DWORD	0																					; The most recent negative input
negative_sum	DWORD	0																					; The total sum of all the inputed negatives
negative_count	DWORD	0																					; The total count of all negative numbers
negative_avg	DWORD	?																					; Only updated after all the inputs are done, average whole number
fpnt_quotient	REAL4	?																					; extra credit: the floating point quotient
fpnt_thousanth	DWORD	1000																				; extra credit: decimal to the thousanth
fpnt_whole		DWORD	?																					; extra credit: the whole number before the decimal
fpnt_decimal	DWORD	?																					; extra credit: the decimal representation
fpnt_by1000		DWORD	0																					; the result from first division by 1000 as a 4 digit int
fpnt_remainder	DWORD	?																					; the remainder
fpnt_hold		DWORD	?

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
		mov		edx, OFFSET intro_3			; print the program introduction part 3
		call	WriteString
		call	CrLf						; new line
		mov		edx, OFFSET intro_4			; print the program introduction part 4
		call	WriteString
		call	CrLf						; new line
		mov		edx, OFFSET EC_intro_1		; print the extra credit section of the intro
		call	WriteString
		call	CrLf						; new line
		mov		edx, OFFSET EC_intro_2		; print the extra credit section of the intro
		call	WriteString
		call	CrLf						; new line
		mov		edx, OFFSET EC_intro_3		; print the extra credit section of the intro
		call	WriteString
		call	CrLf						; new line

		mov		edx, OFFSET prompt_1		; prompt the user for their name
		call	WriteString
		mov		edx, OFFSET userinput
		mov		ecx, SIZEOF	userinput
		call	ReadString
		mov		byteCount, eax
		mov		edx, OFFSET prompt_2
		call	WriteString
		mov		edx, OFFSET userinput
		call	WriteString
		call	CrLf

;---------------------------------------------------------------;
;	The Inputs label will be the start of the program,			;
;	where we will prompt the user to input their - integers		;
;	into our datastreams until a positive number is inputed		;
;---------------------------------------------------------------;
Inputs:	
		mov		edx, OFFSET line_num_in		; EC: Write the line number
		call	WriteString					; formating
		mov		eax, negative_count			; take the current number of inputed negatives
		inc		eax							; increase by 1 cause thats what were looking for
		call	WriteDec					; write this number between brackets
		mov		edx, OFFSET line_num_fin	; formating
		call	WriteString

		mov		edx, OFFSET prompt_3		; prompt the user for negative numbers
		call	WriteString
		call	ReadInt						; read in the user input
		mov		negative_cur, eax			; move the input val to negative_cur

		mov		eax, negative_cur			; move the num_of_fibs to int reg
		cmp		eax, MAXNUM					; compare int reg val (num user wants to print) to the max val
		jg		HigherInput					; if greater than, jump to higher input failure label
		cmp		eax, MINNUM					; compare int reg val (num user wants to print) to the min val
		jl		LowerInput					; if less than, jump to lower input failure label
		
		jmp		Calculations				; else, its within min and max, so jump to calculations

;---------------------------------------------------------------;
;	The Lower/Higher Inputs labels will be jumped to when the 	;
;	user inputs a faulty negative integer, because it was above ;
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
		jmp		FinalCalculations

;---------------------------------------------------------------;
;	The Calculations label will be the bulk of the process,		;
;	where we calculate the different math operations, and		;
;	output them (very smoothly with proper symbols) to the		;
;	output.														;
;---------------------------------------------------------------;
Calculations:
		inc		negative_count				; increase the negative numbers count

		mov		eax, negative_sum			; move the sum to a register
		add		eax, negative_cur			; add the current to the sum
		mov		negative_sum, eax			; place the updated sum back into the variable

		jmp		Inputs

;---------------------------------------------------------------;
;	The FinalCalculations label will be called when a positive	;
;	integer was inputed, so we will do the last remaining calcs	;
;	to find the average and floating point average.				;
;---------------------------------------------------------------;
FinalCalculations:
		mov		eax, 0						; reset eax value
		mov		eax, negative_sum			; set eax register to sum
		cdq									; convert DoubleWord to QuadWord
		mov		ebx, negative_count			; set ebx register to count
		idiv	ebx							; Doing integer division
		mov		negative_avg, eax			; move the eax register value to average

		fld		negative_sum				; load num1 as a floating point into stack 0
		fdiv	negative_count				; floating point divide num1 by num2
		fimul	fpnt_thousanth				; multiply by 1000 to get 4 digits that will be used when spliting for decimal and whole int
		frndint								; round the number to a whole int so we can move to our var
		fist	fpnt_by1000					; store calculated int into 4 digit int var
		fst		fpnt_quotient				; store calculated floating point from stack


;---------------------------------------------------------------;
;	The Output label will be the final call in the program		;
;	where it will simply print the results of the expirement	;
;---------------------------------------------------------------;
Output:
		mov		edx, OFFSET outro_1			; intro output
		call	WriteString
		call	CrLf
		call	CrLf

		mov		edx, OFFSET outro_2			; negative count
		call	WriteString
		mov		eax, negative_count
		cmp		eax, 0						; check to see if they didn't input a single negative number
		je		NoNegatives					; jump and give them a nice message :)
		call	WriteDec					; they had at least 1 negative, so continue
		call	CrLf

		mov		edx, OFFSET outro_3			; negative sum
		call	WriteString
		mov		eax, negative_sum			;
		call	WriteInt					;
		call	CrLf

		mov		edx, OFFSET outro_4			; negative average
		call	WriteString
		mov		eax, negative_avg
		call	WriteInt
		call	CrLf

		mov		edx, OFFSET outro_5			; EC: Negative average floating point value
		call	WriteString					; "The floating-point quotient"
		mov		edx, 0						; prep the remainder
		mov		eax, fpnt_by1000			; load the 4 digit int to int reg
		mov		ecx, 1000					; prep 1000 into the reg to divide eax, this will give us not only the remainder but the whole number
		xor		edx, edx
		div		ecx							; divide eax by 1000 to get the rounded whole number
		mov		fpnt_whole, eax				; store the new number into the whole var
		mov		fpnt_remainder, ecx			; store the calculated remainder into the var
		mov		eax, fpnt_whole				; set the whole number to the reg
		call	WriteInt					; write the whole number before the decimal
		mov		edx, OFFSET dot_string		; "."
		call	WriteString					; print it out
		mov		eax, fpnt_whole				; move the whole num to int reg
		mul		fpnt_thousanth				; multiply by 1000
		mov		fpnt_hold, eax				; move int reg val to temporary var
		mov		eax, fpnt_by1000			; move the 1000th to int reg
		sub		eax, fpnt_hold				; subtract the first digit (timed by 1000) to get a 4 digit to 3 (being the remainder left over)
		mov		fpnt_decimal, eax			; move this new calulated val from the int reg to the decimal var
		call	WriteDec					; write it out
		call	CrLf

		jmp		RunAgain					; output is done, ask to run again

NoNegatives:
		call	CrLf
		mov		edx, OFFSET outro_fail
		call	WriteString
		call	CrLf
		jmp		RunAgain

;---------------------------------------------------------------;
;	The RunAgain label will test to see if the user is			;
;	wanting to run the process one more time, which is 1		;
;	is inputed, will jump the user back into the				;
;	introduction where the user will be asked to input more		;
;	integers. If anything else is answered, the program will	;
;	exit to the OS.												;
;---------------------------------------------------------------;
RunAgain:
		mov		edx, OFFSET prompt_4		; run again prompt
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