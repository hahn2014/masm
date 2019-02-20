TITLE Program 5		(Project5.asm)

; Author: Bryce Hahn
; Course/Project ID: CS 271 Project 5
; Date: 2/20/2019
; Description:
;	This program asks users to enter a number between 10
;		and 200 as the base of how many random numbers
;		between the range of 100 and 999 will be 
;		generated. These generated numbers will be stored
;		in a consecutive array for reference. It will then
;		print all generated numbers (10 per line). Finally,
;		sorting the array from largest to smallest and 
;		store back into the array. Print the medain value of
;		the list. Then finally print the ordered list.
;		EC: 

INCLUDE Irvine32.inc

;-----------------------;
;    Var Declaration    ;
;-----------------------;
.data

project			BYTE	"-	 Number Composition   --   Bryce Hahn  -", 0
intro_1			BYTE	"Welcome to the Number Generator! I will take in an integer (from 10 to 200) to ", 0; Intro 1 
intro_2			BYTE	"represent how many random numbers you want to generate [from 100 and 999]. ", 0	; Intro 2
intro_3			BYTE	"I will verify integer inputs. I will then print the demanded number of ", 0		; Intro 3
intro_4			BYTE	"generated numbers to screen, print the median number, and then sort from ", 0		; Intro 4
intro_5			BYTE	"greatest to smallest, then finally print them in order.", 0						; Intro 5

EC_intro_1		BYTE	"EC: I align the composites in columns", 0											; EC
EC_intro_2		BYTE	"EC: I continue printing pages after the inputted number has been printed", 0		; EC

prompt_1		BYTE	"Please input your name: ", 0														; Prompt for users name firstly
prompt_2		BYTE	"Welcome, ", 0																		; Greet the user
prompt_3		BYTE	"Please enter how many composite numbers I should print: ", 0						; Prompt for a negative number

failed_input_1	BYTE	"The entered number was above the allowed range!", 0								; Warn the user that they can't input such a RIDICULOUSLY high number
failed_input_2	BYTE	"The entered number was bellow the allowed range!", 0								; Warn the user that they can't input such a CRAZY low number

outro_1			BYTE	"---  Outputting your array  ---", 0
outro_2			BYTE	"The array median is: ", 0
finished		BYTE	"Thank you for using my program! Goodbye, ", 0										; Thank the user and say goodbye by name input
space			BYTE	" ", 0

MAXNUM			=		200																					; The maximum range for generated numbers
MINNUM			=		10																					; The minimum range for generated numbers
LOWEST			=		100																					; The lowest number that can be generated
HIGHEST			=		999																					; The largest number that can be generated
userinput		BYTE	21 DUP(0)																			; Byte array for the username input
byteCount		DWORD	?


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
main	PROC
		call	Randomize
		call	intro
		call	inputs
		call	generate
		call	restart
	exit										; close program, return to OS
main	ENDP									; the main PROC is finished, this symbolyses that we are done with the proc

;---------------------------------------------------------------;
;	The intro procedure will be called right off the bat, sort	;
;	of like before using procedures. This will allow to keep	;
;	the main function clean and organized, making debugging		;
;	easier! This function litterally just calls all intro		;
;	scripts.													;
;---------------------------------------------------------------;
intro	PROC
	mov		eax, lightGray + (blue * 16)		; color varaibles consist of: black, white, brown, yellow, blue, green, cyan, red, magenta, gray, lightBlue, lightGreen, lightCyan, lightRed, lightMagenta, and lightGray.
	call	setTextColor						; EXTRA CREDIT: change background and foreground colors
	mov		edx, OFFSET intro_1					; print the program introduction
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro_2					; print the program introduction pt.2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro_3					; print the program introduction pt.3
	call	WriteString	
	call	CrLf
	mov		edx, OFFSET intro_4					; print the program introduction pt.3
	call	WriteString	
	call	CrLf
	mov		edx, OFFSET intro_5					; print the program introduction pt.3
	call	WriteString	
	call	CrLf

	mov		edx, OFFSET EC_intro_1				; display extra credit information for GTA
	call	WriteString
	call	CrLf
	mov		edx, OFFSET EC_intro_2
	call	WriteString
	call	CrLf

	mov		edx, OFFSET prompt_1				; prompt the user for their name
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

	ret
intro	ENDP

;---------------------------------------------------------------;
;	The Lower/Higher Inputs labels will be jumped to when the 	;
;	user inputs a faulty negative integer, because it was above ;
;	the first given integer. This will warn the user to input 	;
;	a proper lower int, then ask for a new int, and check if	;
;	the new int is above num1. If successful, will jump the		;
;	user to the calculations label.								;
;---------------------------------------------------------------;
inputs	PROC		; "get data" equivelent
	StartInp:	
		mov		edx, OFFSET prompt_3			; ask for number of generated numbers
		call	WriteString
		mov		eax, 0
		call	ReadInt
		cmp		eax, MAXNUM
		jg		HigherInput
		cmp		eax, MINNUM
		jl		LowerInput
		ret										; if the input is good, continue to next procedure

	LowerInput:									; if the input is bellow range, ask for another
		mov		edx, OFFSET failed_input_2
		call	WriteString
		call	CrLf
		jmp		StartInp

	HigherInput:								; if the input is above range, ask for another one
		mov		edx, OFFSET failed_input_1
		call	WriteString
		call	CrLf
		jmp		StartInp
	ret
inputs	ENDP

;---------------------------------------------------------------;
;	The generate procedure will be the initial procedure to		;
;	call and generate the initial list of numbers. It will		;
;	recursively call the RandomRange function to generate the	;
;	array of numbers.											;
;---------------------------------------------------------------;
generate	PROC	; "fill array" equivelent

	mov		ecx, eax
	testLoop:
		mov		eax, HIGHEST
		mov		ebx, 100
		sub		eax, ebx
		call	RandomRange
		add		eax, 100
		call	WriteDec
		call	CrLf
		loop	testLoop



	ret
generate	ENDP

;---------------------------------------------------------------;
;	The propSpacing procedure will be called when spacing out	;
;	the numbers to align them properly. This is so we can		;
;	do so without running out of room in the previous procedure	;
;---------------------------------------------------------------;
propSpacing PROC
	
		ret
propSpacing	ENDP

;---------------------------------------------------------------;
;	The sortArray procedure will recursively sort the array of	;
;	generated numbers from greatest to smallest using the		;
;	(SORT METHOD HERE) sorting method.							;
;---------------------------------------------------------------;
sortArray	PROC

	ret
sortArray	ENDP

;---------------------------------------------------------------;
;	The getMedian procedure will calculate the median from the	;
;	array and print it to the screen.							;
;---------------------------------------------------------------;
getMedian	PROC

	ret
getMedian	ENDP

;---------------------------------------------------------------;
;	The printArray will look through the array and print it to	;
;	the screen, this saves space in the calculation procedure.	;
;---------------------------------------------------------------;
printArray	PROC
	;temporary
	mov		edx, OFFSET outro_1
	call	WriteString
	call	CrLf


	ret
printArray	ENDP

;---------------------------------------------------------------;
;	The restart procedure will test to see if the user is		;
;	wanting to run the process one more time, which is 1		;
;	is inputed, will jump the user back into the				;
;	introduction where the user will be asked to input more		;
;	integers. If anything else is answered, the program will	;
;	exit to the OS.												;
;---------------------------------------------------------------;
restart		PROC
	mov		edx, OFFSET finished				; program is done message
	call	CrLf								; add an extra new line for good looks
	call	WriteString
	mov		edx, OFFSET userinput
	call	WriteString
	call	CrLf

	ret
restart		ENDP

END main										; the symbolyses that the main program is finished