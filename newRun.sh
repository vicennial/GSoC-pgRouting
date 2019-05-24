#!/bin/bash

set -e

# This run.sh is intended for Current version of pgRouting
if [ -z $1 ]; then
    PGR_VERSION=$(grep -Po '(?<=project\(PGROUTING VERSION )[^;]+' CMakeLists.txt)
else
    PGR_VERSION=$1
fi
echo "PGR_VERSION: $PGR_VERSION"

# test setup
TESTDIR="
allpairs  astar bdAstar bdDijkstra bellman_ford ChPP common
components contraction costFlow costMatrix dagShortestPath
dijkstra driving_distance ksp lineGraph max_flow mincut spanningTree
pickDeliver topology trsp tsp vrp_basic vrppdtw withPoints
alpha_shape
"
TESTDIR="components"
#TESTDIR=""

# Compiler setup
COMPILER="4.8 4.9 5 6 7 8"
COMPILER="8"
#COMPILER='Default'

# when more than one postgres version is installed on the computer
PGSQL_VER="10"
PGPORT=5433
PGSQL_VER="9.5"
PGPORT=5432
PGUSER="akhil"

function test_compile {

echo ------------------------------------
echo ------------------------------------
echo Compiling with $1
echo ------------------------------------

# when more than one gcc compiler is installed on the computer
if [ "$1" !=  'Default' ]
then
    sudo update-alternatives --set gcc /usr/bin/gcc-$1
fi

cd build/

# Using all defaults
#cmake ..

# Options Release RelWithDebInfo MinSizeRel Debug
#cmake  -DCMAKE_BUILD_TYPE=Debug ..

# with documentation
#cmake  -DDOC_USE_BOOTSTRAP=ON -DWITH_DOC=ON -DBUILD_DOXY=ON -DPgRouting_DEBUG=ON -DCMAKE_BUILD_TYPE=Debug ..
#cmake  -DDOC_USE_BOOTSTRAP=ON -DWITH_DOC=ON -DBUILD_DOXY=ON  -DCMAKE_BUILD_TYPE=Debug ..

# when more than one postgres version is installed on the computer
cmake -DPOSTGRESQL_BIN=/usr/lib/postgresql/$PGSQL_VER/bin -DDOC_USE_BOOTSTRAP=ON -DWITH_DOC=ON -DBUILD_DOXY=ON  -DBUILD_LATEX=OFF  -DCMAKE_BUILD_TYPE=$2 ..
#cmake -DPOSTGRESQL_BIN=/usr/lib/postgresql/$PGSQL_VER/bin -DDOC_USE_BOOTSTRAP=ON -DWITH_DOC=ON -DBUILD_DOXY=ON  -DBUILD_LATEX=OFF  -DCMAKE_BUILD_TYPE=$2 -DPGROUTING_DEBUG=ON ..
#cmake -DCMAKE_VERBOSE_MAKEFILE=ON  -DPOSTGRESQL_BIN=/usr/lib/postgresql/$PGSQL_VER/bin -DDOC_USE_BOOTSTRAP=ON -DWITH_DOC=ON -DBUILD_DOXY=ON  -DBUILD_LATEX=OFF  -DCMAKE_BUILD_TYPE=$2 ..
#cmake  -DPOSTGRESQL_BIN=/usr/lib/postgresql/$PGSQL_VER/bin -DDOC_USE_BOOTSTRAP=ON -DWITH_DOC=ON -DBUILD_DOXY=ON  -DBUILD_LATEX=OFF  -DCMAKE_BUILD_TYPE=$2 -DPGROUTING_DEBUG=ON -SET_VERSION_BRANCH=develop ..

#make doc
make
sudo make install
#exit 0
#make doxy
cd ..

echo --------------------------------------------
echo "updating signature for $PGR_VERSION"
echo --------------------------------------------
bash tools/release-scripts/get_signatures.sh
git diff sql/sigs/pgrouting--${PGR_VERSION}.sig
#sleep 2

echo --------------------------------------------
echo update NEWS for $PGR_VERSION
echo --------------------------------------------
tools/release-scripts/notes2news.pl
git diff NEWS
#sleep 2

echo --------------------------------------------
echo update documentation queries
echo --------------------------------------------
echo "tools/testers/algorithm-tester.pl  -documentation  -pgport $PGPORT"
#sleep 2

echo --------------------------------------------
echo  tests by directory
echo --------------------------------------------


for t in $TESTDIR
do
    tools/testers/algorithm-tester.pl  -alg $t -pgport $PGPORT -docmentation
    sleep 1
#    tools/testers/algorithm-tester.pl  -alg $t -pgport $PGPORT -debug1
#    sleep 1
    tools/developer/taptest.sh $t
    sleep 1
    tools/testers/algorithm-tester.pl  -alg $t -pgport $PGPORT
    sleep 1
done

cd build
#make doc
cd ..

echo --------------------------------------------
echo  All tests
echo --------------------------------------------
# tools/testers/algorithm-tester.pl -pgport $PGPORT

#tools/testers/algorithm-tester.pl  -pgport $PGPORT -docmentation
#tools/testers/algorithm-tester.pl  -pgport $PGPORT

return 0
echo pgTap testing all

dropdb --if-exists -p $PGPORT ___pgr___test___
createdb  -p $PGPORT ___pgr___test___
sh ./tools/testers/pg_prove_tests.sh $PGUSER $PGPORT Release
dropdb  -p $PGPORT ___pgr___test___
}

for v in $COMPILER
do
#    rm -rf build/*
#    test_compile $v Release
#    rm -rf build/*
    test_compile $v Debug
done

exit 0
