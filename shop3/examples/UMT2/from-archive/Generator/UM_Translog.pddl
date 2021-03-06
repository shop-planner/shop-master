
(define (domain UM-Translog-2)
	(:requirements :typing :adl :equality :negative-preconditions :existential-preconditions :universal-preconditions :fluents)
	(:types region package city location vehicle route equipment ptype vtype vptype rtype ltype - object
		crane plane-ramp - equipment)

	(:constants regularv flatbed tanker hopper auto air - vtype
		    truck airplane train - vptype
		    road-route rail-route air-route - rtype
		    regularp bulky liquid granular cars mail - ptype
		    airport train-station - ltype)

    	(:predicates (at-equipment ?e - equipment ?l - location)
			(at-packagec ?p - package ?c - crane)
		      (at-packagel ?p - package ?l - location)
			(at-packagev ?p - package ?v - vehicle)
		     	(at-vehicle ?v - vehicle ?l - location)
		     	(availablel ?l - location)
			(availabler ?r - route)
			(availablev ?v - vehicle)
		     	(chute-connected ?v - vehicle)
			(clear)
			(connect-city ?r - route ?rtype - rtype ?c1 ?c2 - city)
		     	(connect-loc ?r - route ?rtype - rtype ?l1 ?l2 - location)
			(delivered ?p - package ?d - location )
			(door-open ?v - vehicle)
			(empty ?c - crane)
			(fees-collected ?p - package)
			(hose-connected ?v - vehicle)
			(h-start ?p - package)
			(hub ?l - location)
			(in-city ?l - location ?c - city)
			(in-region ?c - city ?r - region) 
			(move ?p - package)
			(move-emp ?v - vehicle)
			(over ?p - package)
			(pv-compatible ?ptype - ptype ?vtype - vtype)
			(ramp-connected ?v - vehicle ?r - plane-ramp)
			(ramp-down ?v - vehicle)
			(rv-compatible ?rtype - rtype ?vptype - vptype)
			(serves ?h - location ?r - region)
			(tcenter ?l - location)
			(t-end ?p - package)
			(t-start ?p - package) 
			(typel ?l - location ?type - ltype)
			(typep ?p - package ?type - ptype)
			(typev ?v - vehicle ?type - vtype)
			(typevp ?v - vehicle ?type - vptype)
		      (unload ?v - vehicle)
			(valve-open ?v - vehicle))
	(:functions	(distance ?l1 ?l2 - location)
			(gas-left ?v - vehicle)
			(gpm ?v - vehicle)
			(height-v ?v - vehicle)
			(height-cap-l ?l - location)
			(height-cap-r ?r - route)
			(length-v ?v - vehicle)
			(length-cap-l ?l - location)
			(local-height ?c - city)
			(local-weight ?c - city)
			(volume-cap-c ?c - crane)
			(volume-cap-l ?l - location)
			(volume-cap-v ?v - vehicle)
			(volume-load-l ?l - location)
			(volume-load-v ?v - vehicle)
			(volume-p ?p - package)
			(weight-cap-c ?c - crane)
			(weight-cap-r ?r - route)
			(weight-cap-v ?v - vehicle)
			(weight-p ?p - package)
			(weight-load-v ?v - vehicle)
			(weight-v ?v - vehicle)
			(width-v ?v - vehicle)
			(width-cap-l ?l - location))

	(:action collect-fees
      		:parameters (?p - package)
		:precondition (and (not (fees-collected ?p))
					 (not (exists (?dd - location)
					              (delivered ?p ?dd))))
      		:effect (fees-collected ?p))

	(:action deliver
		:parameters (?p - package ?d - location)
		:precondition (and (at-packagel ?p ?d)
				   (not (exists (?dd - location)
					    (delivered ?p ?dd))))
		:effect (and (delivered ?p ?d)
			       (not (at-packagel ?p ?d))
			     (decrease (volume-load-l ?d) (volume-p ?p))))

	(:action open-door-regular
		:parameters (?v - vehicle)
		:precondition (and (not (door-open ?v))
				   	 (typev ?v regularv))
		:effect (door-open ?v))

	(:action close-door-regular
		:parameters (?v - vehicle)
		:precondition (and (door-open ?v)
				       (typev ?v regularv))
		:effect (not (door-open ?v)))

	(:action load-regular
		:parameters (?p - package ?v - vehicle ?l - location)
		:precondition (and (at-vehicle ?v ?l)
				   (availablev ?v)
				   (at-packagel ?p ?l)
				   (typev ?v regularv)
				   (exists (?ptype - ptype)
				       (and (typep ?p ?ptype)
				   	    (pv-compatible ?ptype regularv)))
				   (door-open ?v)
				   (>= (weight-cap-v ?v) (+ (weight-load-v ?v) (weight-p ?p)))
				   (>= (volume-cap-v ?v) (+ (volume-load-v ?v) (volume-p ?p)))
				   (fees-collected ?p))
		:effect (and (at-packagev ?p ?v) 
			     (not (at-packagel ?p ?l))
			     (decrease (volume-load-l ?l) (volume-p ?p))			     
			     (increase (weight-load-v ?v) (weight-p ?p))
			     (increase (volume-load-v ?v) (volume-p ?p))))

	(:action unload-regular
		:parameters (?p - package ?v - vehicle ?l - location)
		:precondition (and (at-vehicle ?v ?l)
				   (at-packagev ?p ?v)
				   (typev ?v regularv)
				   (>= (volume-cap-l ?l) (+ (volume-load-l ?l) (volume-p ?p)))
				   (door-open ?v))
		:effect (and (at-packagel ?p ?l)
			     (not (at-packagev ?p ?v))
			     (not (move ?p))
			     (unload ?v)
			     (not (clear))
			     (increase (volume-load-l ?l) (volume-p ?p))			    
			     (decrease (weight-load-v ?v) (weight-p ?p))
			     (decrease (volume-load-v ?v) (volume-p ?p))))
   	
	(:action pick-up-package-ground
		:parameters (?p - package ?c - crane ?l - location)
		:precondition (and (at-equipment ?c ?l)
				   (at-packagel ?p ?l)
				   (empty ?c)
				   (fees-collected ?p)
				   (<= (weight-p ?p) (weight-cap-c ?c))
				   (<= (volume-p ?p) (volume-cap-c ?c)))
   		:effect (and (at-packagec ?p ?c)
			     (not (empty ?c))
			     (decrease (volume-load-l ?l) (volume-p ?p))
			     (not (at-packagel ?p ?l))))

	(:action put-down-package-vehicle
		:parameters (?p - package ?c - crane ?v - vehicle ?l - location)
		:precondition (and (at-equipment ?c ?l)
				   (at-packagec ?p ?c)
				   (at-vehicle ?v ?l)
				   (typev ?v flatbed)
				   (availablev ?v)
				   (exists (?ptype - ptype)
				       (and (typep ?p ?ptype)
					    (pv-compatible ?ptype flatbed)))
				   (>= (weight-cap-v ?v) (+ (weight-load-v ?v) (weight-p ?p)))
				   (>= (volume-cap-v ?v) (+ (volume-load-v ?v) (volume-p ?p)))
				   (fees-collected ?p))
		:effect (and (empty ?c)
			     (at-packagev ?p ?v)
			     (not (at-packagec ?p ?c))
			     (increase (weight-load-v ?v) (weight-p ?p))
		             (increase (volume-load-v ?v) (volume-p ?p))))

	(:action pick-up-package-vehicle
		:parameters (?p - package ?c - crane ?v - vehicle ?l - location)
		:precondition (and (empty ?c)
				   (at-equipment ?c ?l)
				   (at-packagev ?p ?v)
				   (at-vehicle ?v ?l)
				   (<= (weight-p ?p) (weight-cap-c ?c))
				   (<= (volume-p ?p) (volume-cap-c ?c)) 
				   (typev ?v flatbed))
   		:effect (and (at-packagec ?p ?c)
			     (not (empty ?c))
			     (not (at-packagev ?p ?v))
			     (decrease (weight-load-v ?v) (weight-p ?p))
		             (decrease (volume-load-v ?v) (volume-p ?p))))

	(:action put-down-package-ground
		:parameters (?p - package ?c - crane ?l - location)
		:precondition (and (at-equipment ?c ?l)
				   (at-packagec ?p ?c)
				   (>= (volume-cap-l ?l) (+ (volume-load-l ?l) (volume-p ?p))))
		:effect (and (at-packagel ?p ?l)
			     (empty ?c)	
			     (not (move ?p))
			     (increase (volume-load-l ?l) (volume-p ?p))
			     (not (at-packagec ?p ?c))))
 
	(:action connect-chute
		:parameters (?v - vehicle)
		:precondition (and (not (chute-connected ?v))
				   (typev ?v hopper))
		:effect (chute-connected ?v))

	(:action disconnect-chute
		:parameters (?v - vehicle)
		:precondition (and (chute-connected ?v)
 				   (typev ?v hopper))
   		:effect (not (chute-connected ?v)))

	(:action fill-hopper
		:parameters (?p - package ?v - vehicle ?l - location)
   		:precondition (and (chute-connected ?v)
				   (at-vehicle ?v ?l)
				   (at-packagel ?p ?l)
				   (availablev ?v)
   				   (typev ?v hopper)	
				   (exists (?ptype - ptype)
				       (and (typep ?p ?ptype)
					    (pv-compatible ?ptype hopper)))
				   (>= (weight-cap-v ?v) (+ (weight-load-v ?v) (weight-p ?p)))
				   (>= (volume-cap-v ?v) (+ (volume-load-v ?v) (volume-p ?p)))
				   (fees-collected ?p))
		:effect (and (at-packagev ?p ?v)
			     (not (at-packagel ?p ?l))
			     (decrease (volume-load-l ?l) (volume-p ?p))			    
			     (increase (weight-load-v ?v) (weight-p ?p))
			     (increase (volume-load-v ?v) (volume-p ?p))))

	(:action empty-hopper
		:parameters (?p - package ?v - vehicle ?l - location)
		:precondition (and (chute-connected ?v)
				   (at-vehicle ?v ?l)
				   (at-packagev ?p ?v)
				   (>= (volume-cap-l ?l) (+ (volume-load-l ?l) (volume-p ?p)))
				   (typev ?v hopper))
		:effect (and (at-packagel ?p ?l)
			     (not (at-packagev ?p ?v))
			     (not (move ?p))
			     (unload ?v)
			     (not (clear))
			     (increase (volume-load-l ?l) (volume-p ?p))			     
			     (decrease (weight-load-v ?v) (weight-p ?p))
			     (decrease (volume-load-v ?v) (volume-p ?p))))
 
	(:action connect-hose
		:parameters (?v - vehicle)
		:precondition (and (not (hose-connected ?v))
				   (typev ?v tanker))
		:effect (hose-connected ?v))

	(:action disconnect-hose
		:parameters (?v - vehicle)
		:precondition (and (hose-connected ?v)
				   (not (valve-open ?v))
				   (typev ?v tanker))
		:effect (not (hose-connected ?v)))

	(:action open-valve
		:parameters (?v - vehicle)
		:precondition (and (not (valve-open ?v))
				   (hose-connected ?v)
				   (typev ?v tanker))
		:effect (valve-open ?v))
 
	(:action close-valve
		:parameters (?v - vehicle)
		:precondition (and (valve-open ?v)
				   (typev ?v tanker))
		:effect (not (valve-open ?v)))

	(:action fill-tank
		:parameters (?p - package ?v - vehicle ?l - location)
		:precondition (and (at-vehicle ?v ?l)
				   (at-packagel ?p ?l)
				   (typev ?v tanker)
				   (availablev ?v)
				   (exists (?ptype - ptype)
				       (and (typep ?p ?ptype)
					    (pv-compatible ?ptype tanker)))
   				   (valve-open ?v)
				   (hose-connected ?v)
				   (>= (weight-cap-v ?v) (+ (weight-load-v ?v) (weight-p ?p)))
				   (>= (volume-cap-v ?v) (+ (volume-load-v ?v) (volume-p ?p)))
				   (fees-collected ?p))
   		:effect (and (at-packagev ?p ?v)
			     (not (at-packagel ?p ?l))
			     (decrease (volume-load-l ?l) (volume-p ?p))			     
			     (increase (weight-load-v ?v) (weight-p ?p))
			     (increase (volume-load-v ?v) (volume-p ?p))))

	(:action empty-tank
		:parameters (?p - package ?v - vehicle ?l - location)
		:precondition (and (at-vehicle ?v ?l)
				   (at-packagev ?p ?v)
				   (typev ?v tanker)
				   (>= (volume-cap-l ?l) (+ (volume-load-l ?l) (volume-p ?p)))
				   (hose-connected ?v)
				   (valve-open ?v))
		:effect (and (at-packagel ?p ?l)
			     (not (at-packagev ?p ?v))
			     (not (move ?p))
			     (unload ?v)
			     (not (clear))
			     (increase (volume-load-l ?l) (volume-p ?p))			   
			     (decrease (weight-load-v ?v) (weight-p ?p))
			     (decrease (volume-load-v ?v) (volume-p ?p))))
 
	(:action raise-ramp
      		:parameters (?v - vehicle)
		:precondition (and (ramp-down ?v)
			           (typev ?v auto))
  	    	:effect (not (ramp-down ?v)))

   	(:action lower-ramp
   	   	:parameters (?v - vehicle)
		:precondition (and (not (ramp-down ?v))
				   (typev ?v auto))
      		:effect (ramp-down ?v))

	(:action load-cars
		:parameters (?p - package ?v - vehicle ?l - location)
            	:precondition (and (typev ?v auto)
				   (exists (?ptype - ptype)
				       (and (typep ?p ?ptype)
					    (pv-compatible ?ptype auto)))
				   (availablev ?v)
				   (at-packagel ?p ?l)
				   (at-vehicle ?v ?l)
				   (ramp-down ?v)
				   (>= (weight-cap-v ?v) (+ (weight-load-v ?v) (weight-p ?p)))
				   (>= (volume-cap-v ?v) (+ (volume-load-v ?v) (volume-p ?p)))
				   (fees-collected ?p))
		:effect (and (at-packagev ?p ?v)
			     (not (at-packagel ?p ?l))
			     (decrease (volume-load-l ?l) (volume-p ?p))			     
			     (increase (weight-load-v ?v) (weight-p ?p))
			     (increase (volume-load-v ?v) (volume-p ?p))))
				
	(:action unload-cars
 		:parameters (?p - package ?v - vehicle ?l - location)
      		:precondition (and  (at-packagev ?p ?v)  
		              	    (at-vehicle ?v ?l)  
				    (typev ?v auto)
				    (>= (volume-cap-l ?l) (+ (volume-load-l ?l) (volume-p ?p)))
				    (ramp-down ?v))
		:effect (and (at-packagel ?p ?l)
		             (not (at-packagev ?p ?v))
			    (not (move ?p))
			     (unload ?v)
			     (not (clear))
			     (increase (volume-load-l ?l) (volume-p ?p))			  
			     (decrease (weight-load-v ?v) (weight-p ?p))
			     (decrease (volume-load-v ?v) (volume-p ?p))))
 
  	(:action attach-conveyor-ramp
      		:parameters (?v - vehicle ?r - plane-ramp ?l - location)
      		:precondition (and (not (exists (?vv - vehicle)
							   (ramp-connected ?vv ?r)))  
		                   (at-equipment ?r ?l)  
				       (typev ?v air)
				   (not (exists (?rr - plane-ramp)
					    (ramp-connected ?v ?rr)))
		                   (at-vehicle ?v ?l))
      		:effect (ramp-connected ?v ?r))

  	(:action detach-conveyor-ramp
      		:parameters (?v - vehicle ?r - plane-ramp ?l - location)
      		:precondition (and (ramp-connected ?v ?r)  
			           (at-equipment ?r ?l)  
			           (at-vehicle ?v ?l)
				   (not (door-open ?v)))
      		:effect (not (ramp-connected ?v ?r)))

	(:action open-door-airplane
		:parameters (?v - vehicle)
		:precondition (and (not (door-open ?v))
				       (typev ?v air)
					 (exists (?r - plane-ramp)
					     (ramp-connected ?v ?r))) 
		:effect (door-open ?v))

	(:action close-door-airplane
		:parameters (?v - vehicle)
		:precondition (and (door-open ?v)
					 (typev ?v air))
		:effect (not (door-open ?v)))	

	(:action load-airplane
 		:parameters (?p - package ?v - vehicle ?l - location)
		:precondition (and (at-packagel ?p ?l)  
				   (at-vehicle ?v ?l)  
				   (availablev ?v)
				   (exists (?ptype - ptype)
				       (and (typep ?p ?ptype)
					    (pv-compatible ?ptype air)))	
				   (door-open ?v)
				   (exists (?ramp - plane-ramp)
					(ramp-connected ?v ?ramp))
				   (>= (weight-cap-v ?v) (+ (weight-load-v ?v) (weight-p ?p)))
				   (>= (volume-cap-v ?v) (+ (volume-load-v ?v) (volume-p ?p)))
				   (fees-collected ?p))
       	:effect (and (at-packagev ?p ?v)
		     (not (at-packagel ?p ?l))
		     (decrease (volume-load-l ?l) (volume-p ?p))
		     (increase (weight-load-v ?v) (weight-p ?p))
		     (increase (volume-load-v ?v) (volume-p ?p))))

	(:action unload-airplane
 		:parameters (?p - package ?v - vehicle ?l - location)
		:precondition (and (typev ?v air)
				   (at-packagev ?p ?v)  
				   (at-vehicle ?v ?l)  
				   (>= (volume-cap-l ?l) (+ (volume-load-l ?l) (volume-p ?p)))
				   (exists (?ramp - plane-ramp)
					(ramp-connected ?v ?ramp))
				   (door-open ?v))
       		:effect (and (at-packagel ?p ?l)
		     	     (not (at-packagev ?p ?v))
			    (not (move ?p))
			     (unload ?v)
			     (not (clear))
			     (increase (volume-load-l ?l) (volume-p ?p))
		             (decrease (weight-load-v ?v) (weight-p ?p))
		             (decrease (volume-load-v ?v) (volume-p ?p))))

	
	(:action move-vehicle-local-road-route1
		:parameters (?v - vehicle ?ori - location ?des - location ?ocity - city)
		:precondition (and (at-vehicle ?v ?ori)
				   (not (= ?ori ?des))
				   (or (> (volume-load-v ?v) 0)
				       (not (move-emp ?v)))
				   (or (and (typev ?v regularv)
					    (not (door-open ?v)))
				       (and (typev ?v hopper)
					    (not (chute-connected ?v)))
				        (and (typev ?v tanker)
					    (not (valve-open ?v))
					    (not (hose-connected ?v)))
				       (and (typev ?v auto)
					    (not (ramp-down ?v)))
				       (and (typev ?v air)
					    (not (door-open ?v))
					    (not (exists (?ramp - plane-ramp)
					             (ramp-connected ?v ?ramp))))
				       (typev ?v flatbed))	
			        (>= (height-cap-l ?des) (height-v ?v))
 		              (>= (length-cap-l ?des) (length-v ?v))
				  (>= (width-cap-l ?des) (width-v ?v))
				  (>= (gas-left ?v) (* (gpm ?v) (distance ?ori ?des)))
				  (typevp ?v truck)
				  (in-city ?ori ?ocity)
				  (in-city ?des ?ocity)
				  (<= (height-v ?v) (local-height ?ocity))
				  (<= (+ (weight-v ?v) (weight-load-v ?v)) (local-weight ?ocity))
				  (or (and (tcenter ?ori)
					     (tcenter ?des))
					(and (not (tcenter ?ori))
					     (not (tcenter ?des))))
			        (not (exists (?p - package)
				           (and (at-packagev ?p ?v)
					          (or (over ?p)
							  (move ?p)
							  (t-start ?p)
					              (t-end ?p)
					              (h-start ?p))))))
		:effect (and (not (at-vehicle ?v ?ori))
	                   (at-vehicle ?v ?des)
				 (when (> (volume-load-v ?v) 0)
					(not (move-emp ?v)))
			       (when (= (volume-load-v ?v) 0)
					(move-emp ?v))
			       (decrease (gas-left ?v) (* (distance ?ori ?des) (gpm ?v)))
			       (forall (?p - package)
			   	     (when (at-packagev ?p ?v)
				           (and (move ?p)
						    (over ?p))))))

	(:action move-vehicle-local-road-route2
		:parameters (?v - vehicle ?ori - location ?des - location ?ocity - city)
		:precondition (and (at-vehicle ?v ?ori)
				   (not (= ?ori ?des))
				    (or (> (volume-load-v ?v) 0)
				       (not (move-emp ?v)))
				   (or (and (typev ?v regularv)
					    (not (door-open ?v)))
				       (and (typev ?v hopper)
					    (not (chute-connected ?v)))
				     (and (typev ?v tanker)
					    (not (valve-open ?v))
					    (not (hose-connected ?v)))
				       (and (typev ?v auto)
					    (not (ramp-down ?v)))
				       (and (typev ?v air)
					    (not (door-open ?v))
					    (not (exists (?ramp - plane-ramp)
					             (ramp-connected ?v ?ramp))))
				       (typev ?v flatbed))	
			        (>= (height-cap-l ?des) (height-v ?v))
 		              (>= (length-cap-l ?des) (length-v ?v))
				  (>= (width-cap-l ?des) (width-v ?v))
				  (>= (gas-left ?v) (* (gpm ?v) (distance ?ori ?des)))
				  (typevp ?v truck)
				  (in-city ?ori ?ocity)
				  (in-city ?des ?ocity)
				  (<= (height-v ?v) (local-height ?ocity))
				  (<= (+ (weight-v ?v) (weight-load-v ?v)) (local-weight ?ocity))
				  (and (not (tcenter ?ori))
					 (tcenter ?des))
			        (not (exists (?p - package)
				           (and (at-packagev ?p ?v)
					          (or (over ?p)
							  (move ?p)
							  (t-start ?p)
					              (t-end ?p)
					              (h-start ?p))))))
		:effect (and (not (at-vehicle ?v ?ori))
	                   (at-vehicle ?v ?des)
			        (when (> (volume-load-v ?v) 0)
					  (not (move-emp ?v)))
			       (when (= (volume-load-v ?v) 0)
					(move-emp ?v))
			       (decrease (gas-left ?v) (* (distance ?ori ?des) (gpm ?v)))
			       (forall (?p - package)
			   	     (when (at-packagev ?p ?v)
				           (and (move ?p)
						    (t-start ?p))))))

	(:action move-vehicle-local-road-route3
		:parameters (?v - vehicle ?ori - location ?des - location ?ocity - city)
		:precondition (and (at-vehicle ?v ?ori)
					(not (= ?ori ?des))
				    (or (> (volume-load-v ?v) 0)
				       (not (move-emp ?v)))
				   (or (and (typev ?v regularv)
					    (not (door-open ?v)))
				       (and (typev ?v hopper)
					    (not (chute-connected ?v)))
				        (and (typev ?v tanker)
					    (not (valve-open ?v))
					    (not (hose-connected ?v)))
				       (and (typev ?v auto)
					    (not (ramp-down ?v)))
				       (and (typev ?v air)
					    (not (door-open ?v))
					    (not (exists (?ramp - plane-ramp)
					             (ramp-connected ?v ?ramp))))
				       (typev ?v flatbed))	
			        (>= (height-cap-l ?des) (height-v ?v))
 		              (>= (length-cap-l ?des) (length-v ?v))
				  (>= (width-cap-l ?des) (width-v ?v))
				  (>= (gas-left ?v) (* (gpm ?v) (distance ?ori ?des)))
				  (typevp ?v truck)
				  (in-city ?ori ?ocity)
				  (in-city ?des ?ocity)
				  (<= (height-v ?v) (local-height ?ocity))
				  (<= (+ (weight-v ?v) (weight-load-v ?v)) (local-weight ?ocity))
				  (and (tcenter ?ori)
					 (not (tcenter ?des)))
			        (not (exists (?p - package)
				           (and (at-packagev ?p ?v)
					          (or (over ?p)
							  (move ?p)
							  (t-start ?p))))))
		:effect (and (not (at-vehicle ?v ?ori))
	                   (at-vehicle ?v ?des)
			        (when (> (volume-load-v ?v) 0)
					(not (move-emp ?v)))
			       (when (= (volume-load-v ?v) 0)
					(move-emp ?v))
			       (decrease (gas-left ?v) (* (distance ?ori ?des) (gpm ?v)))
			       (forall (?p - package)
			   	     (when (at-packagev ?p ?v)
				           (and (over ?p)
						(move ?p)
						(not (t-end ?p))
						(not (h-start ?p)))))))

	(:action move-vehicle-road-route-crossCity
		:parameters (?v - vehicle ?ori - location ?des - location ?ocity ?dcity - city ?r - route)
		:precondition (and (at-vehicle ?v ?ori)
					(not (= ?ori ?des))
				    (or (> (volume-load-v ?v) 0)
				       (not (move-emp ?v)))
				   (or (and (typev ?v regularv)
					    (not (door-open ?v)))
				       (and (typev ?v hopper)
					    (not (chute-connected ?v)))
				       (and (typev ?v tanker)
					    (not (valve-open ?v))
					    (not (hose-connected ?v)))
				       (and (typev ?v auto)
					    (not (ramp-down ?v)))
				       (and (typev ?v air)
					    (not (door-open ?v))
					    (not (exists (?ramp - plane-ramp)
					             (ramp-connected ?v ?ramp))))
				       (typev ?v flatbed))	
			        (>= (height-cap-l ?des) (height-v ?v))
 		              (>= (length-cap-l ?des) (length-v ?v))
				  (>= (width-cap-l ?des) (width-v ?v))
				  (>= (gas-left ?v) (* (gpm ?v) (distance ?ori ?des)))
				  (typevp ?v truck)
				  (in-city ?ori ?ocity)
				  (in-city ?des ?dcity)
				  (not (= ?ocity ?dcity))
				  (connect-city ?r road-route ?ocity ?dcity)
				  (availabler ?r)
				  (<= (height-v ?v) (height-cap-r ?r))
			        (<= (+ (weight-v ?v) (weight-load-v ?v)) (weight-cap-r ?r))
				  (not (exists (?p - package)
					     (and (at-packagev ?p ?v)
					          (or (over ?p)
							  (move ?p)
							  (t-start ?p)
					              (t-end ?p)
					              (h-start ?p))))))
		:effect (and (not (at-vehicle ?v ?ori))
	                   (at-vehicle ?v ?des)
			        (when (> (volume-load-v ?v) 0)
					  (not (move-emp ?v)))
			       (when (= (volume-load-v ?v) 0)
					(move-emp ?v))
			       (decrease (gas-left ?v) (* (distance ?ori ?des) (gpm ?v)))
			       (forall (?p - package)
			   	     (when (at-packagev ?p ?v)
				           (and (move ?p)
						    (over ?p))))))

	(:action move-vehicle-nonroad-route1
		:parameters (?v - vehicle ?ori ?des - location ?r - route)
		:precondition (and (at-vehicle ?v ?ori)
				   (not (= ?ori ?des))
				   (or (> (volume-load-v ?v) 0)
				       (not (move-emp ?v)))
				   (or (and (typev ?v regularv)
					    (not (door-open ?v)))
				       (and (typev ?v hopper)
					    (not (chute-connected ?v)))
				       (and (typev ?v tanker)
					    (not (valve-open ?v))
					    (not (hose-connected ?v)))
				       (and (typev ?v auto)
					    (not (ramp-down ?v)))
				       (and (typev ?v air)
					    (not (door-open ?v))
					    (not (exists (?ramp - plane-ramp)
					             (ramp-connected ?v ?ramp))))
				       (typev ?v flatbed))	
			        (>= (height-cap-l ?des) (height-v ?v))
 		              (>= (length-cap-l ?des) (length-v ?v))
				  (>= (width-cap-l ?des) (width-v ?v))
				  (>= (gas-left ?v) (* (gpm ?v) (distance ?ori ?des)))
				  (not (typevp ?v truck))
				  (tcenter ?ori)
				  (tcenter ?des)
				  (or (and (hub ?ori)
					     (hub ?des))
					(and (not (hub ?ori))
					     (not (hub ?des))))
				  (availablel ?ori)
				  (availablel ?des)
				  (exists (?rtype - rtype ?vtype - vptype)
					(and (connect-loc ?r ?rtype ?ori ?des)
					     (typevp ?v ?vtype)
					     (rv-compatible ?rtype ?vtype)))
                          (availabler ?r)
				  (<= (height-v ?v) (height-cap-r ?r))
				  (<= (+ (weight-v ?v) (weight-load-v ?v)) (weight-cap-r ?r))
   				  (not (exists (?p - package)
					     (and (at-packagev ?p ?v)
					          (or (over ?p)
							  (move ?p)
					              (t-end ?p)
					              (h-start ?p))))))
		:effect (and (not (at-vehicle ?v ?ori))
	                   (at-vehicle ?v ?des)
			        (when (> (volume-load-v ?v) 0)					  			(not (move-emp ?v)))
			       (when (= (volume-load-v ?v) 0)
					(move-emp ?v))
			       (decrease (gas-left ?v) (* (distance ?ori ?des) (gpm ?v)))
				
			       (forall (?p - package)
			   	     (when (at-packagev ?p ?v)
				           (and (t-end ?p)
						(not (t-start ?p))
						    (move ?p))))))

	(:action move-vehicle-nonroad-route2
		:parameters (?v - vehicle ?ori ?des - location ?r - route)
		:precondition (and (at-vehicle ?v ?ori)
				   (not (= ?ori ?des))
				    (or (> (volume-load-v ?v) 0)
				       (not (move-emp ?v)))
				   (or (and (typev ?v regularv)
					    (not (door-open ?v)))
				       (and (typev ?v hopper)
					    (not (chute-connected ?v)))
				       (and (typev ?v tanker)
					    (not (hose-connected ?v))
					    (not (valve-open ?v)))
				       (and (typev ?v auto)
					    (not (ramp-down ?v)))
				       (and (typev ?v air)
					    (not (door-open ?v))
					    (not (exists (?ramp - plane-ramp)
					             (ramp-connected ?v ?ramp))))
				       (typev ?v flatbed))	
			        (>= (height-cap-l ?des) (height-v ?v))
 		              (>= (length-cap-l ?des) (length-v ?v))
				  (>= (width-cap-l ?des) (width-v ?v))
				  (>= (gas-left ?v) (* (gpm ?v) (distance ?ori ?des)))
				  (not (typevp ?v truck))
				  (tcenter ?ori)
				  (tcenter ?des)
				  (not (hub ?ori))
				  (hub ?des)
				  (availablel ?ori)
				  (availablel ?des)
				  (exists (?rtype - rtype ?vtype - vptype)
					(and (connect-loc ?r ?rtype ?ori ?des)
					     (typevp ?v ?vtype)
					     (rv-compatible ?rtype ?vtype)))
                          (availabler ?r)
				  (<= (height-v ?v) (height-cap-r ?r))
				  (<= (+ (weight-v ?v) (weight-load-v ?v)) (weight-cap-r ?r))
   				  (not (exists (?p - package)
					     (and (at-packagev ?p ?v)
					          (or (over ?p)
							  (move ?p)
					              (t-end ?p)
					              (h-start ?p))))))
		:effect (and (not (at-vehicle ?v ?ori))
	                   (at-vehicle ?v ?des)
			        (when (> (volume-load-v ?v) 0)
					  (not (move-emp ?v)))
			       (when (= (volume-load-v ?v) 0)
					(move-emp ?v))
			       (decrease (gas-left ?v) (* (distance ?ori ?des) (gpm ?v)))
				
			       (forall (?p - package)
			   	     (when (at-packagev ?p ?v)
				           (and (h-start ?p)
						(not (t-start ?p))
						    (move ?p))))))

	(:action move-vehicle-nonroad-route3
		:parameters (?v - vehicle ?ori ?des - location ?r - route)
		:precondition (and (at-vehicle ?v ?ori)
				   (not (= ?ori ?des))
				   (or (> (volume-load-v ?v) 0)
				       (not (move-emp ?v)))
				   (or (and (typev ?v regularv)
					    (not (door-open ?v)))
				       (and (typev ?v hopper)
					    (not (chute-connected ?v)))
				       (and (typev ?v tanker)
					    (not (hose-connected ?v))
					    (not (valve-open ?v)))
				       (and (typev ?v auto)
					    (not (ramp-down ?v)))
				       (and (typev ?v air)
					    (not (door-open ?v))
					    (not (exists (?ramp - plane-ramp)
					             (ramp-connected ?v ?ramp))))
				       (typev ?v flatbed))	
			        (>= (height-cap-l ?des) (height-v ?v))
 		              (>= (length-cap-l ?des) (length-v ?v))
				  (>= (width-cap-l ?des) (width-v ?v))
				  (>= (gas-left ?v) (* (gpm ?v) (distance ?ori ?des)))
				  (not (typevp ?v truck))
				  (tcenter ?ori)
				  (tcenter ?des)
				  (hub ?ori)
				  (not (hub ?des))
				  (availablel ?ori)
				  (availablel ?des)
				  (exists (?rtype - rtype ?vtype - vptype)
					(and (connect-loc ?r ?rtype ?ori ?des)
					     (typevp ?v ?vtype)
					     (rv-compatible ?rtype ?vtype)))
                          (availabler ?r)
				  (<= (height-v ?v) (height-cap-r ?r))
				  (<= (+ (weight-v ?v) (weight-load-v ?v)) (weight-cap-r ?r))
   				  (not (exists (?p - package)
					     (and (at-packagev ?p ?v)
					          (or (over ?p)
							  (move ?p)
					              (t-end ?p))))))
		:effect (and (not (at-vehicle ?v ?ori))
	                   (at-vehicle ?v ?des)
			        (when (> (volume-load-v ?v) 0)
					  (not (move-emp ?v)))
			       (when (= (volume-load-v ?v) 0)
					(move-emp ?v))
			       (decrease (gas-left ?v) (* (distance ?ori ?des) (gpm ?v)))
			       (forall (?p - package)
			   	     (when (at-packagev ?p ?v)
				           (and (t-end ?p)
						(not (h-start ?p))
						(not (t-start ?p))
						    (move ?p))))))

	(:action clean-domain
		:parameters()
	      :precondition (not (exists (?v - vehicle)
			             (and (unload ?v)
					  (or (and (typev ?v regularv)
					           (door-open ?v))
				       	      (and (typev ?v hopper)
					    	   (chute-connected ?v))
				       	      (and (typev ?v tanker)
					    	   (hose-connected ?v))
					      (and (typev ?v tanker)
					    	   (valve-open ?v))
				       	      (and (typev ?v auto)
					    	   (ramp-down ?v))
				       	      (and (typev ?v air)
					    	   (exists (?ramp - plane-ramp)
					               (ramp-connected ?v ?ramp)))
					      (and (typev ?v air)
						   (door-open ?v))))))
		:effect (clear))

)

						 