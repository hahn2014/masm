TITLE Program 1		(addtwo.asm)

; Author: Bryce Hahn
; Course/Project ID: CS 271 Project 1
; Date: 1/9/2019
; Description: Get the input for two numbers from the user,
; add them up, and tell if the second number is larger than the first number.

INCLUDE Irvine32.inc

.data								; var declaration
num1			DWORD	2			; The first number the user will enter
num2			DWORD	7			; The second number the user will enter
keep_going		BYTE	1			; Continue running the program until the user quits
intro_1			BYTE	"Welcome to Add 'Em Up! In this program you will give two integers and I will add them up! (and subtract, divide, multiply)", 0
intro_2			BYTE	"Don't forget that I only want the second number to be lower than the first.", 0
prompt_1		BYTE	"Please provide your first integer: ", 0
prompt_2		BYTE	"Please provide your second integer: ", 0
input_too_big	BYTE	"I'm sorry, the second integer was bigger than the first! Try another.", 0
result_1		BYTE	"The sum of your integers is ", 0
prompt_3		BYTE	"Do you wish to add some more? ", 0
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
		mov		edx, OFFSET result_1
		call	WriteString
		mov		eax, num1
		call	WriteDec
		call	CrLf

	; ask if the user wishes to run aagain.
		mov		edx, OFFSET prompt_3
		call	WriteString
		; get user input for a y or n


	; exit the program
		mov		edx, OFFSET finish
		call	CrLf
		call	WriteString
		call	CrLf
	exit			; close program, return to OS
main ENDP


END main