parse_expr := proc(expr)
	# this function deals with the case when then expr is not a leaf. First extract the operator, 
	# then do a recursive call on the left and (if binary op) right children of the operator. Combine all at the end
	
	local parse_list, i, left_child, right_child;
	# print("current expr", expr);
	parse_list := [];
	
		if op(0,expr)=`+` then parse_list := [op(parse_list), "add"];
		elif op(0,expr)=`*` then parse_list := [op(parse_list), "mul"];
		elif op(0,expr)=`^` then parse_list := [op(parse_list), "pow"];
		elif op(0,expr)=Fraction then parse_list := [op(parse_list), "div"];	
		
		elif op(0,expr)=arccos then parse_list := [op(parse_list), "acos"];
		elif op(0,expr)=arctan then parse_list := [op(parse_list), "atan"];
		elif op(0,expr)=arcsin then parse_list := [op(parse_list), "asin"];
		elif op(0,expr)=arccot then parse_list := [op(parse_list), "acot"];
		elif op(0,expr)=arcsec then parse_list := [op(parse_list), "asec"];
		elif op(0,expr)=arccsc then parse_list := [op(parse_list), "acsc"];

		
		elif op(0,expr)=arccosh then parse_list := [op(parse_list), "acosh"];
		elif op(0,expr)=arctanh then parse_list := [op(parse_list), "atanh"];
		elif op(0,expr)=arcsinh then parse_list := [op(parse_list), "asinh"];
		elif op(0,expr)=arccoth then parse_list := [op(parse_list), "acoth"];
		elif op(0,expr)=arcsech then parse_list := [op(parse_list), "asech"];
		elif op(0,expr)=arccsch then parse_list := [op(parse_list), "acsch"];	
									
		else parse_list := [op(parse_list), convert(op(0,expr), string)]; # unary operators
		end if;

     	left_child := maple_to_prefix(op(1,expr));
     	
     	
     	if nops(expr)>1 then

     		if op(0,expr)=`+` then
				right_child := maple_to_prefix(add( [op(2..nops(expr),expr)] ));
			elif op(0,expr)=`*` then
     			right_child := maple_to_prefix(mul( [op(2..nops(expr),expr)] ));
     		else	
				right_child := maple_to_prefix( op(2,expr) );
			end if;
			
		else
			right_child := []; # unary function, dealt with left child
     	end if;
     		
     	# print("LEFT", left_child, "RIGHT", right_child);
     	parse_list := [op(parse_list), op(left_child), op(right_child)];

	return parse_list
end proc:


maple_to_prefix := proc(expr)
    # converts a maple expression to prefix notation
	# based on https://www.geeksforgeeks.org/convert-infix-prefix-notation/
	local expr_str;
	
	expr_str := convert(expr, string); 
	if type(expr, symbol) or evalb(expr=I) or evalb(expr=Pi) then 
		return [expr_str];
	elif type(expr, integer) then
		if expr < 0 then 
			return ["INT-", convert(abs(expr), string)];
		else
			return ["INT+", convert(expr, string)];
		end if;
	else  
		return parse_expr(expr);
	
	end if;
end proc:

prefix_to_maple := proc(my_list)
    # Converts a prefix notation expression (list of strings) to a maple type expression
	# Based on https://www.geeksforgeeks.org/prefix-infix-conversion/
	local L, ss, bot, binops, i, j, expr;

	L := ListTools:-Reverse(my_list);
	
	ss := stack[new]();
	binops := ["add", "sub", "mul", "div", "pow"];
	bot := table(zip(`=`,binops,[`+`, `-`, `*`, `/`, `^`]));
	
	for i in L do:
        # cases where node is a leaf
		if i = "x" then
	          stack[push](x, ss);
	     elif i = "Pi" then
	     	stack[push](Pi, ss);
	     elif i = "E" then
	     	stack[push](exp(1), ss);
	     elif i = "I" then
	     	stack[push](I, ss);
	     elif StringTools:-IsDigit(i) then
	        	stack[push](i, ss);
	     elif i = "INT+" then
	     	expr := [];
	     	while not stack[empty](ss) and type(stack[top](ss), string) do
	     		expr := [op(expr),stack[pop](ss)];
	     	end do:
	     	expr := parse(cat(seq(convert(j, string), j in expr))); # combines all strings in expr

	     	stack[push](expr, ss);   
	      elif i = "INT-" then
	     	expr := [];

	     	while not stack[empty](ss) and type(stack[top](ss), string) do
	     		expr := [op(expr),stack[pop](ss)];

	     	end do:
	     	expr := parse(cat(seq(convert(j, string), j in expr))); # combines all strings in expr

	     	stack[push](-expr, ss);
        
        # unary operators
		elif i in binops then
			expr := bot[i](stack[pop](ss),stack[pop](ss));
			stack[push](expr,ss);
		elif i="abs" then
			expr := abs(stack[pop](ss));
			stack[push](expr, ss);
		elif i[1] = "a" and i <> "abs" then
			expr := convert(cat("arc",i[2..-1]),'name')(stack[pop](ss));
			stack[push](expr, ss);
		
        # binary operators
        else
			expr := convert(i, 'name')(stack[pop](ss));
			stack[push](expr, ss);
		end if:	
	end do:

	return stack[pop](ss);

end proc: