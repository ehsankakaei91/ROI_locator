# ROI anatomical locator
Here I provide a set of [MATLAB](https://mathworks.com/products/matlab) based scripts to locate the anatomical regions associated with desired regions of interest (ROI).


## Citing ##

If you are using MD758 parcellation please refer to [MD758 parcellation](https://github.com/cognitive-biology/Parcellation) and cite accordingly.
The following atlases is included, please cite them accordingly:
1. HCP Glasser_et_al_2016 (MMP)
2. Brodmann
3. CAREN (Doucet et.al 2019 Hum Brain Mapp)
4. Yeo 2011 J Neurophysiol
5. Wang et al. 2015 (topographic)
6. fsl HarvardOxford

## How to use ##
First, download or clone the repository. 
The function coordinates_info(X,Y,Z,S) which gets the coordinates X,Y,Z from the desired space S ['mni' or 'tal' (Talairach)] and returns the list of regions ROI in various atlases.
