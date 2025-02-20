BITS 32

section .text
global _start

_start:

    ;get kernel32 base address through peb
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

    ;create stack string "GetModuleHandleW" and store
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

    ;loop through kernel32 until matching function name is found
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

    ;store pointer to GetModuleHandle in eax
    GetModuleHandleFound:
        mov ecx, [ebp - 10h]
        mov edi, [ebp - 8h]
        mov ax, [ecx + eax * 2]
        mov eax, [edi + eax * 4]
        add eax, ebx

    ;create "LockDownBrowser.dll" argument and call GetModuleHandle
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

        mov ecx, esp
        xor ebx, ebx
        push ecx
        call eax
        add esp, 4

    add esp, 1ch
    add esp, 0ch
    add esp, 4h
    pop ebp

    ;if handle was returned (eax != 0), move to unhook; if no handle returned then exit
    xor ebx, ebx
    cmp eax, ebx
    jne callUnhookProcess
    jmp findKernelAndExit

    ;add unhook function offset to dll base address, set parameters (pointer to null values), and call
    callUnhookProcess:
        xor ebx, ebx
        push ebx
    
        mov bx, 0x156
        jmp skip

        ;calling allows us to put current frame pointer in eax; used for null value offset calculation
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
        add esp, 4

        ;on successful unhooking, clear registers and loop in memory (to be fixed later)
        xor eax, eax
        xor ebx, ebx
        xor ecx, ecx
        xor edx, edx
    
        loopFunc:
            xor eax, eax
            xor ebx, ebx
            jmp loopFunc

    ;to get frame pointer, jump and call necessary for avoiding null bytes in original call instruction
    skip:
        call get_eip

    ;get kernel32 address and find ExitThread function; exact same as  start but searching for "ExitThread"
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

        findExitThread:
            mov esi, [ebp - 14h]
            mov edi, [ebp - 0ch]
            cld
            mov edi, [edi + eax*4]
            add edi, ebx
            mov cl, 8
            repe cmpsb
            jz ExitThreadFound
            inc eax
            cmp eax, [ebp - 4h]
            jne findExitThread

        ExitThreadFound:
            mov ecx, [ebp - 10h]
            mov edx, [ebp - 8h]
            mov ax, [ecx + eax * 2]
            mov eax, [edx + eax * 4]
            add eax, ebx

        CallExitThread:
            xor edx, edx	
            push edx
            and esp, 0xFFFFFFF0
            xor edx, edx
            push edx
            call eax