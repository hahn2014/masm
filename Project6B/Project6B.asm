TITLE Program 6B		(Project6B.asm)

; Author: Bryce Hahn
; Course/Project ID: CS 271 Project 6
; Date: 3/4/2019
; Description:
;	This program will produce a random equation in the format
;		(n!)/(r!(n-r)!) generating n from [3 to 12] and r 
;		from [1 to n]. The user then has to solve and answer
;		the problem solution to the input. If they are correct,
;		let them know, and keep playing until the user asks to
;		stop. The factorial calculation happens recursively.
;		EC: I keep track of how many got right vs wrong, and
;			display for each new problem.

INCLUDE Irvine32.inc

;-----------------------;
;    Var Declaration    ;
;-----------------------;
.data

project			BYTE	"-	 Combinations Calculator    --   Bryce Hahn  -", 0
intro_1			BYTE	"The program will generate a number n [3 - 12] and a number r [1 - n] which will ",0; Intro 1
intro_2			BYTE	"be used to calculate the number of combinations of r items taken from a set ",0	; Intro 2
intro_3			BYTE	"of n items. The user is then prompted to answer the solution to the problem, ", 0	; Intro 3
intro_4			BYTE	"and the correct answer will then be displayed after. The program will continue ", 0; Intro 4
intro_5			BYTE	"until the user expressively demands to stop.", 0									; Intro 5
EC_intro_1		BYTE	"EC: I keep track of how many problems the user gets right vs. wrong",0; EC 1
EC_intro_2		BYTE	"EC: I utalise the floating point operators and registers for calculations", 0		; EC 2
problem_1		BYTE	"PROBLEM ", 0																		; The problem, then the problem number
problem_2		BYTE	"Number of elements in the set: ", 0
problem_3		BYTE	"Number of elements to choose from the set: ", 0
prompt_1		BYTE	"Please enter the solution to the problem: ", 0										; Prompt for a random number
prompt_2		BYTE	"Would you like to practice another problem? (Y/N) ", 0								; as the user to keep going
failed_input_1	BYTE	"The entered number was above the allowed range!", 0								; Warn the user that they can't input such a RIDICULOUSLY high number
failed_input_2	BYTE	"The entered number was bellow the allowed range!", 0								; Warn the user that they can't input such a CRAZY low number
failed_input_3	BYTE	"The entered value was not a number, please try again.", 0							; The user didn't input a number in for the solution
outro_1			BYTE	"             ---  Outputting your unsorted array  ---             ", 0
outro_2			BYTE	"The array median is: ", 0
outro_3			BYTE	"             ---  Outputting your sorted array  ---             ", 0
finished		BYTE	"Thank you for using my program! Goodbye.", 0										; Thank the user and say goodbye by name input


nMAXNUM			=		12																					; The maximum range for n
nMINNUM			=		3																					; The minimum range for n
rMINNUM			=		1																					; The lowest number that can be generated for r
problemNum		DWORD	1
problemsRight	DWORD	0
n				DWORD	?
r				DWORD	?
answer			DWORD	?


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
		call	Randomize						; set the time seed for the randomize functions in order to keep the generator psuedo-random

	;-----------Display Program Intro-----------;
		push	OFFSET	project					; +36
		push	OFFSET	intro_1					; +32
		push	OFFSET	intro_2					; +28
		push	OFFSET	intro_3					; +24
		push	OFFSET	intro_4					; +20
		push	OFFSET	intro_5					; +26
		push	OFFSET	EC_intro_1				; +12
		push	OFFSET	EC_intro_2				; +8
		call	intro

	;-----------Generate A Problem--------------;
		push	OFFSET	problem_1				; +36
		push	OFFSET	problem_2				; +32
		push	OFFSET	problem_3				; +28
		push	n								; +24
		push	r								; +20
		push	answer							; +16
		push	problemNum						; +12
		push	problemsRight					; +8
		call	showProblem

	;-----------Get User Input------------------;
		push	OFFSET	prompt_1				; +12
		push	answer							; +8
		call	getData

	;------------End Of The Program-------------;
		push	OFFSET	finished				; +8
		call	restart
	exit										; close program, return to OS
main	ENDP									; the main PROC is finished, this symbolyses that we are done with the proc

;---------------------------------------------------------------;
;	The intro procedure will be called right off the bat, sort	;
;	of like before using procedures. This will allow to keep	;
;	the main function clean and organized, making debugging		;
;	easier! This function litterally just calls all intro		;
;	scripts.													;
;	Parameters: program, intro_1, intro_2, intro_3, intro_4,	;
;	intro_5, EC_intro_1, EC_intro_2, EC_intro_3, EC_intro_4		;
;	Returns: 40 bytes from the stack							;
;	Pre-Conditions: none										;
;---------------------------------------------------------------;
intro	PROC
	mov		eax, lightGray + (blue * 16)		; color varaibles consist of: black, white, brown, yellow, blue, green, cyan, red, magenta, gray, lightBlue, lightGreen, lightCyan, lightRed, lightMagenta, and lightGray.
	call	setTextColor						; EXTRA CREDIT: change background and foreground colors

	push	ebp									; push all the general purpose regs to stack
	mov		ebp, esp							; save the stack into ebp to not alter data

	mov		edx, [ebp + 36]						; program
	call	WriteString
	call	CrLf
	mov		edx, [ebp + 32]						; intro_1
	call	WriteString
	call	CrLf
	mov		edx, [ebp + 28]						; intro_2
	call	WriteString
	call	CrLf
	mov		edx, [ebp + 24]						; intro_3
	call	WriteString
	call	CrLf
	mov		edx, [ebp + 20]						; intro_4
	call	WriteString
	call	CrLf
	mov		edx, [ebp + 16]						; intro_5
	call	WriteString
	call	CrLf
	
	mov		edx, [ebp + 12]						; EC_intro_1
	call	WriteString
	call	CrLf
	mov		edx, [ebp + 8]						; EC_intro_2
	call	WriteString
	call	CrLf

	pop		ebp
	ret		34									; clean the stack 34 bytes up
intro	ENDP

;---------------------------------------------------------------;
;	The generateProblem procedure will generate the 2 numbers	;
;	in the problem, and then print the question to the screen.	;
;	The procedure will also solve the problem itself, and then	;
;	jump to the next procedure to wait for user answer to cross	;
;	check answers and see if the user is correct.				;
;	Parameters: 
;---------------------------------------------------------------;
showProblem	PROC
	push	ebp
	mov		ebp, esp

	mov		edx, [ebp + 36]						; problem_1
	call	WriteString
	mov		eax, [ebp + 12]						; problemNum
	call	WriteDec
	call	CrLf
	mov		edx, [ebp + 32]						; problem_2
	call	WriteString

	mov		eax, nMAXNUM						; set the max to eax
	sub		eax, nMINNUM						; subtract the lowest from eax (this will give us a range of 1 to (max-min))
	call	RandomRange							; generate random number in range (1 to (max-min))
	add		eax, nMINNUM						; add lowest to generated number (this fixes the range to be from min to max)
	mov		[ebp + 24], eax						; move the n value to the stack

	call	WriteDec							; this prints our N value to the screen

	call	CrLf
	mov		edx, [ebp + 28]						; problem_3
	call	WriteString

	sub		eax, rMINNUM						; subtract the lowest from eax (this will give us a range of 1 to (max-min))
	call	RandomRange							; generate random number in range (1 to (max-min))
	add		eax, rMINNUM						; add lowest to generated number (this fixes the range to be from min to max)
	mov		[ebp + 20], eax						; move the r value to the stack

	call	WriteDec							; this prints our R value to the screen
	call	CrLf


	

	;TEMP : print the answer
	call	combinations						; this will add 4 bytes to the index distance of the addresses (to compensate for return address)


	
	pop		ebp
	ret		34
showProblem	ENDP

;---------------------------------------------------------------;
;	The combinations process calculates (n!)/(r!(n-r)!), and	;
;	stores the value in result. It will call factorial process	;
;	3 times, for n!, r!, and (n-r)! respectively, then multiply	;
;	and divide as needed.										;
;	Parameters: n, r as values, answer as reference				;
;	Returns: the problems calculation value to answer			;
;	Pre-Conditions, n and r are real integer values				;
;---------------------------------------------------------------;
combinations	PROC
	mov		eax, [ebp + 24]						; The N value
	mov		ebx, [ebp + 20]						; The R value
	mov		ecx, eax							; N
	sub		ecx, ebx							; N - R Value

	sub		ebp, 8								; make 2 local variable spaces (2*4) for factorial and factorial index

	;------------------N!-----------------------;
	mov		[ebp - 8], eax						; set the factorial index to N value
	call	factorial
	mov		eax, [ebp - 4]						; move the total to eax
	call	WriteDec
	call	CrLf
	;------------------R!-----------------------;
	mov		[ebp - 8], ebx						; set the factorial index to R value
	call	factorial
	mov		eax, [ebp - 4]						; move the total to eax
	call	WriteDec
	call	CrLf
	;-----------------(N-R)!--------------------;
	mov		[ebp - 8], ecx						; set the factorial index to N-R value
	call	factorial
	mov		eax, [ebp - 4]						; move the total to eax
	call	WriteDec
	call	CrLf


	call	CrLf
	call	CrLf
	call	CrLf

	ret
combinations	ENDP

;---------------------------------------------------------------;
;	The factorial procedure will take an input on the stack, i,	;
;	and recursively multiply itself until it has reached 1.		;
;	Parameters: i as current factorial, iS as factorial sum		;
;	returns: iS value of the factorial							;
;	Pre-Conditions: i as a valid integer.						;
;---------------------------------------------------------------;
factorial	PROC
	mov		eax, [ebp - 8]						; factorial index, I.E How many iterations the factorial process will be called
	mov		ebx, [ebp - 4]

	cmp		ebx, 0
	je		FirstRun
	jg		RecursiveRun

	FirstRun:
		mov		[ebp - 4], eax					; Since it's the first run, we just change the value of the total
		dec		eax								; go to the next number
		mov		[ebp - 8], eax					; set the index to n-1
		jmp		checkIndex						; see if we're done

	RecursiveRun:
		mov		ecx, eax						; store the index value before multiplying
		mul		ebx								; since this is at least the second itteration, multiply the total by the current index
		mov		[ebp - 4], eax					; store the new total
		dec		ecx								; set the index to n-1
		mov		[ebp - 8], ecx					; store the new index
		jmp		checkIndex						; see if we're done

	checkIndex:
		mov		eax, [ebp - 8]					; if we just came from the RecursiveRun Label eax needs to be reset
		cmp		eax, 0							; if the index is now at 0, we don't want to multiply by 0 so we're done
		jg		nextCall						; but the index is > 0 so go to next recursive call
		je		endProc							; we've done

	nextCall:
		;call	factorial
		ret

	endProc:
		ret
factorial	ENDP

;---------------------------------------------------------------;
;	The getData procedure will get the user input as a string	;
;	and verify the input was an integer. It will then compare	;
;	the user input to the answer of the problem, and reply		;
;	accordingly.												;
;	Parameters: prompt_1, failed_input_1, failed_input_2		;
;	Returns: if user answer was correct							;
;	Pre-Condition: answer should be a valid integer				;
;---------------------------------------------------------------;
getData	PROC
	push	ebp
	mov		ebp, esp
	
	mov		edx, [ebp + 12]						; prompt_1
	call	WriteString

	;mov		ecx, SIZEOF	userinput
	;call	ReadString
	;mov		byteCount, eax




	pop		ebp
	ret		8									; clean the stack 12 bytes
getData	ENDP

;---------------------------------------------------------------;
;	The restart procedure will test to see if the user is		;
;	wanting to run the process one more time, which is 1		;
;	is inputed, will jump the user back into the				;
;	introduction where the user will be asked to input more		;
;	integers. If anything else is answered, the program will	;
;	exit to the OS.												;
;	Parameters: finished										;
;	Returns: none												;
;	Pre-Conditions: none										;
;---------------------------------------------------------------;
restart		PROC
	push	ebp
	mov		ebp, esp
	
	call	CrLf
	mov		edx, [ebp + 8]						; finished
	call	WriteString

	pop		ebp
	ret		4
restart		ENDP

END main										; the symbolyses that the main program is finished