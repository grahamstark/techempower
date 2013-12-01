with Ada.Strings.Unbounded; 
with Ada.Text_IO;
with Ada.Text_IO.Unbounded_IO;
with GNATColl.Traces;

with Base_Types;
with Environment;

with DB_Commons;
with Techempower_Data;

with Connection_Pool;

with World_Type_IO;
with Fortune_Type_IO;

procedure Techempower_Load is

   RECORDS_TO_ADD : constant integer := 0; --10000;
   
   package d renames DB_Commons;
   
   use Base_Types;
   use ada.strings.Unbounded;
   use Techempower_Data;
   use Ada.Text_IO;
   
   log_trace : GNATColl.Traces.Trace_Handle := GNATColl.Traces.Create( "TECHEMPOWER_LOAD" );
   
   procedure Log( s : String ) is
   begin
      GNATColl.Traces.Trace( log_trace, s );
   end Log;

   world_test_item : Techempower_Data.World_Type;
   fortune_test_item : Techempower_Data.Fortune_Type;
   f : File_Type;
   s : Unbounded_String;
begin   
   Open( f, In_File, "./etc/this_is_some_text.txt" );
   GNATColl.Traces.Parse_Config_File( "./etc/logging_config_file.txt" );
   Connection_Pool.Initialise(
           Environment.Get_Server_Name,
           Environment.Get_Database_Name,
           Environment.Get_Username,
           Environment.Get_Password,
           10 );
   Log( "World_Type_Create_Test: create tests" );
   for i in 1 .. RECORDS_TO_ADD loop
      world_test_item.Id := World_Type_IO.Next_Free_Id;
      world_test_item.random_number := i;
      World_Type_IO.Save( world_test_item, False );         
   end loop;
   loop
      exit when End_Of_File( f );
      fortune_test_item.Id := Fortune_Type_IO.Next_Free_Id;
      fortune_test_item.message := Unbounded_IO.Get_Line( f );
      Unbounded_IO.Put_Line( fortune_test_item.message );
      Fortune_Type_IO.Save( fortune_test_item, False );         
   end loop;
   Close( f );
   Connection_Pool.Shutdown;
end Techempower_Load;
