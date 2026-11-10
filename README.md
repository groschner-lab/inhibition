# Non-canonical inhibition shapes motion vision
Scripts used for analyses and simulations in Zuidinga et al.

We used the Anaconda distribution of Python (https://docs.anaconda.com/anaconda/install/index.html). To run the scripts locally, download the file collection and navigate to the path in the terminal (Mac) or in an Anaconda Prompt (Windows), create the respective environments and start JupyterLab. For scripts that need input data, download the data files from Zenodo (url) and save them in the respective `input_data` folder.

## Environment creation
Assuming a version of conda is already installed, run:
`conda env create --file PATH_TO_ENVIRONMENT_FILE.yml`
to create the necessary environment to run the respective scripts.

### Environments
* The `inhibition_analyses` environment defined by `inhibition_analyses_environment.yml` was used for most data analyses.
* The `inhibition_flywire_export` environment defined by `inhibition_flywire_environment.yml` was used to plot dendrite morphology of T4 and T5 neurons based on FAFB 783. The environment uses fafbseg, which was developed for Mac and probably does not work off the bat for Windows users. Before using fafbseg, you need an API token as described [here](https://fafbseg-py.readthedocs.io/en/latest/source/tutorials/flywire_setup.html#flywire-setup).
* The `inhibition_model` environment defined by `inhibition_model_environment.yml` was used to run the compartmental model. The model was based on data exported from the jupyter notebooks `inhibition_analysis/ephys.ipynb` and `inhibition_flywire/FlyWire_morphology_export.ipynb`.
  * **Please note:** We found that older Macs with an intel processor cannot install all the required packages in this environment. Alternatively, one can try to install the `inhibition_model_intel` environment defined by `inhibition_model_environment_intel.yml`.

## Environment activation:
Activate the respective environment using:
* `conda activate inhibition_analysis`
* `conda activate inhibition_flywire_export`
* `conda activate inhibition_model`, or `conda activate inhibition_model_intel`

## Start JupyterLab:
Run: `jupyter lab`

In JupyterLab, navigate to the desired .ipynb file and run the code.
