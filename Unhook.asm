BITS 32

section .text
global _start

_start:

    mov edx, ecx

    push ebp
    mov ebp, esp

    sub esp, 1ch
    xor eax, eax
    mov [ebp - 04h], eax
    mov [ebp - 08h], eax
    mov [ebp - 0ch], eax
    mov [ebp - 10h], eax
    mov [ebp - 14h], eax
    mov [ebp - 18h], eax
    mov [ebp - 1ch], eax

    push 41656C64h
    push 6E614865h
    push 6C75646Fh
    push 4D746547h

    mov [ebp - 14h], esp

    xor ebx, ebx
    mov bl, 0x30
    mov eax, [fs:ebx]

    mov eax, [eax + 0ch]
    mov eax, [eax + 14h]
    mov ebx, eax
    mov eax, [ebx]
    mov ebx, eax
    mov eax, [ebx]
    mov eax, [eax -8h + 18h]

    mov ebx, eax
    ;mov edx, eax
    
    mov eax, [ebx + 3ch]
    add eax, ebx
    mov eax, [eax + 78h]
    add eax, ebx
    mov ecx, [eax + 14h]
    mov [ebp - 4h], ecx
    mov ecx, [eax + 1ch]
    add ecx, ebx
    mov [ebp - 8h], ecx
    mov ecx, [eax + 20h]
    add ecx, ebx
    mov [ebp - 0ch], ecx
    mov ecx, [eax + 24h]
    add ecx, ebx
    mov [ebp - 10h], ecx
    xor eax, eax
    xor ecx, ecx

    findGetModuleHandle:
        mov esi, [ebp - 14h]
        mov edi, [ebp - 0ch]
        cld
        mov edi, [edi + eax*4]
        add edi, ebx
        mov cl, 16
        repe cmpsb
        jz GetModuleHandleFound
        inc eax
        cmp eax, [ebp - 4h]
        jne findGetModuleHandle

    GetModuleHandleFound:
        mov ecx, [ebp - 10h]
        mov edi, [ebp - 8h]
        mov ax, [ecx + eax * 2]
        mov eax, [edi + eax * 4]
        add eax, ebx

    CallGetModuleHandle:
        xor ebx, ebx	
        push ebx
        mov ebx, 6C6C64FFh 
        shr ebx, 8
        push ebx
        push 2E726573h
        push 776F7242h
        push 6E776F44h
        push 6B636F4Ch

        ; push 6C6C642Eh
        ; push 32336C65h
        ; push 6E72654Bh

        mov ecx, esp
        xor ebx, ebx
        push ecx
        call eax
        add esp, 4

    add esp, 1ch
    add esp, 0ch
    add esp, 4h
    pop ebp

    xor ebx, ebx
    cmp eax, ebx
    jne beepTime
    jmp findKernelAndExitHoop

beepTime:
    xor ebx, ebx
    push ebx
    
    mov bx, 0x156
    call get_eip
    get_eip:
    pop edx
    add edx, ebx
    push edx

    xor edx, edx
    mov dx, 10C0h
    add edx, eax

    push edx
    pop eax
    call eax
    ; nop
    ; nop

    ; push eax
    ; mov eax, arg_ptr    //pointer with value: 0x00 //use 0x1C00 if you want to enable all hooks
    ; push eax
    ; push LockDownBrowser.CLDBDoSomeStuff()
    ; pop eax
    ; call eax

    ; below makes beep

    ; push ebp
    ; mov ebp, esp

    ; sub esp, 1ch
    ; xor eax, eax
    ; mov [ebp - 04h], eax
    ; mov [ebp - 08h], eax
    ; mov [ebp - 0ch], eax
    ; mov [ebp - 10h], eax
    ; mov [ebp - 14h], eax
    ; mov [ebp - 18h], eax
    ; mov [ebp - 1ch], eax

	; push 70656542h

    ; mov [ebp - 14h], esp

    ; xor ebx, ebx
    ; mov bl, 0x30
    ; mov eax, [fs:ebx]

    ; mov eax, [eax + 0ch]
    ; mov eax, [eax + 14h]
    ; mov ebx, eax
    ; mov eax, [ebx]
    ; mov ebx, eax
    ; mov eax, [ebx]
    ; mov eax, [eax -8h + 18h]

    ; mov ebx, eax
    ; mov edx, eax
    
    ; mov eax, [ebx + 3ch]
    ; add eax, ebx
    ; mov eax, [eax + 78h]
    ; add eax, ebx
    ; mov ecx, [eax + 14h]
    ; mov [ebp - 4h], ecx
    ; mov ecx, [eax + 1ch]
    ; add ecx, ebx
    ; mov [ebp - 8h], ecx
    ; mov ecx, [eax + 20h]
    ; add ecx, ebx
    ; mov [ebp - 0ch], ecx
    ; mov ecx, [eax + 24h]
    ; add ecx, ebx
    ; mov [ebp - 10h], ecx
    ; xor eax, eax
    ; xor ecx, ecx
    ; jmp findBeep

    findKernelAndExitHoop:
        jmp findKernelAndExitHoop2 

    findBeep:
        mov esi, [ebp - 14h]
        mov edi, [ebp - 0ch]
        cld
        mov edi, [edi + eax*4]
        add edi, ebx
        mov cl, 4
        repe cmpsb
        jz BeepFound
        inc eax
        cmp eax, [ebp - 4h]
        jne findBeep

    findKernelAndExitHoop2:
        jmp findKernelAndExitHoop3

    BeepFound:
        mov ecx, [ebp - 10h]
        mov edx, [ebp - 8h]
        mov ax, [ecx + eax * 2]
        mov eax, [edx + eax * 4]
        add eax, ebx
        ;jmp CallLoadLib

    CallBeep:
        xor edx, edx	
        push edx
        mov dx, 0x03e8
        push edx
        push edx
        ;push ecx
        call eax
        add esp, 4

    add esp, 1ch
    add esp, 0ch
    add esp, 4h
    pop ebp

    jmp findKernelAndExit
    
    findKernelAndExitHoop3:
        jmp findKernelAndExit

push ebp
mov ebp, esp
push eax
mov eax, 0xFFe14025
shl eax, 8
push eax
xor ebx, ebx
mov bl, 0x10
shl ebx, 0x18
mov bx, 0x10c0
push ebx
pop eax
call eax
xor ebx, ebx
mov bx, 0x1F4
push ebx
mov ebx, 0xFFbfd23c
shl ebx, 8
mov eax, [ebx]
call eax
pop eax
mov esp,ebp
pop ebp

findKernelAndExit:
    xor eax, eax
    xor ebx, ebx
    xor ecx, ecx
    xor edx, edx

    push ebp
    mov ebp, esp

    sub esp, 1ch
    xor eax, eax
    mov [ebp - 04h], eax
    mov [ebp - 08h], eax
    mov [ebp - 0ch], eax
    mov [ebp - 10h], eax
    mov [ebp - 14h], eax
    mov [ebp - 18h], eax
    mov [ebp - 1ch], eax

    mov edx, 6461FFFFh
    shr edx, 8
    shr edx, 8
    push edx
    push 65726854h
    push 74697845h

    mov [ebp - 14h], esp

    xor ebx, ebx
    mov bl, 0x30
    mov eax, [fs:ebx]

    mov eax, [eax + 0ch]
    mov eax, [eax + 14h]
    mov ebx, eax
    mov eax, [ebx]
    mov ebx, eax
    mov eax, [ebx]
    mov eax, [eax -8h + 18h]

    mov ebx, eax
    mov edx, eax

    mov eax, [ebx + 3ch]
    add eax, ebx
    mov eax, [eax + 78h]
    add eax, ebx
    mov ecx, [eax + 14h]
    mov [ebp - 4h], ecx
    mov ecx, [eax + 1ch]
    add ecx, ebx
    mov [ebp - 8h], ecx
    mov ecx, [eax + 20h]
    add ecx, ebx
    mov [ebp - 0ch], ecx
    mov ecx, [eax + 24h]
    add ecx, ebx
    mov [ebp - 10h], ecx
    xor eax, eax
    xor ecx, ecx

    findExitProcess:
        mov esi, [ebp - 14h]
        mov edi, [ebp - 0ch]
        cld
        mov edi, [edi + eax*4]
        add edi, ebx
        mov cl, 8
        repe cmpsb
        jz ExitProcFound
        inc eax
        cmp eax, [ebp - 4h]
        jne findExitProcess

    ExitProcFound:
        mov ecx, [ebp - 10h]
        mov edx, [ebp - 8h]
        mov ax, [ecx + eax * 2]
        mov eax, [edx + eax * 4]
        add eax, ebx
        ;jmp CallLoadLib

    CallExitProc:
        xor edx, edx	
        push edx			

        loopFunc:
        xor eax, eax
        xor ebx, ebx
        jmp loopFunc

        and esp, 0xFFFFFFF0
        xor edx, edx
        push edx
        call eax

    add esp, 1ch
    add esp, 0ch
    add esp, 4h
    pop ebp
    ret