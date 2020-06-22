FROM lsstdesc/stack-sims:w_2019_42-sims_w_2020_24
MAINTAINER Heather Kelly <heather@slac.stanford.edu>

ARG LSST_STACK_DIR=/opt/lsst/software/stack
ARG LSST_USER=lsst
ARG LSST_GROUP=lsst

ARG LSST_STACK_VER=w_2020_24

ARG LSST_IMSIM_VER=v0.6.1

ENV HDF5_USE_FILE_LOCKING FALSE

WORKDIR $LSST_STACK_DIR


RUN /bin/bash -c 'source $LSST_STACK_DIR/loadLSST.bash; \
                  pip freeze > $LSST_STACK_DIR/require.txt; \
                  setup -t sims_$LSST_STACK_VER sims_catUtils; \
                  chmod ugo+x $SIMS_CATUTILS_DIR/support_scripts/get_kepler_light_curves.sh; \
                  chmod ugo+x $SIMS_CATUTILS_DIR/support_scripts/get_mdwarf_flares.sh; \
                  $SIMS_CATUTILS_DIR/support_scripts/get_kepler_light_curves.sh; \
                  $SIMS_CATUTILS_DIR/support_scripts/get_mdwarf_flares.sh; \
                  unset sims_catUtils; ' && \
    cd $LSST_STACK_DIR && \
    mkdir astropy_iers && \
    cd astropy_iers && \
    curl -LO https://raw.githubusercontent.com/LSSTDESC/imSim/$LSST_IMSIM_VER/data/19-10-30-finals2000A.all 


