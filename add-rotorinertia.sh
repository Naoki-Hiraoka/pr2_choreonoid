FNAME=$FNAME

#add rotorInertia to all joints
ROTOR_INERTIA=1.0 # Temporary
LINES=`grep -n -E "DEF .* Joint" $FNAME | cut -d: -f1 | tac` #reverse order

for l in ${LINES[@]};
do
    ed $FNAME << EOF
$l
a
rotorInertia $ROTOR_INERTIA # Temporary value for simulation!!
.
w
q
EOF
done


#modify robotInertia
ROTOR_INERTIA_VECTOR=("torso_lift_joint 100000.0"
                      "bl_caster_rotation_joint 0.01"
                      "br_caster_rotation_joint 0.01"
                      "fl_caster_rotation_joint 0.01"
                      "fr_caster_rotation_joint 0.01"
)

for i in `seq ${#ROTOR_INERTIA_VECTOR[@]}`;
do
    _ROTOR_INERTIA_VEC=(${ROTOR_INERTIA_VECTOR[$(($i - 1))]})
    _JOINT_NAME=${_ROTOR_INERTIA_VEC[0]}
    _ROTOR_INERTIA=${_ROTOR_INERTIA_VEC[1]}
    sed -e "/$_JOINT_NAME Joint/{n; s/\(.*rotorInertia \)[0-9.]*/\1$_ROTOR_INERTIA/g}" $FNAME > /tmp/add_rotorinertia.wrl
    mv /tmp/add_rotorinertia.wrl $FNAME
done


#modify mass (simulate the effect of counter weight)
MASS_VECTOR=("l_shoulder_pan_link 0.1"
             "l_shoulder_lift_link 0.1"
             "l_upper_arm_roll_link 0.1"
             "l_elbow_flex_link 0.1"
             "l_forearm_roll_link 0.1"
             "l_wrist_flex_link 0.1"
             "l_wrist_roll_link 0.1"
             "r_shoulder_pan_link 0.1"
             "r_shoulder_lift_link 0.1"
             "r_upper_arm_roll_link 0.1"
             "r_elbow_flex_link 0.1"
             "r_forearm_roll_link 0.1"
             "r_wrist_flex_link 0.1"
             "r_wrist_roll_link 0.1")

for i in `seq ${#MASS_VECTOR[@]}`;
do
    _MASS_VEC=(${MASS_VECTOR[$(($i - 1))]})
    _LINK_NAME=${_MASS_VEC[0]}
    _MASS=${_MASS_VEC[1]}
    sed -e "/$_LINK_NAME Segment/{n; s/\(.*mass \)[0-9.]*/\1$_MASS/g}" $FNAME > /tmp/add_rotorinertia.wrl
    mv  /tmp/add_rotorinertia.wrl $FNAME
done
