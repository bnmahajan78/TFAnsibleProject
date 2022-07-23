oout=$1
user=$2
pemfile=$3
echo $oout

cd ~/myscripts
echo "pemfilename= " $pemfile

sudo ssh -i $pemfile  ubuntu@$oout -tt -o  StrictHostKeyChecking=no  -o ControlMaster=no <<EOF

cd ~/.ssh
rm id_rsa
rm id_rsa.pub
rm authorized_keys
cp authorized_keys_bkp1 authorized_keys

#ssh-keygen -q -t -N ''  -f ~/.ssh/id_rsa <<<y >/dev/null 2>&1

ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa <<<y >/dev/null 2>&1

cat  ~/.ssh/id_rsa.pub | sudo -S tee -a ~/.ssh/authorized_keys
cat ~/.ssh/authorized_keys
cd ~/myscripts
exit


