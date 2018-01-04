(in-package :shop2-user)
(defproblem STRIPS-SAT-X-1 adlSat
  (
    ;;;
    ;;;  facts
    ;;;
    (SATELLITE SATELLITE0)
    (INSTRUMENT INSTRUMENT0)
    (SATELLITE SATELLITE1)
    (INSTRUMENT INSTRUMENT1)
    (INSTRUMENT INSTRUMENT2)
    (MODE INFRARED0)
    (MODE INFRARED1)
    (MODE THERMOGRAPH2)
    (DIRECTION GROUNDSTATION1)
    (DIRECTION STAR0)
    (DIRECTION STAR2)
    (DIRECTION PLANET3)
    (DIRECTION STAR4)
    (DIRECTION PLANET5)
    (DIRECTION STAR6)
    (DIRECTION STAR7)
    (DIRECTION PHENOMENON8)
    (DIRECTION PHENOMENON9)
    ;;;
    ;;;  initial states
    ;;;
    (SUPPORTS INSTRUMENT0 THERMOGRAPH2)
    (SUPPORTS INSTRUMENT0 INFRARED0)
    (CALIBRATION_TARGET INSTRUMENT0 STAR0)
    (ON_BOARD INSTRUMENT0 SATELLITE0)
    (POWER_AVAIL SATELLITE0)
    (POINTING SATELLITE0 STAR6)
    (SUPPORTS INSTRUMENT1 INFRARED0)
    (SUPPORTS INSTRUMENT1 THERMOGRAPH2)
    (SUPPORTS INSTRUMENT1 INFRARED1)
    (CALIBRATION_TARGET INSTRUMENT1 STAR2)
    (SUPPORTS INSTRUMENT2 THERMOGRAPH2)
    (SUPPORTS INSTRUMENT2 INFRARED1)
    (CALIBRATION_TARGET INSTRUMENT2 STAR2)
    (ON_BOARD INSTRUMENT1 SATELLITE1)
    (ON_BOARD INSTRUMENT2 SATELLITE1)
    (POWER_AVAIL SATELLITE1)
    (POINTING SATELLITE1 STAR0)
  )
  ;;;
  ;;; goals
  ;;;
  (:ordered 
    (:TASK HAVE_IMAGE PLANET3 INFRARED1)
    (:TASK HAVE_IMAGE STAR4 INFRARED1)
    (:TASK HAVE_IMAGE PLANET5 THERMOGRAPH2)
    (:TASK HAVE_IMAGE STAR6 INFRARED1)
    (:TASK HAVE_IMAGE STAR7 INFRARED0)
    (:TASK HAVE_IMAGE PHENOMENON8 THERMOGRAPH2)
    (:TASK HAVE_IMAGE PHENOMENON9 INFRARED0)
  )
)