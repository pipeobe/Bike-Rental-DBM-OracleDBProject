


OracleXML getXML -user "userID/password" \
? -conn "jdbc:oracle:thin:@sit.itec.yorku.ca:1521:studb10g" \
? "select p.soid.storeID as "storeID", p.eoid.fullname() as "name" , p.hourlyRate as "wage", p.soid.totalBikes() as "numOfBikes" ,
p.soid.totalAccessories() as "numOfAccessories" from payTable p"

OracleXML getXML -user "userID/password" \
? -conn "jdbc:oracle:thin:@sit.itec.yorku.ca:1521:studb10g" \
? "select s.storeID as "siteID", s.location as "Address", s.totalAccessories() as "TotalAccessories" from siteStoreTable s"

OracleXML getXML -user "userID/password" \
? -conn "jdbc:oracle:thin:@sit.itec.yorku.ca:1521:studb10g" \
? "select r.rid, r.coid.fullname() as "name", r.lateFee as "lateFeeCharged", r.damageFee as "damageFeeCharged", r.coid.RentalDetails() as
"rentalDetails", r.roid.totalPrice() as "totalPrice" from return_feeTable r"

OracleXML getXML -user "userID/password" \
? -conn "jdbc:oracle:thin:@sit.itec.yorku.ca:1521:studb10g" \
? "select p.soid.storeID as "SID", p.soid.location as "Address", p.eoid.fullname() as "Name", p.eoid.employeeNumber as
"ENumber" from payTable p"

OracleXML getXML -user "userID/password" \
? -conn "jdbc:oracle:thin:@sit.itec.yorku.ca:1521:studb10g" \
? "select s.storeID, s.location.fulladdress() as "full_Address" from siteStoreTable s where s.storeopeningTime = '1000' or
s.storeclosingTime = '2100'"