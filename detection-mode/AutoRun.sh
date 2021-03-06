#!/bin/bash
echo $#

if [ "$1" != "" ]; then
    echo "[TeddyPlus] GitHub Repo To Clone =" $1
    export cloneRepo=$1
else
    echo "[TeddyPlus:ERROR] Parameter 1 is empty"
fi
if [ "$2" != "" ]; then
    export location=$2
	echo "[TeddyPlus] Output Result Location =" $2
else
    echo "[TeddyPlus:ERROR] parameter 2 is empty"
fi
if [ "$3" != "" ]; then
	echo "[TeddyPlus] Repository name =" $3
    export index=$3
else
    echo "[TeddyPlus:ERROR] Parameter 3 is empty"
fi

git clone $cloneRepo && cd "$(basename "$_" .git)"
echo $(pwd)
for OPT in "$@"
do
    case $OPT in
        -a) echo "-a is " $2
            date=$2
            after=" --after ${date} " 
            shift;;
        -b) echo "-b is " $2
            date=$2
            before=" --before ${date}"
            shift;;
        *) shift;;
    esac
done

gitclonedhead=$(git symbolic-ref --short HEAD)
commitCommand="git log --oneline --pretty=format:\"%h;\""
if [ "$after" ]; then
    commitCommand=$commitCommand$after
fi
if [ "$before" ]; then
    commitCommand=$commitCommand$before
fi

echo $commitCommand
commit=$($commitCommand)
echo $commit
commitarray=(${commit//;/})
echo $commitarrayi
commit_count=${#commitarray[@]}

if [ $commit_count == "0" ]; then
    echo "There are no commits."
else
    echo "There are some commits."
fi

commitNo=0
for ((i=${#commitarray[@]};i>0;i--))
do
echo "[TeddyPlus] Commit#$i ID:${commitarray[$i]} >> Starting search"

git checkout ${commitarray[$i]}
# Calling shell script that runs Siamese.jar, perform indexing and searching
#=====================================
/home/teddy/client/CallSiamese.sh $PWD /home/teddy/client/python-idioms $location $index ${commitarray[$i]} $commitNo
#=====================================

git checkout $gitclonedhead
((commitNo=commitNo+1))
done

## echo or run tatts scrip

# Calling shell script that runs bokeh visualization
/home/teddy/client/CallBokeh.sh $location
