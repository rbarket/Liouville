# loading auxillary functions for the data generator
# Set the current directory to where this file is located if the read function below does not work
read "liouville_functions.mpl";  # loads all functions in the mpl file

# Generate an (integrand, integral) pair through the Liouville method. 
# T: list of field extensions. The final item in the list is the top-level field extension which is the most important.
# r: An upper bound on the multiplicity of the denominator. It may be less than r if when doing the SFF, there are common terms.
liouville_gen := proc(T, r)	
	local prev_extensions, Q_list, coeff_list, log_list, N, D, A, B, F, cont, i, s, t, j, k:
	global theta:

	# Step 1: Generate polynomial factors
	prev_extensions := T[1..numelems(T)-1]:
	Q_list := generate_q(r, prev_extensions):
     Q_list := [seq(Q_list[i]^i, i=1..r)]:

	# Step 2: Squarefree factor the multiplied denominator factors
	# Squarefree would fail for input [x, sqrt(-5*x), sqrt(-5/x)]
	# with a reducible RootOf Error. T[2] = x*T[3] for x>0 and T[2] = -x*T[3] for x < 0
	try	
		D := sqrfree(mul(Q_list[i], i=1..numelems(Q_list)), theta):
	catch:
		return FAIL, FAIL;
	end;
	     
	cont := D[1]: # content from SF factorization
	Q_list := [seq(D[2][i][1]^(D[2][i][2]), i=1..numelems(D[2]))]: # Put Q_1, ..., Q_s into a list
	s := D[2][-1][2]: # the max degree
	D := cont*mul(Q_list):

	if simplify(eval(D, theta=T[-1]))=0 then print("T", T); return FAIL, FAIL; end if; # checking for 0, return FAIL
	
	# Step 3 Generate Numerator N. Degree should be at least 1 less than than the denominator
	t := max(s - rand(1..3)(), 0): # min degree 0 (no logs in numer), max degree is deg(denom)-1 
	N := generate_q(t, prev_extensions): # create t factors for the numerator
	N := mul([seq(N[i]^i, i=1..numelems(N))]):

	# Step 4: Select an integer j and generate j logarithms with distinct arguments from Q_list and j constants. j must be <= len(Q_list) 
	j := choose_int([6/10, 3/10, 1/10]): # prob. 0.6, 0.3, 0.1 to choose j=1, j=2, or j=3. Can modify or extend list
	j := min(j, numelems(Q_list)); # if j is bigger than the number of elements available, make j equal to that.
	coeff_list := [seq(rand_rational(5,3), i=1..j)]:

	Statistics:-Shuffle(Q_list, inplace=true):
	log_list := Q_list[1..j];
     if member(0, simplify(log_list)) then print("0 here in step 4", log_list); return FAIL, FAIL; end if; # checking for 0, return FAIL
	A := add(coeff_list[i]*log(log_list[i]), i=1..j):

	# Step 5: Select an integer k and generate k logarithms with distinct arguments NOT from Q_list and k constants. 
	k := choose_int([7/10, 2.5/10, 0.5/10]):
	coeff_list := [seq(rand_rational(5,3), i=1..k)]:
	log_list := generate_q(k, prev_extensions, require_theta=false):
	if member(0, simplify(log_list)) then print("0 here in step 5", log_list); return FAIL, FAIL; end if;  # checking for 0, return FAIL
	B := eval(add(coeff_list[i]*log(log_list[i]), i=1..k), theta=T[-1]):

	# Step 6: F= normal(N/D + A) + B
	F := eval(N/D + A, theta=T[-1]);
	return normal(diff(F,x)) + diff(B,x), normal(F) + B:
	
end proc: