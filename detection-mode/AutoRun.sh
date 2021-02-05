#!/bin/bash
echo $#


if [ "$1" != "" ]; then
    echo 'GitHub Repo To Clone =' $1
    cloneRepo=$1
else
    echo "parameter 1 is empty"
fi
if [ "$2" != "" ]; then
    location=$2
	echo 'Output Result Location =' $2
else
    echo "parameter 2 is empty"
fi
if [ "$3" != "" ]; then
	echo 'Elasticsearch index name =' $3
    index=$3
else
    echo "parameter 3 is empty"
fi
git clone $cloneRepo
cd */.
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


#ls -l
gitclonedhead=$(git symbolic-ref --short HEAD)
commitCommand="git log --oneline --pretty=format:\"%h;\""
if [ "$after" ]; then
    commitCommand=$commitCommand$after
else
    echo "no option for after"
fi
if [ "$before" ]; then
    commitCommand=$commitCommand$before
else
    echo "no option for before"
fi
commit=${commitCommand}
echo $commitCommand
commitarray=(${commit//;/})
commitNo=0
for ((i=${#commitarray[@]};i>0;i--))
do
echo "Commit#$i ID:${commitarray[$i]} >> Starting search"

git checkout ${commitarray[$i]}
# Calling shell script that runs Siamese.jar, perform indexing and searching
#=====================================
./../CallSiamese.sh $PWD ./../../python-idioms $location $index ${commitarray[$i]} $commitNo
#=====================================

  ## Uncomment/Comment for manual/auto iteration of commit versions
  ##echo "Press any Key to Continue to the next commit"
  ##read -n 1
git checkout $gitclonedhead
((commitNo=commitNo+1))
done
## Deleting the repo folder after iteration is completed
cd ..
rm -r */
## echo or run tatts scrip

# Calling shell script that runs bokeh visualization
./CallBokeh.sh $location