------------------------------------------------------------------------------
--                                                                          --
--  Handlers for each of WSC's callbacks, plus some support functions   --
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
with AWS.Session;
with AWS.Response;
with AWS.Parameters;
with AWS.Status;

--
package Callbacks is
   
   function Test2_Callback( request : in AWS.Status.Data ) return AWS.Response.Data;
   function Test3_Callback( request : in AWS.Status.Data ) return AWS.Response.Data;
   
end Callbacks;
