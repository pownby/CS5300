#!/bin/bash

cd `dirname "$0"`

TESTDIR=TestFiles/ #test files directory (where all test.cpsl files are)
RESULTS=Result/ #results folder (where to store cpsl run results for comparison)
BASE=Base/ #base folder name (contains results to compare against)

CPSLDIR=../cpsl/build/ #where cpsl compiler binary lives
BINARY=cpsl #binary name
ASM=asm/ #tmp directory for asm files for mars to run

MARSDIR=../mars/
MARSJAR=Mars4_4.jar

pushd . >> /dev/null
cd ${TESTDIR}
LS=`ls *.cpsl`
popd >>/dev/null

#create these directories if they don't exist already
mkdir -p $ASM $RESULTS

for file in $LS; do

    ${CPSLDIR}${BINARY} ${TESTDIR}${file} > ${ASM}${file}

    if [ $? -ne 0 ]; then
        echo "Error running: ${CPSLDIR}${BINARY} ${TESTDIR}${file} > ${ASM}${file}"
        continue
    fi

    java -jar ${MARSDIR}${MARSJAR} ${ASM}${file} > ${RESULTS}${file}

    if [ $? -ne 0 ]; then
        echo "Error running: java -jar ${MARSDIR}${MARSJAR} ${ASM}${file} > ${RESULTS}${file}"
        continue
    fi

    cmp ${RESULTS}${file} ${BASE}${file}
done
