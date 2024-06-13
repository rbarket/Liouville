# File for creating a dataset with the Liouville Generator
# We create 10,000 samples for visualisation purposes

read "liouville_generator.mpl":

NUM_SAMPLES:= 10000:
A := Array[1..NUM_SAMPLES]: # Store Samples in an Array

for j from 1 to NUM_SAMPLES do 

    num_extensions := choose_int([0.8,0.15,0.05]):
    T := [x,seq(theta_generator(), i=1..num_extensions)];
    multiplicity := choose_int([0.8,0.15,0.05]):

    integrand, integral := liouville_gen(T, 1);
    while integrand = FAIL do
        integrand, integral := liouville_gen(T, 1);
    end do:

    A[j] := [integrand, integral]:

end do:

A_string := map(x -> map(y -> convert(y, string), x), A):
Export("dataset.json", convert(A_string, list)):
 print("complete"):
    