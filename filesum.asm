section .data
    msg db "Sum: ", 0
    file db "randomInt100.txt", 0
    newline db 10, 0

section .bss
    num resd 1
    str1 resb 12
    total resd 1
    buf resb 1000

section .text
    global _start

_start:
    mov eax, 5
    mov ebx, file
    xor ecx, ecx
    int 0x80

    mov ebx, eax
    mov eax, 3
    mov ecx, buf
    mov edx, 1000
    int 0x80
    mov ebp, eax

    xor eax, eax
    mov [total], eax
    mov [num], eax
    mov esi, buf

loop:
    movzx eax, byte [esi]
    test al, al
    jz finish
    cmp al, '0'
    jb delim
    cmp al, '9'
    ja delim

    sub al, '0'
    mov ebx, [num]
    lea ebx, [ebx*4 + ebx]
    add ebx, ebx
    add ebx, eax
    mov [num], ebx
    jmp next

delim:
    add [total], ebx
    xor ebx, ebx
    mov [num], ebx

next:
    inc esi
    jmp loop

finish:
    add [total], ebx

    mov eax, [total]
    mov edi, str1
    call to_str

    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, 5
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, str1
        mov edx, 12
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    mov eax, 1
    mov ebx, 0
    int 0x80

to_str:
    mov ecx, 10
    mov edi, str1 + 11
    mov byte [edi], 0

conv:
    dec edi
    xor edx, edx
    div ecx
    add dl, '0'
    mov [edi], dl
    test eax, eax
    jnz conv

    ret
