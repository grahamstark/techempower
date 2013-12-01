------------------------------------------------------------------------------
--                                                                          --
--  Handlers for each of OSCR's callbacks, plus some support functions      --
--                                                                          --
-- This is free software;  you can  redistribute it  and/or modify it under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 2,  or (at your option) any later ver- --
-- sion.  GNAT is distributed in the hope that it will be useful, but WITH- --
-- OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY --
-- or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License --
-- for  more details.  You should have  received  a copy of the GNU General --
-- Public License  distributed with GNAT;  see file COPYING.  If not, write --
-- to  the  Free Software Foundation,  51  Franklin  Street,  Fifth  Floor, --
-- Boston, MA 02110-1301, USA.                                              --
--                                                                          --
--                                                                          --

with AWS.Config;
with AWS.Messages;
with AWS.Mime;
with AWS.Resources;
with AWS.Response.Set;
with AWS.Response;
with AWS.Server;
with AWS.URL;
with Templates_Parser;

with Ada.Containers;
with Ada.Directories;
with Ada.Strings.Fixed;
with Ada.Strings.Maps;
with Ada.Strings.Unbounded;
with Ada.Strings;
with Ada.Text_IO;
with Ada.Characters.Handling;
with Ada.Numerics.Discrete_Random;

with GNAT.Regexp;

with GNATColl.Traces;
with GNATCOLL.JSON;

with Techempower_Data;
with Fortune_Type_IO;
with World_Type_IO;
with Connection_Pool;
with DB_Commons;
with GNATCOLL.SQL.Exec;

package body Callbacks is

   log_trace : GNATColl.Traces.Trace_Handle := GNATColl.Traces.Create( "CALLBACKS" );

   package d renames DB_Commons;

   subtype I_1_10_000 is Integer range 1 .. 10_000;
   package Random_Integers is new Ada.Numerics.Discrete_Random( I_1_10_000 );
   integer_generator : Random_Integers.Generator;
   package gse renames GNATCOLL.SQL.Exec;

   
   procedure Log( s : String ) is
   begin
      GNATColl.Traces.Trace( log_trace, s );
   end Log;

   function Test4_Callback( request : in AWS.Status.Data ) return AWS.Response.Data is
   use GNATCOLL.JSON;
   use GNATCOLL.SQL.Exec;
   use Templates_Parser;
   use Ada.Strings.Unbounded;
   use Techempower_Data;
      session_id      : constant AWS.Session.Id := AWS.Status.Session( request );
      url             : constant AWS.URL.Object := AWS.Status.URI( request ); 
      params          : constant AWS.Parameters.List := AWS.Status.Parameters( request );
      fortune_test_list : Techempower_Data.Fortune_Type_List.Vector;
      end_fortune_test  : Fortune_Type;
      criteria          : d.Criteria;
      translations      : Translate_Set;
      messages          : Vector_Tag;
      ids               : Vector_Tag;
   begin
      fortune_test_list := Fortune_Type_IO.Retrieve( criteria );
      end_fortune_test.message := To_Unbounded_String( "Additional fortune added at request time." );
      end_fortune_test.id := Natural( fortune_test_list.Length ) + 1; 
      fortune_test_list.Append( end_fortune_test );
      for fa of fortune_test_list loop
         messages := messages & fa.message;         
         ids := ids & fa.id'Img;         
      end loop;
      Insert( translations, Assoc( "MESSAGES", messages ));
      Insert( translations, Assoc( "IDS", ids ));
      declare
         s : constant String := Templates_Parser.Parse( "etc/test_4.thtml", translations );
      begin
         return AWS.Response.Build( "text/html", s );
      end;
   end Test4_Callback;
   

   function Test3_Callback( request : in AWS.Status.Data ) return AWS.Response.Data is
   use GNATCOLL.JSON;
   use GNATCOLL.SQL.Exec;
      session_id      : constant AWS.Session.Id := AWS.Status.Session( request );
      url             : constant AWS.URL.Object := AWS.Status.URI( request ); 
      params          : constant AWS.Parameters.List := AWS.Status.Parameters( request );
      connection      : Database_Connection := Connection_Pool.Lease;
      query           : constant String := "select id, randomNumber from world where id = $1" ;
      ps              : gse.Prepared_Statement := gse.Prepare( query, On_Server => True );
      json            : JSON_Array;
      world_test_item : Techempower_Data.World_Type;
      num_queries     : Integer;
      cursor          : gse.Forward_Cursor;
      q_string        : constant String := AWS.URL.Parameter( url, "queries" );
   begin
      begin
         num_queries := Integer'Value( q_string );
         num_queries := Integer'Max( 1, num_queries );
         num_queries := Integer'Min( 500, num_queries );
      exception
         when others => num_queries := 1;
      end;
      for i in 1 .. num_queries loop
         declare
            jlocal : JSON_Value := Create_Object;
            p      : Integer := Random_Integers.Random( integer_generator );
         begin
            cursor.Fetch( connection, ps, Params => ( 1 => +p ));
            if( gse.Has_Row( cursor ))then
               world_test_item.id := gse.Integer_Value( cursor, 0 );
               world_test_item.random_Number := gse.Integer_Value( cursor, 1 );
            end if;
            jlocal.Set_Field( "id", Create( world_test_item.id ));
            jlocal.Set_Field( "randomNumber", Create( world_test_item.random_Number ));
            json := json & jlocal;
         end;
      end loop;
      Connection_Pool.Return_Connection( connection );
      declare
         s : constant String := Create( json ).Write;
      begin
         return AWS.Response.Build( "application/json", s );
      end;
   end Test3_Callback;
   
   function Test2_Callback( request : in AWS.Status.Data ) return AWS.Response.Data is
   use GNATCOLL.JSON;
      session_id   : constant AWS.Session.Id := AWS.Status.Session( request );
      url          : constant AWS.URL.Object := AWS.Status.URI( request ); 
      params       : constant AWS.Parameters.List := AWS.Status.Parameters( request );
      json  : JSON_Value := Create_Object;
      world_test_item : Techempower_Data.World_Type;
      p : Integer := Random_Integers.Random( integer_generator );
   begin
      world_test_item := World_Type_IO.Retrieve_By_PK( +p );
      -- world_test_item.id := p;
      -- world_test_item.random_number := p;
      json.Set_Field( "id", Create( world_test_item.id ));
      json.Set_Field( "randomNumber", Create( world_test_item.random_Number ));
      declare
         s : constant String := json.Write;
      begin
         return AWS.Response.Build( "application/json", s );
      end;
   end Test2_Callback;
   
begin
   Random_Integers.Reset( integer_generator );   
end Callbacks;
