oout=$1
user=$2
pemfile=$3

echo $oout
echo "pwd"$(pwd)

cd ~/myscripts


echo "pemfilename= " $pemfile

echo "sudo ssh -i $pemfile  ubuntu@$oout -tt -o  StrictHostKeyChecking=no  -o ControlMaster=no "
sudo ssh -i $pemfile  ubuntu@$oout -tt -o  StrictHostKeyChecking=no  -o ControlMaster=no <<EOF


cd ~
mkdir -p  ~/myscripts
chmod 777 ~/myscripts

cd ~/myscripts
mkdir -p   tmp
chmod 777 tmp

exit
