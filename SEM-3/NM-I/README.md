# Numerical Methods-I
Fortran source codes for some of Numerical method techniques taught.  

### Sequence of Algorithms
- Practice_eqns - Contains some basic Verilog Codes given in slides  
- gauss - Gauss Elimination Method
- Picards Iteration 
- Newton Raphson
- Linear Regression
- Newton's Interpolation
- Simpson's Rule  

## Compilation Instructions (Linux)  
Install *gfortran* compiler packages by typing,  
`$ sudo apt-get install gfortran`  
For Compiling a single fortran source file goto the respective directory and type,  
`$ gfortran <filename>.f95`  
For Compiling multiple files at once (Subroutines, functions written in another file),  
`$ gfortran <file1>.f95 <file2>.f95`  
Then an executable is generated, run the file by  
`$ ./a.out`  

## Editor Preferences  
I personally use **VSCode** editor which is a rich IDE supporting many languages. *Linting* and *Syntax Highlighting* for fortran is also available! To lint fortran in VSCode install [Modern Fortran](https://marketplace.visualstudio.com/items?itemName=krvajalm.linter-gfortran). Installing [Terminal](https://marketplace.visualstudio.com/items?itemName=formulahendry.terminal) makes it very easier to compile files using integrated terminal.


