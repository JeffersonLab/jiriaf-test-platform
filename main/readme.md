# This directory contains scripts to launch JRMs on compute nodes at NERSC.

1. Run `build-ssh-at-login.sh` to build the SSH tunnels to `jiriaf2301`. Note that you need to add `export n1="10001"; ssh -NfR $n1:localhost:$n1 jiriaf2301` if you have more JRMs. Varible `n1` is the `KUBELET_PORT` of the first JRM, etc.

2. Prepare `node1.sh` and `node2.sh` to launch JRMs on compute nodes. Set the correct `KUBELET_PORT` that is used by the previous step.

3. Run `nersc-slurm.sh` to submit the job to NERSC. Note that you need to add `srun -N1 /global/homes/j/jlabtsai/run-vk/slurm/node1.sh &` if you have more JRMs.