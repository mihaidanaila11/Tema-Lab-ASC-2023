//TODO GASIT BUG IN countVecini
//TODO evolutii

.data
m: .space 4
n: .space 4
p: .space 4
k: .space 4

x: .space 4
y: .space 4
nr_vecini: .space 4

i: .space 4
j: .space 4

string_citire: .asciz "%ld"
string_afisare: .asciz "%ld "
newline: .asciz "\n"

s: .space 1600
saux: .space 1600


.text

	afisareMatrice:
	pushl %ebp
	movl %esp, %ebp
	
	movl $1, i
	loop_linii:
	movl i, %eax
	movl m, %ebx
	subl $1, %ebx 
	cmp %ebx, %eax
	jge iesire

		movl $1, j
		loop_coloane:
		movl j, %eax
		movl n, %ebx
		subl $1, %ebx
		cmp %ebx, %eax
		jge cont_loop_linii
		
		// i*n + j
		movl i, %eax
		mull n
		addl j, %eax
		
		pushl (%edi, %eax, 4)
		pushl $string_afisare
		call printf
		popl %ebx
		popl %ebx
		
		pushl $0
		call fflush
		popl %ebx
		
		
		addl $1, j
		jmp loop_coloane
		
	cont_loop_linii:


	pushl $newline
	call printf
	popl %ebx

	pushl $0
	call fflush
	popl %ebx

	addl $1, i
	jmp loop_linii

	iesire:
	popl %ebp
	ret

	countVecini:
	pushl %ebp
	movl %esp, %ebp
	
	movl $0, nr_vecini
	movl $-1, i
	countVecini_loop_linii:
	movl i, %eax
	cmp $2, %eax
	jge countVecini_iesire
	
		movl $-1, j
		countVecini_loop_coloane:
		movl j, %eax
		cmp $2, %eax
		jge count_vecini_loop_cont
		
		//Verific daca ma aflu pe elementul caruia ii numar vecinii
		countVecini_if_1:
		movl i, %eax
		cmp $0, %eax
		je countVecini_if_2
		//daca nu e egal continuam
		jmp countVecini_cont
		
		countVecini_if_2:
		movl j, %eax
		cmp $0, %eax
		//daca nu ne aflam pe elementul curent continuam
		//daca suntem pe elementul curent trecem la urmatorul
		jne countVecini_cont
		addl $1, j
		
		countVecini_cont:
		//folosim x,y coordonate pentru elementul caruia ii verificam vecinii
		//vecinii se afla la s[x+i][y+j]
		//adica (x+i) * coloane + (y+j)
		movl x, %eax
		addl i, %eax
		mull n
		addl y, %eax
		addl j, %eax
		
		lea s, %edi
		movl (%edi, %eax, 4), %eax
		cmp $1, %eax
		je countVecini_contor
		
		
		addl $1, j
		jmp countVecini_loop_coloane
		
		countVecini_contor:
		addl $1, nr_vecini
		addl $1, j
		jmp countVecini_loop_coloane
	
	count_vecini_loop_cont:
	addl $1, i
	jmp countVecini_loop_linii
	
	countVecini_iesire:
	popl %ebp
	ret
	
	
	evolutie:
	pushl %ebp
	movl %esp, %ebp
	
	//copiez S in SAUX
	movl $1, i
	evolutie_copy_linie:
	movl i, %eax
	movl m, %ebx
	subl $1, %ebx
	cmp %ebx, %eax
	jge evolutie_copy_cont
	
		movl $1, j
		evolutie_copy_coloana:
		movl j, %eax
		movl n, %ebx
		subl $1, %ebx
		cmp %ebx, %eax
		jge evolutie_copy_linie_cont
		
		// i*n + j
		movl i, %eax
		mull n
		addl j, %eax
		lea s, %edi
		movl (%edi, %eax, 4), %ebx
		
		lea saux, %edi
		movl %ebx, (%edi, %eax, 4)
		
		addl $1, j
		jmp evolutie_copy_coloana
	
	evolutie_copy_linie_cont:
	addl $1, i
	jmp evolutie_copy_linie
	
	evolutie_copy_cont:
	movl $1, i
	
	evolutie_loop_linie:
	movl i, %eax
	movl m, %ebx
	subl $1, %ebx
	cmp %ebx, %eax
	jge evolutie_loop_cont
	
		movl $1, j
		evolutie_loop_coloana:
		movl j, %eax
		movl n, %ebx
		subl $1, %ebx
		cmp %ebx, %eax
		jge evolutie_loop_linie_cont
		
		//pregatim countVecini
		
		movl i, %eax
		movl %eax, x
		movl j, %eax
		movl %eax, y
		
		pushl i
		pushl j
		
		call countVecini
		
		popl j
		popl i
		
		//--
		
		movl i, %eax
		mull n
		addl j, %eax
		
		lea s, %edi
		movl (%edi, %eax, 4), %eax
		//verificam daca celula e 1 sau 0
		cmp $0, %eax
		jne eunu
		//aici e 0
		
		
		//AICI SE DECIDE SOARTA CELULEI 0
		
		movl nr_vecini, %eax
		cmp $3, %eax
		// daca nu are 3 vecini iesim din if si sarim la finalul loopului
		jne evolutie_loop_coloana_final
		//daca are 3 vecini setam la 1
		lea saux, %edi
		movl i, %eax
		mull n
		addl j, %eax
		
		movl $1, (%edi, %eax, 4)
		jmp evolutie_loop_coloana_final
		
		eunu:
		//aici e 1 (eunu)
		movl nr_vecini, %eax
		compar:
		cmp $3, %eax
		//daca nu are strict mai mult de 3 vecini ignoram
		jg evolutie_setzero
		cmp $2, %eax
		//daca nu are strict mai putin de 2 vecini ignoram
		jl evolutie_setzero
		jmp evolutie_loop_coloana_final
		
		//altfel setam celula la 0
		evolutie_setzero:
		lea saux, %edi
		movl i, %eax
		mull n
		addl j, %eax
		
		movl $0, (%edi, %eax, 4)
		
		
		evolutie_loop_coloana_final:
		addl $1, j
		jmp evolutie_loop_coloana
	
	evolutie_loop_linie_cont:
	addl $1, i
	jmp evolutie_loop_linie

	
	evolutie_loop_cont:
	//Trec SAUX in S
	movl $1, i
	evolutie_copy2_linie:
	movl i, %eax
	movl m, %ebx
	subl $1, %ebx
	cmp %ebx, %eax
	jge evolutie_copy2_cont
	
		movl $1, j
		evolutie_copy2_coloana:
		movl j, %eax
		movl n, %ebx
		subl $1, %ebx
		cmp %ebx, %eax
		jge evolutie_copy2_linie_cont
		
		lea saux, %edi
		// i*n + j
		movl i, %eax
		mull n
		addl j, %eax
		movl (%edi, %eax, 4), %ebx
		
		lea s, %edi
		movl %ebx, (%edi, %eax, 4)
		
		addl $1, j
		jmp evolutie_copy2_coloana
	
	evolutie_copy2_linie_cont:
	addl $1, i
	jmp evolutie_copy2_linie
	//-----
	evolutie_copy2_cont:
	popl %ebp
	ret


.global main
main:

lea s, %edi

// citim m
pushl $m
pushl $string_citire
call scanf
popl %ebx
popl %ebx
addl $2, m

//citim n
pushl $n
pushl $string_citire
call scanf
popl %ebx
popl %ebx
addl $2, n
//citim p
pushl $p
pushl $string_citire
call scanf
popl %ebx
popl %ebx

//for(int i=0; i<p; i++)
movl $0, i
lea s, %edx
loop_citire_coordonate:
mov i, %eax
cmp p, %eax
jge iesire_loop_citire_coordonate

pushl $x
pushl $string_citire
call scanf
popl %ebx
popl %ebx


pushl $y
pushl $string_citire
call scanf
popl %ebx
popl %ebx

addl $1, x
addl $1, y

// x * nr coloane + y
movl x, %eax
mull n
addl y, %eax


movl $1, (%edi, %eax, 4)

addl $1, i
jmp loop_citire_coordonate

iesire_loop_citire_coordonate:

//citim k
pushl $k
pushl $string_citire
call scanf
popl %ebx
popl %ebx

//Loop generatii:
generatii_loop:
movl k, %eax
cmp $0, %eax
jle generatii_loop_exit

call evolutie

subl $1, k
jmp generatii_loop

generatii_loop_exit:
call afisareMatrice
exit:
mov $1, %eax
xorl %ebx, %ebx
int $0x80
