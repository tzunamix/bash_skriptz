#!/usr/bin/bash
# user and group administration utility on Ubuntu linux

create_user()
{
	while :
	do
		read -p "Enter user name:" user
		if id $user &> /etc/null 
		then
			echo "User name already exist...(try again with another name)"
		else
			adduser $user
			echo "$user created successfully"
			return 0
		fi
	done
}


create_group()
{
	while :
	do
		read -p "Enter group name:" group
		if id $group &> /etc/null 
		then
			echo "Group already exist...(try again with another name)"
		else
			groupadd $group
			echo "$group created successfully"
			return 0
		fi
	done
}
set_pass_group()
{
	while :
	do
		read -p "Enter user name:" user
		if id $user &> /etc/null 
		then
			echo "User already exist...(try again with another name)"
		else
			adduser $user
			echo "$user created successfully"
			return 0
		fi
	done
}

deluser()
{
	users=$(awk -F: '$7=="/bin/bash" { print $1}' /etc/passwd)
	for user in $users
	do
		echo "User: $user , $(id $user | cut -d " " -f 1)"
	done
	while :
	do
		read -p "Enter the name of the user you want to delete:" user
		
		userdel $user
		echo "$user delete successfully"
		return 0
	done
}
delgroup()
{
	echo "List group: "
	getent group
	while :
	do
		read -p "Enter the name of the group you want to delete:" group1
		usermod -g root $group1
		groupdel $group1
		echo "$group1 delete successfully"
		return 0
	done
}

viewuser()
{
	users=$(awk -F: '$7=="/bin/bash" { print $1}' /etc/passwd)
	for user in $users
	do
		echo "User: $user , $(id $user | cut -d " " -f 1)"
	done
}
viewgroup()
{
	echo "List group:"
	getent group
	return 0
}
newfolder()
{
	while :
	do	
		File and folder list:
		ls
		read -p "Enter new folder name:" foldername
		if id $foldername &> /etc/null 
		then
			echo "Try again"
		else
			mkdir $foldername
			return 0
		fi
	done
}
copyfile()
{
	while :
	do	
		echo "File and folder list: "
		ls
		read -p "Enter the name of the file you want to copy:" filename
		read -p "Enter the name of the folder you want to copy the file to: " filename2
		if id $filename &> /etc/null 
		then
			echo "Try again"
		else
			cp /etc/$filename /$filename2
			return 0
		fi
	done
}
editfile()
{
	 while :
	do	
		echo "File list:"
		ls
		read -p "Enter name file to edit with vim:" filename
		if id $filename &> /etc/null 
		then
			echo "Try again"
		else
			vi $filename
			return 0
		fi
	done
}
catfile()
{
	echo "List file: "
	ls
	read -p "Enter the file name you want to view with cat: " filename
	
	cat $filename
	
}
delfile()
{
	echo "List file: "
	ls
	read -p "Enter the file name you want delete: " filename
	
	rm -i $filename
}
delfolder()
{
	echo "List folder: "
	ls
	read -p "Enter the folder name you want delete: " filename
	
	rm -rf $filename
}
space()
{
	echo "List file and folder: "
	ls
	read -p "Enter the file or folder name you want to watch: " filename
	
	du -h $filename
}
setfileandfolder()
{
	while :
do
	echo "
	      1.  Create new file 
	      2.  Create new folder
	      3.  Copy file
	      4.  Edit file with vim
	      5.  Delete file
	      6.  Delete folder
	      7.  View file and folder
	      8.  View file contents with cat
	      9.  Displays the used space of folders and files
	      10. Compress and Extract
	      11. Exit"
        read -p "Enter your choice:" choice


	case $choice in 
		1) newfile ;;
		2) newfolder ;;
		3) copyfile ;;
		4) editfile ;;
		5) delfile ;;
		6) delfolder ;;
	        7) view_fileandfolder ;;
	        8) catfile ;;
	        9) space ;;
	        10) compressandextract ;;
		11) echo "ThankYou, have a nice day...."
		   exit 1 ;;
		*) echo "invalid input...";;
	esac	
	sleep 4
	clear
done

}



extractzip()
{
	echo "List file and folder: " 
	ls
	
	read -p "Enter file name you want to extract here: " filename
	unzip $filename
	
}
extracttar()
{
	echo "List file and folder: " 
	ls
	
	read -p "Enter file name you want to extract here: " filename
	tar -xvf $filename
	
}
extracttargz()
{
	echo "List file and folder: " 
	ls
	
	read -p "Enter file name you want to extract here: " filename
	tar -xzf $filename
	
}
compresstar()
{
	echo "List file and folder: " 
	ls
	
	read -p "Enter folder name you want to compress to .tar here: " filename
	tar -cvzpf $filename
	
}
compresstar()
{
	echo "List file and folder: " 
	tar -tzf backup.tar.gz
	
	
}
compressandextract()
{
	while :
do
	echo "
	      1.  Extract the .zip file
	      2.  Extract the .tar file
	      3.  Extract the file .tar.gz
	      4.  Compress files/folders to .tar . format
	      5.  List compressed files gz
	      6.  Exit"
        read -p "Enter your choice:" choice


	case $choice in 
		1) extractzip ;;
		2) extracttar ;;
		3) extracttargz ;;
		4) compresstar ;;
		5) listgz ;;
		6) echo "ThankYou, have a nice day...."
		   exit 1 ;;
		*) echo "invalid input...";;
	esac	
	sleep 4
	clear
done

}
new_file()
{
	while :
	do
		read -p "Enter file name:" newfile
		if id $newfile &> /etc/null 
		then
			echo "File already exist...(try again with another name)"
		else
			touch $newfile
			echo "$newfile created successfully"
			return 0
		fi
	done
	
}
lock()
{
	while :
	do
		read -p "Enter your user_name to lock password:" user
		if [ -z $user ]
		then
			echo "Username can't be empty, please enter user_name..."
		else
			if id $user &> /etc/null
			then
				passwd -l $user
			        echo "successfully done...."	
				return 0
			else
				echo "provide valid user_name, user $user does not exist"
			fi
		fi
	done
}


backup()
{
	read -p "Enter user_name: " user
	echo "searching for home directory of $user"
	homedir=$(grep ${user}: /etc/passwd | cut -d ":" -f 6)
	echo "Home directory for $user is $homedir "
	echo "creating backup file (.tar).."
	ts=$(date +%F)
	tar -cf ${user}-${ts}.tar $homedir
	echo "$user backup success... "
	return 0
}

view_fileandfolder()
{
	ls -l
	return 0
}

addusertogroup()
{
	users=$(awk -F: '$7=="/bin/bash" { print $1}' /etc/passwd)
	for user in $users
	do
		echo "User: $user , $(id $user | cut -d " " -f 1)"
	done
	
	echo "List group:"
	getent group
	
	while :
	do	
		read -p "Enter the name of the user you want to add:" user
		read -p "Enter the name of the group add: " group

		usermod -a -G $group $user
		echo "$user has been added to the $group "
		return 0

	done
}
delusertogroup()
{
	echo "List group:"
	getent group
	
	while :
	do	
		read -p "Enter the name of the user you want to delete:" user
		read -p "Enter the name of the group: " group

		gpasswd -d $user $group
		echo "$user has been deleted to the $group "
		return 0

	done
}
while :
do
	echo "
	      1.  Create new user 
	      2.  Create new group
	      3.  Lock Password 
	      4.  Create user backup 
	      5.  Delete user
	      6.  Delete group
	      7.  View user-id
	      8.  View group
	      9.  Add users to the group
	      10. Delete users to the group
	      11. File and folder management
	      12. Exit"
        read -p "Enter your choice:" choice


	case $choice in 
		1) create_user ;;
	        2) create_group ;;
		3) lock ;;
		4) backup ;;
		5) deluser ;;
		6) delgroup ;;
		7) viewuser ;;
		8) viewgroup ;;
		9) addusertogroup ;;
		10) delusertogroup ;;
		11) setfileandfolder ;;
		12) echo "Thank You, have a nice day...."
		   exit 1 ;;
		*) echo "invalid input...";;
	esac	
	sleep 4
	clear
done



