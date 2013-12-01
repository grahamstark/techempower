--
-- Created by ada_generator.py on 2013-12-01 16:44:15.147751
-- 


with Ada.Calendar;
with Ada.Exceptions;
with Ada.Strings.Unbounded; 

with GNATColl.Traces;

with AUnit.Assertions;             
with AUnit.Test_Cases; 

with Base_Types;
with Environment;

with DB_Commons;
with Techempower_Data;

with Connection_Pool;

with World_Type_IO;
with Fortune_Type_IO;


-- === CUSTOM IMPORTS START ===
-- === CUSTOM IMPORTS END ===

package body Techempower_Test is

   RECORDS_TO_ADD     : constant integer := 100;
   RECORDS_TO_DELETE  : constant integer := 0;
   RECORDS_TO_ALTER   : constant integer := 0;
   
   package d renames DB_Commons;
   
   use Base_Types;
   use ada.strings.Unbounded;
   use Techempower_Data;

   log_trace : GNATColl.Traces.Trace_Handle := GNATColl.Traces.Create( "TECHEMPOWER_TEST" );
   
   procedure Log( s : String ) is
   begin
      GNATColl.Traces.Trace( log_trace, s );
   end Log;

   
      -- === CUSTOM TYPES START ===
   -- === CUSTOM TYPES END ===

   use AUnit.Test_Cases;
   use AUnit.Assertions;
   use AUnit.Test_Cases.Registration;
   
   use Ada.Strings.Unbounded;
   use Ada.Exceptions;
   use Ada.Calendar;
   
   
--
-- test creating and deleting records  
--
--
   procedure World_Type_Create_Test(  T : in out AUnit.Test_Cases.Test_Case'Class ) is
      --
      -- local print iteration routine
      --
      procedure Print( pos : World_Type_List.Cursor ) is 
      world_test_item : Techempower_Data.World_Type;
      begin
         world_test_item := World_Type_List.element( pos );
         Log( To_String( world_test_item ));
      end print;

   
      world_test_item : Techempower_Data.World_Type;
      world_test_list : Techempower_Data.World_Type_List.Vector;
      criteria  : d.Criteria;
      startTime : Time;
      endTime   : Time;
      elapsed   : Duration;
   begin
      startTime := Clock;
      Log( "Starting test World_Type_Create_Test" );
      
      Log( "Clearing out the table" );
      World_Type_IO.Delete( criteria );
      
      Log( "World_Type_Create_Test: create tests" );
      for i in 1 .. RECORDS_TO_ADD loop
         world_test_item.Id := World_Type_IO.Next_Free_Id;
         -- missingworld_test_item declaration ;
         World_Type_IO.Save( world_test_item, False );         
      end loop;
      
      world_test_list := World_Type_IO.Retrieve( criteria );
      
      Log( "World_Type_Create_Test: alter tests" );
      for i in 1 .. RECORDS_TO_ALTER loop
         world_test_item := World_Type_List.element( world_test_list, i );
         World_Type_IO.Save( world_test_item );         
      end loop;
      
      Log( "World_Type_Create_Test: delete tests" );
      for i in RECORDS_TO_DELETE .. RECORDS_TO_ADD loop
         world_test_item := World_Type_List.element( world_test_list, i );
         World_Type_IO.Delete( world_test_item );         
      end loop;
      
      Log( "World_Type_Create_Test: retrieve all records" );
      World_Type_List.iterate( world_test_list, print'Access );
      endTime := Clock;
      elapsed := endTime - startTime;
      Log( "Ending test World_Type_Create_Test. Time taken = " & elapsed'Img );

   exception 
      when Error : others =>
         Log( "World_Type_Create_Test execute query failed with message " & Exception_Information(Error) );
         assert( False,  
            "World_Type_Create_Test : exception thrown " & Exception_Information(Error) );
   end World_Type_Create_Test;

   
--
-- test creating and deleting records  
--
--
   procedure Fortune_Type_Create_Test(  T : in out AUnit.Test_Cases.Test_Case'Class ) is
      --
      -- local print iteration routine
      --
      procedure Print( pos : Fortune_Type_List.Cursor ) is 
      fortune_test_item : Techempower_Data.Fortune_Type;
      begin
         fortune_test_item := Fortune_Type_List.element( pos );
         Log( To_String( fortune_test_item ));
      end print;

   
      fortune_test_item : Techempower_Data.Fortune_Type;
      fortune_test_list : Techempower_Data.Fortune_Type_List.Vector;
      criteria  : d.Criteria;
      startTime : Time;
      endTime   : Time;
      elapsed   : Duration;
   begin
      startTime := Clock;
      Log( "Starting test Fortune_Type_Create_Test" );
      
      Log( "Clearing out the table" );
      Fortune_Type_IO.Delete( criteria );
      
      Log( "Fortune_Type_Create_Test: create tests" );
      for i in 1 .. RECORDS_TO_ADD loop
         fortune_test_item.Id := Fortune_Type_IO.Next_Free_Id;
         -- missingfortune_test_item declaration ;
         Fortune_Type_IO.Save( fortune_test_item, False );         
      end loop;
      
      fortune_test_list := Fortune_Type_IO.Retrieve( criteria );
      
      Log( "Fortune_Type_Create_Test: alter tests" );
      for i in 1 .. RECORDS_TO_ALTER loop
         fortune_test_item := Fortune_Type_List.element( fortune_test_list, i );
         Fortune_Type_IO.Save( fortune_test_item );         
      end loop;
      
      Log( "Fortune_Type_Create_Test: delete tests" );
      for i in RECORDS_TO_DELETE .. RECORDS_TO_ADD loop
         fortune_test_item := Fortune_Type_List.element( fortune_test_list, i );
         Fortune_Type_IO.Delete( fortune_test_item );         
      end loop;
      
      Log( "Fortune_Type_Create_Test: retrieve all records" );
      Fortune_Type_List.iterate( fortune_test_list, print'Access );
      endTime := Clock;
      elapsed := endTime - startTime;
      Log( "Ending test Fortune_Type_Create_Test. Time taken = " & elapsed'Img );

   exception 
      when Error : others =>
         Log( "Fortune_Type_Create_Test execute query failed with message " & Exception_Information(Error) );
         assert( False,  
            "Fortune_Type_Create_Test : exception thrown " & Exception_Information(Error) );
   end Fortune_Type_Create_Test;

   
   
   
   procedure Register_Tests (T : in out Test_Case) is
   begin
      --
      -- Tests of record creation/deletion
      --
      Register_Routine (T, World_Type_Create_Test'Access, "Test of Creation and deletion of World_Type" );
      Register_Routine (T, Fortune_Type_Create_Test'Access, "Test of Creation and deletion of Fortune_Type" );
      --
      -- Tests of foreign key relationships
      --
   end Register_Tests;
   
   --  Register routines to be run
   
   
   function Name ( t : Test_Case ) return Message_String is
   begin
      return Format( "Techempower_Test Test Suite" );
   end Name;

   -- === CUSTOM PROCS START ===
      
         
      
   -- === CUSTOM PROCS END ===
   
   --  Preparation performed before each routine:
   procedure Set_Up( t : in out Test_Case ) is
   begin
       Connection_Pool.Initialise(
              Environment.Get_Server_Name,
              Environment.Get_Database_Name,
              Environment.Get_Username,
              Environment.Get_Password,
              10 );
      GNATColl.Traces.Parse_Config_File( "./etc/logging_config_file.txt" );
   end Set_Up;
   
   --  Preparation performed after each routine:
   procedure Shut_Down( t : in out Test_Case ) is
   begin
      Connection_Pool.Shutdown;
   end Shut_Down;
   
   
begin
   null;
end Techempower_Test;
