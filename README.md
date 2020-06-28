# install
* Install dependency
```
git clone https://github.com/s-nakaoka/choreonoid --branch release-1.7
./choreonoid/misc/script/install-requisites-ubuntu-16.04.sh
patch -p1 -d choreonoid < [path to pr2_choreonoid]/choreonoid.patch
git clone https://github.com/Naoki-Hiraoka/choreonoid_rosplugin --branch pr2
https://github.com/Naoki-Hiraoka/jsk_pr2eus --branch namespace
catkin build choreonoid choreonoid_rosplugin pr2eus
```

* Build pr2_choreonoid
```
catkin build pr2_choreonoid
```

* Generate pr2.wrl
First, install simtrans (see https://github.com/fkanehiro/simtrans).
Then,
```
mkdir `rospack find pr2_choreonoid`/wrl
rosrun xacro xacro.py `rospack find pr2_description`/robots/pr2.urdf.xacro > /tmp/pr2.urdf
simtrans -i /tmp/pr2.urdf -o `rospack find pr2_choreonoid`/wrl/pr2.wrl --use-both
FNAME=`rospack find pr2_choreonoid`/wrl/pr2.wrl bash `rospack find pr2_choreonoid`/add-rotorinertia.sh
```

# Run simulation
```
roslaunch pr2_choreonoid pr2_choreonoid.launch
```
```
roscd pr2eus
roseus ./pr2-interface.l
(setq *ri* (instance pr2-interface :init :namespace "PR2")) 
(setq *robot* (pr2))
(send *ri* :angle-vector (send *robot* :reset-manip-pose)) 
(do-until-key (send *ri* :send-cmd-vel-raw 1 0 0))
```