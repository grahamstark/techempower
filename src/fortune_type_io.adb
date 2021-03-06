--
-- Created by ada_generator.py on 2013-12-01 17:49:17.969340
-- 
with Techempower_Data;


with Ada.Containers.Vectors;

with Environment;

with DB_Commons; 

with GNATCOLL.SQL_Impl;
with GNATCOLL.SQL.Postgres;


with Ada.Exceptions;  
with Ada.Strings; 
with Ada.Strings.Wide_Fixed;
with Ada.Characters.Conversions;
with Ada.Strings.Unbounded; 
with Text_IO;
with Ada.Strings.Maps;
with Connection_Pool;
with GNATColl.Traces;


-- === CUSTOM IMPORTS START ===
-- === CUSTOM IMPORTS END ===

package body Fortune_Type_IO is

   use Ada.Strings.Unbounded;
   use Ada.Exceptions;
   use Ada.Strings;

   package gsi renames GNATCOLL.SQL_Impl;
   package gsp renames GNATCOLL.SQL.Postgres;
   package gse renames GNATCOLL.SQL.Exec;
   
   use Base_Types;
   
   log_trace : GNATColl.Traces.Trace_Handle := GNATColl.Traces.Create( "FORTUNE_TYPE_IO" );
   
   procedure Log( s : String ) is
   begin
      GNATColl.Traces.Trace( log_trace, s );
   end Log;
   
   
   -- === CUSTOM TYPES START ===
   -- === CUSTOM TYPES END ===

   
   --
   -- generic packages to handle each possible type of decimal, if any, go here
   --


   
   --
   -- Select all variables; substring to be competed with output from some criteria
   --
   SELECT_PART : constant String := "select " &
         "id, message " &
         " from fortune " ;
   
   --
   -- Insert all variables; substring to be competed with output from some criteria
   --
   INSERT_PART : constant String := "insert into fortune (" &
         "id, message " &
         " ) values " ;

   
   --
   -- delete all the records identified by the where SQL clause 
   --
   DELETE_PART : constant String := "delete from fortune ";
   
   --
   -- update
   --
   UPDATE_PART : constant String := "update fortune set  ";
   
   
   procedure Check_Result( conn : in out gse.Database_Connection ) is
      error_msg : constant String := gse.Error( conn );
   begin
      if( error_msg /= "" )then
         Log( error_msg );
         Connection_Pool.Return_Connection( conn );
         Raise_Exception( db_commons.DB_Exception'Identity, error_msg );
      end if;
   end  Check_Result;     


   
   -- 
   -- Next highest avaiable value of Id - useful for saving  
   --
   function Next_Free_Id( connection : Database_Connection := null) return Integer is
      query      : constant String := "select max( id ) from fortune";
      cursor     : gse.Forward_Cursor;
      ai         : Integer := 0;
      ps : gse.Prepared_Statement;
      local_connection : Database_Connection;
      is_local_connection : Boolean;

   begin
      if( connection = null )then
          local_connection := Connection_Pool.Lease;
          is_local_connection := True;
      else
          local_connection := connection;          
          is_local_connection := False;
      end if;

      ps := gse.Prepare( query, On_Server => True );
      cursor.Fetch( local_connection, ps );
      Check_Result( local_connection );
      if( gse.Has_Row( cursor ))then
         ai := gse.Integer_Value( cursor, 0, 0 );

      end if;
      if( is_local_connection )then
         Connection_Pool.Return_Connection( local_connection );
      end if;
      return ai+1;
   end Next_Free_Id;



   --
   -- returns true if the primary key parts of Fortune_Type match the defaults in Techempower_Data.Null_Fortune_Type
   --
   --
   -- Does this Fortune_Type equal the default Techempower_Data.Null_Fortune_Type ?
   --
   function Is_Null( fortune : Techempower_Data.Fortune_Type ) return Boolean is
   use Techempower_Data;
   begin
      return fortune = Techempower_Data.Null_Fortune_Type;
   end Is_Null;


   
   --
   -- returns the single Fortune_Type matching the primary key fields, or the Techempower_Data.Null_Fortune_Type record
   -- if no such record exists
   --
   function Retrieve_By_PK( Id : Integer; connection : Database_Connection := null ) return Techempower_Data.Fortune_Type is
      l : Techempower_Data.Fortune_Type_List.Vector;
      fortune : Techempower_Data.Fortune_Type;
      c : d.Criteria;
   begin      
      Add_Id( c, Id );
      l := Retrieve( c, connection );
      if( not Techempower_Data.Fortune_Type_List.is_empty( l ) ) then
         fortune := Techempower_Data.Fortune_Type_List.First_Element( l );
      else
         fortune := Techempower_Data.Null_Fortune_Type;
      end if;
      return fortune;
   end Retrieve_By_PK;

   
   --
   -- Retrieves a list of Techempower_Data.Fortune_Type matching the criteria, or throws an exception
   --
   function Retrieve( c : d.Criteria; connection : Database_Connection := null ) return Techempower_Data.Fortune_Type_List.Vector is
   begin      
      return Retrieve( d.to_string( c ) );
   end Retrieve;

   
   --
   -- Retrieves a list of Techempower_Data.Fortune_Type retrived by the sql string, or throws an exception
   --
   function Retrieve( sqlstr : String; connection : Database_Connection := null ) return Techempower_Data.Fortune_Type_List.Vector is
      l : Techempower_Data.Fortune_Type_List.Vector;
      ps : gse.Prepared_Statement;
      local_connection : Database_Connection;
      is_local_connection : Boolean;
      query : constant String := SELECT_PART & " " & sqlstr;
      cursor   : gse.Forward_Cursor;
   begin
      if( connection = null )then
          local_connection := Connection_Pool.Lease;
          is_local_connection := True;
      else
          local_connection := connection;          
          is_local_connection := False;
      end if;
      Log( "retrieve made this as query " & query );
      ps := gse.Prepare( query, On_Server => True );
      cursor.Fetch( local_connection, ps );
      Check_Result( local_connection );
      while gse.Has_Row( cursor ) loop
         declare
           fortune : Techempower_Data.Fortune_Type;
         begin
            if not gse.Is_Null( cursor, 0 )then
               fortune.Id := gse.Integer_Value( cursor, 0 );
            end if;
            if not gse.Is_Null( cursor, 1 )then
               fortune.Message:= To_Unbounded_String( gse.Value( cursor, 1 ));
            end if;
            l.append( fortune ); 
         end;
         gse.Next( cursor );
      end loop;
      if( is_local_connection )then
         local_connection.Commit;
         Connection_Pool.Return_Connection( local_connection );
      end if;
      return l;
   end Retrieve;

   
   --
   -- Update the given record 
   -- otherwise throws DB_Exception exception. 
   --
   procedure Update( fortune : Techempower_Data.Fortune_Type; connection : Database_Connection := null ) is
      pk_c : d.Criteria;
      values_c : d.Criteria;
      local_connection : Database_Connection;
      is_local_connection : Boolean;

   begin
      if( connection = null )then
          local_connection := Connection_Pool.Lease;
          is_local_connection := True;
      else
          local_connection := connection;          
          is_local_connection := False;
      end if;

      --
      -- values to be updated
      --
      Add_Message( values_c, fortune.Message );
      --
      -- primary key fields
      --
      Add_Id( pk_c, fortune.Id );
      declare      
         query : constant String := UPDATE_PART & " " & d.To_String( values_c, "," ) & d.To_String( pk_c );
      begin
         Log( "update; executing query" & query );
         gse.Execute( local_connection, query );
         Check_Result( local_connection );
         if( is_local_connection )then
            local_connection.Commit;
            Connection_Pool.Return_Connection( local_connection );
         end if;
      end;
   end Update;


   --
   -- Save the compelete given record 
   -- otherwise throws DB_Exception exception. 
   --
   procedure Save( fortune : Techempower_Data.Fortune_Type; overwrite : Boolean := True; connection : Database_Connection := null ) is   
      c : d.Criteria;
      fortune_tmp : Techempower_Data.Fortune_Type;
      local_connection : Database_Connection;
      is_local_connection : Boolean;
   begin
      if( connection = null )then
          local_connection := Connection_Pool.Lease;
          is_local_connection := True;
      else
          local_connection := connection;          
          is_local_connection := False;
      end if;
      if( overwrite ) then
         fortune_tmp := retrieve_By_PK( fortune.Id );
         if( not is_Null( fortune_tmp )) then
            Update( fortune, local_connection );
            return;
         end if;
      end if;
      Add_Id( c, fortune.Id );
      Add_Message( c, fortune.Message );
      declare
         query : constant String := INSERT_PART & " ( "  & d.To_Crude_Array_Of_Values( c ) & " )";
      begin
         Log( "save; executing query" & query );
         gse.Execute( local_connection, query );
         local_connection.Commit;
         Check_Result( local_connection );
      end;   
      if( is_local_connection )then
         Connection_Pool.Return_Connection( local_connection );
      end if;
   end Save;


   
   --
   -- Delete the given record. Throws DB_Exception exception. Sets value to Techempower_Data.Null_Fortune_Type
   --

   procedure Delete( fortune : in out Techempower_Data.Fortune_Type; connection : Database_Connection := null ) is
         c : d.Criteria;
   begin  
      Add_Id( c, fortune.Id );
      Delete( c, connection );
      fortune := Techempower_Data.Null_Fortune_Type;
      Log( "delete record; execute query OK" );
   end Delete;


   --
   -- delete the records indentified by the criteria
   --
   procedure Delete( c : d.Criteria; connection : Database_Connection := null ) is
   begin      
      delete( d.to_string( c ), connection );
      Log( "delete criteria; execute query OK" );
   end Delete;
   
   procedure Delete( where_Clause : String; connection : gse.Database_Connection := null ) is
      local_connection : gse.Database_Connection;     
      is_local_connection : Boolean;
      query : constant String := DELETE_PART & where_Clause;
   begin
      if( connection = null )then
          local_connection := Connection_Pool.Lease;
          is_local_connection := True;
      else
          local_connection := connection;          
          is_local_connection := False;
      end if;
      Log( "delete; executing query" & query );
      gse.Execute( local_connection, query );
      Check_Result( local_connection );
      Log( "delete; execute query OK" );
      if( is_local_connection )then
         local_connection.Commit;
         Connection_Pool.Return_Connection( local_connection );
      end if;
   end Delete;


   --
   -- functions to retrieve records from tables with foreign keys
   -- referencing the table modelled by this package
   --

   --
   -- functions to add something to a criteria
   --
   procedure Add_Id( c : in out d.Criteria; Id : Integer; op : d.operation_type:= d.eq; join : d.join_type := d.join_and ) is   
   elem : d.Criterion := d.make_Criterion_Element( "id", op, join, Id );
   begin
      d.add_to_criteria( c, elem );
   end Add_Id;


   procedure Add_Message( c : in out d.Criteria; Message : Unbounded_String; op : d.operation_type:= d.eq; join : d.join_type := d.join_and ) is   
   elem : d.Criterion := d.make_Criterion_Element( "message", op, join, To_String( Message ), 256 );
   begin
      d.add_to_criteria( c, elem );
   end Add_Message;


   procedure Add_Message( c : in out d.Criteria; Message : String; op : d.operation_type:= d.eq; join : d.join_type := d.join_and ) is   
   elem : d.Criterion := d.make_Criterion_Element( "message", op, join, Message, 256 );
   begin
      d.add_to_criteria( c, elem );
   end Add_Message;


   
   --
   -- functions to add an ordering to a criteria
   --
   procedure Add_Id_To_Orderings( c : in out d.Criteria; direction : d.Asc_Or_Desc ) is   
   elem : d.Order_By_Element := d.Make_Order_By_Element( "id", direction  );
   begin
      d.add_to_criteria( c, elem );
   end Add_Id_To_Orderings;


   procedure Add_Message_To_Orderings( c : in out d.Criteria; direction : d.Asc_Or_Desc ) is   
   elem : d.Order_By_Element := d.Make_Order_By_Element( "message", direction  );
   begin
      d.add_to_criteria( c, elem );
   end Add_Message_To_Orderings;


   
   -- === CUSTOM PROCS START ===
   -- === CUSTOM PROCS END ===

end Fortune_Type_IO;
