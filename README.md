# ECG signal quality assessment using artificial intelligence models
GITHUB: https://github.com/Bananek96/MasterThesis
## DataBase
Nemcova, A., Smisek, R., Opravilová, K., Vitek, M., Smital, L., & Maršánová, L. (2020). Brno University of Technology ECG Quality Database (BUT QDB) (version 1.0.0). PhysioNet. https://doi.org/10.13026/kah4-0w24.
## ToolBox Instalation
```bash
[old_path] = which('rdsamp'); if (~isempty(old_path)) rmpath(old_path(1:end-8)); end
wfdb_url = 'https://physionet.org/physiotools/matlab/wfdb-app-matlab/wfdb-app-toolbox-0-10-0.zip';
[filestr, status] = urlwrite(wfdb_url, 'wfdb-app-toolbox-0-10-0.zip');
unzip('wfdb-app-toolbox-0-10-0.zip');
cd mcode
addpath(pwd)
savepath
```
