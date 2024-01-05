.data
m: .space 4
n: .space 4
p: .space 4
k: .space 4
mod: .space 1

x: .space 4
y: .space 4
nr_vecini: .space 4

i: .space 4
j: .space 4

string_citire: .asciz "%ld"
string_afisare: .asciz "%ld "
string_mesaj: .asciz "%s"
newline: .asciz "\n"
prefix: .asciz "0x"

s: .space 1600
saux: .space 1600

mesaj: .space 22
mesaj_binar: .space 80
lungime: .space 4
len_cheie: .space 4

hexa: .asciz "A", "B", "C", "D", "E", "F"

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
	
	
	
	cheie_lungire:
	pushl %ebp
	movl %esp, %ebp
	
	proc_scurta:
lea s, %edi
movl lungime, %eax
subl len_cheie, %eax

xorl %edx, %edx
divl len_cheie

//in %eax am cat, in %edx rest

movl $0, i

proc_scurta_loop:
movl i, %ebx
//eax -> cat   edx -> contor
cmp %eax, %ebx
jge proc_scurta_loop_exit

xorl %ecx, %ecx
	
	
	proc_marire:
	cmp len_cheie, %ecx
	jge proc_scurta_loop_cont
	
	//(%edi, %ecx, 4) -> (%edi, %ecx+len_cheie, 4)
	movl %ecx, %ebx
	addl len_cheie, %ebx
	pushl %eax
	
	movl (%edi, %ecx, 4), %eax
	movl %eax, (%edi, %ebx, 4)
	
	popl %eax
	
	incl %ecx
	jmp proc_marire
		
proc_scurta_loop_cont:
movl len_cheie, %ebx
addl %ebx, len_cheie
incl i
jmp proc_scurta_loop
proc_scurta_loop_exit:

movl $0, i
proc_scurta_loop2:
movl i, %ebx
cmp %edx, %ebx
jge proc_scurta_loop2_exit

//(%edi, %ecx, 4) -> (%edi, %ecx+len_cheie, 4)
movl %ebx, %ecx
addl len_cheie, %ecx

movl (%edi, %ebx, 4), %eax
movl %eax, (%edi, %ecx, 4)

incl i
jmp proc_scurta_loop2
proc_scurta_loop2_exit:
addl %ebx, len_cheie
	
	popl %ebp
	ret
	
	
	
	proc_xorare:
	
	//--
	pushl %ebp
	movl %esp, %ebp
	
	xorl %edx, %edx
	lea s, %edi
	lea mesaj_binar, %esi
	xorl %eax, %eax
	xorl %edx, %edx
	cript:
	cmp lungime, %edx
	jge cript_exit

	//xor (%edi, %edx, 4), (%esi, %edx, 1)
	movl (%edi, %edx, 4), %eax

	movb (%esi, %edx, 1), %bl
	xorl %eax, %ebx
	movb %bl, (%esi, %edx, 1)


	incl %edx
	jmp cript
	cript_exit:
	popl %ebp
	ret
	//-


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

//citim punctele p(x,y)
movl $0, i
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
//---

iesire_loop_citire_coordonate:
//citim k
pushl $k
pushl $string_citire
call scanf
popl %ebx
popl %ebx

//citim mod
pushl $mod
pushl $string_citire
call scanf
popl %ebx
popl %ebx

//citim mesaj
pushl $mesaj
pushl $string_mesaj
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

pushl $mesaj
call strlen
popl %ebx

movl %eax, lungime

//(m+2)*(n+2) calculez lungime cheie
movl m, %eax
mull n
popl %ebx
movl %eax, len_cheie

xorb %al, %al
cmp %al, mod
jne decriptare

criptare:
//
movl $0, i
xorl %eax, %eax
xorl %ebx, %ebx
lea mesaj, %edi
lea mesaj_binar, %esi

criptare_parcurgere_mesaj:
movl i, %edx
cmp lungime, %edx
jge criptare_parcurgere_mesaj_exit

movl $7, %ecx
	criptare_gen_binar_mesaj:
	cmp $0, %ecx
	jl criptare_parcurgere_mesaj_cont
	
	//mut ascii litera in %al
	movl i, %edx
	movb (%edi, %edx, 1), %al 
	
	movb $1, %bl
	shl %ecx, %bl
	and %al, %bl
	
	shr %ecx, %bl

	movl %edx, %eax
	pushl %ebx
	movl $8, %ebx
	mull %ebx
	popl %ebx
	addl $7, %eax
	subl %ecx, %eax
	
	movb %bl, (%esi, %eax, 1) 
	
	decl %ecx
	jmp criptare_gen_binar_mesaj

criptare_parcurgere_mesaj_cont:
incl i
jmp criptare_parcurgere_mesaj
criptare_parcurgere_mesaj_exit:



//veirfic daca lungimea mesajului are aceeasi lungime cu cheia
movl $8, %eax
mull lungime
movl %eax, lungime
pushl %eax
//(m+2)*(n+2)
movl m, %eax
mull n
popl %ebx
movl %eax, len_cheie
// ebx -> len mesaj   eax -> len cheie

cmp %ebx, %eax
decizie:
//jg daca mesajul e mai lung decat cheia
jg lunga
//jl daca mesajul e mai scurt decat cheia
jl scurta
jmp criptare

lunga:
//iau in considerare numai cate caractere din cheie ma intereseaza
movl %eax, len_cheie

jmp xorare
scurta:
call cheie_lungire

jmp xorare

xorare:
//TODO


call proc_xorare



pushl $prefix
call printf
popl %ebx

pushl $0
call fflush
popl %ebx

movl lungime, %ebx
shr $2, %ebx
lea mesaj_binar, %esi
movl $0, i
cript_afisare:
cmp %ebx, i
jge cript_afisare_exit

	movl $0, j
	xorl %ecx, %ecx
	grupare:
	movl j, %eax
	cmp $4, %eax
	jge cript_afisare_cont
	
	shl $1, %cl
	//i*4 + j
	movl $4, %eax
	mull i
	addl j, %eax
	
	movb (%esi, %eax, 1), %dl
	or %dl, %cl
	
	incl j
	jmp grupare

cript_afisare_cont:


cmpb $10, %cl
jge litere
jmp cifre

litere:
subb $10, %cl
xorl %eax, %eax
lea hexa, %edi
lea (%edi, %ecx, 2), %eax
pushl %eax
pushl $string_mesaj
jmp cript_incl

cifre:
pushl %ecx
pushl $string_citire

cript_incl:
call printf
popl %ecx
popl %ecx

pushl $0
call fflush
popl %ecx

incl i
jmp cript_afisare
cript_afisare_exit:



jmp exit

decriptare:
//



//incep de la 2 ca sa trec de 0x
movl $2, i
lea mesaj, %edi
lea mesaj_binar, %esi
decript_parcurgere_mesaj:
movl i, %edx
cmp lungime, %edx

jge decript_parcurgere_mesaj_exit

movl $3, %ecx
xorl %ebx, %ebx
xorl %eax, %eax
movb (%edi, %edx, 1), %al
cmp $57, %eax
jle decript_cifra
jmp decript_litera



decript_cifra:
//
//scad 48 pt ca 0 in ascii e 48 si de acolo incep cifrele (ex. 1 in ascii e 49 => 49-48 = 1)
subl $48, %eax
jmp decript_gen_bin_mesaj

decript_litera:
//scad 55 pt ca A(10) in ascii e 65 si de acolo incep literele pana la F(15) (ex. 11 in hexa e B in ascii 66 => 66-55 = 11)
subl $55, %eax
jmp decript_gen_bin_mesaj


//in eax am nr de transformat in binar


	
	decript_gen_bin_mesaj:

	cmp $0, %ecx
	jl decript_parcurgere_mesaj_cont
	
	movb $1, %bl
	shl %ecx, %bl
	and %al, %bl
	shr %ecx, %bl
	
	//salvex eax
	pushl %eax
	
	//i -> eax
	movl i, %eax
	//scad 2 pt ca incep indexarea de la 2 iar in vector vreau sa imi puna de la 0
	subl $2, %eax
	//pastrez bitul 
	pushl %ebx
	movl $4, %ebx
	mull %ebx
	popl %ebx
	addl $3, %eax
	subl %ecx, %eax
	
	movb %bl, (%esi, %eax, 1) 

	popl %eax
	decl %ecx
	jmp decript_gen_bin_mesaj

decript_parcurgere_mesaj_cont:

incl i
jmp decript_parcurgere_mesaj
decript_parcurgere_mesaj_exit:

//veirfic daca lungimea mesajului are aceeasi lungime cu cheia
subl $2, lungime

movl $4, %eax
mull lungime
movl %eax, lungime
//eax -> len mesaj

cmp %eax, len_cheie

//jg daca mesajul e mai lung decat cheia
jg dc_lunga
//jl daca mesajul e mai scurt decat cheia
jl dc_scurta
jmp dc_xorare

dc_lunga:
//iau in considerare numai cate caractere din cheie ma intereseaza
movl %eax, len_cheie
jmp dc_xorare

dc_scurta:
call cheie_lungire


dc_xorare:
call proc_xorare

//

movl lungime, %ebx
shr $3, %ebx
lea mesaj_binar, %esi
movl $0, i

dcript_afisare:
cmp %ebx, i
jge dcript_afisare_exit

	movl $0, j
	xorl %ecx, %ecx
	dc_grupare:
	movl j, %eax
	cmp $8, %eax
	jge dcript_afisare_cont
	
	shl $1, %cl
	//i*8 + j
	movl $8, %eax
	mull i
	addl j, %eax
	
	movb (%esi, %eax, 1), %dl
	or %dl, %cl
	test:
	
	incl j
	jmp dc_grupare

dcript_afisare_cont:
test2:
movl %ecx, j
pushl $j
pushl $string_mesaj
call printf
popl %ecx
popl %ecx

pushl $0
call printf
popl %ecx


incl i
jmp dcript_afisare
dcript_afisare_exit:

jmp exit

exit:
pushl $0
call fflush
popl %ebx

movl $1, %eax
xorl %ebx, %ebx
int $0x80
