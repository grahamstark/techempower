--
-- Created by ada_generator.py on 2013-12-01 17:49:17.821233
-- 

-- === CUSTOM IMPORTS START ===
-- === CUSTOM IMPORTS END ===


package body Environment is
   
   SERVER_NAME       : constant String := "localhost";
   DATABASE_NAME     : constant String := "techempower";
   USER_NAME         : constant String := "postgres";
   PASSWORD          : Constant String := "";

   -- === CUSTOM TYPES START ===
   -- === CUSTOM TYPES END ===


   function Get_Server_Name return String is
   begin
      return SERVER_NAME;
   end Get_Server_Name;

   function Get_Database_Name return String is
   begin
      return DATABASE_NAME;
   end Get_Database_Name;
   
   function Get_Username return String is
   begin
      return USER_NAME;
   end Get_Username;
   
   function Get_Password return String is
   begin
      return PASSWORD;
   end Get_Password;
   
   -- === CUSTOM PROCS START ===
   -- === CUSTOM PROCS END ===

end Environment;

