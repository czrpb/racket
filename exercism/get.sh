#!/usr/bin/env bash

set -x

exercism configure -w $PWD

exercism download --exercise=$1 --track=racket

mv -v racket/$1 .

cd $1

#file="$(echo $1 | tr - _)"
file="$1"

cat <<EOL > submit.sh
#!/usr/bin/env bash

set -x
exercism submit $file.rkt
EOL

chmod 755 submit.sh
