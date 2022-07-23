 

## cat ssh_ubuntu_t.sh
##  /bin/bash  ssh_ubuntu_t.sh ~/myscripts/id_rsa  masternode

pemfile=$1

 echo   "===============T-node start ==============="
## echo   "pemfile " $1
cd  /home/ubuntu/.ssh
cat id_rsa.pub
cp /home/ubuntu/.ssh/id_rsa.pub   ~/myscripts/id_rsa.pub 

  echo   "===============1 Read authorized_keys==============="
cat  authorized_keys

  echo   "===============2 Get self public ip=============="
cd /home/ubuntu/myscripts
out=$(curl ifconfig.me  )
## echo   "Terraform node ip is $out " $out

  echo   "==============3 dossh on self ip==============="

## Target is : Terraform node itSelf

    /bin/bash dossh.sh $out ubuntu $pemfile

  echo   "===============4 copy .pub file on self=============="

  /bin/bash copypublickey.sh $out ubuntu $pemfile

  echo   "=============5 backup sh files on self ================"

   sudo  cp $pemfile   $pemfile-cpy.pem

   sudo chmod 0777 $pemfile-cpy.pem
   # Migrating some files to Master node.

  /bin/bash doscp.sh $out $pemfile $pemfile-cpy.pem tmp/$pemfile.pem
  /bin/bash doscp.sh $out $pemfile $pemfile-cpy.pem tmp/$pemfile-cpy.pem

 # /bin/bash doexec.sh $out  $pemfile 'ls -al /home/ubuntu/myscripts/tmp > /home/ubuntu/myscripts/lscmd.txt'
  #ssh -o StrictHostKeyChecking=no  -i $pemfile   ubuntu@$out  'ls -al /home/ubuntu/myscripts/tmp > /home/ubuntu/myscripts/lscmd.txt'

  #/bin/bash doexec.sh $out  $pemfile 'cat /home/ubuntu/myscripts/lscmd.txt'
  #ssh -o StrictHostKeyChecking=no  -i $pemfile   ubuntu@$out  'cat /home/ubuntu/myscripts/lscmd.txt'


  /bin/bash doscp_path.sh $out $pemfile copypublickey.sh  copypublickey.sh  
  /bin/bash doscp_path.sh $out $pemfile doscp.sh doscp.sh
  /bin/bash doscp_path.sh $out $pemfile dossh.sh dossh.sh  

  /bin/bash doscp_path.sh $out $pemfile dosshMaster.sh dosshMaster.sh
  /bin/bash doscp_path.sh $out $pemfile dosshWorker.sh dosshWorker.sh
  
  /bin/bash doscp_path.sh $out $pemfile doscp_pathssh.sh doscp_pathssh.sh
  /bin/bash doscp_path.sh $out $pemfile  doexec.sh doexec.sh

  #/bin/bash doscp_path.sh $out $pemfile $pemfile-cpy.pem tmp/$pemfile.pem
  #/bin/bash doscp_path.sh $out $pemfile $pemfile-cpy.pem tmp/$pemfile-cpy.pem
  
  /bin/bash doscp_path.sh $out $pemfile ssh_ubuntu_m.sh ssh_ubuntu_m.sh

 /bin/bash doscp_path.sh $out $pemfile iplist iplist
  /bin/bash doscp_path.sh $out $pemfile masternode masternode
  /bin/bash doscp_path.sh $out $pemfile ansiconf ansiconf
  /bin/bash doscp_path.sh $out $pemfile ex4.yaml ex4.yaml
  #/bin/bash doscp_path.sh $out $pemfile $pemfile $pemfile

 # /bin/bash doexec.sh $out  $pemfile 'ls -al /home/ubuntu/myscripts'
  #ssh -o StrictHostKeyChecking=no  -i $pemfile   ubuntu@$out 'ls -al /home/ubuntu/myscripts'



  echo   "====================6 change chmod of self .pem  self .pem file ============================"
 ## distribute own public key  in each dest master ip

       /bin/bash dossh.sh $out ubuntu $pemfile

       sudo cp  $pemfile   $pemfile-cpy.pem

       sudo chmod 0777  $pemfile-cpy.pem

       ls -al *.pem


         cmd1=''
         cmd1='sudo chmod 0700 '
          cmd1+=$pemfile
         





  ## Target is : Master node ips of file
  mnip=''

  mfile=$2

  echo   "Master node file name -" $mfile

  echo   "==============7 Loop through master file ==============="

  echo   "7.1"

i=0
while read -r line; do
        echo   -e "$line\n"
        echo   "=============7.1 Master :Make backup of authorized_keys ================"

      echo "7.1"
            /bin/bash doscp_pathssh.sh $line $pemfile ~/.ssh/authorized_keys  .ssh/authorized_keys_bkp1
            /bin/bash dossh.sh $line ubuntu $pemfile
    
      echo "7.2"
           echo   "=============7.2 Master : do sshkeygen . update authorized_keys . ================"
           /bin/bash dosshMaster.sh $line ubuntu $pemfile

	  echo "7.3"
      echo   "==============7.3 Master : Change self host name ==============="

	   ((i=i+1)) 
	   echo "sudo  ssh -i $pemfile -o StrictHostKeyChecking=no    ubuntu@$line   'sudo hostnamectl  set-hostname Master$i'"
       sudo  ssh -i $pemfile -o StrictHostKeyChecking=no    ubuntu@$line   'sudo hostnamectl  set-hostname Master$i'
      
	  
	  /bin/bash doexec.sh $line  $pemfile 'cat /home/ubuntu/.ssh/authorized_keys'


    #ssh -i $pemfile  ubuntu@line  <<EOF
    /bin/bash doscp.sh $line  $pemfile  $pemfile-cpy.pem  $pemfile

         echo   "=============7.4 Master : Change self .pem chmod to 400  ================"
         cmd1=''
         cmd1='sudo chmod 0400 '           
         cmd1+=$pemfile
       
	   
	   


        /bin/bash doexec.sh $line $pemfile  "$cmd1"

   echo   "=============7.3 remove  nwanted .pem file backup ================"
   sudo rm $pemfile-cpy.pem
   ls -al *.pem

    ## echo   "=============8 Master : do ssh-copy-id on self ================"
    ##  /bin/bash copypublickey.sh $line ubuntu $pemfile


    echo   "============9 Master : Take backup of sh files from Terraform ==>  Master .================="

   # Migrating some files to Master node.
  /bin/bash doscp_path.sh $line $pemfile copypublickey.sh  copypublickey.sh  
  /bin/bash doscp_path.sh $line $pemfile doscp.sh doscp.sh
  /bin/bash doscp_path.sh $line $pemfile dossh.sh dossh.sh
  /bin/bash doscp_path.sh $line $pemfile dosshMaster.sh dosshMaster.sh
  /bin/bash doscp_path.sh $line $pemfile dosshWorker.sh dosshWorker.sh
  /bin/bash doscp_path.sh $line $pemfile doscp_pathssh.sh doscp_pathssh.sh
  /bin/bash doscp_path.sh $line $pemfile  doexec.sh doexec.sh
  /bin/bash doscp_path.sh $line $pemfile iplist iplist
  /bin/bash doscp_path.sh $line $pemfile masternode masternode
  /bin/bash doscp_path.sh $line $pemfile ansiconf ansiconf
  /bin/bash doscp_path.sh $line $pemfile ex4.yaml ex4.yaml
  /bin/bash doscp_path.sh $line $pemfile id_rsa id_rsa
  
   echo   "============10 Master : call ssh_ubuntu_m.sh to link with workers================="

  /bin/bash doscp_path.sh $line $pemfile ssh_ubuntu_m.sh ssh_ubuntu_m.sh

   echo   "========= 11. Switched to ssh_ubuntu_m.sh file=================="


   mnip=$line



done <$mfile


 echo   "============ 12 End of .tf file ============="

 cat   ~/myscripts/masternode
 cat   ~/myscripts/iplist
 cmd1=''
  cmd1='/bin/bash ~/myscripts/ssh_ubuntu_m.sh '
  cmd1+=$pemfile
  cmd1+='  ~/myscripts/iplist'

   echo    $cmd1
   echo     $mnip

   /bin/bash doexec.sh $mnip $pemfile  "$cmd1"
 echo   "============ 12 End of .tf file ============="


  cat   ~/myscripts/iplist
 

