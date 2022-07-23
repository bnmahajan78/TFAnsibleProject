
out=''
out=$1
pemfile=$2
srcpath=$3
destpath=$4
args=$5

sudo scp -o StrictHostKeyChecking=no  -i $pemfile  $srcpath  ubuntu@$out:~/myscripts/$destpath
exit

