    ORG 0
    
    LD A,0
    LD (0x810),A
lp:
    LD A,(0x810)
    INC A
    LD (0x810),A
    LD A,(0x810)
    OUT 0x22,A
    JR lp