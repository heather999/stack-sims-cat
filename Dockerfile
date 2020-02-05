FROM lsstdesc/stack-sims:w_2019_42-sims_w_2019_42-v2
MAINTAINER Heather Kelly <heather@slac.stanford.edu>

ARG LSST_STACK_DIR=/opt/lsst/software/stack
ARG LSST_USER=lsst
ARG LSST_GROUP=lsst

ENV HDF5_USE_FILE_LOCKING FALSE

WORKDIR $LSST_STACK_DIR


RUN /bin/bash -c 'source $LSST_STACK_DIR/loadLSST.bash; \
                  pip freeze > $LSST_STACK_DIR/require.txt; \
                  sed -i 's/astropy==3.1.2/astropy==3.2.3/g' $LSST_STACK_DIR/require.txt; \
                  pip install -c $LSST_STACK_DIR/require.txt astropy==3.2.3; \
                  pip install -c $LSST_STACK_DIR/require.txt pyarrow==0.13.0; \
                  setup -t sims_w_2019_42 sims_catUtils; \
                  chmod ugo+x $SIMS_CATUTILS_DIR/support_scripts/get_kepler_light_curves.sh; \
                  chmod ugo+x $SIMS_CATUTILS_DIR/support_scripts/get_mdwarf_flares.sh; \
                  $SIMS_CATUTILS_DIR/support_scripts/get_kepler_light_curves.sh; \
                  $SIMS_CATUTILS_DIR/support_scripts/get_mdwarf_flares.sh; \
                  unset sims_catUtils; ' && \
    cd $LSST_STACK_DIR && \
    mkdir astropy_iers && \
    cd astropy_iers && \
    curl -LO https://raw.githubusercontent.com/LSSTDESC/imSim/v0.6.1/data/19-10-30-finals2000A.all 


