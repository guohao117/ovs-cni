#!/bin/bash -xe

main() {
    TARGET="$0"
    TARGET="${TARGET#./}"
    TARGET="${TARGET%.*}"
    TARGET="${TARGET#*.}"
    echo "TARGET=$TARGET"
    export TARGET

    cd ..
    export GOROOT=/usr/local/go
    export GOPATH=$(pwd)/go
    export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
    mkdir -p $GOPATH

    echo "Install Go 1.10"
    export GIMME_GO_VERSION=1.10
    mkdir -p /gimme
    curl -sL https://raw.githubusercontent.com/travis-ci/gimme/master/gimme | HOME=/gimme bash >> /etc/profile.d/gimme.sh
    source /etc/profile.d/gimme.sh

    mkdir -p $GOPATH/src/kubevirt.io
    mkdir -p $GOPATH/pkg
    ln -s $(pwd)/ovs-cni $GOPATH/src/kubevirt.io/
    cd $GOPATH/src/kubevirt.io/ovs-cni

    echo "Run functional tests"
    exec automation/test.sh
}

[[ "${BASH_SOURCE[0]}" == "$0" ]] && main "$@"
