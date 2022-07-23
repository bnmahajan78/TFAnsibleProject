
out=''
out=$1
pemfile=$2
srcpath=$3
destpath=$4
args=$5

echo "sudo scp -tt -o StrictHostKeyChecking=no  -i $pemfile  $srcpath  ubuntu@$out:~/$destpath"

sudo scp  -tt -o StrictHostKeyChecking=no  -i $pemfile  $srcpath  ubuntu@$out:~/$destpath

exit



