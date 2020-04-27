GRANT ALL PRIVILEGES ON * . * TO 'root'@'localhost';
DROP DATABASE IF EXISTS BI_OLTP;
DROP DATABASE IF EXISTS BI_MIR;
DROP DATABASE IF EXISTS BI_STG;
DROP DATABASE IF EXISTS BI_DW;
CREATE DATABASE BI_OLTP;
CREATE DATABASE BI_MIR;
CREATE DATABASE BI_STG;
CREATE DATABASE BI_DW;

DROP TABLE IF EXISTS BI_OLTP.customers;
CREATE TABLE BI_OLTP.customers (
CustomerID INT,
E_mail  VARCHAR(50),
Customer_First_Name VARCHAR(50),
Customer_Last_Name VARCHAR(50),
Gender char,
Phone INT,
DOB DATE,
Address_Country VARCHAR(50),
Address_City VARCHAR(50),
Address_Street VARCHAR(50),
ZIP_Code INT,
PRIMARY KEY (CustomerID)
);
LOAD DATA LOCAL INFILE 'C:\\Users\\\uzannada\\Desktop\\Customer_BI.csv' INTO TABLE BI_OLTP.customers FIELDS TERMINATED BY ',' IGNORE 1 LINES;


DROP TABLE IF EXISTS BI_OLTP.ports;
CREATE TABLE BI_OLTP.ports (
Port_code  INT,
Language VARCHAR(50),
City VARCHAR(50),
Country VARCHAR(50),
PRIMARY KEY (Port_code)
);
LOAD DATA LOCAL INFILE 'C:\\Users\\\uzannada\\Desktop\\Port_BI.csv' INTO TABLE BI_OLTP.ports FIELDS TERMINATED BY ',' IGNORE 1 LINES;

DROP TABLE IF EXISTS BI_OLTP.ships;
CREATE TABLE BI_OLTP.ships (
IMO_Number  INT,
Ship_Name VARCHAR(50),
MAX_Capacity INT,
PRIMARY KEY (IMO_Number)
);
LOAD DATA LOCAL INFILE 'C:\\Users\\\uzannada\\Desktop\\SHIPS_bi.csv' INTO TABLE BI_OLTP.ships FIELDS TERMINATED BY ',' IGNORE 1 LINES;

DROP TABLE IF EXISTS BI_OLTP.Rooms;
CREATE TABLE BI_OLTP.Rooms (
IMO_Number  INT,
Room_Number INT,
Type_ VARCHAR(50),
Max_Guests VARCHAR(50),
Price INT,
PRIMARY KEY (IMO_Number,Room_Number),
FOREIGN KEY (IMO_Number) REFERENCES BI_OLTP.ships(IMO_Number)
);
LOAD DATA LOCAL INFILE 'C:\\Users\\\uzannada\\Desktop\\ROOMS_BI.csv' INTO TABLE BI_OLTP.Rooms FIELDS TERMINATED BY ',' IGNORE 1 LINES;

DROP TABLE IF EXISTS BI_OLTP.Cruises;
CREATE TABLE BI_OLTP.Cruises (
Voyage_Code  INT,
Uses_for INT,
Price INT,
PRIMARY KEY (Voyage_Code),
FOREIGN KEY (Uses_for) REFERENCES BI_OLTP.ships(IMO_Number)
);
LOAD DATA LOCAL INFILE 'C:\\Users\\\uzannada\\Desktop\\Cruises_BI.csv' INTO TABLE BI_OLTP.Cruises FIELDS TERMINATED BY ',' IGNORE 1 LINES;

DROP TABLE IF EXISTS BI_OLTP.Agencies;
CREATE TABLE BI_OLTP.Agencies (
Agency_ID  INT,
Agency_Name VARCHAR(50),
Country VARCHAR(50),
PRIMARY KEY (Agency_ID)
);
LOAD DATA LOCAL INFILE 'C:\\Users\\\uzannada\\Desktop\\Agencies_BI.csv' INTO TABLE BI_OLTP.Agencies FIELDS TERMINATED BY ',' IGNORE 1 LINES;

DROP TABLE IF EXISTS BI_OLTP.Search;
CREATE TABLE BI_OLTP.Search (
IP VARCHAR(50),
SearchTime Datetime,
UsingCustomer INT,
PRIMARY KEY (IP,SearchTime),
FOREIGN KEY (UsingCustomer) REFERENCES BI_OLTP.customers(CustomerID)
);
LOAD DATA LOCAL INFILE 'C:\\Users\\\uzannada\\Desktop\\search_BI.csv' INTO TABLE BI_OLTP.Search FIELDS TERMINATED BY ',' IGNORE 1 LINES;

DROP TABLE IF EXISTS BI_OLTP.CruisesSearch;
CREATE TABLE BI_OLTP.CruisesSearch (
IP  VARCHAR(50),
SearchTime Datetime,
UsesFor INT,
PRIMARY KEY (IP,SearchTime),
FOREIGN KEY (IP,SearchTime) REFERENCES BI_OLTP.Search(IP,SearchTime),
FOREIGN KEY (UsesFor) REFERENCES BI_OLTP.Cruises(Voyage_Code)
);
LOAD DATA LOCAL INFILE 'C:\\Users\\\uzannada\\Desktop\\CruisesSearch_BI.csv' INTO TABLE BI_OLTP.CruisesSearch FIELDS TERMINATED BY ',' IGNORE 1 LINES;



DROP TABLE IF EXISTS BI_OLTP.Orders;
CREATE TABLE BI_OLTP.Orders (
OrderID  int,
Order_Date Date,
Order_Time time,
NumberOfGuests INT,
MadeBy INT,
HandeledBy INT,
PRIMARY KEY (OrderID),
FOREIGN KEY (MadeBy) REFERENCES BI_OLTP.customers(CustomerID),
FOREIGN KEY (HandeledBy) REFERENCES BI_OLTP.Agencies(Agency_ID)
);
LOAD DATA LOCAL INFILE 'C:\\Users\\\uzannada\\Desktop\\Orders_BI.csv' INTO TABLE BI_OLTP.Orders FIELDS TERMINATED BY ',' IGNORE 1 LINES;

DROP TABLE IF EXISTS BI_OLTP.GDP;
CREATE TABLE BI_OLTP.GDP (
City varchar(50),
Country varchar(50),
YearGDP INT,
Salary_Average  decimal(8,3),
GDP decimal(8,3),
Rank int,
population int,
PRIMARY KEY (City,Country,YearGDP)
);
LOAD DATA LOCAL INFILE 'C:\\Users\\\uzannada\\Desktop\\GDP_BI.csv' INTO TABLE BI_OLTP.GDP FIELDS TERMINATED BY ',' IGNORE 1 LINES;

DROP TABLE IF EXISTS BI_OLTP.Stopings;
CREATE TABLE BI_OLTP.Stopings (
Voyage_Code INT,
Port_code  INT,
date_time date,
PRIMARY KEY (Voyage_Code,Port_code),
FOREIGN KEY (Voyage_Code) REFERENCES BI_OLTP.Cruises(Voyage_Code),
FOREIGN KEY (Port_code) REFERENCES BI_OLTP.ports(Port_code)
);
LOAD DATA LOCAL INFILE 'C:\\Users\\\uzannada\\Desktop\\Stopings_BI.csv' INTO TABLE BI_OLTP.Stopings FIELDS TERMINATED BY ',' IGNORE 1 LINES;


DROP TABLE IF EXISTS BI_OLTP.Resevations;
CREATE TABLE BI_OLTP.Resevations (
OrderID	int,
IMO_Number int,
Room_Number int,
Voyage_Code int,
PRIMARY KEY (OrderID,IMO_Number,Room_Number,Voyage_Code),
FOREIGN KEY (Voyage_Code) REFERENCES BI_OLTP.Cruises(Voyage_Code),
FOREIGN KEY (IMO_Number,Room_Number) REFERENCES BI_OLTP.Rooms(IMO_Number,Room_Number),
FOREIGN KEY (OrderID) REFERENCES BI_OLTP.Orders(OrderID)
);
LOAD DATA LOCAL INFILE 'C:\\Users\\\uzannada\\Desktop\\reservation__BI.csv' INTO TABLE BI_OLTP.Resevations FIELDS TERMINATED BY ',' IGNORE 1 LINES;


DROP table IF exists BI_DW.datedim;
CREATE TABLE IF NOT EXISTS BI_DW.datedim  (
    date_id INT NOT NULL auto_increment,
    fulldate date,
    dayofmonth int,
    dayofyear int,
    dayofweek int,
    dayname varchar(10),
    monthnumber int,
    monthname varchar(10),
    year    int,
    quarter tinyint,
    PRIMARY KEY(date_id)
) ENGINE=InnoDB AUTO_INCREMENT=1000;



DROP PROCEDURE IF EXISTS BI_DW.datedimbuild;
delimiter //
CREATE PROCEDURE BI_DW.datedimbuild (p_start_date DATE, p_end_date DATE)
BEGIN
    DECLARE v_full_date DATE;

    DELETE FROM datedim;

    SET v_full_date = p_start_date;
    WHILE v_full_date < p_end_date DO

        INSERT INTO datedim (
            fulldate ,
            dayofmonth ,
            dayofyear ,
            dayofweek ,
            dayname ,
            monthnumber,
            monthname,
            year,
            quarter
        ) VALUES (
            v_full_date,
            DAYOFMONTH(v_full_date),
            DAYOFYEAR(v_full_date),
            DAYOFWEEK(v_full_date),
            DAYNAME(v_full_date),
            MONTH(v_full_date),
            MONTHNAME(v_full_date),
            YEAR(v_full_date),
            QUARTER(v_full_date)
        );

        SET v_full_date = DATE_ADD(v_full_date, INTERVAL 1 DAY);
    END WHILE;
END//

SET SQL_SAFE_UPDATES=0;
call BI_DW.datedimbuild ('2013-01-01', '2019-04-30');
SET SQL_SAFE_UPDATES=1;




DROP TABLE IF EXISTS BI_DW.Dim_Time;
CREATE TABLE BI_DW.Dim_Time  (
    TimeID INT NOT NULL auto_increment,
    Fulltime time,
    Hour int,
    Minute int,
    AmPm varchar(2),
    PRIMARY KEY(TimeID)
) ENGINE=InnoDB AUTO_INCREMENT=1000;




DROP PROCEDURE IF EXISTS BI_DW.BuildDimTime;
delimiter //
CREATE PROCEDURE BI_DW.BuildDimTime()
BEGIN
    DECLARE v_full_date DATETIME;

    DELETE FROM BI_DW.Dim_Time;

    SET v_full_date = '2016-01-01 00:00:00';
    WHILE v_full_date <= '2016-01-01 23:59:00' DO

        INSERT INTO BI_DW.Dim_Time(
            fulltime ,
            hour ,
            minute ,
            ampm
        ) VALUES (
            TIME(v_full_date),
            HOUR(v_full_date),
            MINUTE(v_full_date),
            DATE_FORMAT(v_full_date,'%p')
        );

        SET v_full_date = DATE_ADD(v_full_date, INTERVAL 1 MINUTE);
        
    END WHILE;
END//



SET SQL_SAFE_UPDATES=0;
call BI_DW.BuildDimTime();

DROP table IF exists BI_DW.time_Stamp;
CREATE TABLE IF NOT EXISTS BI_DW.time_Stamp(
Run timestamp not null,
primary key (run));


UPDATE `bi_dw`.`dim_cruises` SET `scd_start`='2013-01-01 00:00:00';
UPDATE `bi_dw`.`dim_cusomers` SET `scd_start`='2013-01-01 00:00:00';
UPDATE `bi_dw`.`dim_rooms` SET `scd_start`='2013-01-01 00:00:00';