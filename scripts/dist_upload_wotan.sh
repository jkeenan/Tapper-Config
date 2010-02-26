#! /bin/bash

EXECDIR=$(dirname $0)
DISTFILES='Artemis*-*.*.tar.gz '
$EXECDIR/../../Artemis/scripts/artemis_version_increment.pl $EXECDIR/../lib/Artemis/Config.pm
cd $EXECDIR/..

if [[ -e MANIFEST ]]
then
  rm MANIFEST
fi
./Build manifest || exit -1

perl Build.PL || exit -1
./Build dist || exit -1

# -----------------------------------------------------------------
# It is important to not overwrite existing files.
# -----------------------------------------------------------------
# That guarantees that the version number is incremented so that we
# can be sure about version vs. functionality.
# -----------------------------------------------------------------

echo ""
echo '----- upload ---------------------------------------------------'
rsync -vv --progress --ignore-existing ${DISTFILES} artemis@bancroft:/home/artemis/CPANSITE/CPAN/authors/id/A/AR/ARTEMIS/

echo ""
echo '----- re-index -------------------------------------------------'
ssh artemis@bancroft /home/artemis/perl510/bin/cpansite -vl index /home/artemis/CPANSITE/CPAN/
ssh artemis@bancroft /home/artemis/perl510/bin/cpan Artemis::Config
