#!/bin/bash

# This is script performs round-trip tests for selected frontends/backends.
# Initial test cases are written in verilog. The first pass is "conversion" from
# verilog to one of the selected languages. Then, the output file is read again
# using a corresponding frontend and written by a corresponding backend. In the
# end both files are compared and if they differ an error is thrown.

VERBOSE=2

# Single round-trip test
run_single_test () {
    set -e

    echo " "${SOURCE}

    # Frontent options
    if [ "$LANG" == "verilog" ]; then
        FRONTEND_OPTS="-pwires -nolatches -nomem2reg -nopp -noopt -noautowire -icells"
        BACKEND_OPTS="-pwires2params"
    else
        FRONTEND_OPTS=""
        BACKEND_OPTS=""
    fi

    # Initial run, feed the input file through Yosys 1st time.
    ../../../yosys -ql yosys.log -p "read_verilog -pwires "../${SOURCE}"; write_"${LANG}" ""${BACKEND_OPTS}"" round_trip.1"
    # Round-trip run, feed the file 2nd time through Yosys
    ../../../yosys -ql yosys.log -p "read_"${LANG}" ""${FRONTEND_OPTS}"" round_trip.1; write_"${LANG}" ""${BACKEND_OPTS}"" round_trip.2"

    # Sort output lines. Sometimes Yosys prints out some wire declarations in
    # different order than they were in the input file. Sorting lines allows
    # to mitigate that but will make the check prone to output syntax errors
    # etc.
    sort round_trip.1 > round_trip.1.sorted
    sort round_trip.2 > round_trip.2.sorted

    # Check if files are identical
    set +e

    if [[ ${VERBOSE} -ge 2 ]]; then
        diff -B -y round_trip.2 round_trip.1
    fi

    diff -q -B -y round_trip.2.sorted round_trip.1.sorted
    if [ $? -ne 0 ]; then
        echo "Test failed! Output after round-trip differs!"

        if [[ ${VERBOSE} -ge 1 ]]; then
            diff -B -y round_trip.2 round_trip.1
        fi

        exit -1
    fi
}

# Run tests. Look for verilog files and do the round-trip for all of them.
echo "Running round-trip tests..."

for SOURCE in *.v; do
    for LANG in verilog ;do #ilang; do
        WORKDIR=work.$(basename ${SOURCE%.*})_${LANG}
        mkdir -p ${WORKDIR}
        cd ${WORKDIR}
        run_single_test
        cd ..
    done
done

