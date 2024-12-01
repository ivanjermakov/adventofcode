section .bss
    out: resb 2048
    input: resb 2048
    a1: resb 2048
    a2: resb 2048

section .data
    input_filename: db "data/day1a.txt", 0
    input_filename_len: equ $-input_filename

    out_len: dd 0
    input_len: dd 2048
    a1_len: dd 2048
    a2_len: dd 2048

    i: dd 0
    j: dd 0
    k: dd 0
    parsed_n: dd 0
    e: db 0

    exit_id: dd 1
    read_id: dd 3
    write_id: dd 4
    open_id: dd 5

section .text
    global _start

_start:
    ; open file, eax is a fd
    mov eax, [open_id]
    mov ebx, input_filename
    mov ecx, 0
    mov edx, 0
    int 0x80

    ; read file bytes into input
    mov ebx, eax
    mov eax, [read_id]
    mov ecx, input
    mov edx, [input_len]
    int 0x80

    ; iterate each byte in input and assemble a1 and a2 with i32s
    mov byte [i], 0

    loop:
        mov esi, input
        add esi, [i]
        mov al, [esi]
        mov [e], al

        cmp byte [e], 0
        je loop_out

        ; for each char
        call parse_num
        mov esi, [i]
        imul esi, 4
        add esi, a1
        mov [esi], eax

        ; skip spaces
        add dword [i], 3

        call parse_num
        mov esi, [i]
        imul esi, 4
        add esi, a2
        mov [esi], eax

        inc dword [i]
        jmp loop

    loop_out:

    call exit

; read buf[i] until byte is not in digits range (0x30 - 0x39), incrementing i
; write resulting u32 to eax
parse_num:
    mov dword [parsed_n], 0

    parse_num_loop:
        mov esi, input
        add esi, [i]
        mov al, [esi]
        mov [e], al

        cmp byte [e], 0x30
        jl parse_num_done
        cmp byte [e], 0x39
        jg parse_num_done

        sub byte [e], 0x30

        mov eax, [parsed_n]
        imul eax, 10
        add eax, [e]
        mov dword [parsed_n], eax

        inc dword [i]
        jmp parse_num_loop

    parse_num_done:
        mov eax, parsed_n

    ret

write:
    mov eax, [write_id]
    mov ebx, 1
    int 0x80
    ret

exit:
    mov eax, [exit_id]
    mov ebx, 0
    int 0x80
    ret
