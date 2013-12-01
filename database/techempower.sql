--
-- created on 28-11-2013 by Mill
--
drop database if exists techempower;
create database techempower with encoding 'UTF-8';

\c techempower;


CREATE TABLE world( 
       id INTEGER not null,
       randomNumber INTEGER,
       PRIMARY KEY( id )
);

CREATE TABLE fortune( 
       id INTEGER not null,
       message VARCHAR(1),
       PRIMARY KEY( id )
);

