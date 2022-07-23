out=$1
userid=$2
pemfile=$3
ls
pwd
cd /home/ubuntu/myscripts

#pemfile=$(ls *.pem | head -1)
echo "keyname = " $pemfile
echo "ip =" $out
echo "sudo ssh-copy-id  -i /home/ubuntu/.ssh/id_rsa.pub  ubuntu@$out"
sudo ssh-copy-id  -i /home/ubuntu/.ssh/id_rsa.pub  ubuntu@$out
