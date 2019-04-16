(in-package :shop-user)
(defproblem pfile7 DEPOT
  (
    ;;;
    ;;;  facts
    ;;;
    (DEPOT DEPOT0)
    (DEPOT DEPOT1)
    (DEPOT DEPOT2)
    (DEPOT DEPOT3)
    (DEPOT DEPOT4)
    (DEPOT DEPOT5)
    (DEPOT DEPOT6)
    (DEPOT DEPOT7)
    (DEPOT DEPOT8)
    (DEPOT DEPOT9)
    (DISTRIBUTOR DISTRIBUTOR0)
    (DISTRIBUTOR DISTRIBUTOR1)
    (DISTRIBUTOR DISTRIBUTOR2)
    (DISTRIBUTOR DISTRIBUTOR3)
    (DISTRIBUTOR DISTRIBUTOR4)
    (DISTRIBUTOR DISTRIBUTOR5)
    (DISTRIBUTOR DISTRIBUTOR6)
    (DISTRIBUTOR DISTRIBUTOR7)
    (DISTRIBUTOR DISTRIBUTOR8)
    (DISTRIBUTOR DISTRIBUTOR9)
    (TRUCK TRUCK0)
    (TRUCK TRUCK1)
    (TRUCK TRUCK2)
    (TRUCK TRUCK3)
    (TRUCK TRUCK4)
    (TRUCK TRUCK5)
    (PALLET PALLET0)
    (PALLET PALLET1)
    (PALLET PALLET2)
    (PALLET PALLET3)
    (PALLET PALLET4)
    (PALLET PALLET5)
    (PALLET PALLET6)
    (PALLET PALLET7)
    (PALLET PALLET8)
    (PALLET PALLET9)
    (PALLET PALLET10)
    (PALLET PALLET11)
    (PALLET PALLET12)
    (PALLET PALLET13)
    (PALLET PALLET14)
    (PALLET PALLET15)
    (PALLET PALLET16)
    (PALLET PALLET17)
    (PALLET PALLET18)
    (PALLET PALLET19)
    (PALLET PALLET20)
    (PALLET PALLET21)
    (PALLET PALLET22)
    (PALLET PALLET23)
    (PALLET PALLET24)
    (PALLET PALLET25)
    (PALLET PALLET26)
    (PALLET PALLET27)
    (PALLET PALLET28)
    (PALLET PALLET29)
    (PALLET PALLET30)
    (PALLET PALLET31)
    (PALLET PALLET32)
    (PALLET PALLET33)
    (PALLET PALLET34)
    (PALLET PALLET35)
    (PALLET PALLET36)
    (PALLET PALLET37)
    (PALLET PALLET38)
    (PALLET PALLET39)
    (CRATE CRATE0)
    (CRATE CRATE1)
    (CRATE CRATE2)
    (CRATE CRATE3)
    (CRATE CRATE4)
    (CRATE CRATE5)
    (CRATE CRATE6)
    (CRATE CRATE7)
    (CRATE CRATE8)
    (CRATE CRATE9)
    (CRATE CRATE10)
    (CRATE CRATE11)
    (CRATE CRATE12)
    (CRATE CRATE13)
    (CRATE CRATE14)
    (CRATE CRATE15)
    (CRATE CRATE16)
    (CRATE CRATE17)
    (CRATE CRATE18)
    (CRATE CRATE19)
    (CRATE CRATE20)
    (CRATE CRATE21)
    (CRATE CRATE22)
    (CRATE CRATE23)
    (CRATE CRATE24)
    (CRATE CRATE25)
    (CRATE CRATE26)
    (CRATE CRATE27)
    (CRATE CRATE28)
    (CRATE CRATE29)
    (CRATE CRATE30)
    (CRATE CRATE31)
    (CRATE CRATE32)
    (CRATE CRATE33)
    (CRATE CRATE34)
    (CRATE CRATE35)
    (CRATE CRATE36)
    (CRATE CRATE37)
    (CRATE CRATE38)
    (CRATE CRATE39)
    (HOIST HOIST0)
    (HOIST HOIST1)
    (HOIST HOIST2)
    (HOIST HOIST3)
    (HOIST HOIST4)
    (HOIST HOIST5)
    (HOIST HOIST6)
    (HOIST HOIST7)
    (HOIST HOIST8)
    (HOIST HOIST9)
    (HOIST HOIST10)
    (HOIST HOIST11)
    (HOIST HOIST12)
    (HOIST HOIST13)
    (HOIST HOIST14)
    (HOIST HOIST15)
    (HOIST HOIST16)
    (HOIST HOIST17)
    (HOIST HOIST18)
    (HOIST HOIST19)
    ;;;
    ;;;  initial states
    ;;;
    (AT PALLET0 DEPOT0)
    (CLEAR CRATE37)
    (AT PALLET1 DEPOT1)
    (CLEAR PALLET1)
    (AT PALLET2 DEPOT2)
    (CLEAR CRATE39)
    (AT PALLET3 DEPOT3)
    (CLEAR CRATE34)
    (AT PALLET4 DEPOT4)
    (CLEAR CRATE36)
    (AT PALLET5 DEPOT5)
    (CLEAR CRATE5)
    (AT PALLET6 DEPOT6)
    (CLEAR PALLET6)
    (AT PALLET7 DEPOT7)
    (CLEAR CRATE14)
    (AT PALLET8 DEPOT8)
    (CLEAR CRATE4)
    (AT PALLET9 DEPOT9)
    (CLEAR PALLET9)
    (AT PALLET10 DISTRIBUTOR0)
    (CLEAR CRATE13)
    (AT PALLET11 DISTRIBUTOR1)
    (CLEAR CRATE16)
    (AT PALLET12 DISTRIBUTOR2)
    (CLEAR CRATE32)
    (AT PALLET13 DISTRIBUTOR3)
    (CLEAR PALLET13)
    (AT PALLET14 DISTRIBUTOR4)
    (CLEAR CRATE30)
    (AT PALLET15 DISTRIBUTOR5)
    (CLEAR PALLET15)
    (AT PALLET16 DISTRIBUTOR6)
    (CLEAR PALLET16)
    (AT PALLET17 DISTRIBUTOR7)
    (CLEAR CRATE28)
    (AT PALLET18 DISTRIBUTOR8)
    (CLEAR PALLET18)
    (AT PALLET19 DISTRIBUTOR9)
    (CLEAR PALLET19)
    (AT PALLET20 DISTRIBUTOR3)
    (CLEAR CRATE9)
    (AT PALLET21 DEPOT6)
    (CLEAR PALLET21)
    (AT PALLET22 DEPOT2)
    (CLEAR PALLET22)
    (AT PALLET23 DEPOT1)
    (CLEAR PALLET23)
    (AT PALLET24 DEPOT5)
    (CLEAR CRATE35)
    (AT PALLET25 DISTRIBUTOR3)
    (CLEAR CRATE25)
    (AT PALLET26 DEPOT2)
    (CLEAR CRATE1)
    (AT PALLET27 DEPOT6)
    (CLEAR CRATE24)
    (AT PALLET28 DEPOT0)
    (CLEAR PALLET28)
    (AT PALLET29 DISTRIBUTOR2)
    (CLEAR CRATE3)
    (AT PALLET30 DISTRIBUTOR0)
    (CLEAR PALLET30)
    (AT PALLET31 DISTRIBUTOR3)
    (CLEAR CRATE21)
    (AT PALLET32 DISTRIBUTOR7)
    (CLEAR CRATE6)
    (AT PALLET33 DISTRIBUTOR8)
    (CLEAR CRATE29)
    (AT PALLET34 DISTRIBUTOR5)
    (CLEAR PALLET34)
    (AT PALLET35 DEPOT2)
    (CLEAR CRATE27)
    (AT PALLET36 DISTRIBUTOR3)
    (CLEAR PALLET36)
    (AT PALLET37 DISTRIBUTOR6)
    (CLEAR CRATE19)
    (AT PALLET38 DEPOT4)
    (CLEAR CRATE38)
    (AT PALLET39 DISTRIBUTOR9)
    (CLEAR PALLET39)
    (AT TRUCK0 DEPOT5)
    (AT TRUCK1 DISTRIBUTOR7)
    (AT TRUCK2 DEPOT2)
    (AT TRUCK3 DISTRIBUTOR5)
    (AT TRUCK4 DEPOT1)
    (AT TRUCK5 DISTRIBUTOR0)
    (AT HOIST0 DEPOT0)
    (AVAILABLE HOIST0)
    (AT HOIST1 DEPOT1)
    (AVAILABLE HOIST1)
    (AT HOIST2 DEPOT2)
    (AVAILABLE HOIST2)
    (AT HOIST3 DEPOT3)
    (AVAILABLE HOIST3)
    (AT HOIST4 DEPOT4)
    (AVAILABLE HOIST4)
    (AT HOIST5 DEPOT5)
    (AVAILABLE HOIST5)
    (AT HOIST6 DEPOT6)
    (AVAILABLE HOIST6)
    (AT HOIST7 DEPOT7)
    (AVAILABLE HOIST7)
    (AT HOIST8 DEPOT8)
    (AVAILABLE HOIST8)
    (AT HOIST9 DEPOT9)
    (AVAILABLE HOIST9)
    (AT HOIST10 DISTRIBUTOR0)
    (AVAILABLE HOIST10)
    (AT HOIST11 DISTRIBUTOR1)
    (AVAILABLE HOIST11)
    (AT HOIST12 DISTRIBUTOR2)
    (AVAILABLE HOIST12)
    (AT HOIST13 DISTRIBUTOR3)
    (AVAILABLE HOIST13)
    (AT HOIST14 DISTRIBUTOR4)
    (AVAILABLE HOIST14)
    (AT HOIST15 DISTRIBUTOR5)
    (AVAILABLE HOIST15)
    (AT HOIST16 DISTRIBUTOR6)
    (AVAILABLE HOIST16)
    (AT HOIST17 DISTRIBUTOR7)
    (AVAILABLE HOIST17)
    (AT HOIST18 DISTRIBUTOR8)
    (AVAILABLE HOIST18)
    (AT HOIST19 DISTRIBUTOR9)
    (AVAILABLE HOIST19)
    (AT CRATE0 DISTRIBUTOR2)
    (ON CRATE0 PALLET12)
    (AT CRATE1 DEPOT2)
    (ON CRATE1 PALLET26)
    (AT CRATE2 DEPOT7)
    (ON CRATE2 PALLET7)
    (AT CRATE3 DISTRIBUTOR2)
    (ON CRATE3 PALLET29)
    (AT CRATE4 DEPOT8)
    (ON CRATE4 PALLET8)
    (AT CRATE5 DEPOT5)
    (ON CRATE5 PALLET5)
    (AT CRATE6 DISTRIBUTOR7)
    (ON CRATE6 PALLET32)
    (AT CRATE7 DISTRIBUTOR3)
    (ON CRATE7 PALLET31)
    (AT CRATE8 DISTRIBUTOR4)
    (ON CRATE8 PALLET14)
    (AT CRATE9 DISTRIBUTOR3)
    (ON CRATE9 PALLET20)
    (AT CRATE10 DISTRIBUTOR3)
    (ON CRATE10 PALLET25)
    (AT CRATE11 DISTRIBUTOR8)
    (ON CRATE11 PALLET33)
    (AT CRATE12 DEPOT4)
    (ON CRATE12 PALLET38)
    (AT CRATE13 DISTRIBUTOR0)
    (ON CRATE13 PALLET10)
    (AT CRATE14 DEPOT7)
    (ON CRATE14 CRATE2)
    (AT CRATE15 DEPOT2)
    (ON CRATE15 PALLET35)
    (AT CRATE16 DISTRIBUTOR1)
    (ON CRATE16 PALLET11)
    (AT CRATE17 DEPOT5)
    (ON CRATE17 PALLET24)
    (AT CRATE18 DEPOT2)
    (ON CRATE18 PALLET2)
    (AT CRATE19 DISTRIBUTOR6)
    (ON CRATE19 PALLET37)
    (AT CRATE20 DEPOT2)
    (ON CRATE20 CRATE18)
    (AT CRATE21 DISTRIBUTOR3)
    (ON CRATE21 CRATE7)
    (AT CRATE22 DISTRIBUTOR2)
    (ON CRATE22 CRATE0)
    (AT CRATE23 DISTRIBUTOR4)
    (ON CRATE23 CRATE8)
    (AT CRATE24 DEPOT6)
    (ON CRATE24 PALLET27)
    (AT CRATE25 DISTRIBUTOR3)
    (ON CRATE25 CRATE10)
    (AT CRATE26 DEPOT2)
    (ON CRATE26 CRATE20)
    (AT CRATE27 DEPOT2)
    (ON CRATE27 CRATE15)
    (AT CRATE28 DISTRIBUTOR7)
    (ON CRATE28 PALLET17)
    (AT CRATE29 DISTRIBUTOR8)
    (ON CRATE29 CRATE11)
    (AT CRATE30 DISTRIBUTOR4)
    (ON CRATE30 CRATE23)
    (AT CRATE31 DEPOT4)
    (ON CRATE31 PALLET4)
    (AT CRATE32 DISTRIBUTOR2)
    (ON CRATE32 CRATE22)
    (AT CRATE33 DEPOT4)
    (ON CRATE33 CRATE31)
    (AT CRATE34 DEPOT3)
    (ON CRATE34 PALLET3)
    (AT CRATE35 DEPOT5)
    (ON CRATE35 CRATE17)
    (AT CRATE36 DEPOT4)
    (ON CRATE36 CRATE33)
    (AT CRATE37 DEPOT0)
    (ON CRATE37 PALLET0)
    (AT CRATE38 DEPOT4)
    (ON CRATE38 CRATE12)
    (AT CRATE39 DEPOT2)
    (ON CRATE39 CRATE26)
  )
  ;;;
  ;;; goals
  ;;;
  ((achieve-goals
    ((ON CRATE0 PALLET19) (ON CRATE1 CRATE39) (ON CRATE2 PALLET22)
     (ON CRATE3 PALLET30) (ON CRATE4 CRATE23) (ON CRATE5 PALLET23)
     (ON CRATE6 CRATE26) (ON CRATE7 CRATE11) (ON CRATE8 PALLET3)
     (ON CRATE9 PALLET24) (ON CRATE11 PALLET6) (ON CRATE12 PALLET10)
     (ON CRATE13 PALLET38) (ON CRATE14 CRATE24) (ON CRATE15 PALLET36)
     (ON CRATE16 PALLET1) (ON CRATE17 CRATE14) (ON CRATE18 CRATE38)
     (ON CRATE19 CRATE12) (ON CRATE20 PALLET35) (ON CRATE21 CRATE1)
     (ON CRATE22 PALLET28) (ON CRATE23 PALLET13) (ON CRATE24 PALLET0)
     (ON CRATE26 PALLET9) (ON CRATE27 PALLET39) (ON CRATE28 PALLET31)
     (ON CRATE29 PALLET8) (ON CRATE30 PALLET25) (ON CRATE31 PALLET27)
     (ON CRATE32 PALLET18) (ON CRATE33 CRATE13) (ON CRATE34 PALLET12)
     (ON CRATE35 CRATE15) (ON CRATE36 PALLET34) (ON CRATE38 PALLET17)
     (ON CRATE39 CRATE6))
  ))
)