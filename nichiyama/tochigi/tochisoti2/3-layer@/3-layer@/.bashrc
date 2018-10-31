# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
# --- BERRYPI START ---
export BERRYPI_PATH=$WIENROOT/SRC_BerryPI/BerryPI
export BERRYPI_PYTHON=/usr/bin/python
alias berrypi="${BERRYPI_PYTHON} ${BERRYPI_PATH}/berrypi"
# --- BERRYPI END ---
# added by WIEN2k: BEGIN
# --------------------------------------------------------
alias lsi="ls -aslp *.in*"
alias lso="ls -aslp *.output*"
alias lsd="ls -aslp *.def"
alias lsc="ls -aslp *.clm*"
alias lss="ls -aslp *.scf* */*.scf"
alias lse="ls -aslp *.error"
alias LS="ls -aslp | grep /"
alias pslapw="ps -ef |grep "lapw""
alias cdw="cd /home/csl/WIEN2k"
alias vs="ruby /home/csl/submit_code/vaspsubmit.rb"
alias qs="qstat -f"
alias clean='rm -rf CHG CHGCAR DOSCAR EIGENVAL IBZKPT PCDAT WAVECAR XDATCAR OUTCAR CONTCAR OSZICAR PROCAR vasprun.xml vasp-job.* csl.vasp.* *~ *.e* *.o* *.po* *.pe*'
export OMP_NUM_THREADS=1
#export LD_LIBRARY_PATH=.....
export EDITOR="vi"
export SCRATCH=./
export WIENROOT=/usr/local/WIEN2k_14.2
export W2WEB_CASE_BASEDIR=/home/csl/WIEN2k
export STRUCTEDIT_PATH=$WIENROOT/SRC_structeditor/bin
export PDFREADER=evince
export PATH=$PATH:$WIENROOT:$STRUCTEDIT_PATH:$WIENROOT/SRC_IRelast/script-elastic:.
export OCTAVE_EXEC_PATH=${PATH}::
export OCTAVE_PATH=${STRUCTEDIT_PATH}::

export PATH=$PATH:$WIENROOT:.
ulimit -s unlimited
alias octave="octave -p $OCTAVE_PATH"
# --------------------------------------------------------
# added by WIEN2k: END 
# --- BERRYPI START ---
export BERRYPI_PATH=$WIENROOT/SRC_BerryPI/BerryPI
export BERRYPI_PYTHON=/usr/bin/python
alias berrypi="${BERRYPI_PYTHON} ${BERRYPI_PATH}/berrypi"
# --- BERRYPI END ---
