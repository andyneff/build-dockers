FROM golang:1.5.3
MAINTAINER Andy Neff <andyneff@users.noreply.github.com>

RUN cd /tmp && \
    wget https://storage.googleapis.com/golang/go1.5.3.darwin-amd64.tar.gz && \
    tar xf go1.5.3.darwin-amd64.tar.gz && \
    cp -r /tmp/go/pkg/darwin* /usr/local/go/pkg/ && \
    cp -r /tmp/go/pkg/obj/darwin* /usr/local/go/pkg/obj/ && \
    cp -r /tmp/go/pkg/tool/darwin* /usr/local/go/pkg/tool/ && \
    rm -r go*

VOLUME /go/src/github.com/github/git-lfs

WORKDIR /go/src/github.com/github/git-lfs

CMD if [ ! "ls -A /go/src/github.com/github/git-lfs" ]; then \
      git clone -n https://github.com/github/git-lfs.git . && \
      git checkout ${GITLFS_VERSION:-master}; \
    fi && \
    for GOARCH in 386 amd64; do \
      for GOOS in darwin linux windows; do \
        echo "Building ${GOARCH}/${GOOS}" && \
        GOARCH=$GOARCH GOOS=$GOOS ./script/bootstrap && \
        mv ./bin/git-lfs ./bin/git-lfs_$GOARCH_$GOOS; \
        ls ./bin ; \
      done; \
    done
#    cp -r T /src /tmp/src && \
#    /tmp/src/script/bootstrap
