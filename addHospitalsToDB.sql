#add csv to database
CREATE TABLE `hospitals_19oct7` (
  `﻿X` double DEFAULT NULL,
  `Y` double DEFAULT NULL,
  `OBJECTID` int(11) DEFAULT NULL,
  `ID` int(11) DEFAULT NULL,
  `NAME` text,
  `ADDRESS` text,
  `CITY` text,
  `STATE` text,
  `ZIP` int(11) DEFAULT NULL,
  `ZIP4` text,
  `TELEPHONE` text,
  `TYPE` text,
  `STATUS` text,
  `POPULATION` int(11) DEFAULT NULL,
  `COUNTY` text,
  `COUNTYFIPS` int(11) DEFAULT NULL,
  `COUNTRY` text,
  `LATITUDE` double DEFAULT NULL,
  `LONGITUDE` double DEFAULT NULL,
  `NAICS_CODE` int(11) DEFAULT NULL,
  `NAICS_DESC` text,
  `SOURCE` text,
  `SOURCEDATE` text,
  `VAL_METHOD` text,
  `VAL_DATE` text,
  `WEBSITE` text,
  `STATE_ID` text,
  `ALT_NAME` text,
  `ST_FIPS` int(11) DEFAULT NULL,
  `OWNER` text,
  `TTL_STAFF` int(11) DEFAULT NULL,
  `BEDS` int(11) DEFAULT NULL,
  `TRAUMA` text,
  `HELIPAD` text
);
ALTER TABLE `hospital_db`.`hospitals_19oct7` 
CHANGE COLUMN `ID` `ID` INT(11) NOT NULL ,
ADD PRIMARY KEY (`ID`);

load data local infile "~\\Hospitals_19Oct07.csv"
into table hospitals_19oct7
fields terminated by ','
lines terminated by '\n'
ignore 1 rows;

#add these columns for real-time updates
alter table hospitals_19oct7 add column ventilators int(11),
							 add column negative_rooms int(11),  
                             add column shortages text,
                             add column status text,
                             add column entry_date date;
                             
				select * from hospitals_19oct7 limit 10;

-- example udate query  
--  update hospital_db.hospitals_19oct7
--  set shortages = "gloves", ventilators = 30, entry_date = str_to_date('2020-03-29', '%Y-%m-%d')
--  where id = 38593901;
-- 
-- update hospital_db.hospitals_19oct7
-- set shortages = NULL, ventilators = NULL, entry_date = NULL
-- where id = 10;


               
  select * from hospitals_19oct7 where objectid = 4;              
    select * from hospitals_19oct7 where ventilators is not null;  
     select * from hospitals_19oct7 where id = 13 or id = 25190712;     
#tables for future use
#to show history of availability 
              
#hospital information table
create table hosp_info_19oct7 as select * from hospitals_19oct7;
alter table hosp_info_19oct7 drop beds;

#table for number of beds (linked by id)
create table beds as select ID, beds as numBeds from hospitals_19oct7;
alter table beds add column vetilators int(11),
				 add column negative_rooms int(11),  
                 add column shortages text,
                 add column entry_date date;


