--
-- Created by ada_generator.py on 2013-11-27 11:28:58.430191
-- 
with Ada.Containers.Vectors;
--
-- FIXME: may not be needed
--
with Ada.Calendar;

with Base_Types; use Base_Types;

with Ada.Strings.Unbounded;

-- === CUSTOM IMPORTS START ===
-- === CUSTOM IMPORTS END ===

package Techempower_Data is

   use Ada.Strings.Unbounded;
   

   -- === CUSTOM TYPES START ===
   -- === CUSTOM TYPES END ===


   --
   -- record modelling world : Test 2
   --
   type World_Type is record
         Id : Integer := MISSING_I_KEY;
         Random_Number : Integer := 0;
   end record;
   --
   -- container for world : Test 2
   --
   package World_Type_List is new Ada.Containers.Vectors
      (Element_Type => World_Type,
      Index_Type => Positive );
   --
   -- default value for world : Test 2
   --
   Null_World_Type : constant World_Type := (
         Id => MISSING_I_KEY,
         Random_Number => 0
   );
   --
   -- simple print routine for world : Test 2
   --
   function To_String( rec : World_Type ) return String;

        
   -- === CUSTOM PROCS START ===
   -- === CUSTOM PROCS END ===

end Techempower_Data;
