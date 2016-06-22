#!/bin/bash
# Waring: Make sure to run this script under bypy sub dir
cd `dirname $0` 
# check python 2.7 installed
whereis python |grep python2.7
if [ $? -ne 0 ]; then 
    echo "++++++ installing python2.7 ..."
    yum install -y centos-release-SCL
    yum install -y python27
fi
# install easy_install
echo "++++++ installing easy_install ..."
tmp_dir="./tmp`date +%y%m%d%H%M%s`"
mkdir -p ${tmp_dir} && cd ${tmp_dir}
# below cause error 
wget https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py
python2.7 ez_setup.py
cd .. && rm -fr ${tmp_dir}

easy_install-2.7 pip
# install requests
easy_install-2.7 requests

# now auth this python bypy client
echo "++++++ now auth this python client of bypy...."
python2.7 bypy.py list

# adding to crontab like this
echo " */2 * * * * ( /Data/bypy/daemon.sh /Data/youtube >> /Data/bypy/bypy.log 2>&1 )"

exit 0

