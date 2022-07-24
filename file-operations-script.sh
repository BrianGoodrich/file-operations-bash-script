#!/bin/bash
#Brian Goodrich - The purpose of this script is to display a menu with several options, and execute commands based on the users choice from the menu. Option 1 will list the files in the current directory. Option 2 will display the number of empty files in the directory specified by the user. Option 3 will navigate to a directory specified by the user and preform the ls -l ocmmand. Option 4 will ask the user for a word, then search for that word in all the files of the current directory. Option 5 will copy files from current directory to the directory specified by the user.

trap trapCleanup SIGTERM SIGINT

touch logerr.txt

function printMenu() {

    echo Please select one of the following:
    echo 1. List files in current directory
    echo 2. Display the number of empty files in a given directory and then list those files
    echo 3. Navigate to another directory as specified and ls -l of the current working directory.
    echo 4. Enter a word, then the number of files in the current working directory that contain that word in the file.
    echo 5. Provide a directory name and then a series of filenames to move into that directory.
    echo 6. Exit
}

function option2() {

    dirInput=""

    while [[ "infinite" ]]; do

        echo You chose option 2: Please enter the directory name
        read dirInput

        if [[ ! -d ./$dirInput ]]; then
            echo $dirInput either does not exist, or is not a directory, please enter a different directory name. \n
            echo $dirInput either does not exist, or is not a directory. >>logerr.txt
            continue
        fi

        break
    done

    cd $dirInput

    echo The number of empty files in this directory is:
    ls -al | grep -c '\ 0\ '

    echo The empty files in this directory are:
    ls -al | grep '\ 0\ ' | sed 's/^.*\s//'

    cd ..
}

function option3() {

    dirInput2=""

    while [[ "infinite" ]]; do

        echo You chose option 3: Please enter the directory name
        read dirInput2

        if [[ ! -d ./$dirInput2 ]]; then
            prinf "$dirInput2 either does not exist, or is not a directory, please enter a different directory name. \n"
            echo $dirInput2 either does not exist, or is not a directory. >>logerr.txt
            continue
        fi

        break
    done

    cd $dirInput2

    ls -l

    cd ..
}

option4() {

    word=''
    count='0'

    echo You chose option 4: Please enter a word to search for. The number of files that contain this word will then be printed.
    read word

    lsContents=$(ls)

    fileArray=($lsContents)

    for ((i = 0; i < ${#fileArray[*]}; i++)); do

        if [[ -f ./${fileArray[$i]} ]]; then

            temp=$(grep -c "$word" ${fileArray[$i]})

            if [[ temp -gt 0 ]]; then
                count=$(($count + 1))
            fi

        fi
    done

    echo There are: $count files with $word in them.
}

option5() {

    input=''

    while [[ "infinite" ]]; do

        echo You chose option 4: Please enter a directory name, followed by the files you would like to move to the directory.
        read input

        inputArray=($input)

        if [[ ! -d ./${inputArray[0]} ]]; then
            echo The directory ${inputArray[0]} either does not exist or is not a directory, please enter a different directory, followed by the files you would like to move to the directory.
            echo The directory ${inputArray[0]} does not exist >>logerr.txt
            continue
        fi

        for ((i = 1; i < ${#inputArray[*]}; i++)); do

            if [[ ! -f ./${inputArray[$i]} ]]; then
                echo The file ${inputArray[$i]} does not exist, please enter a directory, followed by the files you would like to move to the directory.
                echo The file ${inputArray[$i]} does not exist >>logger.txt
                continue
            fi

        done

        break
    done

    for ((i = 1; i < ${#inputArray[*]}; i++)); do

        cat ${inputArray[$i]} >$HOME/${inputArray[0]}/${inputArray[$i]}

    done

}

function trapCleanup() {
    echo "This program will now terminate, goodbye."
    exit
}

forbiddenCharacter=''
userInput='6'

while [[ "infinite" ]]; do

    printMenu
    read userInput

    forbiddenCharacter=$(echo $userInput | grep -c '|')

    if [[ $forbiddenCharacter -ge 1 ]]; then
        echo Your input included a \| which is forbidden, this program will now terminate.
        echo Input included \|, exit 1. >>logerr.txt
        exit 1
    fi

    case $userInput in

    1)
        ls
        continue
        ;;
    2)
        option2
        ;;
    3)
        option3
        ;;
    4)
        option4
        ;;
    5)
        option5
        ;;
    6)
        break
        ;;

    esac

done
