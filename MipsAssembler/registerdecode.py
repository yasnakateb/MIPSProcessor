# dictionary used to contain register numeric values
registers = {
    "$zero" : 0,
    "$at" : 1,
    "$v0" : 2,
    "$v1" : 3,
    "$a0" : 4,
    "$a1" : 5,
    "$a2" : 6,
    "$a3" : 7,
    "$t0" : 8,
    "$t1" : 9,
    "$t2" : 10,
    "$t3" : 11,
    "$t4" : 12,
    "$t5" : 13,
    "$t6" : 14,
    "$t7" : 15,
    "$s0" : 16,
    "$s1" : 17,
    "$s2" : 18,
    "$s3" : 19,
    "$s4" : 20,
    "$s5" : 21,
    "$s6" : 22,
    "$s7" : 23,
    "$t8" : 24,
    "$t9" : 25,
    "$k0" : 26,
    "$k1" : 27,
    "$gp" : 28,
    "$sp" : 29,
    "$fp" : 30,
    "$ra" : 31
}


def reg_decode(func_type, instr, regs):
    
    #execution for r-type functions
    if func_type == "r":   
        
        #standard r-type MIPS instructions              
        try:   
            #return[      rs,                 rt,               rd,          shamt]    
            return[registers[regs[1]], registers[regs[2]], registers[regs[0]], 0]
        except:
            return None


    #execution for i-type functions
    elif func_type == "i":
        
        
        #special case for lw, sb, sw, ll sc
        if (instr == "lw") or  (instr == "sw"):
            try:
                if len(regs[1]) > 1 and regs[1][1] == "x":
                    imm = int(regs[1], base=16)
                else:
                    imm = int(regs[1])
            
                #return[       rs,                rt        ,  immediate  ]      
                return[registers[regs[2]], registers[regs[0]], imm]
            except:
                return None
                          
        
        #standard i-type MIPS instructions    
        try:
            if len(regs[2]) > 1 and regs[2][1] == "x":
                imm = int(regs[2], base=16)
            else:
                imm = int(regs[2])
        
            #return[        rs                 rt             immediate ]
            return [registers[regs[1]], registers[regs[0]], imm]
        except:
            return None       
        
    
    #execution for j-type functions
    elif func_type == "j":   
        try:
            if len(regs[0]) > 1 and regs[0][1] == "x":
                imm = int(regs[0], base=16)
            else:
                imm = int(regs[0])        
                 
            #return [ immediate ]
            return [imm]
        except:
            return None    
    
    else:
        return None      