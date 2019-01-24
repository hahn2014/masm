TITLE Program 3		(Project3.asm)

; Author: Bryce Hahn
; Course/Project ID: CS 271 Project 3
; Date: 1/21/2019
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
EC_intro_1		BYTE	"EC: I print the line numbers when taking in user inputs!", 0						; EC
EC_intro_2		BYTE	"EC: I output the floating point average as well!", 0								; EC					;;;; this is due to change when I 
EC_intro_3		BYTE	"EC: I change my background color and text color!", 0								; EC					;;;; actually know what they are
prompt_1		BYTE	"Please input your name: ", 0														; Prompt for users name firstly
prompt_2		BYTE	"Welcome, ", 0																		; Greet the user
prompt_3		BYTE	"Please enter how many composite numbers I should print: ", 0						; Prompt for a negative number
prompt_4		BYTE	"Do you want to run the program again? (enter 1 for yes)", 0						; Prompt the user to run again
failed_input_1	BYTE	"The entered number was above the allowed range!", 0								; Warn the user that they can't input such a RIDICULOUSLY high number
failed_input_2	BYTE	"The entered number was bellow the allowed range!", 0								; Warn the user that they can't input such a CRAZY low number
outro_1			BYTE	"---  Outputting your composite numbers  ---", 0									; Start the calc section with letting the user know it's printing
finished		BYTE	"Thank you for using my program! Goodbye, ", 0										; Thank the user and say goodbye by name input
seperator		BYTE	", ", 0

MAXNUM			=		400																					; The maximum range of negative numbers
MINNUM			=		1																					; The minimum range we want to calculate
userinput		BYTE	21 DUP(0)																			; Byte array for the username input

byteCount		DWORD	?																					; used for holding information about user inputting a string
keep_going		DWORD	?																					; User inputed responce to run again
printCount		DWORD	?																					; user inputed number of composites to print
compos_current	DWORD	4																					; the current composite number

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
		mov		edx, OFFSET intro_2			; print the program introduction pt.2
		call	WriteString
		call	CrLf						; new line
		mov		edx, OFFSET intro_3			; print the program introduction pt.3
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
		mov		edx, OFFSET prompt_3		; ask for number of composite numbers
		call	WriteString
		mov		eax, 0
		call	ReadInt
		mov		printCount, eax
		cmp		eax, MAXNUM
		jg		HigherInput
		cmp		eax, MINNUM
		jl		LowerInput
		jmp		Calculations

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
		jmp		Inputs

;---------------------------------------------------------------;
;	The Calculations label will be the bulk of the process,		;
;	where we calculate the different math operations, and		;
;	output them (very smoothly with proper symbols) to the		;
;	output.														;
;---------------------------------------------------------------;
Calculations:
		mov		edx, OFFSET outro_1
		call	WriteString
		call	CrLf
		call	CrLf
		mov		compos_current, 4			; always start off composites at 4

		mov		ecx, printCount				; we will loop through the calculations this many times
		dec		ecx							; decrease the loop count by 1 though because we already start at 4
		CompositeLoop:






			mov		eax, compos_current
			call	WriteDec
			mov		edx, OFFSET seperator
			call	WriteString
			;call	CrLf

			loop CompositeLoop




		jmp		RunAgain					; output is done, ask to run again

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