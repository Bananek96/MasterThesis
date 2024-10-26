# ECG signal quality assessment using artificial intelligence models
## [SCHEDULE]
1) Literature analysis related to the topic of the work
2) Selection of the database and its initial preparation
2) Preprocessing of ECG signals, division into classes and epochs
3) Feature extraction of ECG signals
4) Feature selection and preparation of input vectors
5) Choosing the architecture of the learning model
6) Optimization of the parameters of the selected model
7) Performing model training
8) Analysis of the results obtained
9) Editing of the work
## [LITERATURE]
Articles on ECG signal processing and artificial intelligence methods in the classification task.<br/>
[1] Nemcova, A., Smisek, R., Opravilová, K., Vitek, M., Smital, L., & Maršánová, L. (2020). Brno University of Technology ECG Quality Database (BUT QDB) (version 1.0.0). PhysioNet. https://doi.org/10.13026/kah4-0w24.
[] van der Bijl, K., Elgendi, M., & Menon, C. (2022). Automatic ECG quality assessment techniques: A systematic review. Diagnostics, 12(11), 2578. <br/>
[2] Zhou, R., Lu, L., Liu, Z., Xiang, T., Liang, Z., Clifton, D. A., ... & Zhang, Y. T. (2023). Semi-supervised learning for multi-label cardiovascular diseases prediction: a multi-dataset study. IEEE Transactions on Pattern Analysis and Machine Intelligence.<br/>
[3] Zhou, R., Lu, L., Liu, Z., Xiang, T., Liang, Z., Clifton, D. A., ... & Zhang, Y. T. (2023). Semi-supervised learning for multi-label cardiovascular diseases prediction: a multi-dataset study. IEEE Transactions on Pattern Analysis and Machine Intelligence.<br/>
[4] Rasmussen, S. M., Jensen, M. E., Meyhoff, C. S., Aasvang, E. K., & Słrensen, H. B. (2021, November). Semi-supervised analysis of the electrocardiogram using deep generative models. In 2021 43rd Annual International Conference of the IEEE Engineering in Medicine & Biology Society (EMBC) (pp. 1124-1127). IEEE.<br/>
[5] Liu, X., Wang, H., Li, Z., & Qin, L. (2021). Deep learning in ECG diagnosis: A review. Knowledge-Based Systems, 227, 107187.<br/>
[6] Petmezas, G., Stefanopoulos, L., Kilintzis, V., Tzavelis, A., Rogers, J. A., Katsaggelos, A. K., & Maglaveras, N. (2022). State-of-the-art deep learning methods on electrocardiogram data: systematic review. JMIR medical informatics, 10(8), e38454.<br/>
[7] Kuetche, F., Alexendre, N., Pascal, N. E., Colince, W., & Thierry, S. (2023). Signal quality indices evaluation for robust ECG signal quality assessment systems. Biomedical Physics & Engineering Express, 9(5), 055016.<br/>
[8] Mondal, A., Manikandan, M. S., & Pachori, R. B. (2024). Fast CNN Based Electrocardiogram Signal Quality Assessment Using Fourier Magnitude Spectrum for Resource-Constrained ECG Diagnosis Devices. IEEE Sensors Letters.<br/>
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
