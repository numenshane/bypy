#!/bin/bash
# Waring: Make sure to run this script under bypy sub dir
cd `dirname $0`
local_flag=0 
# check python 2.7 installed
whereis python |grep python2.7
if [ $? -ne 0 ]; then 
    ${local_flag}=1
    echo "++++++ yum install ++++++ "
    yum groupinstall -y 'development tools'
    yum install -y zlib-devel bzip2-devel openssl-devel xz-libs wget
    yum install xz -y

    echo "++++++ installing python2.7 from src ++++++"
    src_dir="./tmp`date +%y%m%d%H%M%s`"
    mkdir -p ${src_dir} && cd ${src_dir}
    wget https://www.python.org/ftp/python/2.7.8/Python-2.7.8.tar.xz
    xz -d Python-2.7.8.tar.xz
    tar -xvf Python-2.7.8.tar
    cd Python-2.7.8 && ./configure --prefix=/usr/local
    make && make altinstall
    make clean && cd ../.. && rm -fr ${src_dir}
    
    echo "rm old link, create new, modify yum conf"
    mv /usr/bin/python /usr/bin/python_backup
    ln -s /usr/local/bin/python2.7 /usr/bin/python
    sed -i 's/\/usr\/bin\/python$/\/usr\/bin\/python2.6.6/1' /usr/bin/yum
fi    
    # install easy_install
    echo "++++++ installing easy_install ..."
    tmp_dir="./tmp`date +%y%m%d%H%M%s`"
    mkdir -p ${tmp_dir} && cd ${tmp_dir}
    wget https://bootstrap.pypa.io/ez_setup.py
    python2.7 ez_setup.py
    cd .. && rm -fr ${tmp_dir}

    easy_install-2.7 pip
    # install requests
    easy_install-2.7 requests
    pip install bypy

# now auth this python bypy client
echo "++++++ now auth this python client of bypy...."
if [ ${local_flag} -eq '1' ]; 
    then /usr/local/bin/python2.7 bypy.py list
else 
    python2.7 bypy.py list
fi

# adding to crontab like this
echo "*/2 * * * * ( /Data/bypy/daemon.sh /Data/youtube >> /Data/bypy/bypy.log 2>&1 )"

exit 0
