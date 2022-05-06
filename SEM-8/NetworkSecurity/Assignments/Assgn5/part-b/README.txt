
If using Colab:
	1. Directly upload the notebook in Google Colab and verify the notebook
	2. All the data analysis is done with pandas_profling and html files are attached.

Instructions for running Locally:

1. Install Python Virtual Environment Manager by 
    $ pip3 install virtualenv

2. Create a new Python Virtual Environment by 
    $ python3 -m venv ~/netsec   

3. Activate the shell by 
    $ source ~/netsec/bin/activate

4. Install all the requirements by 
    $ pip3 install -r requirements.txt

5. To run jupyter notebook on local server with virtualenv follow 
        https://janakiev.com/blog/jupyter-virtual-envs/ 
        and add netsec as virtualenv to jupyter notebook 

        Steps:
	    - Goto the ~ directory 
            - $ pip3 install --user ipykernel
            - $ cd ~ && python3 -m ipykernel install --user --name=netsec

6. Go to the Root directory of the project & 
    Run the jupyter notebook by using the newly installed virtualenv as the kernel

    $ jupyter notebook

7. Change the dataset paths accordingly
