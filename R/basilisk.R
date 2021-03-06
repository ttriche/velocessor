# scvelo 0.2.2 and cellrank 0.5.1 tested along with AnnData dependencies
.cellrank_dependencies <- c(
    "alabaster==0.7.12",
    "anndata==0.7.4", # cellrank requires anndata>=0.7.2, so this is fine a
    "async-generator>=1.0",
    "attrs>=17.4.0",
    "Babel==2.8.0",
    "backcall>=0.2.0",
    "bleach>=3.0.0",
    "brotlipy==0.7.0",
    "certifi==2020.6.20",
    "cffi==1.14.1",
    "chardet==3.0.4",
    "colorama==0.4.3",
    "cryptography==3.1",
    "cycler==0.10.0",
    "decorator==4.4.2",
    "defusedxml>=0.6.0",
    "docrep>=0.2.7",
    "docutils==0.16",
    "entrypoints>=0.2.2",
    "future-fstrings>=1.0.0",
    "h5py==2.10.0",
    "idna==2.10",
    "imagesize==1.2.0",
    "importlib-metadata==1.7.0",
    "ipykernel>=4.5.1",
    "ipython>=5.0.0",
    "ipython-genutils>=0.2.0",
    "ipywidgets>=7.5.1",
    "jedi>=0.10",
    "Jinja2==2.11.2",
    "joblib==0.16.0",
    "jsonschema!=2.5.0,>=2.4",
    "jupyter-client>=1.0.0",
    "jupyter-core>=4.6.0",
    "jupyterlab-pygments>=0.1.2",
    "kiwisolver==1.2.0",
    "llvmlite==0.34.0",
    "loompy==2.0.16",
    "MarkupSafe==1.1.1",
    "matplotlib==3.3.1",
    "mistune<2,>=0.8.1",
    "mock==4.0.2",
    "natsort==7.0.1",
    "nbformat>=4.2.0",
    "nest-asyncio>=1.4.0",
    "networkx==2.5",
    "notebook>=4.4.1",
    "numba==0.51.2",
    "numexpr==2.7.1",
    "numpy==1.19.1",
    "olefile==0.46",
    "packaging==20.4",
    "pandas==1.1.2",
    "pandocfilters>=1.4.1",
    "parso<=0.8.0,>=0.7.0",
    "patsy==0.5.1",
    "pexpect>4.3",
    "ptyprocess>=0.5",
    "pickleshare>=0.7.5",
    "prompt-toolkit!=3.0.0,!=3.0.1,<3.1.0,>=2.0.0",
    "Pillow==7.2.0",
    "pip==20.2.3",
    "prometheus-client>=0.8.0",
    "pycparser==2.20",
    "pygments==2.7.0",
    "pyOpenSSL==19.1.0",
    "pyparsing==2.4.7",
    "pyrsistent>=0.14.0",
    "PySocks==1.7.1",
    "python-dateutil==2.8.1",
    "pytz==2020.1",
    "pyzmq>=13",
    "requests==2.24.0",
    "scanpy==1.6.0",
    "scikit-learn==0.23.2",
    "scipy==1.5.2",
    "scvelo==0.2.2",
    "seaborn==0.11.0",
    "Send2Trash>=1.5.0",
    "setuptools>=18.5",
    "setuptools-scm==4.1.2",
    "sinfo==0.3.1",
    "six==1.15.0",
    "snowballstemmer==2.0.0",
    "Sphinx==3.2.1",
    "sphinxcontrib-applehelp==1.0.2",
    "sphinxcontrib-devhelp==1.0.2",
    "sphinxcontrib-htmlhelp==1.0.3",
    "sphinxcontrib-jsmath==1.0.1",
    "sphinxcontrib-qthelp==1.0.3",
    "sphinxcontrib-serializinghtml==1.1.4",
    "statsmodels==0.12.0",
    "stdlib-list==0.6.0",
    "terminado>=0.8.3",
    "testpath>=0.4.4",
    "threadpoolctl==2.1.0",
    "toml==0.10.1",
    "tornado==6.0.4",
    "traitlets>=4.2",
    "tqdm==4.49.0",
    "umap-learn==0.4.6",
    "urllib3==1.25.10",
    "wcwidth>=0.2.5",
    "wheel==0.35.1",
    "webencodings>=0.5.1",
    "widgetsnbextension~=3.5.0",
    "zipp==3.1.0"
)

#' @importFrom basilisk BasiliskEnvironment
#' @importFrom zellkonverter .AnnDataDependencies
cellrank.env <- BasiliskEnvironment("env", "velocessor",
  packages=.cellrank_dependencies, channels = c("bioconda", "conda-forge")
)
