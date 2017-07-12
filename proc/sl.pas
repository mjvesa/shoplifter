(*
 * Shoplifter
 *
 *  An esoteric concatentive programming language
 *
 *  Modified: 2017-5-5
 *)
program shoplifter;

uses SysUtils;

{$H+}
const
  LOGGING           = true;
  HEAP_SIZE         = 1000;
  MAX_WORD_COUNT    = 1000;
  MAX_NESTING_LEVEL = 100;
  MAX_SOURCE_LENGTH = 100000;
  STACK_DEPTH       = 100;
  SINGLE_CHARS      = ['(', ')', '[', ']', '{', '}','''', '$', '#', '"','\'];

var
  input         : string;
  inputIndex    : integer;
  line          : integer;
  scopes        : array [0..MAX_NESTING_LEVEL] of integer;
  scopeIndex    : integer;
  words         : array [0..MAX_WORD_COUNT] of string;
  contents      : array [0..MAX_WORD_COUNT] of string;
  source        : array [0..MAX_SOURCE_LENGTH] of string;
  heap          : array [0..HEAP_SIZE] of string;
  ds            : array [0..STACK_DEPTH] of string;
  sp            : integer;
  sourceLength  : integer;
  wordCount     : integer;
  s             : string;

procedure log(msg:string);
begin
  if LOGGING then writeln(msg);
end;

procedure push(s:string);
begin
  log('pushing "' + s + '"');
  inc(sp); 
  ds[sp]:=s;
end;

procedure decsp;
begin
  dec(sp);
  log('SP decreased to ' + IntToStr(sp));
end;


function hasNextWord:boolean;
begin
  hasNextWord:=inputIndex<=length(input);
end;

function getNextWord:String;
var
  str : String;
begin
  while (inputIndex <= length(input)) and (input[inputIndex] <= ' ') do begin
    inc(inputIndex,1);
  end;
  str := '';
  while (inputIndex <= length(input)) and (input[inputIndex] > ' ')
        and not (input[inputIndex] in SINGLE_CHARS) do begin
    str := str + input[inputIndex];
    inc(inputIndex,1);
  end;

  if (length(str) = 0) and (inputIndex <= length(input)) and (input[inputIndex] in SINGLE_CHARS) then begin
    str := input[inputIndex];
    inc(inputIndex, 1);
  end;

  getNextWord := str;
end;

function tokenize(str : string):integer;
var
  i     : integer;
  found : boolean;
begin
  found := false;
  i := wordCount - 1;
  while (i >= 0)  and (found = false) do begin
    if words[i] = str then begin
      found := true;
      break;
    end;
    dec(i, 1);
  end;
  log('- ' + str + ' i: ' + IntToStr(i));
  tokenize := i;
end;

procedure LoadSource(fileName : string);
var
  sourceFile : Text;
  line       : string;
  lineNum    : integer;
begin
  assign(sourceFile, fileName);
  reset(sourceFile);
  lineNum:=0;
  while not eof(sourceFile) do begin
    readln(sourceFile,line);
    source[lineNum]:=line;
    inc(lineNum);
  end;
  close(sourceFile);
  sourceLength:=lineNum;
end;

procedure AppendToInput(s:string);
begin
  input:=s+copy(input,inputIndex,length(input));
  inputIndex:=1;
end;

procedure appendInclude(name:string);
var
  include         : Text;
  oldLines        : array [0..MAX_SOURCE_LENGTH] of string;
  includeLength,i : integer;
  s               : string;
begin
  log('Appending include ' + name + '.sl');
  assign(include, name + '.sl');
  reset(include);
  includeLength := 0;
  while not eof(include) do begin
    inc(includeLength);
    oldLines[includeLength - 1] := source[line + includeLength - 1];
{    log('Replacing: ' + source[line + includeLength - 1]);}
    readln(include, s);
    source[line + includeLength - 1] := s;
  end;
  {Move lines downward by the include size}
  for i := 0 to sourceLength - line  - 2 do begin
    source[sourceLength  + includeLength - i - 1] := source[sourceLength - i - 1];
  end;
  {insert old source below the included stuff}
  for i := 0 to includeLength - 1 do begin
{    log('Putting back: ' + oldLines[i]);}
    source[line  + includeLength + i] := oldLines[i];
  end;
  inc(sourceLength, includeLength);
{  for i := 0 to sourceLength - 1 do begin
    log('Source: ' + source[i]);
  end;}
end;

procedure nextLine;
begin
    inc(line);
    inputIndex := 1;
    input := source[line - 1];
end;

procedure LoadMacro;
var
  running     : boolean;
  firstLine   : boolean;
  s, current  : string;
begin
  words[wordCount]:=getNextWord;
  current:=copy(input, inputIndex, length(input));
  nextLine;
  running:=true;
  firstLine:=true;
  log('Got macro ' + words[wordCount]);
    while running do begin
        s := getNextWord;
        if (s = ':') or (s = '===') then begin
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

procedure LoadSingleTokenMacro;
begin
  words[wordCount]:=getNextWord;
  contents[wordCount]:=getNextWord;
  inc(wordCount);
end;

procedure ExpandFile(fileName : string; targetFileName : string; platform : string);
var
  target  : Text;
  i       : integer;
  {s,} tmp  : string;
  
  procedure HandleString;
  var
    s : string;
  begin
    s:='';
    while (input[inputIndex] <> '"') do begin
      if (input[inputIndex]='\') then begin
        inc(inputIndex);
      end;
      s:=s+input[inputIndex];
      inc(inputIndex);
    end;
    inc(inputIndex);
    push(s);
  end;

begin
  Log('Expanding ' + fileName + ' to ' + targetFileName);
  LoadSource(fileName);
  assign(target, targetFileName);
  rewrite(target);
  line := 0;
  appendInclude('target-' + platform);
  while (line <= sourceLength) do begin
    nextLine;
    while hasNextWord do begin
      s := getNextWord;
      if (length(s) > 0) then begin
        i := tokenize(s);
        if (i >= 0) then begin
          appendToInput(contents[i]);
        end else if (S = '"') then begin
          HandleString;
        end else if (s = 'begin-block') then begin
          scopes[scopeIndex] := wordCount;
          inc(scopeIndex);
        end else if (s = 'end-block') then begin
          dec(scopeIndex);
          if (scopeIndex<0) then begin
            writeln('Scope error!'); halt;
          end;
          wordCount := scopes[scopeIndex];
        end else if (s = ':') then begin
          loadMacro();
        end else if (s = '''') then begin
          loadSingleTokenMacro;
        end else if (s= '$') then begin
          appendInclude(getNextWord);
          nextLine;
        end else if (s= '#') then begin
          appendInclude('target-' + platform + '.' +  getNextWord);
          nextLine;
        end else if (s = ';;;') then begin
          while (inputIndex < length(input)) 
            and (input[inputIndex] <> #10) do begin
            inc(inputIndex);
          end;
          if inputIndex = length(input) then begin
              nextLine;
          end;
        end else if (s = '_aload') then begin
          ds[sp]:=heap[StrToInt(ds[sp])];
        end else if (s = '_astore') then begin
          heap[StrToInt(ds[sp])]:=ds[sp-1];
          decsp; decsp;
        end else if (s = '_add') then begin
          ds[sp-1]:=IntToStr(StrToInt(ds[sp-1])+StrToInt(ds[sp]));
          decsp;
        end else if (s = '_sub') then begin
          ds[sp-1]:=IntToStr(StrToInt(ds[sp-1])-StrToInt(ds[sp]));
          decsp;
        end else if (s = '_print') then begin
          write(target, ds[sp]);
          decsp();
        end else if (s = '_println') then begin
          writeln(target, ds[sp]);
          decsp();
        end else if (s = '_dup') then begin
          inc(sp); ds[sp]:=ds[sp-1];
        end else if (s = '_swap') then begin
          tmp:=ds[sp]; ds[sp]:=ds[sp-1];
          ds[sp-1]:=tmp;
        end else if (s = '_rot') then begin
          tmp:=ds[sp-2]; ds[sp-2]:=ds[sp-1];
          ds[sp-1]:=ds[sp]; ds[sp]:=tmp;
        end else if (s = '_cat') then begin
          ds[sp-1]:=ds[sp-1]+ds[sp]; decsp;
        end else if (s = '_drop') then begin
          decsp;
        end else begin
          push(s); {Use as-is}
        end;
      end;
    end;
  end;
  close(target);
end;

begin
  if (paramCount = 3) then begin
    wordCount := 0;
    scopeIndex := 0;
    sp := 0;
    ExpandFile(paramstr(1), paramstr(2), paramstr(3));
  end else begin
    writeln('Invocation: sl <source> <target> <platform>');
  end;
end.
