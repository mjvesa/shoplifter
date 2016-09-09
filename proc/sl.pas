(*
 * Shoplifter
 *
 *  An esoteric concatentive programming language
 *
 *  Modified: 2015-8-12
 *)
program shoplifter;

uses SysUtils;

{$H+}
const
    LOGGING = false;
    MAX_WORD_COUNT = 1000;
    MAX_NESTING_LEVEL = 100;
    MAX_SOURCE_LENGTH = 100000;
    SINGLE_CHARS   = ['(', ')', '[', ']', '{', '}','''', '$', '#', '"'];

const
    TARGET_WORD = 0;
    SL_TO_SL_WORD = 1;

type
    WordDef  = record
        name    : string;
        target : integer;
    end;

var
    input           : string;
    inputIndex      : integer;
    line            : integer;
    scopes          : array [0..MAX_NESTING_LEVEL] of integer;
    scopeIndex      : integer;
    words           : array [0..MAX_WORD_COUNT] of WordDef;
    contents        : array [0..MAX_WORD_COUNT] of string;
    source          : array [0..MAX_SOURCE_LENGTH] of string;
    sourceLength    : integer;
    wordCount       : integer;
    current         : string;
    whitespace      : string;

procedure log(msg:string);
begin
    if LOGGING then writeln(msg);
end;


function hasNextWord:boolean;
begin
   hasNextWord :=  inputIndex <= length(input);
end;

function getNextWord:String;
var
    str : String;
begin
    whitespace := '';
    while (inputIndex <= length(input)) and (input[inputIndex] <= ' ') do begin
        whitespace := whitespace + input[inputIndex];
        inc(inputIndex,1);
    end;
    str := '';
    while (inputIndex <= length(input)) and (input[inputIndex] > ' ') and not (input[inputIndex] in SINGLE_CHARS) do begin
        str := str + input[inputIndex];
        inc(inputIndex,1);
    end;

    if (length(str) = 0) and (inputIndex <= length(input)) and (input[inputIndex] in SINGLE_CHARS) then begin
       str := input[inputIndex];
       inc(inputIndex, 1);
    end;

    getNextWord := str;
end;


function tokenize(word : string):integer;
var
    i       : integer;
    found   : boolean;
begin
    found := false;
    i := wordCount - 1;
    while (i >= 0)  and (found = false) do begin
        if words[i].name = word then begin
            found := true;
            break;
        end;
        dec(i, 1);
    end;
    tokenize := i;
end;

procedure loadSource(fileName : string);
var
    sourceFile : Text;
    line       : string;
    lineNum    : integer;
begin
    assign(sourceFile, fileName);
    reset(sourceFile);
    lineNum := 0;
    while not eof(sourceFile) do begin
        readln(sourceFile, line);
        source[lineNum] := line;
        inc(lineNum);
    end;
    close(sourceFile);
    sourceLength := lineNum;
end;

procedure appendInclude(name:string);
var
    include         : Text;
    oldLines        : array [0..MAX_SOURCE_LENGTH] of string;
    includeLength,i : integer;
    s               : string;
begin
    assign(include, name + '.sl');
    reset(include);
    includeLength := 0;
    while not eof(include) do begin
        inc(includeLength);
        oldLines[includeLength - 1] := source[line + includeLength - 1];
        log('Replacing: ' + source[line + includeLength - 1]);
        readln(include, s);
        source[line + includeLength - 1] := s;
    end;

    {Move lines downward by the include size}
    for i := 0 to sourceLength - line  - 2 do begin
        source[sourceLength  + includeLength - i - 1] := source[sourceLength - i - 1];
    end;

    {insert old source below the included stuff}
    for i := 0 to includeLength - 1 do begin
        log('Putting back: ' + oldLines[i]);
        source[line  + includeLength + i] := oldLines[i];
    end;
    inc(sourceLength, includeLength);

    for i := 0 to sourceLength - 1 do begin
        log('Source: ' + source[i]);
    end;
end;

procedure nextLine;
begin
    inc(line);
    inputIndex := 1;
    input := source[line - 1];
end;

procedure loadMacro(target : integer);
var
    running     : boolean;
    firstLine   : boolean;
    s, current  : string;
begin
    words[wordCount].name := getNextWord;
    words[wordCount].target := target;
    current := copy(input, inputIndex, length(input));
    nextLine;
    running := true;
    firstLine := true;
    log('Got macro ' + words[wordCount].name + ' of type ' + IntToStr(target));
    while running do begin
        s := getNextWord;
        if (s = ':') or (s = '===') or (s = '***') then begin
            log('Ending macro with ' + s);
            if (s = '===') then begin
                nextLine;
            end else begin
                inputIndex := 1;
            end;
            running := false;
        end else if s = ';;;' then begin
            nextLine;
        end else begin
            log('Macro line: ' + input);
            if firstLine then begin
                current := current + input;
                firstLine := false;
            end else begin
                current := current + #10 + input;
            end;
            nextLine;
        end;
    end;
    contents[wordCount] := current;
    inc(wordCount);
end;

procedure loadSingleTokenMacro;
begin
    words[wordCount].name := getNextWord;
    words[wordCount].target := SL_TO_SL_WORD;
    contents[wordCount] := getNextWord;
    inc(wordCount);
end;



procedure expandFile(fileName : string; targetFileName : string; platform : string);
var
    target  : Text;
    i       : integer;
    s       : string;

    procedure printWord(word :  string);
    var
        i :  integer;
    begin
        i := tokenize(word);
        if i < 0 then begin
            log('Unable to find ' +  word + ' in set of tokens');
            halt;
        end else begin
            write(target, contents[tokenize(word)]);
        end;
    end;
    procedure HandleString;
    begin
        printWord('str-pre');
        while (input[inputIndex] <> '"') do begin
            write(target, input[inputIndex]);
            inc(inputIndex);
        end;
        printWord('str-post');
        inc(inputIndex);
    end;

begin
    log('Expanding ' + fileName + ' to ' + targetFileName);
    loadSource(fileName);
    assign(target, targetFileName);
    rewrite(target);
    line := 0;
    appendInclude('target-' + platform);
    while (line <= sourceLength) do begin
        nextLine;
        while hasNextWord do begin
            s := getNextWord;
            write(target, whitespace);
            if (length(s) > 0) then begin
                if ((s[1] in ['0'..'9']) or ((s[1] = '-') and (s[2] in ['0'..'9']))) then begin
                    printWord('literal-prolog');
                    write(target, s);
                    printWord('literal-epilog');
                {TODO string management stuff here}
                end else if (S = '"') then begin
                    HandleString;
                end else if (s = 'begin-block') then begin
                    scopes[scopeIndex] := wordCount;
                    inc(scopeIndex);
                end else if (s = 'end-block') then begin
                    dec(scopeIndex);
                    wordCount := scopes[scopeIndex];
                end else if (s = ':') then begin
                    loadMacro(SL_TO_SL_WORD);
                end else if (s = '***') then begin
                    loadMacro(TARGET_WORD);
                end else if (s = '''') then begin
                    loadSingleTokenMacro;
                end else if (s= '$') then begin
                    appendInclude(getNextWord);
                    nextLine;
                end else if (s= '#') then begin
                    appendInclude('target-' + platform + '.' +  getNextWord);
                    nextLine;
                end else if (s = ';;;') then begin
                    while (inputIndex < length(input)) and (input[inputIndex] <> #10) do begin
                        inc(inputIndex);
                    end;
                    if inputIndex = length(input) then begin
                        nextLine;
                    end;
                end else begin
                    i := tokenize(s);
                    log('Expanding ' + s);
                    if (i < 0) then begin
                            write(target, ' ' + s + ' ');
                    end else begin
                        if (words[i].target = TARGET_WORD) then begin
                            write(target, contents[i]);
                        end else begin
                            input := contents[i] + copy(input, inputIndex, length(input));
                            inputIndex := 1;
                        end;
                    end;
                end;
            end;
        end;
        writeln(target);
    end;
    close(target);
end;

begin
    if (paramCount = 3) then begin
        wordCount := 0;
        scopeIndex := 0;
        ExpandFile(paramstr(1), paramstr(2), paramstr(3));
    end else begin
        writeln('Invocation: sl <source> <target> <platform>');
    end;
end.
