--
-- created on 27-11-2013 by Mill
--
drop database if exists techempower;
create database techempower with encoding 'UTF-8';

\c techempower;


CREATE TABLE world( 
       id INTEGER not null,
       randomNumber INTEGER default 0,
       PRIMARY KEY( id )
);

