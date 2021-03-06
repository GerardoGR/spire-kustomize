#!/bin/bash

# Based off: https://github.com/spiffe/spire/blob/main/test/integration/test.sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd "${DIR}" || fail-now "Unable to change to script directory"

. ./common

SUITES=suites/*
if [[ -n $1 ]]; then
        SUITES=$@
fi

echo "Testing $SUITES"

failed=()
for suite in $SUITES; do
    if ! ./test-one.sh "${suite}"; then
        echo "STATUS=$?"
        failed+=( "$(basename "${suite}")" )
    fi
done

[ ${#failed[@]} -eq 0 ] || fail-now "The following tests failed: ${failed[*]}"
