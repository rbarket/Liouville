# Generating Elementary Integrable Expressions
Maple Implementation of the paper "The Liouville Generator for Producing Integrable Expressions" (to be published).

## How to use

This repository contains code for the data generation method of generating (integrand, integral) pairs associated with the paper along with a curated dataset that is generated from the method.
The function `liouville_gen(T, r)` from the file `liouville_generator.mpl` will generate a (integrand, integral) pair for a given list of extensions `T` and a multiplicity `r` .
The file `create_dataset.mpl` will create a set number examples and store them JSON format.

Although the main function only has two arguments, it relies on many auxillary functions from `liouville_functions.mpl`. 

TODO: Add descriptions of these auxillary functions in the readme
TODO: Add uses of the dataset from other research papers
TODO: Separate the dataset into different multiplicities and whether they contain special functions
