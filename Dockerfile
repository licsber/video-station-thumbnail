FROM jrottenberg/ffmpeg:4.2-centos7

LABEL maintainer="Licsber <Licsber@njit.edu.cn>"

WORKDIR /

VOLUME [ "/video" ]

COPY main.sh .

ENTRYPOINT [ "/main.sh" ]

CMD [ "4" ]
