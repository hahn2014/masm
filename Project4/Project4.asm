TITLE Program 4		(Project4.asm)

; Author: Bryce Hahn
; Course/Project ID: CS 271 Project 4
; Date: 2/09/2019
; Description:
;	This program asks users to enter the number of composite
;		numbers they would like to see between 1 and 400. If
;		they write a number that's out of bounds the program
;		loops until they write a number in range. The program
;		then displays a parting message.
;		EC: 

INCLUDE Irvine32.inc

;-----------------------;
;    Var Declaration    ;
;-----------------------;
.data

project			BYTE	"-	 Number Composition   --   Bryce Hahn  -", 0
intro_1			BYTE	"Welcome to the Number Composition! I will take in an integer to represent how ", 0	; Intro 1 
intro_2			BYTE	"many composite numbers you want to print between 1 and 400. I verify integer ", 0	; Intro 2
intro_3			BYTE	"inputs. I will then print the demanded number of composite numbers to screen.", 0	; Intro 3
EC_intro_1		BYTE	"EC: I align the composites in columns", 0											; EC
EC_intro_2		BYTE	"EC: I continue printing pages after the inputted number has been printed", 0		; EC
prompt_1		BYTE	"Please input your name: ", 0														; Prompt for users name firstly
prompt_2		BYTE	"Welcome, ", 0																		; Greet the user
prompt_3		BYTE	"Please enter how many composite numbers I should print: ", 0						; Prompt for a negative number
prompt_4		BYTE	"Do you want to run the program again? (enter 1 for yes)", 0						; Prompt the user to run again
failed_input_1	BYTE	"The entered number was above the allowed range!", 0								; Warn the user that they can't input such a RIDICULOUSLY high number
failed_input_2	BYTE	"The entered number was bellow the allowed range!", 0								; Warn the user that they can't input such a CRAZY low number
outro_1			BYTE	"---  Outputting your composite numbers  ---", 0									; Start the calc section with letting the user know it's printing
outro_2			BYTE	"---  Press 1 to print more numbers, or anything else to finish  ---", 0			; EX -- tell the user to continue printing
finished		BYTE	"Thank you for using my program! Goodbye, ", 0										; Thank the user and say goodbye by name input
space			BYTE	" ", 0

MAXNUM			=		400																					; The maximum range of negative numbers
MINNUM			=		1																					; The minimum range we want to calculate
userinput		BYTE	21 DUP(0)																			; Byte array for the username input

byteCount		DWORD	?																					; used for holding information about user inputting a string
keep_going		DWORD	?																					; User inputed responce to run again
printCount		DWORD	?																					; user inputed number of composites to print
compos_current	DWORD	4																					; the current composite number
compos_bool		DWORD	0																					; a boolean operator to keep track through the methods
compos_count	DWORD	?																					; number of calculated composites
linecount		DWORD	0																					; keep track of how many numbers are on a line

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
		call	intro
		call	inputs
		call	getComposites
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
	mov		edx, OFFSET intro_1					; print the program introduction (Called only once when the program starts since the user doesn't need to see this after they restart)
	call	WriteString
	call	CrLf								; new line
	mov		edx, OFFSET intro_2					; print the program introduction pt.2
	call	WriteString
	call	CrLf								; new line
	mov		edx, OFFSET intro_3					; print the program introduction pt.3
	call	WriteString	
	call	CrLf								; new line
	mov		edx, OFFSET EC_intro_1
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
inputs	PROC
	StartInp:	
		mov		edx, OFFSET prompt_3			; ask for number of composite numbers
		call	WriteString
		mov		eax, 0
		call	ReadInt
		mov		printCount, eax
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
;	The getComposites procedure will be the bulk of the process ;
;	that prints out the composite number found through the		;
;	isComposite method.											;
;---------------------------------------------------------------;
getComposites	PROC
	mov		edx, OFFSET outro_1
	call	WriteString
	call	CrLf
	call	CrLf
	mov		compos_current, 4					; start the composite at the lowest possible value of 4
	mov		ecx, printCount						; we will loop through the calculations this many times


	CompositeLoop:
		mov		eax, compos_current
		mov		ebx, 2							; start the divisor with the lowest possible composite divisor

		call	isComposite						; call will find the next composite number in order

		mov		eax, compos_current				; this is the next composite number to print
		call	WriteDec
		inc		compos_count					; increase the number of composites printed

		inc		linecount						; keep track of how many composites per line are printed
		cmp		linecount, 10					; check if we're now at 10 on a line
		je		Lining
		jne		Spacer

		Lining:
			call	CrLf
			mov		linecount, 0
			jmp		EndOfLoop

		Spacer:
			call	propSpacing

		EndOfLoop:
			inc		compos_current
			loop	CompositeLoop

		mov		edx, OFFSET outro_2
		call	WriteString
		mov		eax, 0
		mov		ecx, 50
		call	ReadInt
		cmp		eax, 1
		je		CompositeLoop
		
	ret
getComposites ENDP

;---------------------------------------------------------------;
;	The propSpacing procedure will be called when spacing out	;
;	the composites to align them properly. This is so we can	;
;	do so without running out of room in the getComposite proc.	;
;---------------------------------------------------------------;
propSpacing PROC
	mov		eax, compos_current
	cmp		eax, 10
	jl		singleDigit
	cmp		eax, 100
	jl		doubleDigit
	cmp		eax, 1000
	jl		tripleDigit
	cmp		eax, 10000
	jl		quadDigit
	cmp		eax, 100000
	jl		quintupleDigit
	jge		septupleDigit

	singleDigit:
		mov		ebx, 9
		jmp		printLoop
	doubleDigit:
		mov		ebx, 8
		jmp		printLoop
	tripleDigit:
		mov		ebx, 7
		jmp		printLoop
	quadDigit:
		mov		ebx, 6
		jmp		printLoop
	quintupleDigit:
		mov		ebx, 5
		jmp		printLoop
	septupleDigit:
		mov		ebx, 4
		jmp		printLoop

	printLoop:
		mov		edx, OFFSET space
		call	WriteString
		dec		ebx
		cmp		ebx, 0
		jg		printLoop

		ret
propSpacing	ENDP

;---------------------------------------------------------------;
;	The isComposite procedure will be called during the			;
;	getComposite procedure as a means to keep the looping to	;
;	labels acessible. Keeping the other procedure relatively	;
;	clean and organized. We do the bulk of the calculations here;
;---------------------------------------------------------------;
isComposite	PROC
	CheckComposite:
		cmp		ebx, eax							; check to see if the loop has reached a divisor for itself
		je		NextComposite

		cdq											; prep for division
		div		ebx									; divide by divisor (can be from 2 to n, being the current compos check)
		cmp		edx, 0								; check if the remainder is 0
		je		ReturnComposite
		jne		LoopNotComposite

		ReturnComposite:							; we found the next composite number
			ret

		LoopNotComposite:							; Current divisor is not finding a composite, increase
			mov		eax, compos_current				; reset eax to current
			inc		ebx								; increase the divisor to check for next compos
			jmp		CheckComposite

		NextComposite:								; we hit the dividing by itself limit, so on to the next number
			inc		compos_current					; next number
			mov		eax, compos_current				; set eax to next number
			mov		ebx, 2							; reset divisor to 2 (minimum)
			jmp		CheckComposite
isComposite	ENDP

;---------------------------------------------------------------;
;	The restart procedure will test to see if the user is		;
;	wanting to run the process one more time, which is 1		;
;	is inputed, will jump the user back into the				;
;	introduction where the user will be asked to input more		;
;	integers. If anything else is answered, the program will	;
;	exit to the OS.												;
;---------------------------------------------------------------;
restart		PROC
	call	CrLf
	mov		edx, OFFSET prompt_4				; run again prompt
	call	WriteString
	call	ReadInt								; read in the user input for an answer
	mov		keep_going, eax						; move the user input to a readable register
	cmp		eax, 1								; compare if the user input was a '1'
	je		RestartProg
	jne		FinishProg

	RestartProg:
		call	inputs								; Jumps to int inputs if wanted, else end program

	FinishProg:
		mov		edx, OFFSET finished				; program is done message
		call	CrLf								; add an extra new line for good looks
		call	WriteString
		mov		edx, OFFSET userinput
		call	WriteString
		call	CrLf

	ret
restart		ENDP

END main										; the symbolyses that the main program is finished