ARG IMAGE=store/intersystems/iris-community:2019.4.0.383.0
FROM ${IMAGE}

# now for InterSystems IRIS

USER root

ENV SRC_DIR=/home/irisowner

COPY --chown=irisowner ./od/ $SRC_DIR/od

USER irisowner

RUN iris start $ISC_PACKAGE_INSTANCENAME && \
    /bin/echo -e " do \$system.OBJ.Load(\"/home/irisowner/od/Installer.cls\",\"ck\")\n" \
            " set sc = ##class(od.Installer).Setup(, 3)\n" \
            " halt" \
    | iris session $ISC_PACKAGE_INSTANCENAME && \
 iris stop $ISC_PACKAGE_INSTANCENAME quietly \
  && rm -rf $SRC_DIR/isc


HEALTHCHECK --interval=5s CMD /irisHealth.sh || exit 1
