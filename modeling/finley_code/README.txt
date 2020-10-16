## Description of files for Supplementary Material associated with manuscript
## submitted to Remote Sensing of Environment
## Title: Hierarchical Bayesian models for small area estimation of 
## 	  forest variables using LiDAR
## DOI: 
## Authors: Neil R. Ver Planck*, Andrew O. Finley, John A. Kershaw, Jr.,
## Aaron Weiskittel, and Megan C. Kress
## *Corresponding author email: verplan6@msu.edu

## All files should be placed in the same directory

##----------------------------------
##Data image and scripts to run in R
##----------------------------------
1) data.RData
	R image of needed objects for fitting SAE models for Stand-level AGB

2) model-FH.R
	Fay-Herriot SAE model

3) model-FHCAR.R
	Fay-Herriot with conditional autoregressive prior (FHCAR) SAE model
	also used to apply FHCAR-SMOOTH model with smoothed sampling variances

4) main.R
	runs the three SAE models and provides two example figures from the manuscript
