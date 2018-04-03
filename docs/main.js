var opcodes = [];

var types = {
    "int": {
        "regex": /[0-9]+/, fun: (token) =>
        {
            return token;
        }
    },
    "reg": {
        "regex": /[A-F]/, fun: (token) =>
        {
            return registerToNumber(token);
        }
    },
    "var": {
        "regex": /\$[0-9]+/, fun: (token) =>
        {
            return token.substring(1);
        }
    },
    "line": {
        "regex": /([0-9]+|:[A-Za-z][A-Za-z0-9]*)/, fun: (token) =>
        {
            return lineNumberMarker(token);
        }
    },
    "*": {
        "regex": /.*/, fun: (token) =>
        {
            return token;
        }
    }
};

function registerToNumber(reg)
{
    if (reg == undefined) {
        return 0;
    }
    return reg.charCodeAt(0) - 65;
}

function lineNumberMarker(line)
{
    return "<" + line + ">";
}


String.prototype.insert = function (index, string)
{
    if (index > 0) {
        return this.substring(0, index) + string + this.substring(index, this.length);
    } else {
        return string + this;
    }
};


function translateToBytes(text)
{

    const standardReturn = function (tokens, opcode)
    {
        var r = "";
        var j = 1;
        for (let p in opcode.params) {
            r += types[opcode.params[p]].fun(tokens[j]) + " ";
            j++;
        }

        return opcode.byte + " " + r;
    };

    const validOP = function (tokens)
    {
        for (let i = 1; i < tokens.length; i++) {
            if (!tokens[i].match(types[opcodes[tokens[0]].params[i - 1]].regex)) {
                return false
            }
        }
        return true;
    };

    let returnString = "";

    let jumpList = [];
    let lineNumber = 0;

    const lines = text.split(/\n/);

    for (let i = 0; i < lines.length; i++) {
        const tokens = lines[i].trim().split(/\s/);

        if (opcodes[tokens[0]] != undefined && validOP(tokens)) {
            const opcode = opcodes[tokens[0]];

            if (opcode.return != undefined) {
                returnString += opcode.return(tokens, opcode);
            } else {
                returnString += standardReturn(tokens, opcode);
            }

            returnString += "\n";
        } else {

            if (tokens[0].startsWith(":")) {
                if (jumpList[tokens[0]] == undefined) {
                    jumpList[tokens[0]] = lineNumber;
                }
            } else {
                returnString += opcodes["NOP"].byte;
                returnString += "\n";
            }
        }
        lineNumber++;
    }

    for (let key in jumpList) {
        const regex = new RegExp(lineNumberMarker(key), 'g');
        returnString = returnString.replace(regex, jumpList[key]);
    }

    return returnString;
}

function genJava()
{
    let l = "public enum OPCODE{\n";
    for (let op in opcodes) {
        let code=opcodes[op];
        l += op + " = " + code.byte + ";\n";
    }
    l += "}";
    return l;
}


function download(filename, text)
{
    var pom = document.createElement('a');
    pom.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(text));
    pom.setAttribute('download', filename);

    if (document.createEvent) {
        var event = document.createEvent('MouseEvents');
        event.initEvent('click', true, true);
        pom.dispatchEvent(event);
    }
    else {
        pom.click();
    }
}


