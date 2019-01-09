TITLE Program 1		(Project1.asm)

; Author: Bryce Hahn
; Course/Project ID: CS 271 Project 1
; Date: 1/9/2019
; Description: Get the input for two numbers from the user,
; add them up, divide, subtract and multiply, and tell if the second number is larger than the first number.

INCLUDE Irvine32.inc

.data								; var declaration
num1			DWORD	2			; The first number the user will enter
num2			DWORD	7			; The second number the user will enter
sum				DWORD	?			; the sum of the inputs
dif				DWORD	?			; the difference of the inputs
prod			DWORD	?			; the product of the inputs
quotient		DWORD	?			; the quotient of the inputs
remain			DWORD	?			; the remainder of the quotient
keep_going		BYTE	1			; Continue running the program until the user quits
intro_1			BYTE	"Welcome to Add 'Em Up! In this program you will give two integers and I will add them up! (and subtract, divide, multiply)", 0
intro_2			BYTE	"Don't forget that I only want the second number to be lower than the first.", 0
prompt_1		BYTE	"Please provide your first integer: ", 0
prompt_2		BYTE	"Please provide your second integer: ", 0
input_too_big	BYTE	"I'm sorry, the second integer was bigger than the first! Try another.", 0
result_1		BYTE	"The sum of your integers is ", 0
result_2		BYTE	"The difference of your integers is ", 0
result_3		BYTE	"The product of your integers is ", 0
result_4		BYTE	"The quotient of your integers is ", 0
result_5		BYTE	" and the remainder is ", 0
prompt_3		BYTE	"Do you wish to add some more? (y/n) ", 0
finish			BYTE	"Thanks for addin up! Goodbye.", 0



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
	; get user inputs for 2 random integers
		mov		edx, OFFSET prompt_1
		call	WriteString
		;get the int
		mov		eax, OFFSET num1
		mov		ecx, 4
		call	ReadInt

	; check to see if the second integer is bigger than the first one


	; calculate the sum of the two numbers
		
		
		
		
		
		
	; print result
		mov		edx, OFFSET result_1	; sum
		call	WriteString
		mov		eax, sum
		call	WriteDec
		call	CrLf

		mov		edx, OFFSET result_2	; difference
		call	WriteString
		mov		eax, dif
		call	WriteDec
		call	CrLf

		mov		edx, OFFSET result_3	; product
		call	WriteString
		mov		eax, prod
		call	WriteDec
		call	CrLf

		mov		edx, OFFSET result_4	; quotient
		call	WriteString
		mov		eax, quotient
		call	WriteDec
		mov		edx, OFFSET result_5	; remainder
		call	WriteString
		mov		eax, remain
		call	WriteDec
		call CrLf

	; ask if the user wishes to run aagain.
		mov		edx, OFFSET prompt_3
		call	WriteString
		; get user input for a y or n
		mov		eax, OFFSET keep_going
		mov		ecx, 1
		call	ReadDec

	; exit the program
		mov		edx, OFFSET finish
		call	CrLf
		call	WriteString
		call	CrLf
	exit			; close program, return to OS
main ENDP


END main