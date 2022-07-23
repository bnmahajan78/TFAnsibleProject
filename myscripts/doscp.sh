out=$1
pemfile=$2
srcfile=$3
destfile=$4

echo "sudo scp -o StrictHostKeyChecking=no  -i ~/myscripts/$pemfile  ~/myscripts/$srcfile  ubuntu@$out:~/myscripts/$destfile"
sudo scp -o StrictHostKeyChecking=no  -i $pemfile  ~/myscripts/$srcfile  ubuntu@$out:~/myscripts/$destfile
exit
