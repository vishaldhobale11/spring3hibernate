#!/bin/bash
for i in `cat $1`
do
iserver=`echo ${i} | cut -d , -f 1`
iuser=`echo ${i} | cut -d , -f 2`
iip=`echo ${i} | cut -d , -f 3`
echo "$iserver $iuser $iip"

        for j in `cat $2`
        do
        tserver=`echo $j | cut -d , -f1`
        job=`echo $j | cut -d , -f2`
        option=`echo $j | cut -d , -f3`
        option2=`echo $j | cut -d , -f4`
        if [ $iserver == $tserver ]; then
                if [ $job == "install" ]; then
                ssh $iuser@$iip "
				install(){
				if [ -z `rpm -qa "${option}"` ];then
				echo "INSTALLING $option ......"
				sudo yum install -y $option
				else
				echo "Package $option is already installed"
				fi
				}
				install
				"
		elif [ $job == "copy" ]; then
                ssh $iuser@$iip "copyFile()
                                {
                                if [ -f ${option2} ]; then
				echo " File $option2 is already exists at destination path"
                                else
                                cp ${option} ${option2}
				echo "Copy completed"
				fi
                                }
                                copyFile
                                "
                elif [ $job == "service" ]; then
		echo "$job $option"
                ssh $iuser@$iip "service()
                                {
                                sudo service $option restart
                                }
                                service
                                "
	fi
        else
        echo "Working..."
        fi
done
done
