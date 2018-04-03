/*
 * JMP= 1;
 * JNZ= 2;
 * JEZ= 3;
 * 
 * ADD=  4;
 * SUB=  5;
 * MUL=  6;
 * DIV=  7;
 * AND=  8;
 * OR =  9;
 * XOR=  10;
 * INC=  11;
 * DEC=  12;
 * 
 * ADDm= 13;
 * 
 * PUSH=14;
 * POP =15;
 * 
 * LOAD=16;
 * SAVE=17;
 * 
 * RESET=126;
 * HALT=127;
 * RESUME=128;
 */


//{"byte":1,"params":[],"return"=function()}
opcodes["error"] = {
    "byte": -1,
    "params": [],
    "java": "",
    "return": () =>
    {
        return -1;
    }
};
opcodes["NOP"] = {"byte": 0, "params": [], "java": ""};
opcodes["JMP"] = {"byte": 1, "params": ["line"]};
opcodes["JNZ"] = {"byte": 2, "params": ["reg", "line"]};
opcodes["JEZ"] = {"byte": 3, "params": ["reg", "line"]};
opcodes["ADD"] = {"byte": 4, "params": ["reg", "var"]};
opcodes["SUB"] = {"byte": 5, "params": ["reg", "var"]};
opcodes["MUL"] = {"byte": 6, "params": ["reg", "var"]};
opcodes["DIV"] = {"byte": 7, "params": ["reg", "var"]};
opcodes["AND"] = {"byte": 8, "params": ["reg", "var"]};
opcodes["OR"] = {"byte": 9, "params": ["reg", "var"]};
opcodes["XOR"] = {"byte": 10, "params": ["reg", "var"]};
opcodes["INC"] = {"byte": 11, "params": ["reg"]};
opcodes["DEC"] = {"byte": 12, "params": ["reg"]};
opcodes["ADDm"] = {"byte": 13, "params": ["reg", "var"]};
opcodes["PUSH"] = {"byte": 14, "params": ["reg"]};
opcodes["POP"] = {"byte": 15, "params": ["reg"]};
opcodes["LOAD"] = {"byte": 16, "params": ["reg", "var"]};
opcodes["SAVE"] = {"byte": 17, "params": ["reg", "var"]};

opcodes["RESET"] = {"byte": 126, "params": []};
opcodes["HALT"] = {"byte": 127, "params": []};
opcodes["RESUME"] = {"byte": 128, "params": []};