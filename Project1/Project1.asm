TITLE Program 1		(Project1.asm)

; Author: Bryce Hahn
; Course/Project ID: CS 271 Project 1
; Date: 1/9/2019
; Description: Get the input for two numbers from the user,
; add them up, divide, subtract and multiply, and tell if the second number is larger than the first number.

INCLUDE Irvine32.inc

.data								; var declaration
num1			DWORD	10			; The first number the user will enter
num2			DWORD	7			; The second number the user will enter
sum				DWORD	?			; the sum of the inputs
dif				DWORD	?			; the difference of the inputs
prod			DWORD	?			; the product of the inputs
quotient		DWORD	?			; the quotient of the inputs
remain			DWORD	?			; the remainder of the quotient
keep_going		DWORD	?			; Continue running the program until the user quits
intro_1			BYTE	"Welcome to Add 'Em Up! In this program you will give two integers and I will add them up! (and subtract, divide, multiply)", 0
intro_2			BYTE	"Don't forget that I only want the second number to be lower than the first.", 0
prompt_1		BYTE	"Please provide your first integer: ", 0
prompt_2		BYTE	"Please provide your second integer: ", 0
failed_1		BYTE	"The second integer was bigger than the first.", 0
failed_prompt_1 BYTE	"Please enter a new integer: ", 0
input_too_big	BYTE	"I'm sorry, the second integer was bigger than the first! Try another.", 0
result_1		BYTE	"The sum of ", 0
result_2		BYTE	"The difference of ", 0
result_3		BYTE	"The product of ", 0
result_4		BYTE	"The quotient of ", 0
result_5		BYTE	"The floating-point quotient of ", 0
prompt_3		BYTE	"Do you wish to add some more? (Press 1 to start over) ", 0
finish			BYTE	"Thanks for addin up! Goodbye.", 0
result_string	BYTE	"=", 0
sum_string		BYTE	"+", 0
dif_string		BYTE	"-", 0
prod_string		BYTE	"*", 0
quotient_string BYTE	"/", 0
remain_string	BYTE	" remainder ", 0


.code				; end of data segment
main PROC
	; Introduce user to the program, and what they need to do/instructions
		;intro 1
		mov		edx, OFFSET intro_1
		call	WriteString
		call	CrLf
		; intro 2
		mov		edx, OFFSET intro_2
		call	WriteString
		call	CrLf

Inputs:					; get user inputs for 2 random integers
		mov		edx, OFFSET prompt_1
		call	WriteString
		; get the input
		call	ReadInt
		mov		num1, eax

		mov		edx, OFFSET prompt_2
		call	WriteString
		; get the input
		call	ReadInt
		mov		num2, eax

	; check to see if the second integer is bigger than the first one
		mov		eax, num2
		cmp		eax, num1
		jg		FailedInput
		jle		Calculations

FailedInput:			; let the user know the input was UNACEPTABLE
		mov		edx, OFFSET failed_1
		call	WriteString
		call	CrLf
		mov		edx, OFFSET failed_prompt_1
		call	WriteString
		call	ReadInt
		mov		num2, eax

		;once again check
		mov		eax, num2
		cmp		eax, num1
		jg		FailedInput
		jle		Calculations


Calculations:			; calculate all the different forms
	; calculate the sum of the two numbers
		mov		eax, num1
		add		eax, num2
		mov		sum, eax
		
	; calculate the difference of the two numbers
		mov		eax, num1
		mov		ebx, num2
		sub		eax, ebx
		mov		dif, eax

	; calculate the product of the two numbers
		mov		eax, num1
		mov		ebx, num2
		mul		ebx
		mov		prod, eax

	; calculate the quotient of the two numbers
		mov		edx, 0
		mov		eax, num1
		cdq
		mov		ebx, num2
		cdq
		div		ebx

		mov		quotient, eax
		mov		remain, edx

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

		call	CrLf

RunAgain:					; ask if the user wishes to run aagain.
		mov		edx, OFFSET prompt_3
		call	WriteString
		; get user input for a y or n
		call	ReadInt
		mov		keep_going, eax

		cmp		eax, 1
		je		Inputs		; Jumps to int inputs if wanted, else end program

	; exit the program
		mov		edx, OFFSET finish
		call	CrLf
		call	WriteString
		call	CrLf
	exit			; close program, return to OS
main ENDP


END main