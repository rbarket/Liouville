# These are auxillary functions used for the Liouville generator in liouville_generator.mpl


# Generate an elementary extension theta. Outside function will be a single function that is not nested. Inside
# function can be composed of previous elementary extensions. Need to add this functionality in
theta_generator := proc()
local outside_function, num_terms, p, f, g:
	

	# prob 0.9 of choosing elem. function, prob. 0.1 of choosing a special function
	p := rand(0..1.0)():
	if p <= 0.9 then
    		outside_function := [ln, exp, sin, cos, tan, sqrt]:
    	else
    		outside_function := [Li, erf]:
	end if:
	f := RandomTools:-Generate(choose(outside_function)):
	
    num_terms := choose_int([0.8,0.15,0.05]): # how many terms in the inner function g
    do
        g := randpoly(x, expons=rand(-1..2), coeffs=rand(-5..5), terms=num_terms):
    until has(g,x);
    
    # return a basic function for these edge cases
    if f=Li and g=1 then return Li(x); # Li(1) causes error
    elif f=ln and g=0 then return ln(x); #ln(0) is undefined
    elif f(g) = 0 then return ln(x); # 0 causes many errors so chose to return ln(x) by default
    elif has(f(g), sqrt(x^2)) then return sqrt(x): # edge case when f(g)=sqrt(x^2), causes error
    end if;
    
    return f(g):
    
end proc:


# Generate a random polynomial in the previous field. We set the number of terms to 1 for simplicity
rand_coeff := proc(prev_field, min_exp, max_exp)
  return randpoly(prev_field, expons=rand(min_exp..max_exp), coeffs=rand(-5..5), terms=1)
end proc:


rand_rational := proc(max_num, max_den:=1)
    # max_num: max int of the numerator
    # max_den: max int of the denominator
    local N, D;

    N := rand(1..max_num)():
    D := rand(1..max_den)(): 
    return N/D:
end proc:


# Generate linear factors in theta. Note that this deg. 2 and higher factors but we set them to linear for simplicity.
generate_q := proc(num_terms, prev_field, require_theta:=true)
    # num_terms: how many factors to generate
    # prev_field: what expressions can exist in the factor e.g. [x, ln(x)] would generate factors containing these expressions
    # require_theta: wether an expression must be of the form a(x)*theta + b(x) or wether it can be just b(x)
	local term, terms, i;
	terms := [];
	
	for i from 1 to num_terms do
		term := 0;
		
		if require_theta then # if coefficient of theta is 0, redo
		    while not has(term, theta) do:			
		     	# a(x)*theta + b(x) with min expon -1 and max 1 (min and max are a param that can be changed)
		     	term := rand_coeff(prev_field, rand(-1..0)(), rand(0..1)())*theta + rand_coeff(prev_field, rand(-1..0)(), rand(0..1)()); 
		    od:
		
		else  # for factors that dont necessarily require theta (can be just b(x))
			while term=0 do
				term := rand_coeff(prev_field, rand(-1..0)(), rand(0..1)())*theta + rand_coeff(prev_field, rand(-1..0)(), rand(0..1)());
			end do:
		end if:
		
		terms := [op(terms), term];
	end do:

	return terms;
end proc:


# Function for generating an integer, given a probability list. the list must sum to 1
# Each element in the probability list corresponds to the chance that position is the return value.
# E.g. [6/10, 3/10, 1/10] -> 60% chance to return 1, 30% chance to return 2, 10% chance to return 3
choose_int := proc(prob_list)
    local r, i, total_prob:

    # Check probability list sums to 1
    if add(prob_list)<>1 then 
    	    print("probability list does not equal 1"): 
    	    return FAIL: 
    end if:

    r := rand(0...1.0)():  # the probability that was chosen

    # iterate through the probability list until an integer is chosen that is below the total probability
    total_prob := 0:
    for i from 1 to numelems(prob_list) do
        total_prob += prob_list[i]: 
        if r <= total_prob then return i: end if: # return the index of the selected probability
    end do:

    print("made it out of for loop, error"):
    return None:
    
end proc:
