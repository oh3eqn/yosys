#!/bin/bash

# Single round-trip test
run_single_test () {
    set -e

    # Frontent options
    if [ "$LANG" == "verilog" ]; then
        FRONTEND_OPTS="-nolatches -nomem2reg -nopp -noopt -noautowire -icells"
    else
        FRONTEND_OPTS=""
    fi

    # Initial run
    ../../../yosys -ql yosys.log -p "read_verilog "../${SOURCE}"; write_"${LANG}" round_trip.1"
    # Round-trip run
    ../../../yosys -ql yosys.log -p "read_"${LANG}" ""${FRONTEND_OPTS}"" round_trip.1; write_"${LANG}" round_trip.2"

    # Sort output lines
    sort round_trip.1 > round_trip.1.sorted
    sort round_trip.2 > round_trip.2.sorted

    # Check
    set +e
    diff -q -B -y round_trip.2.sorted round_trip.1.sorted
    if [ $? -ne 0 ]; then
        echo "Test failed! Output after round-trip differs!"
        exit -1
    fi
}

# Run tests
for SOURCE in *.v; do
    for LANG in verilog ilang; do
        WORKDIR=work_$(basename ${SOURCE%.*})_${LANG}
        mkdir -p ${WORKDIR}
        cd ${WORKDIR}
        run_single_test
        cd ..
    done
done

