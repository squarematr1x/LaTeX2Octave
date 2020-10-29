function out = latex2oct(in)
  ## -- latex2octave (S)
  ##     Convert input LaTex string S to normal string
  ##     Resulting string can be copied to perform numerical calculations
  
  symbols = {"\^", "\cdot", "\times", "\div", "\left", "\right", " ", "{", "}"};
  oct_symbols = {"^", "*", "*", "/", "", "", "", "(", ")"};
  
  functions = {"\pi", "\sin", "\cos", "\tan", "\log", "\ln", "\sqrt", "\frac"};
  oct_functions = {"`","@sin@", "@cos@", "@tan@", "@log10@", "@log@", "@sqrt@", "@frac@"};
  
  assert(ischar(in), "Input must be a string")
  assert(!MissingBrackets(in), "Input string is missing parenthesis")
  assert(length(symbols) == length(oct_symbols), "Error with symbols")
  assert(length(symbols) == length(oct_symbols), "Error with functions")
  
  for i=1:length(symbols)
    in = strrep(in, symbols{i}, oct_symbols{i});
  endfor

  for i=1:length(functions)
    in = strrep(in, functions{i}, oct_functions{i});
  endfor
  
  in = HandleFractions(in);
  in = HandleRoots(in);
  in = AddMulSign(in);
  in = RemoveFunctionToken(in);
  in = RemovePiToken(in);
  
  out = in;
endfunction

function out = MissingBrackets(in)
  n = length(in);
  left_brackets = 0;
  right_brackets = 0;
  
  for i=1:n
    if in(i) == '(' || in(i) == '{' || in(i) == '['
      left_brackets++;
    elseif in(i) == ')' || in(i) == '}' || in(i) == ']'
      right_brackets++;
    endif
  endfor
  
  out = abs(left_brackets-right_brackets); 
endfunction

function out = AddMulSign(in)
  new_string = "";
  operators = {'(','+','-','^','*','/',',',')','@'};
  n = length(in);
  inside_func_str = 0;

  for i=1:n 
    new_string(end+1) = in(i);  
    if i < n  
      if in(i) == '@'
        inside_func_str = !inside_func_str;
      elseif in(i+1) == '(' && all(strcmp(in(i), operators(1:end-2)) == 0)
        new_string(end+1) = '*';
      elseif in(i) == ')' && all(strcmp(in(i+1), operators(2:end)) == 0)
        new_string(end+1) = '*';
      elseif !inside_func_str
        if isalpha(in(i)) 
          if isalpha(in(i+1))
            new_string(end+1) = '*';
          elseif isdigit(in(i+1))
            new_string(end+1) = '*';  
          elseif IsPi(in(i+1))
            new_string(end+1) = '*';
          endif  
        elseif isdigit(in(i))
          if isalpha(in(i+1))      
            new_string(end+1) = '*';
          elseif IsPi(in(i+1))
            new_string(end+1) = '*';
          endif
        elseif IsPi(in(i))
          if isalpha(in(i+1))
            new_string(end+1) = '*';
          elseif isdigit(in(i+1))
            new_string(end+1) = '*';
          elseif IsPi(in(i+1))
            new_string(end+1) = '*';
          endif
        elseif (isdigit(in(i)) || isalpha(in(i)) || IsPi(in(i))) && in(i+1) == '@'
          new_string(end+1) = '*';
        endif
      endif  
    endif  
  endfor
  
  out = new_string;
endfunction

function out = IsPi(t)
  token_found = 0;
  
  if t == '`'
    token_found = 1;
  endif
  
  out = token_found;
endfunction

# Convert \frac{a}{b} to a/b
function out = HandleFractions(in)
  n = length(in);
  fraction_found = 0;
  new_str = "";
  i = 1;
  
  while i <= n
    if IsFraction(in, i)      
      fraction_found = 1;
      i += 6;
    elseif fraction_found && i+1 <= n && in(i:i+1) == ")("
      new_str(end+1:end+3) = ')/(';
      fraction_found = 0;
      i += 2;
    else
      new_str(end+1) = in(i);
      i++;
    endif
  endwhile
  
  out = new_str;
endfunction

function out = IsFraction(in, index=1)
  n = length(in);
  i = index;
  out = 0;
  
  if i + 5 <= n
    matches = (in(i:i+5) == "@frac@");
    out = all(matches > 0);
  endif
endfunction

# Convert \sqrt[a]{b} to nthroot(b,a)
function out = HandleRoots(in)
  i = 1;
  n = length(in);
  root_found = 0;
  exp_found = 0;
  exp_str = "";
  
  while i <= n
    if IsNthRoot(in, i)
      root_found = 1;
      i += 6;
    elseif root_found && in(i) == '['
      new_str(end+1:end+10) = "@nthroot@(";
      exp_found = 1;
      i++;
      while in(i) != ']'
        exp_str(end+1) = in(i);
        i++;
      endwhile
      root_found = 0;
      i++;
    elseif exp_found && in(i) == '('
      new_str(end+1) = in(i);   
      left_brackets = 1;
      right_brackets = 0;
      i++;
      while left_brackets-right_brackets != 0
        new_str(end+1) = in(i);      
        if in(i) == '('
          left_brackets++;
        elseif in(i) == ')'
          right_brackets++;
        endif         
        i++; 
      endwhile
      new_str(end+1) = ',';
      new_str(end+1:end+length(exp_str)) = exp_str;
      new_str(end+1) = ')';
      exp_found = 0;
    else
      new_str(end+1) = in(i);
      i++;
    endif
  endwhile
  
  out = new_str;
endfunction

function out = IsNthRoot(in, index=1)
  n = length(in);
  out = 0;
  
  if index + 6 <= n
    matches = (in(index:index+6) == "@sqrt@[");
    out = all(matches > 0);
  endif
endfunction

function out = RemoveFunctionToken(in)
  out = strrep(in, '@', '');
endfunction

function out = RemovePiToken(in)
  out = strrep(in, '`', "pi");
endfunction
