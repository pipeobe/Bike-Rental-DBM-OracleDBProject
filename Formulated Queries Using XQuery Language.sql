


	xquery
let $c:=doc('/public/milestone3group3/commission.xml')
for $a in $c/rentalBooking/commission[amount >=10]
let $e:=doc('/public/milestone3group3/eAddress.xml')
for $m in $e/store/site/employee
where $a/name = $m/@name
return $m/address/text()
/

	xquery
let $e:=doc('/public/milestone3group3/ePay.xml')
for $p in $e/employee/pay
where $p/totalPay >500
return element pay {attribute totalpay {$p/totalPay/text()}, element hours {$p/hours/text()}, element wage {$p/hourlyRate/text()}}
/

	xquery
let $e:=doc('/public/milestone3group3/eAddress.xml')
for $c in $e/store/site
where $c/@storeID = "01"
return $c/employee/@name
/

	xquery
let $c:=doc('/public/milestone3group3/bike.xml')
for $d in $c/Bike/Store/Barcode
where $d/@id = "846294719"
return element bikeinfo{attribute type {$d/Type/text()}, element size {$d/Size/text()}, element brand{$d/Brand/text()}}

	xquery
let $c:=doc('/public/milestone3group3/ids.xml')
for $d in $c/rental_booking/Confirmation
where $d/@confirmationNum= "2974458760"
return element userID {attribute id {$d/userID/@userID}}
/

	xquery
let $c:=doc('/public/milestone3group3/ids.xml')
for $d in $c/rental_booking/Confirmation/userID
let $s:=doc('/public/milestone3group3/bike.xml')
for $a in $s/Bike/Store/Barcode
where $d/Barcode = $a/@id
return element description {attribute size{$a/Size/text()}, element Type{$a/Type/text()}}
/

	xquery
let $d:=doc("/public/milestone3group3/rental_booking.xml")
for $r in $d/rental_booking/customer
where $r/@name = "Kim Nguyen"
return $r/rental/@cn
/

	xquery
let $f:=doc("/public/milestone3group3/returnfee.xml")
for $r in $f/fees/return_fee
where $r/gender = "F"
return element return_fee {attribute rid {$r/rid/text()}, element gender {$r/gender/text()}, element latefee {$r/latefee/text()},
element damagefee {$r/damagefee/text()}}
/

	xquery
  let $c:=doc("/public/milestone3group3/customer.xml")
  for $b in $c/customerProfile/customer[age <30]
  let $s := doc("/public/milestone3group3/rental_booking.xml")
  for $e in $s/rental_booking/customer/rental
  where $b/@confirmationNum = $e/@cn
  return $e/duration/text()
  /
  
	xquery
let $c:=doc("/public/milestone3group3/repair.xml")
for $d in $c/bike/repair
where $d/type = 'Ebike'
return $d/duration/text()
/

	xquery
let $c:=doc("/public/milestone3group3/siteStoreNew.xml")
for $d in $c/locations/store
where $d/bike_inventory > '60'
return $d/id
 /
 
	xquery
let $c:=doc("/public/milestone3group3/maintenance.xml")
for $d in $c/bike/type
where $d/@bikeType = 'Ebike'
return $d/maintenance/@mid
/

	xquery
let $c:=doc("/public/milestone3group3/commission2.xml")
for $p in $c/rental_booking/confirmation/commission[price>50]
let $t:=doc('/public/milestone3group3/commission.xml')
for $s in $t/rentalBooking/commission
where $p/@cid = $s/@cid
return $s/name/text()
/

	xquery
let $d:=doc("/public/milestone3group3/damagedRentals.xml")
for $r in $d/rental/rentalBooking
where $r/damagedItem = "Bike"
return element damagedBike {attribute id {$r/ID/text()}, element barcode {$r/Barcode/text()}, element description{$r/itemDescription/text()}}
/

	xquery
let $c:=doc("/public/milestone3group3/commission.xml")
for $s in $c/rentalBooking/commission
where $s/name = "Steve Rogers"
return $s/employeeNumber
/

	xquery
let $c:=doc("/public/milestone3group3/maintenance.xml")
for $m in $c/bike/type
let $s := doc("/public/milestone3group3/repair.xml") 
for $e in $s/bike/repair 
where $m/@bikeType = $e/type 
return $e/duration   
/
