#!/bin/sh

SCM_REPO_PATH=$1
SCM_TYPE=$2
SCM_PROJECT=$3

SCM_REPO_URL=file://$SCM_REPO_PATH

PATH={{ bitnami_home }}/subversion/bin:$PATH

case "$SCM_TYPE" in
    svn)
        svn mkdir $SCM_REPO_URL/{trunk,branches,tags} \
            --username admin -m "Add trunk, branches, tags."
        ;;
    git)
        ;;
    *)
        echo "SCM not supported: $SCM_TYPE" >&2
        ;;
esac

exit 0
