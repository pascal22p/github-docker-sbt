FROM eclipse-temurin:21-jdk

LABEL maintainer="pascal22p@parois.net"

RUN set -x \
  && apk --update add --no-cache --virtual .build-deps curl \
  && SBT_VER="1.10.1" \
  && ESUM="47fe98ce9498ee46e69f22672f3c12234cbe7e719e764410a13e58b725d659f3" \
  # && SBT_URL="https://piccolo.link/sbt-${SBT_VER}.tgz" \
  && SBT_URL="https://github.com/sbt/sbt/releases/download/v${SBT_VER}/sbt-${SBT_VER}.tgz" \
  && apk add shadow \
  && apk add bash \
  && apk add openssh \
  && apk add rsync \
  && apk add git \
  && apk add docker \
  && curl -Ls ${SBT_URL} > /tmp/sbt-${SBT_VER}.tgz \
  && sha256sum /tmp/sbt-${SBT_VER}.tgz \
  && (echo "${ESUM}  /tmp/sbt-${SBT_VER}.tgz" | sha256sum -c -) \
  && mkdir /opt/sbt \
  && tar -zxf /tmp/sbt-${SBT_VER}.tgz -C /opt/sbt \
  && sed -i -r 's#run \"\$\@\"#unset JAVA_TOOL_OPTIONS\nrun \"\$\@\"#g' /opt/sbt/sbt/bin/sbt \
  && apk del --purge .build-deps \
  && rm -rf /tmp/sbt-${SBT_VER}.tgz /var/cache/apk/*

COPY github-credentials.sbt /root/.sbt/1.0/


ADD entrypoint.sh /entrypoint.sh


ENV PATH="/opt/sbt/sbt/bin:$PATH" \
    JAVA_OPTS="-XX:+UseContainerSupport -Dfile.encoding=UTF-8" \
    SBT_OPTS="-Xmx2048M -Xss2M"


#RUN sbt about
ENTRYPOINT ["/entrypoint.sh"]
