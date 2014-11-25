QG14_Noah_Dukler
================

Project for Quant Gen 2014 (also for SCBM)

Dependencies I do not install for you:
* Plink 1.9 (plink command must be in your $PATH variable as well) 
* R (Run on 3.1, try other versions at your own risk)
* GNU make

To build my project just run Makefile from the directory it is in using command:
make
If you want to parallelize the analysis run with command:
make -j num_of_cores

To build my report you need latex installed as well as all the packages in the header of the .tex file. 
All of these packages are in the texlive or texlive-extra package distributions.
