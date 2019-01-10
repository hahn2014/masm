TITLE Program 1		(Project1.asm)

; Author: Bryce Hahn
; Course/Project ID: CS 271 Project 1
; Date: 1/10/2019
; Description:
;		Get the input for two numbers from the user,
;		check to see if the second is bigger than the first
;		add, divide (reg, and floating point), subtract and multiply
;		then print the results, prompt the user if they wish to go again

INCLUDE Irvine32.inc

.data										; var declaration
num1			DWORD	10																					; The first number the user will enter
num2			DWORD	7																					; The second number the user will enter
sum				DWORD	?																					; the sum of the inputs
dif				DWORD	?																					; the difference of the inputs
prod			DWORD	?																					; the product of the inputs
quotient		DWORD	?																					; the quotient of the inputs
remain			DWORD	?																					; the remainder of the quotient
keep_going		DWORD	?																					; Continue running the program until the user quits
intro_1			BYTE	"Welcome to Add 'Em Up! In this program you will give me two integers,", 0			; the folowing 3 are the declaration of the intro descriptions
intro_2			BYTE	"and I will calculate them up! (add, subtract, multiply, and divide)", 0
intro_3			BYTE	"Don't forget that I only want the second number to be lower than the first.", 0
prompt_1		BYTE	"Please provide your first integer: ", 0											; the folowing 2 are the prompts for the integer inputs
prompt_2		BYTE	"Please provide your second integer: ", 0
failed_1		BYTE	"The second integer was bigger than the first.", 0									; warn the user the second int was too big
failed_prompt_1 BYTE	"Please enter a new integer: ", 0													; prompt the user for a different integer
result_1		BYTE	"The sum of ", 0																	; the start of the sum result
result_2		BYTE	"The difference of ", 0																; the start of the difference result
result_3		BYTE	"The product of ", 0																; the start of the product result
result_4		BYTE	"The quotient of ", 0																; the start of the quotient result
result_5		BYTE	"The floating-point quotient of ", 0												; extra credit: the start of the floating point quotient result
prompt_3		BYTE	"Do you wish to add some more? (Press 1 to start over) ", 0							; extra credit: prompt the user to start over
finish			BYTE	"Thanks for addin up! Goodbye.", 0													; goodbye message
result_string	BYTE	"=", 0																				; all the folowing are for a clean calculation output
sum_string		BYTE	"+", 0
dif_string		BYTE	"-", 0
prod_string		BYTE	"*", 0
quotient_string BYTE	"/", 0
remain_string	BYTE	" remainder ", 0


.code										; end of data segment, start the coding with processes
;---------------------------------------------------------------;
;	main PROC will be called once the program is run, this		;
;	is where we can call other processes so that we aren't		;
;	crowded into the main function like this (GROSS), so we		;
;	will implement this into further projects.					;
;---------------------------------------------------------------;
main PROC
		mov		edx, OFFSET intro_1			; print the program introduction (Called only once when the program starts since the user doesn't need to see this after they restart)
		call	WriteString
		call	CrLf						; new line
		mov		edx, OFFSET intro_2			; print the program introduction part 2
		call	WriteString
		call	CrLf						; new line
		mov		edx, OFFSET intro_3			; print the warning to keep the second input below the first
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
		mov		edx, OFFSET prompt_1		; prompt the user for their first int
		call	WriteString
		call	ReadInt						; read in the user input
		mov		num1, eax					; move input val to num1, later projects we need to check if real int

		mov		edx, OFFSET prompt_2		; prompt the user for their second int
		call	WriteString
		call	ReadInt						; read in the user input
		mov		num2, eax					; move the input val to num2

											; check to see if the second integer is bigger than the first one
		mov		eax, num2					; move the num2 to int reg
		cmp		eax, num1					; compare int reg val (num2) to num1
		jg		FailedInput					; if greater than, jump to failedInput label
		jle		Calculations				; if less than or equal to, jump to calculations label

;---------------------------------------------------------------;
;	The FailedInputs label will be jumped to when the user		;
;	inputs a faulty second integer, because it was above the	;
;	first given integer. This will warn the user to input a		;
;	proper lower int, then ask for a new int, and check if		;
;	the new int is above num1. If successful, will jump the		;
;	user to the calculations label.								;
;---------------------------------------------------------------;
FailedInput:
		mov		edx, OFFSET failed_1		; warn the user that the input was too large
		call	WriteString
		call	CrLf
		mov		edx, OFFSET failed_prompt_1	; prompt the user for a newer, lower int
		call	WriteString
		call	ReadInt						; read the user input
		mov		num2, eax					; move int reg val to num2

		;once again check
		mov		eax, num2					; just to be sure, move num2 to int reg
		cmp		eax, num1					; compare int reg val (num2) to num1
		jg		FailedInput					; jump if greater than, restart label
		jle		Calculations				; jump if less than or equal, start calculations label

;---------------------------------------------------------------;
;	The Calculations label will be the bulk of the process,		;
;	where we calculate the different math operations, and		;
;	output them (very smoothly with proper symbols) to the		;
;	output.														;
;---------------------------------------------------------------;
Calculations:
	; calculate the sum of the two numbers
		mov		eax, num1					; move num1 to int reg
		add		eax, num2					; add num2 to int reg val
		mov		sum, eax					; move reg val to sum DWORD
		
	; calculate the difference of the two numbers
		mov		eax, num1					; move num1 to int reg 1
		mov		ebx, num2					; move num2 to int reg 2
		sub		eax, ebx					; subtract reg 2 from reg 1
		mov		dif, eax					; move reg 1 val to dif DWORD

	; calculate the product of the two numbers
		mov		eax, num1					; move num1 to int reg 1
		mov		ebx, num2					; move num2 to int reg 2
		mul		ebx							; multiply reg 1 by reg 2
		mov		prod, eax					; move reg 1 val to prod DWORD

	; calculate the quotient of the two numbers
		mov		edx, 0						; set the value or remainder reg to 0
		mov		eax, num1					; move num1 to int reg 1
		cdq									; convert DoubleWord to QuadWord
		mov		ebx, num2					; move num2 to int reg 2
		cdq									; convert DoubleWord to QuadWord
		div		ebx							; divide reg 1 by reg 2

		mov		quotient, eax				; move reg 1 val to quotient (final form)
		mov		remain, edx					; move reg 2 val to remainder (final form)

	; calculate the floating point quotient of the two numbers





	; print result
		mov		edx, OFFSET result_1
		call	WriteString					; "The sum of "
		mov		eax, num1
		call	WriteDec					; num1
		mov		edx, OFFSET sum_string
		call	WriteString					; "+"
		mov		eax, num2
		call	WriteDec					; num2
		mov		edx, OFFSET result_string
		call	WriteString					; "="
		mov		eax, sum
		call	WriteDec					; res
		call	CrLf

		mov		edx, OFFSET result_2
		call	WriteString					; "The difference of "
		mov		eax, num1
		call	WriteDec					; num1
		mov		edx, OFFSET dif_string
		call	WriteString					; "-"
		mov		eax, num2
		call	WriteDec					; num2
		mov		edx, OFFSET result_string
		call	WriteString					; "="
		mov		eax, dif
		call	WriteDec					; res
		call	CrLf

		mov		edx, OFFSET result_3
		call	WriteString					; "The product of "
		mov		eax, num1
		call	WriteDec					; num1
		mov		edx, OFFSET prod_string
		call	WriteString					; "*"
		mov		eax, num2
		call	WriteDec					; num2
		mov		edx, OFFSET result_string
		call	WriteString					; "="
		mov		eax, prod
		call	WriteDec					; res
		call	CrLf

		mov		edx, OFFSET result_4
		call	WriteString					; "The quotient of "
		mov		eax, num1
		call	WriteDec					; num1
		mov		edx, OFFSET quotient_string
		call	WriteString					; "/"
		mov		eax, num2
		call	WriteDec					; num2
		mov		edx, OFFSET result_string
		call	WriteString					; "="
		mov		eax, quotient
		call	WriteDec					; quotient
		mov		edx, OFFSET remain_string
		call	WriteString					; " remainder "
		mov		eax, remain
		call	WriteDec					; remainder
		call	CrLf


		mov		edx, OFFSET result_5
		call	WriteString					; "The floating-point quotient of "
		mov		eax, num1
		call	WriteDec					; num1
		mov		edx, OFFSET quotient_string
		call	WriteString					; "/"
		mov		eax, num2
		call	WriteDec					; num2
		mov		edx, OFFSET result_string
		call	WriteString					; "="
		; we need the output for the floating point quotient here
		call	CrLf

;---------------------------------------------------------------;
;	The RunAgain label will test to see if the user is			;
;	wanting to run the process one more time, which is 1		;
;	is inputed, will jump the user back into the				;
;	introduction where the user will be asked to input more		;
;	integers. If anything else is answered, the program will	;
;	exit to the OS.												;
;---------------------------------------------------------------;
RunAgain:
		mov		edx, OFFSET prompt_3		; run again prompt
		call	WriteString
		call	ReadInt						; read in the user input for an answer
		mov		keep_going, eax				; move the user input to a readable register

		cmp		eax, 1						; compare if the user input was a '1'
		je		Inputs						; Jumps to int inputs if wanted, else end program

	; exit the program
		mov		edx, OFFSET finish			; program is done message
		call	CrLf						; add an extra new line for good looks
		call	WriteString
		call	CrLf
	exit									; close program, return to OS
main ENDP									; the main PROC is finished, this symbolyses that we are done with the proc


END main									; the symbolyses that the main program is finished