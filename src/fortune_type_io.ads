--
-- Created by ada_generator.py on 2013-12-01 17:49:17.962343
-- 
with Techempower_Data;
with DB_Commons;
with Base_Types;
with ADA.Calendar;
with Ada.Strings.Unbounded;

with GNATCOLL.SQL.Exec;


-- === CUSTOM IMPORTS START ===
-- === CUSTOM IMPORTS END ===

package Fortune_Type_IO is
  
   package d renames DB_Commons;   
   use Base_Types;
   use Ada.Strings.Unbounded;
   
   use GNATCOLL.SQL.Exec;
   

   -- === CUSTOM TYPES START ===
   -- === CUSTOM TYPES END ===

   
   function Next_Free_Id( connection : Database_Connection := null) return Integer;

   --
   -- returns true if the primary key parts of Fortune_Type match the defaults in Techempower_Data.Null_Fortune_Type
   --
   function Is_Null( fortune : Techempower_Data.Fortune_Type ) return Boolean;
   
   --
   -- returns the single Fortune_Type matching the primary key fields, or the Techempower_Data.Null_Fortune_Type record
   -- if no such record exists
   --
   function Retrieve_By_PK( Id : Integer; connection : Database_Connection := null ) return Techempower_Data.Fortune_Type;
   
   --
   -- Retrieves a list of Techempower_Data.Fortune_Type matching the criteria, or throws an exception
   --
   function Retrieve( c : d.Criteria; connection : Database_Connection := null ) return Techempower_Data.Fortune_Type_List.Vector;
   
   --
   -- Retrieves a list of Techempower_Data.Fortune_Type retrived by the sql string, or throws an exception
   --
   function Retrieve( sqlstr : String; connection : Database_Connection := null ) return Techempower_Data.Fortune_Type_List.Vector;
   
   --
   -- Save the given record, overwriting if it exists and overwrite is true, 
   -- otherwise throws DB_Exception exception. 
   --
   procedure Save( fortune : Techempower_Data.Fortune_Type; overwrite : Boolean := True; connection : Database_Connection := null );
   
   --
   -- Delete the given record. Throws DB_Exception exception. Sets value to Techempower_Data.Null_Fortune_Type
   --
   procedure Delete( fortune : in out Techempower_Data.Fortune_Type; connection : Database_Connection := null );
   --
   -- delete the records indentified by the criteria
   --
   procedure Delete( c : d.Criteria; connection : Database_Connection := null );
   --
   -- delete all the records identified by the where SQL clause 
   --
   procedure Delete( where_Clause : String; connection : Database_Connection := null );
   --
   -- functions to retrieve records from tables with foreign keys
   -- referencing the table modelled by this package
   --

   --
   -- functions to add something to a criteria
   --
   procedure Add_Id( c : in out d.Criteria; Id : Integer; op : d.operation_type:= d.eq; join : d.join_type := d.join_and );
   procedure Add_Message( c : in out d.Criteria; Message : Unbounded_String; op : d.operation_type:= d.eq; join : d.join_type := d.join_and );
   procedure Add_Message( c : in out d.Criteria; Message : String; op : d.operation_type:= d.eq; join : d.join_type := d.join_and );
   --
   -- functions to add an ordering to a criteria
   --
   procedure Add_Id_To_Orderings( c : in out d.Criteria; direction : d.Asc_Or_Desc );
   procedure Add_Message_To_Orderings( c : in out d.Criteria; direction : d.Asc_Or_Desc );

   -- === CUSTOM PROCS START ===
   -- === CUSTOM PROCS END ===

  
end Fortune_Type_IO;
