--
-- Created by ada_generator.py on 2013-12-01 17:49:17.844394
-- 
-- === CUSTOM IMPORTS START ===
-- === CUSTOM IMPORTS END ===

package body Base_Types is

   -- === CUSTOM TYPES START ===
   -- === CUSTOM TYPES END ===

   function Slice_To_Unbounded( s : String; start : Positive; stop : Natural ) return Unbounded_String is
   begin
      return To_Unbounded_String( Slice( To_Unbounded_String( s ), start, stop ) );
   end Slice_To_Unbounded;

   -- === CUSTOM PROCS START ===
   -- === CUSTOM PROCS END ===

end Base_Types;
