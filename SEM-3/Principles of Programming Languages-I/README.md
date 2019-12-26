# POPL-I  
Contains codes implemented in *Eiffel* Language.  

### Sequence  
- 1 - Chinese Remainder Theorem
- 2 - HeapSort

## Compilation Instructions (Linux)   

- First, install Eiffel Compiler Packages by typing,  
``` 
$ sudo add-apt-repository ppa:eiffelstudio-team/ppa
$ sudo apt-get update 
$ sudo apt-get install eiffelstudio
```  
For compiling eiffel files, goto respective directory and type,  
`$ ec application.e`  
It generates some Eiffel files. Generally while compiling through command line It ignores all the contract conditions. To avoid that, we should add  
```
<option warning="true">
			<assertions precondition="true"  postcondition="true" check="true"  invariant="true" loop="true" supplier_precondition="true"/>
		</option>
```  
this to the .ecf file generated. This makes sure to Run with written contract conditons.  
The .ecf file after adding looks like ![Compilation instructions](https://github.com/akashtadwai/IITH-BTech-ES-Courses/blob/master/SEM-3/Principles%20of%20Programming%20Languages-I/compilation%20instructions.jpg)

To run the file we should change grant some permissions if necessary by typing,  
`$ chmod +x ./application`  
Now to run the program for given inputs in particular format type,  
`$ ./application`  
