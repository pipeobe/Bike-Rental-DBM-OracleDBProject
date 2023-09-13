


select xmlroot(xmlelement ("commission", xmlattributes(c.cid as "cid"),
xmlforest(c.amount as "amount", c.eoid.fullname() as "name", c.eoid.employeeNumber as "employeeNumber")),
 version '1.0') from commissionTable c;
 
select xmlroot(xmlelement("store",
xmlagg (xmlelement("site", xmlattributes(e.soid.storeID as "storeID"),
xmlagg(xmlelement("employee", xmlattributes(e.fullname() as "name"),
xmlelement("address", e.eAddress.fullAddress())))))), version '1.0')
from employeeTable e group by e.soid.storeID;

select xmlroot(xmlelement("pay", 
xmlelement("name", p.eoid.fullname()), 
xmlelement("hours", p.hoursWorked), 
xmlelement("hourlyRate", p.hourlyRate), 
xmlelement("totalPay", p.totalPay())), version '1.0') 
from payTable p where p.totalPay() >= 300;

	select xmlroot(xmlelement("rental_booking",
xmlagg(xmlelement("Confirmation", xmlattributes(r.confirmationNum as "confirmationNum"),
xmlagg(xmlelement("userID", xmlattributes(r.coid.userID as "userID"),
xmlelement("Barcode", r.rentalType.barcode)))))), version '1.0')
from rental_bookingTable r group by r.confirmationNum;

	select xmlroot(xmlelement("Bike",
xmlagg(xmlelement("Store",xmlattributes(b.obStoreID.storeID as "ID"),
xmlagg(xmlelement("Barcode",xmlattributes(b.barcode as "id"),
xmlelement("Type", b.bikeType),
xmlelement("Size",b.bikeSize),
xmlelement("Brand",b.brand)))))), version '1.0')
from bikeTable b group by b.obStoreID.storeID;

	select xmlroot(xmlelement("replacement",
xmlforest(r.repid as "ID",r.cost as "Cost",r.boid.brand as "Brand")), version '1.0')
from replacementTable r where r.cost >=30;
	select xmlroot(xmlelement("bike",xmlagg(xmlelement("repair",
xmlattributes(r.rid as "rn"),xmlelement("duration",
r.duration()),xmlelement("type",r.boid.bikeType)))), version '1.0')
from repairTable r;

	select xmlroot(xmlelement("bike",
xmlagg(xmlelement("type", xmlattributes(m.boid.bikeType as "bikeType"),
xmlagg(xmlelement("maintenance", xmlattributes(m.mid as "mid"),
xmlelement("nextMaintenance",m.nextMaintenanceDate())))))), version '1.0')
from maintenanceTable m
group by m.boid.bikeType;

	select xmlroot(xmlelement("store", 
xmlelement("id", s.storeID), 
xmlelement("city", s.location.city), 
xmlelement("bike_inventory", s.numberOfBikes)), version '1.0') 
from siteStoreTable s;

	select xmlroot(xmlelement ("customer", xmlattributes(r.confirmationNum as "confirmationNum"),
	xmlforest(r.coid.fullname() as "name", r.coid.caddress as "address",  r.coid.uEmail as "email", round(r.coid.comps()/365,0) as "age" )),
	version '1.0') from rental_bookingTable r;
	
	select xmlroot(xmlelement("rental_booking",
xmlagg(xmlelement("customer", xmlattributes (r.coid.fullname() as "name"),
xmlagg(xmlelement("rental", xmlattributes(r.confirmationNum as "cn"),
xmlelement("id",r.coid.getuID()), xmlelement("duration",r.duration()),
xmlelement("price", r.totalPrice())))))), version '1.0')
from rental_bookingTable r group by r.coid.fullname(); 
 
	select xmlroot(xmlelement("return_fee",
xmlelement("rid", r.rid), 
xmlelement("damagefee", r.damageFee), 
xmlelement("latefee", r.lateFee), 
xmlelement("name", r.coid.fullname()), 
xmlelement("dateofbirth", r.coid.dateOfBirth), 
xmlelement("gender", r.coid.Ugender)), version '1.0')
from return_feeTable r; 

	select xmlroot(xmlelement("rental_booking",
xmlelement("barcode",  r.rentalType.barcode),
xmlelement("description", r.rentalType.itemDescription()),
xmlelement("confirmationNum",
r.confirmationNum)), version '1.0')
from rental_bookingTable r;

	select xmlroot(xmlelement("rentalBooking",
xmlforest(r.roid.confirmationNum as "ID", r.damagedITEM as "damagedItem",r.roid.rentalType.barcode as "Barcode", r.roid.rentalType.itemDescription() as "itemDescription")),version '1.0')
from return_feeTable r;

	select xmlroot(xmlelement("rental_booking ",
xmlagg(xmlelement("confirmation", xmlattributes(c.roid.status as "status"),
xmlagg (xmlelement ("commission", xmlattributes(c.cid as "cid"),
xmlelement("amount", c.amount),
xmlelement("price", c.roid.totalPrice())))))), version '1.0')
from commissionTable c group by c.roid.status;
