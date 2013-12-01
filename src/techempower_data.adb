--
-- Created by ada_generator.py on 2013-12-01 16:44:14.680531
-- 

with GNAT.Calendar.Time_IO;
-- === CUSTOM IMPORTS START ===
-- === CUSTOM IMPORTS END ===

package body Techempower_Data is

   use ada.strings.Unbounded;
   package tio renames GNAT.Calendar.Time_IO;

   -- === CUSTOM TYPES START ===
   -- === CUSTOM TYPES END ===
   
   
   function To_String( rec : Fortune_Type ) return String is
   begin
      return  "Fortune_Type: " &
         "Id = " & rec.Id'Img &
         "Message = " & rec.Message'Img;
   end to_String;



   function To_String( rec : World_Type ) return String is
   begin
      return  "World_Type: " &
         "Id = " & rec.Id'Img &
         "Random_Number = " & rec.Random_Number'Img;
   end to_String;



        
   -- === CUSTOM PROCS START ===
   -- === CUSTOM PROCS END ===

end Techempower_Data;
