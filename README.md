Author: TianChi Date: 2015-12
#using bypy as backend content consumer agent
	bypy: python client for BaiDu Yun disk
#first: check out src code under certain dir for convient usage
	mkdir -p /Data && cd /Data 
	for read only
	     	git clone https://github.com/numenshane/bypy
        for write 
	     	git clone https://numenshane@github.com/numenshane/bypy
       	for ssh not http(s)
	     	edit .git/config, convert https:// to ssh://git@
		need private ssh key to push remotely
#Second: auto provision for env
        sh -x auto_provision.sh #install python2.7 and request lib
	open browser to input auth code #using open auth for bypy client to access your Yun disk file   
#Third: periodly batch job using crontab
	using daemon.sh to sync remote bypy's dir, currently just hardcode using localdir /Data/youtube
	crontabl -e 
	    	*/2 * * * * ( /Data/bypy/daemon.sh >> /Data/bypy/bypy.log 2>&1 )
#Continuing
