oout=$1
user=$2
pemfile=$3
echo $oout

 
echo "pemfilename= " $pemfile

sudo ssh -i $pemfile  ubuntu@$oout -tt -o  StrictHostKeyChecking=no  -o ControlMaster=no <<EOF

cd ~
mkdir -p  ~/t3
chmod 777 ~t3

cd ~/t3
mkdir -p   tmp
chmod 777 tmp

cd ~/t3
ls -al

cd ~/t3/tmp
ls -al

cd ~/.ssh
ls -al
cd ~/t3

exit
