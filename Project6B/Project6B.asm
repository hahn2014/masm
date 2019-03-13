TITLE Program 6B		(Project6B.asm)

; Author: Bryce Hahn
; Course/Project ID: CS 271 Project 6B
; Date: 3/12/2019
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
EC_intro_1		BYTE	"EC: I keep track of how many problems the user gets right vs. wrong",0				; EC 1
EC_intro_2		BYTE	"EC: I utalise the floating point operators and registers for calculations", 0		; EC 2

problem_1		BYTE	"Number of elements in the set: ", 0
problem_2		BYTE	"Number of elements to choose from the set: ", 0

prompt_1		BYTE	"Please enter your solution to the problem: ", 0									; Prompt for user solution
prompt_2		BYTE	"Would you like to practice another problem? (Y/N) ", 0								; as the user to keep going
failed_input_1	BYTE	"Invalid Responce! The given input was not an integer.", 0							; The user didn't input a number in for the solution
failed_input_2	BYTE	"Invalid Responce! The given input was not (Y/y, N/n). ", 0

outro_1			BYTE	"There are ", 0
outro_2			BYTE	" combinations of ", 0
outro_3			BYTE	" items from a set of ", 0
outro_4			BYTE	". That is correct!", 0
finished		BYTE	"Thank you for using my program! Goodbye.", 0										; Thank the user and say goodbye by name input


nMAXNUM			=		12																					; The maximum range for n
nMINNUM			=		3																					; The minimum range for n
rMINNUM			=		1																					; The lowest number that can be generated for r
problemNum		DWORD	0
problemsRight	DWORD	0
n				DWORD	?
r				DWORD	?
answer			DWORD	?
userinput		BYTE	10 DUP(0)


;---------------------------------------------------------------;
;	Macro mPrintString replaces having to move a byte to edx	;
;	and call writeString with only one line. also allows for	;
;	pretty lazy debuging which is a plus.						;
;	THIS METHOD ONLY WORKS WITH VARAIBLES						;
;---------------------------------------------------------------;
mWriteString	MACRO	buffer:REQ
	push	edx
	mov		edx, OFFSET buffer
	call	WriteString
	pop		edx
ENDM

;---------------------------------------------------------------;
;	Macro mWriteStringLn is the same as mWriteString but adds	;
;	a new line after the printed text so you don't have to write;
;	a new line call in the main functions.						;
;---------------------------------------------------------------;
mWriteStringLn	MACRO	buffer:REQ
	mWriteString	buffer
	call	CrLf
ENDM

mWriteDec		MACRO	decimal
	push	eax
	mov		eax, decimal
	call	WriteDec
	pop		eax
ENDM

;---------------------------------------------------------------;
;	Macro mWrite lets you write a string to the output without	;
;	pre-emptively defining it, I.E in quotes you can write		;
;	anything to the output.										;
;---------------------------------------------------------------;
mWrite		MACRO	text
	LOCAL	string
	.data
	string	BYTE	text, 0

	.code
	push	edx
	mov		edx, OFFSET string
	call	WriteString
	pop		edx
ENDM

;---------------------------------------------------------------;
;	Macro mWriteLn is the same as mWrite but adds a new line	;
;	call at the end so you don't have to write on in the code	;
;	section of the functions.									;
;---------------------------------------------------------------;
mWriteLn	MACRO	text
	mWrite	text
	call	CrLf
ENDM

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
		call	intro

		NewProblem:
	;-----------Generate A Problem--------------;
		push	n								; +24
		push	r								; +20
		push	OFFSET	answer					; +16
		push	OFFSET	problemNum				; +12
		push	OFFSET	problemsRight			; +8
		call	showProblem

	;-----------Get User Input------------------;
		push	n								; +24
		push	r								; +20
		push	OFFSET	problemsRight			; +16
		push	OFFSET	userinput				; +12
		push	OFFSET	answer					; +8
		call	getData							; Change to Int for temp solution, or just getData for true finished product

	;------------End Of The Program-------------;
		push	OFFSET	userinput				; +8
		call	restart
		cmp		eax, 1
		je		NewProblem

	exit										; close program, return to OS
main	ENDP									; the main PROC is finished, this symbolyses that we are done with the proc

;---------------------------------------------------------------;
;	The intro procedure will be called right off the bat, sort	;
;	of like before using procedures. This will allow to keep	;
;	the main function clean and organized, making debugging		;
;	easier! This function litterally just calls all intro		;
;	scripts.													;
;	Parameters: program, intro_1, intro_2, intro_3, intro_4,	;
;	intro_5, EC_intro_1, EC_intro_2								;
;	Returns: n/a												;
;	Pre-Conditions: called varaibles must be real strings		;
;---------------------------------------------------------------;
intro	PROC
	mov		eax, lightGray + (blue * 16)		; color varaibles consist of: black, white, brown, yellow, blue, green, cyan, red, magenta, gray, lightBlue, lightGreen, lightCyan, lightRed, lightMagenta, and lightGray.
	call	setTextColor						; EXTRA CREDIT: change background and foreground colors

	mWriteStringLn	project
	mWriteStringLn	intro_1
	mWriteStringLn	intro_2
	mWriteStringLn	intro_3
	mWriteStringLn	intro_4
	mWriteStringLn	intro_5
	mWriteStringLn	EC_intro_1
	mWriteStringLn	EC_intro_2

	ret
intro	ENDP

;---------------------------------------------------------------;
;	The generateProblem procedure will generate the 2 numbers	;
;	in the problem, and then print the question to the screen.	;
;	The procedure will also solve the problem itself, and then	;
;	jump to the next procedure to wait for user answer to cross	;
;	check answers and see if the user is correct.				;
;	Parameters: n, r, answer, problemNum, problemsRight			;
;	Returns: n, r, and answer values to their address			;
;	Pre-Conditions: none										;
;---------------------------------------------------------------;
showProblem	PROC
	push	ebp
	mov		ebp, esp
	sub		esp, 12								; make space for 3 local variables for factorial

	mov		eax, [ebp + 12]						; offset to eax
	mov		ebx, [eax]							; value of offset to ebx
	inc		ebx									; increase 
	mov		eax, [ebp + 12]						; offset to eax
	mov		[eax], ebx							; value to value of offset

	mWrite			"Problem "
	mov				eax, [ebp + 12]
	mWriteDec		[eax]						; problemNum


	mWrite			" ("
	mov			eax, [ebp + 8]
	mWriteDec	[eax]
	mWrite		"/"
	mov			eax, [ebp + 12]
	mov			ebx, [eax]
	dec			ebx
	mWriteDec	ebx

	mWriteLn	" answered correct)"

	mWriteString	problem_1

	mov		eax, nMAXNUM						; set the max to eax
	sub		eax, nMINNUM						; subtract the lowest from eax (this will give us a range of 1 to (max-min))
	call	RandomRange							; generate random number in range (1 to (max-min))
	add		eax, nMINNUM						; add lowest to generated number (this fixes the range to be from min to max)
	mov		n, eax
	mov		[ebp + 24], eax						; move the n value to the stack

	call	WriteDec							; this prints our N value to the screen

	call	CrLf
	mWriteString	problem_2

	sub		eax, rMINNUM						; subtract the lowest from eax (this will give us a range of 1 to (max-min))
	call	RandomRange							; generate random number in range (1 to (max-min))
	add		eax, rMINNUM						; add lowest to generated number (this fixes the range to be from min to max)
	mov		r, eax
	mov		[ebp + 20], eax						; move the r value to the stack

	call	WriteDec							; this prints our R value to the screen
	call	CrLf

	call	combinations						; this will add 4 bytes to the index distance of the addresses (to compensate for return address)
	
	mov		esp, ebp							; remove locals from stack
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

	;------------------N!-----------------------;
	push	[ebp + 24]							; push the N value to the stack [ebp + 8] in factorial
	call	factorial							; returns the N! to eax
	mov		DWORD PTR [ebp - 4], eax			; store in local var 1

	;------------------R!-----------------------;
	push	[ebp + 20]							; push the R value to the stack [ebp + 8] in factorial
	call	factorial							; returns the R! to eax
	mov		DWORD PTR [ebp - 8], eax			; store in local var 2

	;-----------------(N-R)!--------------------;
	mov		eax, [ebp + 24]						; The N value
	mov		ebx, [ebp + 20]						; The R value
	sub		eax, ebx							; N - R Value
	push	eax
	call	factorial							; returns the (N - R)! to eax
	mov		DWORD PTR [ebp - 12], eax			; store in local var 3

	;now for the answer
	;		n!
	;	----------
	;	r!(n - r)!

	mov		eax, DWORD PTR [ebp - 8]			; R!
	mov		ebx, DWORD PTR [ebp - 12]			; (N - R)!
	mul		ebx									; R! * (N - R)!

	mov		ebx, eax							; set bottom value to divisor
	mov		eax, DWORD PTR [ebp - 4]			; N!
	div		ebx									; (n!)/(r!(n-r)!)			answer stored in eax

	mov		ebx, [ebp + 16]						; answer offset to ebx
	mov		[ebx], eax							; move answer to the stack value

	ret		12
combinations	ENDP

;---------------------------------------------------------------;
;	The factorial procedure will take an input on the stack, i,	;
;	and recursively multiply itself until it has reached 1.		;
;	Parameters: i as current factorial, iS as factorial sum		;
;	returns: EAX = value of the factorial						;
;	Pre-Conditions: i as a valid integer.						;
;---------------------------------------------------------------;
factorial	PROC
	push	ebp
	mov		ebp, esp
	
	mov		eax, [ebp + 8]						; the designated stack location for the index value
	cmp		eax, 0								; check to see if index > 0
	ja		RecursiveCall						; i > 0
	mov		eax, 1
	jmp		endRecursion						; we need to loop back to the first call

	RecursiveCall:
		dec		eax								; i - 1
		push	eax								; used as the next layer of recursions new index
		call	factorial

	Return:										; only called when we keep looping back layers of recursion
		mov		ebx, [ebp + 8]					; get index
		mul		ebx								; prod * index

	endRecursion:
		pop		ebp								; remove the current layer of recursion's ebp placer
		ret		4								; clear the dedicated stack bytes for the index value
factorial	ENDP

;---------------------------------------------------------------;
;	The getData procedure will get the user input as a string	;
;	and verify the input was an integer. It will then compare	;
;	the user input to the answer of the problem, and reply		;
;	accordingly.												;
;	Parameters: prompt_1										;
;	Returns: if user answer was correct							;
;	Pre-Condition: answer should be a valid integer				;
;---------------------------------------------------------------;
getData PROC
	push    ebp
	mov     ebp,esp
	sub		esp, 8								; 2 local varaibles

	tryAgain:
		mWriteString   prompt_1
		mov     edx, [ebp + 12]					; move OFFSET of temp to receive string of integers
		mov     ecx, 12
		call    ReadString
		cmp     eax, 10							; user input was a number larger than 10 bytes
		jg      invalidInput

		mov     ecx, eax						; loop through each char in input
		mov     esi, [ebp + 12]					; point at char in string
		mov		edx, 0
		mov		[ebp - 8], edx					; start accumulation at 0

	loopString:									; loop validated each char in the input
		mov     al, [esi]						; move value of char into al register
		inc     esi								; point to next char in string
		sub     al, 48d							; subtract 48 from ASCII value of char to get integer  

		cmp     al ,0							; make sure char is >= 0
		jl      invalidInput
		cmp     al, 9							; or <= 9
		jg      invalidInput
		; in order to convert, we want to do (i = curNum, n = char index, i * (10 ^ n)
		; this will allow us to add each additional loop value to edx, to end up with converted string
		mov		[ebp - 4], eax
		;push	eax								; ebp - 4
		mov		ebx, ecx						; n = ecx
		dec		ebx
		mov		eax, 1							; (10 ^ n) = eax
		mov		edi, 10
		PowerOf:
			cmp		ebx, 0
			je		PowerOfDone
			mul		edi							; eax * 10
			dec		ebx							; n - 1
			cmp		ebx, 0
			jg		PowerOf
		PowerOfDone:
		
		;eax now = (10 ^ n)
		mov		ebx, eax						; temporarily hold (10 ^ n) in ebx
		mov		eax, [ebp - 4]					; set eax back to the input char value

		movzx	edi, al							; move value of al to edi as temp register
		mov		eax, ebx						; move (10 ^ n) back to eax
		mul		edi								; eax = i * (10 ^ n)
		xor		edx, edx
		mov		edx, [ebp - 8]
		add		edx, eax						; add eax to accumulation total
		mov		[ebp - 8], edx

		loop    loopString
		jmp     Verify

	invalidInput:								; reset registers and variables to 0
		mov     al, 0
		mov     eax, 0
		mov     ebx, [ebp + 8]
		mov     [ebx], eax
		mov     ebx, [ebp + 12]
		mov     [ebx], eax       
		mWriteStringLn   failed_input_1
		jmp     tryAgain

	Verify:
		mov		eax, [ebp + 8]					; answer
		mov		ebx, [eax]
		cmp		ebx, edx						; compare answer to input result
		je		answerRight
		jne		answerWrong


	answerRight:
		mov				eax, [ebp + 8]
		mWrite			"There are "
		mWriteDec		[eax]
		mWrite			" combinations of "
		mWriteDec		[ebp + 20]
		mWrite			" items from a set of "
		mWriteDec		[ebp + 24]
		mWriteLn		". You're correct!"
		mov				ebx, [ebp + 16]
		mov				eax, [ebx]
		inc				eax
		mov				ebx, [ebp + 16]
		mov				[ebx], eax

		mov		esp, ebp						; remove locals from stack
		pop		ebp
		ret		20

	answerWrong:
		mov				eax, [ebp + 8]
		mWrite			"There are "
		mWriteDec		[eax]
		mWrite			" combinations of "
		mWriteDec		[ebp + 20]
		mWrite			" items from a set of "
		mWriteDec		[ebp + 24]
		mWriteLn		". You're incorrect!"

		mov		esp, ebp						; remove locals from stack
		pop		ebp
		ret		20
getData	ENDP

;---------------------------------------------------------------;
;	The restart procedure will test to see if the user is		;
;	wanting to run the process one more time, which is 1		;
;	is inputed, will jump the user back into the				;
;	introduction where the user will be asked to input more		;
;	integers. If anything else is answered, the program will	;
;	exit to the OS.												;
;	Parameters: userinput										;
;	Returns: eax = 1 if user wishes to restart					;
;	Pre-Conditions: none										;
;---------------------------------------------------------------;
restart		PROC
	push	ebp
	mov		ebp, esp
	startOfCall:
		mWriteString	prompt_2
	
		mov		edx, [ebp + 8]					; userinput
		mov		ecx, 10
		call	ReadString

		mov		esi, [ebp + 8]
		lodsb									; load string as byte to ax 8 bit register
		cmp		ax, 89d							; compare input to Y decimal value
		je		startOver
		cmp		ax, 121d						; compare input to y decimal value
		je		startOver
		cmp		ax, 78d							; compare input to N decimal value
		je		endProg
		cmp		ax, 110d						; compare input to n decimal value
		je		endProg
		jmp		failedInput						; some other input

	startOver:
		mov		eax, 1
		call	CrLf
		call	CrLf
		pop		ebp
		ret		4

	endProg:
		mov		eax, 0
		call	CrLf
		mWriteStringLn	finished
		pop		ebp
		ret		4

	failedInput:
		mWriteStringLn	failed_input_2
		jmp		startOfCall

	
restart		ENDP

END main										; the symbolyses that the main program is finished