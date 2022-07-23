out=$1
pemfile=$2
cmdd=$3

echo $out
echo $pemfile
echo $cmdd

#echo "ssh -tt -o StrictHostKeyChecking=no  -i $pemfile  ubuntu@$out '$cmdd' <<EOF"
#sudo ssh -tt -o StrictHostKeyChecking=no  -i $pemfile  ubuntu@$out  "$cmdd"  <<EOF

echo "sudo ssh  -tt -o  StrictHostKeyChecking=no  -i $pemfile  ubuntu@$out '$cmdd'  "
      sudo ssh  -tt -o  StrictHostKeyChecking=no  -i $pemfile  ubuntu@$out    "$cmdd"  <<EOF


exit
