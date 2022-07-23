##/bin/bash  ssh_ubuntu_m.sh 18july.pem  iplist
pemfile=$1
iplistfile=$2

cd /home/ubuntu/myscripts

echo   "================ Master Node start  =============="
echo   "Node list"

echo "Masternode"
cat  /home/ubuntu/myscripts/masternode

echo "Workernode"
cat  /home/ubuntu/myscripts/iplist

        echo   "================14 Read self ip =============="
        cd /home/ubuntu/myscripts
        masterip=$(curl ifconfig.me  )
        echo  "Master ip of this node is $ip" $masterip
        output=$masterip
        echo  "Master ip of this node is $ip" $output

        /bin/bash /home/ubuntu/myscripts/copypublickey.sh $masterip ubuntu $pemfile


  echo   "=================15 Install Ansible============"

          echo  "1.Master ip of this node is $ip" $output  $masterip

       #sudo apt-add-repository ppa:ansible/ansible
       #sudo apt update -y
       #sudo apt install ansible -y



	    echo  "2.Master ip of this node is $ip" $output  $masterip
cd /home/ubuntu/myscripts
ls -al
  echo   "=================16 Add entry in /etc/ansible/hosts ============"
  sudo   cp /etc/ansible/hosts  /etc/ansible/hosts_original
  sudo   cp ~/myscripts/ansiconf  /etc/ansible/hosts
#  sudo   echo   $masterip   Master.example.com  | sudo -S tee -a /etc/hosts
#  sudo  sed -i '20s/.*/[web]/'  /etc/ansible/hosts
#  sudo  sed -i '23s/.*//'$masterip  /etc/ansible/hosts
#  sudo  sed -i '25s/.*/[app]/'  /etc/ansible/hosts


  echo   "=================17 Read  Worker ips from file ============"

echo "========================"
sudo cat /etc/ansible/hosts
echo "========================"
sudo cat /etc/hosts
echo "========================"
sudo cat  /etc/ansible/hosts
echo "========================"

## Target is : Worker ips of file

        wfile=$2
        echo   $wfile
        echo   "=============== 18 Test commands on master node ================"

        cd /home/ubuntu/myscripts
        no=26
        i=0

    echo " sudo ssh -i  $pemfile ubuntu@$master 'sudo hostnamectl  set-hostname Master'"
    sudo ssh -i  $pemfile ubuntu@$masterip 'sudo hostnamectl  set-hostname Master' </dev/null

     echo " sudo ssh -i  $pemfile ubuntu@$master 'sudo cat /etc/hostname'"
    sudo ssh -i  $pemfile ubuntu@$masterip 'sudo cat /etc/hostname' </dev/null


  echo   "=============== 18 Worker node file name - $wfile ================"
  while read -r linew; do
   echo  -e "$linew\n"
   ((i=i+1))

  echo  "=================19.1 Copy Master's authorization file to Worker node $i - $linew ============"
    
     cat /home/ubuntu/.ssh/authorized_keys

    /bin/bash doscp_pathssh.sh $linew $pemfile "/home/ubuntu/.ssh/authorized_keys" ".ssh/authorized_keys_bkp1"
    /bin/bash dossh.sh $linew ubuntu $pemfile
    /bin/bash doexec.sh $linew $pemfile 'cat /home/ubuntu/.ssh/authorized_keys'
   /bin/bash doexec.sh $linew $pemfile 'cat /home/ubuntu/.ssh/authorized_keys_bkp1'
    /bin/bash doexec.sh $linew $pemfile 'sudo cp .ssh/authorized_keys_bkp1   /home/ubuntu/.ssh/authorized_keys'
    /bin/bash doexec.sh $linew $pemfile 'cat /home/ubuntu/.ssh/authorized_keys'
    /bin/bash dossh.sh $linew ubuntu $pemfile
    sudo ssh -i ~/myscripts/$pemfile  -o StrictHostKeyChecking=no  ubuntu@$linew </dev/null

    echo  "=================19 Set hostname of Worker node $i - $linew ============"
     echo "i = "
    /bin/bash doexec.sh $linew $pemfile "sudo hostnamectl  set-hostname Worker-${i}"
    /bin/bash doexec.sh $linew $pemfile 'cat /etc/hostname'

echo  "row = $linew"

 done <$wfile


#########################################################################

echo  "=================19.2 Copy Update Master's /etc/hosts file and export to Worker node ============"
i=0
if grep -qF "Master.example.com" /etc/hosts;
then
    # code if found
    echo "Entry exists."
else
    # code if not found
   i=0
   
    echo  "sudo ssh -i $pemfile ubuntu@$masterip  "
	
	 
	 /bin/bash doexec.sh $masterip $pemfile "echo   ${masterip}   Master.example.com  | sudo -S tee -a /etc/hosts"
 
    while read -r linew; do
          echo  -e "$linew\n"
          ((i=i+1))
		  
          /bin/bash doexec.sh $masterip $pemfile "echo   $linew   Worker${i}.example.com  | sudo -S tee -a /etc/hosts"
         

     done <$wfile
   i=0
    echo  "Copying to worker nodes."
    while read -r linew; do
       echo  -e "$linew\n"
       ((i=i+1))
	   
	   destpath="/etc/hosts"
       sudo scp -o StrictHostKeyChecking=no  -i  $pemfile "/etc/hosts" ubuntu@$linew:$destpath
	   
	   destpath1="~/myscripts/"
	   sudo scp -o StrictHostKeyChecking=no  -i  $pemfile $pemfile ubuntu@$linew:$destpath1
	    
	   /bin/bash doexec.sh $linew $pemfile " cat $pemfile "
         
		 
       /bin/bash doexec.sh $masterip $pemfile "echo   $linew   Worker${i}.example.com  | sudo -S tee -a /etc/hosts"

	 echo  "sudo ssh -i $pemfile ubuntu@$linew "
	
   done <$wfile
   echo  "Copying done at worker nodes."

  fi



###############################################################

 echo  "================20  End of iplist file ============"
 
 
 
 
 
 
  echo  "================21  About ansible test ============"
  
    cd ~/myscripts
	
	 echo  "======Master - $masterip=========="
	 echo "Check if file $pemfile exist. "
	  echo " pemfile "
	cat $pemfile
	  
	echo " masterip "
	echo $masterip
	
	 
	  
	 echo " /bin/bash dossh.sh $masterip ubuntu $pemfile"
	 /bin/bash dossh.sh $masterip ubuntu $pemfile
	
	i=0
    echo  "Copying to worker nodes."
    while read -r linew; do
       echo  -e "$linew\n"
       ((i=i+1))
	     echo  "=======Worker-$i - $linew========="
		  echo "/bin/bash dossh.sh $linew ubuntu $pemfile"
		/bin/bash dossh.sh $linew ubuntu $pemfile
		
	done <$wfile
	
	
	echo  "====================21.1======================================"
	cd ~/myscripts
	
	echo " Cross check masterip "
	echo $masterip
	
	echo  "======================21.2===================================="
	
    echo " pemfile "
	cat $pemfile
	  
	echo " masterip "
	echo $masterip
	
	echo " /bin/bash doexec.sh $masterip $pemfile 'ansible --version' "
	/bin/bash doexec.sh $masterip $pemfile "ansible --version"
	 
	echo  "=====================21.3======================================"
	echo " masterip "
	echo $masterip
	
	/bin/bash doexec.sh $masterip $pemfile  "ansible web -m ping"
	echo  "=====================21.4======================================"
	##/bin/bash doexec.sh $masterip $pemfile  "ansible app -m ping"
	echo  "=====================21.5======================================"
    /bin/bash doexec.sh $masterip $pemfile  "ansible-inventory --list -y"
    echo  "=====================21.6======================================"
   
   rm ex3.yaml
 touch ex3.yaml
 echo "---" >>  ~/myscripts/ex3.yaml
 echo "- hosts: web" >>  ~/myscripts/ex3.yaml
 echo "  become: true" >>  ~/myscripts/ex3.yaml
 echo "  tasks:" >>  ~/myscripts/ex3.yaml
 echo "  - name: Install Package" >>  ~/myscripts/ex3.yaml
 echo "    apt: name=apache2 state=present" >>  ~/myscripts/ex3.yaml
 echo "  - name: Start apache2 service" >>  ~/myscripts/ex3.yaml
 echo "    service: name=apache2 state=started" >>  ~/myscripts/ex3.yaml
	   
cat ~/myscripts/ex3.yaml

echo "ansible-playbook ~/myscripts/ex3.yaml"
ansible-playbook ~/myscripts/ex3.yaml


cat ~/myscripts/ex4.yaml
echo "ansible-playbook ~/myscripts/ex4.yaml"
ansible-playbook ~/myscripts/ex4.yaml



  echo  "================22  End of iplist file ============"

exit
