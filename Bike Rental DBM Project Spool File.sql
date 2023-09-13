

Create Type (object):

CREATE TYPE addressT AS OBJECT (streetNumber varchar2(5), streetName varchar2(12), city varchar2(12), country varchar2 (10), postalCode varchar2 (6), member function fullAddress return varchar2);

create type siteStoreT as object(storeID char(2),location addressT, numberOfEm char(2), numberOfBikes char(2), numberOfAccessories char(2), storeopeningTime char(4), storeclosingTime char(4), member function totalBikes return char, member function totalAccessories return char);

CREATE TYPE employeeT AS OBJECT (employeeNumber char(5), eAddress addressT, fName varchar2(12), lName varchar2(12), title varchar2(4), soid ref siteStoreT, member function fullname return varchar2);

CREATE TYPE payT AS OBJECT (pid char(10), hoursWorked Number, hourlyRate Number, eoid ref employeeT, soid ref siteStoreT, member function totalPay return Number);

create type rentalT as object (barcode char(9), pricePerHour Number, obStoreID ref siteStoreT, member function itemDescription return varchar2) not final;

create type bikeT under rentalT(bikeType char(5), bikeSize char(1), status char(3), brand char(10), member function operational return varchar2, overriding member function itemDescription return varchar2);

create type bike_helmetT under rentalT(helmetSize char(1), brand char(10), overriding member function itemDescription return varchar2);

create type bike_kneepadsT under rentalT(kneepadSize char(1), brand char(10), overriding member function itemDescription return varchar2);


 

Create Type customerProfileT as Object(userID char(10), firstN varchar2(10), lastN varchar2(10), dateOfBirth date, caddress addressT, uEmail varchar2(15), uPassword char(10), phoneNum char(10), Ugender char(1), pastRentNum char(10), currentRental varchar2(10), cardOnFile number, member function getUId return char, member function RentalDetails return varchar2, member function fullname return varchar2, map member function comps return Number);

CREATE TYPE rental_bookingT AS OBJECT (confirmationNum char(10), status varchar2(10), checkIn varchar2(20), checkOut varchar2(20), rentalType ref rentalT, coid ref customerProfileT,pricePerHour number, member function duration return varchar2, member function totalPrice return number);

CREATE TYPE commissionT AS OBJECT (cid char(2), amount Number, eoid ref employeeT, roid ref rental_bookingT);
 
CREATE TYPE return_feeT AS OBJECT (rid char(4), damagedItem varchar2(8), damageFee varchar2(5), lateFee varchar2(5), lostFee varchar2(5), coid ref customerProfileT, roid ref rental_bookingT);
 
create type maintenanceT as object
(mid char(4), lastMaintenance date, nextMaintenance date, checkUp varchar2(20), boid ref bikeT, member function nextMaintenanceDate return date);

create type repairT as object (rid char(4), start_date date, end_date date, status varchar2(20), boid ref bikeT, member function duration return varchar2, ORDER member function comps(ip_repair repairT) return integer);

create type replacementT as object (repid char(4), replacementPart varchar2(15), cost number, roid ref repairT, boid ref bikeT);

Create Body:

CREATE TYPE BODY employeeT as
        	Member function fullname return varchar2
        	Is
        	Begin
        	Return self.fName || ' ' || self.lName;
        	End;
        	End;
        	/
 
CREATE TYPE BODY payT as
        	Member function totalPay return number
        	Is
        	Begin
        	Return self.hoursWorked * self.hourlyRate;
        	End;
        	End;
        	/
 
CREATE TYPE BODY addressT as
        	Member function fullAddress return varchar2
        	Is
        	Begin
        	Return self.streetNumber || ' ' || self.streetName || ', ' || self.city || ', ' || self.country || ', ' || self.postalCode;
        	End;
        	End;
        	/

SQL> create type body siteStoreT as member function
   	totalBikes return char
   	is
   	begin
   	return self.numberOfBikes;
   	end;
   	member function totalAccessories return char
    is
    begin
   return self.numberOfAccessories;
   end;
   end;
   /
SQL> create type body rentalT as member function
   	itemDescription return varchar2
   	is
   	begin
   	return self.barcode;
   	end;
   	end;
   	/
SQL> create type body bikeT as overriding member function
   	itemDescription return varchar2
   	is
   	begin
   	return self.brand;
   	end;
   	member function operational return varchar2
   	is
   	begin
     return self.status;
     end;
     end;
     /
SQL> create type body bike_helmetT as overriding member 
function
   	itemDescription return varchar2
   	is
   	begin
   	return self.HelmetSize;
   	end;
   	end;
   	/
SQL> create type body bike_kneepadsT as overriding member 
function
   	itemDescription return varchar2
   	is
   	begin
   	return self.kneepadSize;
   	end;
   	end;
   	/

create type body repairT as member function duration return varchar2
is
begin
return self.start_date||' to '||self.end_date;
end;
order member function comps(ip_repair repairT) return integer
is
result integer := 0; 
begin
if ip_repair.start_date > self.start_date THEN
result := -1;
elsif ip_repair.start_date < self.start_date THEN
result := 1;
elsif ip_repair.start_date = self.start_date THEN
result := 0;
end if;
return result;
end;
end;
/

create type body maintenanceT as member function nextMaintenanceDate return date 
is
begin
return self.nextMaintenance;
end;
end;
/

create type body rental_bookingT as member function duration
return varchar2
is
begin
return self.checkOut ||' to '|| self.checkIn;
end;
member function totalPrice return Number
is
begin
return (((to_date(self.checkIn,'MM/DD/YY HH24:MI'))- (to_date(self.checkOut,'MM/DD/YY HH24:MI')))*24)*pricePerHour;
end;
end;
/

SQL> create type body customerProfileT as member function
   	getuID return char
   	is
   	begin
   	return self.userID;
   	end;
   	member function RentalDetails return varchar2
        is
        begin
        return self.currentRental;
        end;
  	member function fullname return varchar2
        is
	   begin
        return self.firstN || ' ' || self.lastN;
        end;
        map member function comps return 
  	   number
        is begin
        return SYSDATE - self.dateOfBirth;
        end;
        end;
  	/

Create Table:

CREATE TABLE employeeTable of employeeT (employeeNumber primary key);

CREATE TABLE commissionTable of commissionT (cid primary key);
 
CREATE TABLE payTable of payT (pid primary key);

SQL> create table siteStoreTable of siteStoreT(storeID primary 
key);

SQL> create table bikeTable of bikeT(barcode primary key);

SQL> create table bike_helmetTable of bike_helmetT(barcode primary key);

SQL> create table bike_kneepadsTable of bike_kneepadsT(barcode 
primary key);

create table replacementTable of replacementT (repid primary key);

create table repairTable of repairT (rid primary key);

create table maintenanceTable of maintenanceT (mid primary key);

CREATE TABLE return_feeTable of return_feeT (rid primary key);

CREATE TABLE rental_bookingTable of rental_bookingT (confirmationNum primary key);

SQL> create table customerProfileTable of customerProfileT (userID primary key);








spool file demonstrating execution of SQL statements to insert data:
spool p2t1.lst
spool p2t2.lst
spool p2t3.lst

CREATE TYPE addressT AS OBJECT (streetNumber varchar2(5), streetName varchar2(12), city varchar2(12), country varchar2 (10), postalCode varchar2 (6), member function fullAddress return varchar2);

create type siteStoreT as object(storeID char(2),location addressT, numberOfEm char(2), numberOfBikes char(2), numberOfAccessories char(2), storeopeningTime char(4), storeclosingTime char(4), member function totalBikes return char, member function totalAccessories return char);

insert into siteStoreTable values(siteStoreT('01', addressT('74362','Rosetta Blvd','Toronto','Canada','I1P8G3'),'10','50','30','0700','2200'));
insert into siteStoreTable values(siteStoreT('02',addressT('93649','River Street','Hamilton','Canada','H8E7B3'),'13','75','24','1000','2300'));
insert into siteStoreTable values(siteStoreT('03',addressT('74861','Tree Rue','Mississauga','Canada','G3J9D7'),'20','90','89','0900','2100'));

CREATE TYPE employeeT AS OBJECT (employeeNumber char(5), eAddress addressT, fName varchar2(12), lName varchar2(12), title varchar2(4), soid ref siteStoreT, member function fullname return varchar2);

insert into employeeTable values (employeeT('13847', addressT('742','Pan Street','Toronto','Canada','I1P8G2'), 'Steve', 'Rogers', 'Mr',(select ref(s) from siteStoreTable s where s.storeID = '01')));

insert into employeeTable values (employeeT('13843', addressT('42','Lake Street','Hamilton','Canada','H8E7B2'), 'Jimmy', 'Tin', 'Mr',(select ref(s) from siteStoreTable s where s.storeID = '02')));

insert into employeeTable values (employeeT('12837', addressT('23','Bloor Street','Toronto','Canada','P1P8T2'), 'Tiffany', 'Cave', 'Ms',(select ref(s) from siteStoreTable s where s.storeID = '01')));

insert into employeeTable values (employeeT('13993', addressT('61','Bolt street', 'Mississauga', 'Canada', 'G4J9D9'), 'Sarah', 'Walsh', 'Ms',(select ref(s) from siteStoreTable s where s.storeID = '03')));

CREATE TYPE payT AS OBJECT (pid char(10), hoursWorked Number, hourlyRate Number, eoid ref employeeT, soid ref siteStoreT, member function totalPay return Number);

insert into payTable values ('1399017623', 24, 17,(select ref(e) from employeeTable e where e.employeeNumber = '13847'),(select ref(s) from siteStoreTable s where s.storeID = '01'));

insert into payTable values ('1399017624', 35, 20,(select ref(e) from employeeTable e where e.employeeNumber = '13843'),(select ref(s) from siteStoreTable s where s.storeID = '02'));

insert into payTable values ('1399017625', 10, 15,(select ref(e) from employeeTable e where e.employeeNumber = '12837'),(select ref(s) from siteStoreTable s where s.storeID = '01'));

insert into payTable values ('1399017626', 40, 22,(select ref(e) from employeeTable e where e.employeeNumber = '13993'),(select ref(s) from siteStoreTable s where s.storeID = '03'));

create type rentalT as object (barcode char(9), pricePerHour Number, obStoreID ref siteStoreT, member function itemDescription return varchar2) not final;

create type bikeT under rentalT(bikeType char(5), bikeSize char(1), status char(3), brand char(10), member function operational return varchar2, overriding member function itemDescription return varchar2);

insert into bikeTable values(bikeT('438383758',10.50,(select ref(s) from siteStoreTable s where s.storeID = '01'),'Ebike','M','fun','Bianchi'));

insert into bikeTable values(bikeT('674836254',12.00,(select ref(s) from siteStoreTable s where s.storeID = '03'),'Bike','L','fun','Starling'));

insert into bikeTable values(bikeT('846294719',11.50,(select ref(s) from siteStoreTable s where s.storeID = '02'),'Bike','L','fun','Bianchi'));

insert into bikeTable values(bikeT('756482046',13.50,(select ref(s) from siteStoreTable s where s.storeID = '02'),'Ebike','M','fun','Goku Cycle'));

create type bike_helmetT under rentalT(helmetSize char(1), brand char(10), overriding member function itemDescription return varchar2);

insert into bike_helmetTable values(bike_helmetT('438383759',15.50,(select ref(s) from siteStoreTable s where s.storeID = '01'),'M','Thousand'));

insert into bike_helmetTable values(bike_helmetT('674836255',17.00,(select ref(s) from siteStoreTable s where s.storeID = '03'),'L','Closca'));

insert into bike_helmetTable values(bike_helmetT('846294712',15.50,(select ref(s) from siteStoreTable s where s.storeID = '02'),'L','Giro'));

insert into bike_helmetTable values(bike_helmetT('756482045',16.50,(select ref(s) from siteStoreTable s where s.storeID = '02'),'s','Bontrager'));

create type bike_kneepadsT under rentalT(kneepadSize char(1), brand char(10), overriding member function itemDescription return varchar2);

insert into bike_kneepadsTable values(bike_kneepadsT('438383748', 
15.50,(select ref(s) from siteStoreTable s where s.storeID = '01'),'M','Rapha'));

insert into bike_kneepadsTable values(bike_kneepadsT('674836234', 
17.00,(select ref(s) from siteStoreTable s where s.storeID = '03'),'L','Bluegrass'));

insert into bike_kneepadsTable values(bike_kneepadsT('846294729', 
15.50,(select ref(s) from siteStoreTable s where s.storeID = '02'),'L','Scott Miss'));

insert into bike_kneepadsTable values(bike_kneepadsT('756482246', 
16.50,(select ref(s) from siteStoreTable s where s.storeID = '02'),'M','Kali'));

Create Type customerProfileT as Object(userID char(10), firstN varchar2(10), lastN varchar2(10), dateOfBirth date, caddress addressT, uEmail varchar2(15), uPassword char(10), phoneNum char(10), Ugender char(1), pastRentNum char(10), currentRental varchar2(10), cardOnFile number, member function getUId return char, member function RentalDetails return varchar2, member function fullname return varchar2, map member function comps return Number);

insert into customerProfileTable values (customerProfileT('3564738293','Emmanuel','Obe','20-May-1999',addressT('12','YonStreet','Toronto','Canada','I1D8F2'), '123@gmailcom', 'obepipe', '2895212678', 'M', '2222222222','5555555555', '3'));

insert into customerProfileTable values(customerProfileT('8374659274','Kim','Nguyen','28-Sep-2000',addressT('145','PloLane','Hamilton','Canada','T2D8R2'), 'kim@gmail.com', 'grasshoppe', '8472347686', 'F', '8978986567','1254673652', '1'));

insert into customerProfileTable values(customerProfileT('6475832891','Jasmine','Pabla','18-Sep-1990',addressT('80','FamStreet','Toronto','Canada','WFD8F8'), 'jp90@gmail.com', '123yorkl90', '2595232645', 'F', '1234567891','9876543219', '5'));

insert into customerProfileTable values(customerProfileT('6475832892','Rohan','Bangash','30-Oct-1983',addressT('220','YorkLane','Missisisauga','Canada','SDC3Z1'), 'rb83@gmail.com', 'passme8312', '5585212630', 'M', '7676754389','9096789045', '2'));

CREATE TYPE rental_bookingT AS OBJECT (confirmationNum char(10), status varchar2(10), checkIn varchar2(14), checkOut varchar2(14), rentalType ref rentalT, coid ref customerProfileT,pricePerHour number, member function duration return varchar2, member function totalPrice return number);

insert into rental_bookingTable	 values(rental_bookingT('2974458760', 'Confirmed', '11/01/22 13:00', '11/01/22 9:00', (select ref(b) from bikeTable b where b.barcode = '438383758'), (select ref(c) from customerProfileTable c where c.userID = '3564738293'), 10.50));

insert into rental_bookingTable values(rental_bookingT('2974458761', 'Confirmed', '11/02/22 17:00', '11/02/22 13:00', (select ref(b) from bikeTable b where b.barcode = '756482046'), (select ref(c) from customerProfileTable c where c.userID = '6475832891'), 16.50));

insert into rental_bookingTable values(rental_bookingT('2974458762', 'Confirmed', '11/02/22 17:00', '11/02/22 13:00', (select ref(h) from bike_helmetTable h where h.barcode = '438383759'), (select ref(c) from customerProfileTable c where c.userID = '6475832891'), 15.50));

insert into rental_bookingTable values(rental_bookingT('2974458763', 'Confirmed', '11/02/22 17:00', '11/02/22 13:00', (select ref(h) from bike_helmetTable h where h.barcode = '756482045'), (select ref(c) from customerProfileTable c where c.userID = '6475832891'), 16.50));

insert into rental_bookingTable values(rental_bookingT('2974458764', 'Pending', '10/31/22 18:00', '10/31/22 17:00', (select ref(k) from bike_kneepadsTable k where k.barcode = '756482246'), (select ref(c) from customerProfileTable c where c.userID = '8374659274'), 16.50));

CREATE TYPE commissionT AS OBJECT (cid char(2), amount Number, eoid ref employeeT, roid ref rental_bookingT);

insert into commissionTable values (commissionT('01', 5, (select ref(e) from employeeTable e where e.employeeNumber = '13993'), (select ref(r) from rental_bookingTable r where r.confirmationNum = '2974458760')));

insert into commissionTable values (commissionT('02', 10, (select ref(e) from employeeTable e where e.employeeNumber = '13847'), (select ref(r) from rental_bookingTable r where r.confirmationNum = '2974458762')));

insert into commissionTable values (commissionT('03', 13, (select ref(e) from employeeTable e where e.employeeNumber = '12837'), (select ref(r) from rental_bookingTable r where r.confirmationNum = '2974458763')));

CREATE TYPE return_feeT AS OBJECT (rid char(4), damagedItem varchar2(8), damageFee varchar2(5), lateFee varchar2(5), lostFee varchar2(5), coid ref customerProfileT, roid ref rental_bookingT);

insert into return_feeTable values (return_feeT('0001', 'Bike', '50', '0', '0', (select ref(c) from customerProfileTable c where c.userID = '3564738293'), (select ref(r) from rental_bookingTable r where r.confirmationNum = '2974458760')));

insert into return_feeTable values (return_feeT('0002', 'Bike', '0', '0', '800', (select ref(c) from customerProfileTable c where c.userID = '3564738293'), (select ref(r) from rental_bookingTable r where r.confirmationNum = '2974458760')));

insert into return_feeTable values (return_feeT('0003', 'Bike', '100', '20', '0', (select ref(c) from customerProfileTable c where c.userID = '6475832891'), (select ref(r) from rental_bookingTable r where r.confirmationNum = '2974458763')));
 
create type maintenanceT as object
(mid char(4), lastMaintenance date, nextMaintenance date, checkUp varchar2(20), boid ref bikeT, member function nextMaintenanceDate return date);

insert into maintenanceTable values(maintenanceT('0001', to_date('03/02/2019','DD/MM/YYYY'), to_date('6/03/2019','DD/MM/YYYY'), 'in progress',(select ref(b) from bikeTable b where b.barcode = '438383758')));

insert into maintenanceTable values(maintenanceT('0002', to_date('12/08/2020','DD/MM/YYYY'), to_date('15/09/2020','DD/MM/YYYY'), 'complete',(select ref(b) from bikeTable b where b.barcode = '674836254')));

insert into maintenanceTable values(maintenanceT('0003', to_date('27/10/2021','DD/MM/YYYY'), to_date('28/11/2021','DD/MM/YYYY'), 'in progress',(select ref(b) from bikeTable b where b.barcode = '846294719')));

insert into maintenanceTable values(maintenanceT('0004', to_date('12/05/2020','DD/MM/YYYY'), to_date('15/06/2020','DD/MM/YYYY'), 'in progress',(select ref(b) from bikeTable b where b.barcode = '756482046')));


create type repairT as object (rid char(4), start_date date, end_date date, status varchar2(20), boid ref bikeT, member function duration return varchar2, ORDER member function comps(ip_repair repairT) return integer);

insert into repairTable values(repairT('0001',to_date('12/08/2020','DD/MM/YYYY'),to_date('15/08/2020','DD/MM/YYYY'), 'complete',(select ref(b) from bikeTable b where b.barcode = '438383758')));   

insert into repairTable values(repairT('0002',to_date('18/09/2021','DD/MM/YYYY'),to_date('23/09/2021','DD/MM/YYYY'), 'in progress', (select ref(b) from bikeTable b where b.barcode = '846294719')));

insert into repairTable values(repairT('0003',to_date('04/10/2021','DD/MM/YYYY'),to_date('07/10/2021','DD/MM/YYYY'), 'in progress', (select ref(b) from bikeTable b where b.barcode = '674836254')));

insert into repairTable values(repairT('0004',to_date('24/11/2019','DD/MM/YYYY'),to_date('26/11/2019','DD/MM/YYYY'), 'complete', (select ref(b) from bikeTable b where b.barcode = '756482046')));




create type replacementT as object (repid char(4), replacementPart varchar2(15), cost number, roid ref repairT, boid ref bikeT);

insert into replacementTable values(replacementT('0001', 'wheels', 30, (select ref(r) from repairTable r where r.rid = '0001'), (select ref(b) from bikeTable b where b.barcode = '438383758')));

insert into replacementTable values(replacementT('0002', 'handlebar', 15, (select ref(r) from repairTable r where r.rid = '0002'), (select ref(b) from bikeTable b where b.barcode = '846294719')));

insert into replacementTable values(replacementT('0003', 'brakes', 25, (select ref(r) from repairTable r where r.rid = '0003'), (select ref(b) from bikeTable b where b.barcode = '674836254')));

insert into replacementTable values(replacementT('0004', 'pedals', 35, (select ref(r) from repairTable r where r.rid = '0004'), (select ref(b) from bikeTable b where b.barcode = '756482046')));


