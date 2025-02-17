## 1. Initial Settings:

It is recommended to use it on `Linux`.

### 1.1 Software:

#### Anaconda

[下载 | Anaconda](https://www.anaconda.com/download/)

#### xtb

[下载 | xtb](https://xtb-docs.readthedocs.io/en/latest/setup.html)

#### Packmol

[下载 | Packmol](https://m3g.github.io/packmol/download.shtml)

#### VMD

[下载 | VMD](https://www.ks.uiuc.edu/Development/Download/download.cgi?PackageName=VMD)


#### Gaussion 16

### 1.2 Python Library:

Once you have installed Anaconda, you can create a python runtime environment by:
```commandline
conda create -n my_env python=3.10
```

Then you can activate the environment by: 
```commandline
conda activate my_env
```

There some Python Libraries needed to be installed:

#### 1.2.1 Rdkit

```commandline
conda install -c conda-forge rdkit
```
#### 1.2.2 Openbabel

```commandline
conda install openbabel -c conda-forge
```

#### 1.2.3 Hmmlearn

```commandline
conda install conda-forge::hmmlearn=0.2.7
```
Use for Hidden Markov Model(HMM) construction.

#### 1.2.4 Scikit-learn

```commandline
conda install anaconda::scikit-learn
```

#### 1.2.5 Networkx

```commandline
conda install anaconda::networkx
```

#### 1.2.6 Tqdm

```commandline
conda install conda-forge::tqdm
```

#### 1.2.7 Matplotlib

```commandline
conda install conda-forge::matplotlib
```

#### 1.2.8 Cmocean

```commandline
 conda install conda-forge::cmocean=3.0.3
```

### 1.3 .bashrc Settings:
It is recommended to write down the absolute path of software into the `.bashrc` file. eg: packmol:
```commandline
vi ~/.bashrc
PATH=$PATH:/path/to/packmol
source ~/.bashrc
```

And write the absolute path of the following folder and python program into the `.bashrc` file: ：`DynReacExtr`、`ReacNetDraw`、`QmJob`、`sphereMaker.py`、`trj_split.py`.
```
export PATH=.../python:$PATH
export PATH=.../python/QmJob:$PATH
export PATH=.../python/ReacNetDraw:$PATH
export PATH=.../python/DynReacExtr/src:$PATH
export PATH=.../python/sphereMaker.py:$PATH
export PATH=.../python/trj_split.py:$PATH
```

Notes:
1. Using the latest version of `hmmlearn` and `Cmocean` may result in an error.`hmmlearn=0.2.7` and `cmocean=3.0.3` will be ok.
---

## 2. Initial Sampling:

In this step, `packmol`，`xtb` and `sphereMaker.py` are needed.

### 2.1 Initial md.xyz Construction:

`sphereMaker.py` will automatically calls the `packmol`. Please see its code for more details if you need it.

You can check the parameters by:

```
sphereMaker.py -h
```
```
------------------------------------------------------------
usage: sphereMaker.py [-h] -i [INPUTFILE ...] -n [NUMS ...] 
-d DENSITY --names [NAMES ...] [--center [CENTER ...]] [--dis DIS]

Process some integers.

options:
  -h, --help            show this help message and exit
  -i [INPUTFILE ...], --inputfile [INPUTFILE ...]
                        Input mole file, e.g. water.xyz OH.xyz
  -n [NUMS ...], --nums [NUMS ...]
                        Input mole nums, e.g. 10 1
  -d DENSITY, --density DENSITY
                        Set system density, unit in g/ml, e.g. 10
  --names [NAMES ...]   Set Output file name
  --center [CENTER ...]
                        Set Central Molecules
  --dis DIS             Set Mol distance, unit is Å
------------------------------------------------------------
```
Notes: When you use `--center`, the number of molecules can only be one.

#### 2.1.1 Example:

Construct a system involved 3 molecules using `1.xyz` and `2.xyz`. The numbers of molecule 1 and molecule 2 are 1 and 2, respectively:

```python
sphereMaker.py -i 1.xyz 2.xyz -n 1 2 -d 1.5 --name test --dis 3
```

```python
*** Sphere Radii is 8.30 A.
*** Sphere Radii is 15.68 Bohr.
```
The value of Sphere Radii(in Bohr) is used for setting the sphere of nanoreactor.

### 2.2 Sampling:

#### 2.2.1 MD job file:

**Delete comments when you use**.

```
$chrg 0
$spin 0
$scc
   maxiterations=800
   temp=1000
$cma
$md
   sccacc=2
   temp=298 
   shake=2
   hmass=1
   time=30
   dump=200
   step=0.5
$wall
   potential=logfermi
   beta=0.5
   temp=6000
   sphere: 10, all # In bohr，Setting it according to the output result of sphereMaker.py.(See 2.1.1)
$end
```
#### 2.2.2 Run 

```python
xtb --md --input md.inp test.xyz > log
```

```
         time (ps)    <Epot>      Ekin   <T>   T     Etot
      0    0.00      0.00000   0.0253    0.    0.   -12.21325
est. speed in wall clock h for 100 ps :  0.03
.............
block <Epot> / <T> :     -12.24057  280.     drift:  0.20D-04   Tbath : 280.
  25200   12.60    -12.23947   0.0106  299.  320.   -12.23146
  25400   12.70    -12.23947   0.0096  299.  290.   -12.23186
  25600   12.80    -12.23949   0.0133  299.  401.   -12.23010
  25800   12.90    -12.23951   0.0114  299.  342.   -12.23034
  26000   13.00    -12.23952   0.0096  299.  287.   -12.23216
  26200   13.10    -12.23954   0.0116  299.  349.   -12.23154
  26400   13.20    -12.23956   0.0096  299.  290.   -12.23097
  26600   13.30    -12.23958   0.0093  299.  281.   -12.23126
  26800   13.40    -12.23959   0.0099  299.  297.   -12.23138
  27000   13.50    -12.23960   0.0120  299.  362.   -12.23118
  27200   13.60    -12.23962   0.0083  299.  248.   -12.23311
  27400   13.70    -12.23963   0.0065  299.  194.   -12.23288
  27600   13.80    -12.23962   0.0082  298.  246.   -12.23081
  27800   13.90    -12.23962   0.0139  297.  418.   -12.23192
  28000   14.00    -12.23963   0.0070  298.  211.   -12.23189
  28200   14.10    -12.23964   0.0103  297.  310.   -12.23180
  28400   14.20    -12.23964   0.0087  297.  263.   -12.23035
  28600   14.30    -12.23965   0.0093  297.  278.   -12.23117
  28800   14.40    -12.23966   0.0137  297.  411.   -12.23088
  29000   14.50    -12.23967   0.0093  297.  281.   -12.23102
  29200   14.60    -12.23968   0.0120  297.  362.   -12.23192
  29400   14.70    -12.23969   0.0103  297.  311.   -12.23277
  29600   14.80    -12.23970   0.0079  297.  236.   -12.23293
  29800   14.90    -12.23971   0.0095  297.  285.   -12.23213
```

Notes:
1. Observe the change in `<T>` to make sure that the temperature is balanced.
2. Don't choose the structure in which the reaction takes place.

#### 2.2.3 Different Sampling Situation:

Long-time md sampling (For weak reactivity system):
* Total Sampling Time: > 10 ps
* Generation sampling structure `stru.xyz`(`\sampling\*\stru.xyz`) by `trj_split.py`.

Short-time md sampling (For reactive system, eg: free radical):
* Total Sampling Time: < 0.5 ps

---

## 3. MTD Simulation:

In this step, prepared structure file(`stru.xyz`),`xtb`, `shell` and `pbs` script are needed. 

### 3.1 Example of pbs script(control shell):

```shell
#!/usr/bin/bash

for((i=1;i<=500;i++)) # Number of Folders
do
      ## 1. Construct Basic Sub-folders
      mkdir $i  
      ##
      if [ -d "$i/" ]; then
         cd $i
         pwd

         mv ../$i.xyz ./ # Reactive System
         mv stru.xyz $i.xyz # Weak Reactivity System
         cp ../qsub.pbs qsub.pbs
         cp ../md.inp md.inp
         ##

         ## 2. Submit Job
         # qsub qsub.pbs
         # sleep 5
         ##

         ## 3. Trajectories Analysis       
         # pwd >> ../log
         # dynReacExtr.py -i xtb.trj --refine >> ../log ## For Network Drawing
         ##
         cd ..
   fi
done
```
Then:
```
bash control.sh
```

### 3.2 MTD job file:

**Delete comments when you use**.
```
$chrg 0
$spin 0
$scc
   maxiterations=800
   temp=1000
$cma
$md
   shake=0
   hmass=1
   sccacc=2
   temp=1500
   time=30
   dump=2
   step=0.5
$metadyn # Meta Dynamics
   save=1
   kpush=0.8
   alp=0.7
$wall
   potential=logfermi
   beta=0.5
   temp=6000
   sphere: 10, all
$end
```

### 3.3 Example of PBS Script:
```
#PBS -N xxx
#PBS -j oe
#PBS -l nodes=1:ppn=8
#PBS -V
#PBS -l walltime=999:00:00

# Username
user="xxx"

CURR=$PBS_O_WORKDIR
WORK_DIR=$CURR
TMP_DIR="/state/partition1/scratch/$user/$PBS_JOBID"

export OMP_NUM_THREADS=8

cd $PBS_O_WORKDIR
mkdir -p  $TMP_DIR
cp -r $WORK_DIR/* $TMP_DIR 
cd $TMP_DIR

# xtb command
xtb --md --input xxx.inp *.xyz > log

cp -rf $TMP_DIR/*   $WORK_DIR
rm -rf $TMP_DIR
```



## 4. Reaction Event Extraction:

In this step, `dynReacExtr.py`, `qmPreprocess.py` and `reactPathRefine.py` are needed.

### 4.1 `dynReacExtr.py`
```
dynReacExtr.py -h
```

```
---------------------------------------------------------------------------
usage: dynReacExtr.py [-h] [-i INPUTFILE] [--interval INTERVAL] [--scale SCALE]
                      [--mode MODE] [--hidmatr HIDMATR HIDMATR HIDMATR HIDMATR]
                      [--obvmatr OBVMATR OBVMATR OBVMATR OBVMATR] [--tspin TSPIN]
                      [--tchrg TCHRG] [--jobset JOBSET JOBSET] [--ts] [--opt] [--smooth]
                      [--neb] [--xtbpath] [--xtbopt] [--network] [--draw] [--refine]
                      [--load]

options:
  -h, --help            show this help message and exit
  -i INPUTFILE, --inputfile INPUTFILE
                        Input trajectory file
  --interval INTERVAL   Set interval
  --scale SCALE         Set frame in detect reaction, default 30 frames
  --mode MODE           Select mode: reac or prod, default extract from product
  --hidmatr HIDMATR HIDMATR HIDMATR HIDMATR
                        Matrix hidden of HMM parameters
  --obvmatr OBVMATR OBVMATR OBVMATR OBVMATR
                        Matrix obvserve of HMM parameters
  --tspin TSPIN         Set spin for entire system
  --tchrg TCHRG         Set charge for entire system
  --jobset JOBSET JOBSET
                        Set job set, default scale is -30~30, interval is 10
  --ts                  Proceed gaussion ts job
  --opt                 Proceed gaussion opt job
  --smooth              Proceed smooth trajectory job to get double end points. !! Need
                        nebterpolator !!
  --neb                 Proceed orca neb-ts job
  --xtbpath             Proceed xtb path job
  --xtbopt              Proceed xtb opt job
  --network             Proceed network analysis job
  --draw                draw reactions
  --refine              refine reactions
  --load                load reaction pre-analysis
```

#### 4.1.1 Example:

1. Basic Usage:

```
dynReacExtr.py -i you_traj.xyz
```

2. Load the results of the previous analysis to reduce the analysis time:

```
dynReacExtr.py -i you_traj.xyz --load
```

3. Setting Charge and Spin:

```
dynReacExtr.py -i you_traj.xyz --tspin 0 --tchrg -1
```

4. TS Structure Extraction:

```
dynReacExtr.py -i trj --ts
```

5. Products and Reactant Analysis:(For Network Construction)

```
dynReacExtr.py -i trj --refine
```

6. Pre-optimization:

```
dynReacExtr.py -i trj --xtbopt
```

All of the above can be done at the same time:

```
dynReacExtr.py -i trj --xtbopt --ts --refine --tspin 0 --tchrg -1
```

#### 4.1.2 Output:

```
Filter sigal transition: 100%|███████████████████████████████| 19/19 [00:00<00:00, 311.45it/s]
   *  1 times  |  [H]C1C([H])C(N([H])C(O)C([H])([H])[H])C([H])C([H])C1O+[H]O+[H]O[H]->[H]C1C([H])C(NC(O)C([H])([H])[H])C([H])C([H])C1O+[H]O[H]+[H]O[H]
```

The resulting documents are as follows:

```
# Initial Analysis
.ini_data.npy
_relation.csv
_job.csv

# --refine: Reactant, Products(In SMILES).
_ref_relation.csv

# --xtbopt: Optimized Structure in xtbopt file.
xtbopt
_opt_xtb_data.csv

# --ts: Folder ts has initial guess structure for TS.
tsjob.info
ts
```

#### 4.1.3 Basic Setting:

The default settings for `dynReacExtr.py` are in `\DynReacExtr\src\_setting_default.py`

```python
# The number of CPU(nproc) and Memory(core):
comp_config = {
    "nproc": 8, 
    "core": 4000
}
# Basis and Functional:
qm_config = {
    "g16_base": "SVP",
    "orca_base": "DEF2-SVP",
    "method": "B3LYP"
}
# Dispersion Correction:
disp_config = {
    "g16": "em=GD3BJ",
    "orca": "GD3"
}
# Structure Optimization Settings:
opt_config = {
    "maxcyc": 100,
    "maxstep": 10,
    "g16_addit1": "cartesian,",
    "g16_addit2": "tight,"
}
# TS Optimization Settings:
ts_config = {
    "recalc": 5,
    "maxcyc": 200,
    "g16_addit": "noeigen,calcfc,"
}
# IRC:
irc_config = {
    "stepsize": 10,
    "maxpoints": 300,
    "g16_addit": "noeigen,calcfc,LQA,"
}
# Path Settings:
loc_config = {
    'ini_read_data': Path('.ini_data.npy'),
    "reaction_smi_folder": Path('smi/reaction/'),
    "network_smi_folder": Path('smi/network/'),
    "job_file": Path('_job.csv'),
    "relation_file": Path('_relation.csv'),
    "ref_relation_file": Path('_ref_relation.csv'),
    "reaction_pic": Path('_reaction.png'),
    "network_pic": Path('_network.png'),
    "reaction_network_pic": Path('_reaction_network.png')
}
```

#### 4.1.4 Run:

Reaction events analysis can be performed with the previously mentioned scripts `control.sh`:

```
#!/usr/bin/bash

for((i=1;i<=500;i++))
do
      if [ -d "$i/" ]; then
         cd $i
         pwd

         ## 3. Trajectories Analysis       
         # pwd >> ../log
         # dynReacExtr.py -i xtb.trj --ts --xtbopt >> ../log
         ##
         cd ..
   fi
done
```
Then:
```
bash control.sh
```

### 4.2 `qmPreprocess.py`

All the `_job.csv` files and `tsjob.info` files in each sub-folder are needed.

```
qmPreprocess.py -h
```
```
---------------------------------------------------------------------------
usage: qmPreprocess.py [-h] [--step STEP] [--freq FREQ] [--unite] [--sort] [--ts] [--neb]
                       [--path] [--xtbopt]

options:
  -h, --help   show this help message and exit
  --step STEP
  --freq FREQ
  --unite
  --sort
  --ts
  --neb
  --path
  --xtbopt
```

where TS search needs:
```
  --ts  # Pre-treatment for TS search.
  --step STEP # Number of sub-folders(default: NONE, include all the sub-folder)
  --unite   # Categorize the same reactions.(eg: A -> B and B -> A)
  --sort    # Sort according to reaction frequency.
```

#### 4.2.1 Basic Usage:

```
qmPreprocess.py --ts --sort --unite
```
Folder `ts` will be generated. When you enter it, you will see subfolders (if you use the step command, there will be multiple subfolders, and if you don't use it, only subfolder '1' will be generated). The `info` file in the subfolder records the information about the reaction (SMILES code and number of occurrences):

```
[H]O+[H]OC1C([H])C([H])C(N([H])C(O)C([H])([H])[H])C([H])C1[H]->[H]C1C([H])C(N([H])C(O)C([H])([H])[H])C([H])C([H])C1O+[H]O[H]   6
[H]C1C([H])C(N([H])C(O)C([H])([H])[H])C([H])C([H])C1O+[H]O->[H]C1C(N([H])C(O)C([H])([H])[H])C([H])C([H])C(O)C1+[H]O[H]   4
[H]C1CC(O)C([H])C([H])C1N([H])C(O)C([H])([H])[H]+[H]O->[H]C1CC(O)C([H])C([H])C1NC(O)C([H])([H])[H]+[H]O[H]   4
[H]C1CC(O)C([H])C([H])C1NC(O)C([H])([H])[H]+[H]O->[H]C1CC(O)C([H])CC1NC(O)C([H])([H])[H]+[H]O[H]   4
```

#### 4.2.2 Basic Settings:

You can make changes to the settings according to your needs:(\QmJob\src\_setting_default.py)

```python
loc_config = {
    "orca_loc": '/data/home/users/Software/orca/orca' # Path to Orca
}
user_config = {
    'user': 'zhyt' # Username
}
server_config = {
    "nproc": 8,
    "sleep_t": 300, # Sleep time, second
    "max_nproc": 120, # Number of processing units
    "qsub_num": 20 # Number of job
}
comp_config = {
    "nproc": 8, 
    "core": 4000,
}
qm_config = {
    "g16_base": "SVP",
    "orca_base": "DEF2-SVP",
    "method": "B3LYP"
}
disp_config = {
    "g16": "em=GD3BJ",
    "orca": "GD3"
}
opt_config = {
    "maxcyc": 100,
    "maxstep": 10,
    "g16_addit1": "cartesian,",
    "g16_addit2": "tight,"
}
ts_config = {
    "recalc": 5,
    "maxcyc": 200,
    "g16_addit": "noeigen,calcfc,"
}
irc_config = {
    "stepsize": 10,
    "maxpoints": 300,
    "g16_addit": "noeigen,calcfc,LQA,"
}
```

## 5. Refinement

### 5.1 TS Structure Cluster Analysis

#### Basic Usages:

Modify the `main` function of `class G16_TS` in `reactPathRefine.py` if needed:

```python
def main(self):
    ## 1. Initialize
    self.initialize()
    
    ## 2. Submit Jobs 
    submitJobs(self.type, self.state_csv, self.work_space)
    
    ## 3. Move the Calculation Result
    job_list = csv2List(self.job_csv)
    log_list = getIdxLogList(self.work_space)
    moveLogList(job_list, log_list)
    
    ## 4. TS Structure Cluster Analysis
    clusterEnerFreq_G16()
```

Modify the end of the program and call `G16_TS`:

```python
if __name__ == '__main__':
    G16_TS(10,5).main()
```

Comment out other `class`es which are not needed. `G16_TS(m, n)`:
m: The number of reaction events of a reaction for transition state search by random selection.
n: The number of GJF files managed by each PBS script.

Then:

```
reactPathRefine.py
```

Files `ts_job.csv`, `ts_state.csv`, and folders `ts_workspace` will be generated:
- `ts_state.csv`: The result of each PBS script after submission.
- `ts_workspace`: All calculated GJFs.

If the task submission fails due to a network disconnection, you can comment out the `self.initialize()` in the `main` function and then re-execute `reactPathRefine.py`. 

After all the steps are completed, each subfolder will have a `workspace`, and then you can proceed to the `Irc` calculation.

### 5.2 IRC

#### Basic Usages:

Modify the `main` function of `class G16_Irc` in `reactPathRefine.py` if needed:

```
def main(self):
    ## 1. Initialize
    # self.initialize_ref() # Use this item only after you have used G16_TS_Ref
    self.initialize()
    
    ## 2. Submit Jobs 
    submitJobs(self.type, self.state_csv, self.work_space)

    ## 3. Move the Calculation Result
    job_list = csv2List(self.job_csv)
    log_list = getIdxLogList(self.work_space)
    moveLogList(job_list, log_list)
```

Modify the end of the program and call `G16_Irc`:
```python
if __name__ == '__main__':
    G16_Irc(5).main()
```

Comment out other `class`es which are not needed. `G16_Irc(m)`:
m: The number of GJF files managed by each PBS script.

Then:

```
reactPathRefine.py
```

If the task submission fails due to a network disconnection, you can comment out the `self.initialize()` in the `main` function and then re-execute `reactPathRefine.py`.

If all the steps are completed successfully, you can view the Irc log in each subfolder to draw the reaction mechanism network.

## 6. Reaction Network Drawing

###　6.1 Network Drawing:

You can modify the parameters at the `default_net_param` of the `\ReacNetDraw\_network.py` file.

```python
default_net_param = {
    # Node
    'node_size': 600,
    'r_node_size': 2, # Node Scaling

    # Edge
    'edge_width': 2,
    'r_edge_width': 40, # Edge Scaling

    # Transparency
    'r_alpha': 12, # Transparency Scaling
    'node_alpha': 0.5,
    'edge_alpha': 0.25,
    'node_alpha_criter': 0.6,
    'edge_alpha_criter': 0.7,

    'bound': [3, 6, 10, 20, 35, 50], # Axis Settings

    'cbar_label_size': 20,
    'cbar_tick_size': 14,
    'cbar_label_font': 'Detetected Times',

    'net_label_size': 16,
    'spec_label': {1: '1'},
    'spec_label_color': 'Gray',
    
    # Figure Settings
    'fig_size': [24, 15],
    'fig_dpi': 400,
    'fig_name': 'reac_Event_Network.png'
    }
```

### 6.2 Molecular Structure List:

You can modify the parameters of the molecular structure list diagram at `judgeImgSize` in the `\ReacNetDraw\grid_draw.py` file.

`rdkit` is used for plotting. By adjusting the `subImgSize`, the size of the molecule (max_atom_nums) can be modified for optimal display.

```python
def judgeImgSize(max_atom_nums):
    if max_atom_nums <= 15:
        subImgSize = (400, 400)
        legendFontSize = 300
    elif max_atom_nums <= 25:
        subImgSize = (600, 600)
        legendFontSize = 300
    elif max_atom_nums <= 35:
        subImgSize = (1600, 1000)
        legendFontSize = 300
    elif max_atom_nums <= 45:
        subImgSize = (1700, 1000)
        legendFontSize = 300
    elif max_atom_nums <= 60:
        subImgSize = (2000, 1300)
        legendFontSize = 300
    print(f' * Sub-Grid Image Size:  {subImgSize}')
    return subImgSize, legendFontSize
```

### 6.3 Filter Cnditions

```
smi_dict, smi_list, idx_rela_list, filter_smi_dict \
    = anylseMD(freq_criter=2, NC_range=None, Natom_range=None)
```

Modify the values of the following parameters if needed:
- `freq_criter`: The standrad for filtering reaction events, `int` type.
- `NC_range`: The display range of the number of C atoms, `list` type, e.g. `[1:5]`.
- `Natom_range`: The range of atomic numbers is displayed, and `list` is supported, e.g. `[1:20]`.

### 6.4 Basic Usage

After refinement, use the following command in the parent directory of the folder for all trajory files:

```
grid_draw.py
```

Output:

```
 * Reactions Analysis Report
┌────────────────────────────────────────┐
│ Reactive trajectory number:          50│
│ Reaction number:                    412│
│ Reaction class number:              339│
│ Main Reaction number:                73│
│ Main Reaction class number:          11│
└────────────────────────────────────────┘


Drawing _Grid_Image......
 * Max atom number:  31
 * Sub-Grid Image Size:  (1600, 1000)
```

You can modify `judgeImgSize` according to the `Max atom number` if poorly drawn.

### 6.5 FAQ

`cmocean` library is introduced into an error.

1. Comment out `import cmocean` in `_network.py`.
2. Remove the comment for the 'cmap = cm.plasma.reversed()' code.
3. Modify 'self.cmap' to 'cmap'.

The resulting documents are as follows:

- `reac_main_eve.log`: Obtained by reaction analysis. This file marks the main reaction with the string SMILES for the verification of the convergence of the reaction space.
- `reac_Event_Network.png`: Network diagram.
- `mols-RDkit.svg`: A list of molecular structures corresponding to the network.

### 6.6 Reaction Mechanism Network
It is recommended to use `chemdraw` to draw based on the log of IRC.
