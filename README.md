# Generating Elementary Integrable Expressions
Maple Implementation of the paper "The Liouville Generator for Producing Integrable Expressions" (to be published).

## How to use

This repository contains code for the data generation method of generating (integrand, integral) pairs associated with the paper along with a curated dataset that is generated from the method.
The function `liouville_gen(T, r)` from the file `liouville_generator.mpl` will generate a (integrand, integral) pair for a given list of extensions `T` and a multiplicity `r` .
The file `create_dataset.mpl` will create a set number examples and store them JSON format.

Although the main function only has two arguments, it relies on many auxillary functions from `liouville_functions.mpl`.

## Data
A dataset of 10,000 (integrand, integral) pairs is available in `JSON` format from the file `dataset.json`. These can be directly read as Maple expressions using the `parse` command in Maple or to Python SymPy Expressions using the `sympify` command. This dataset is in normalised form. In the near future, there will be a dataset in partial fraction notation.

If you wish to convert a maple expression to prefix notation, or vice versa, use the file `maple_prefix_converter.mpl`. This Maple file will convert between the two notations.

## Figures
To recreate Figure 1 from the paper, use the folder `Liouville vs FWD vs BWD`. The Python notebook `Compare Liouville FWD BWD.ipynb` will load in the data and recreate the figure as shown in the paper. For the Liouville data, each data point in the list of the form [[integrand_normalised, integral_normalised], [integrand_PF, integral_PF]]. This data has already been converted to prefix notation for ease of measure the numer of tokens.

To recreate Figure 2, use the folder `Normalised vs PF` and load the Python notebook `Compare_Normal_and_PF.ipynb`. Like above, data is of the form [[integrand_normalised, integral_normalised], [integrand_PF, integral_PF]] and already in prefix notation.
