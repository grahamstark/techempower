with AWS.Client;
with Ada.Text_IO;
with Ada.Command_Line;
with AWS.Response;
with AWS.Messages;
with Ada.Calendar; 
with Ada.Strings.Unbounded;
procedure Multi_Get is

   use Ada.Text_IO;
   use Ada.Calendar;
   use Ada.Strings.Unbounded;
   
   url : Unbounded_String;
   requests_per_thread : Positive;
   timeouts : constant AWS.Client.Timeouts_Values := AWS.Client.Timeouts(
      Connect => 50.0, Receive => 50.0, Response => 50.0, Send => 50.0 );
   
   task type Getter_Worker is
      entry Start( thread_num : Positive );
      entry Stop( 
         time_taken       : out Duration; 
         num_errors       : out Natural );
   end Getter_Worker;
   
   task body Getter_Worker is
      use AWS.Messages;
      
      l_num_errors : Natural := 0;
      start_time   : Time := Clock;
      end_time     : Time;
      tnum         : Positive;
      lurl         : constant String := To_String( url );
   begin
      -- Put_Line( "lurl " & lurl );
      accept Start( thread_num : Positive ) do
         tnum := thread_num;
      end Start;
      Put_Line( "started " & tnum'Img );
      for i in 1 .. requests_per_thread loop
         -- Put_Line( "thread " & tnum'Img & " iter " & i'Img );
         declare
            data :AWS.Response.Data := AWS.Client.Get( URL => lurl, Timeouts => timeouts );
            return_code : Status_Code := AWS.Response.Status_Code( data );
         begin
            if( i mod 1 = 0 )then
               Put_Line( "thread " & tnum'Img & " : " & AWS.Response.Message_Body( data ));
               Put_Line( return_code'Img );
            end if;
            if( return_code in Client_Error or return_code in Server_Error )then
               l_num_errors := l_num_errors + 1;
               Put_Line( "error " & tnum'Img & " " & i'Img & " rc " & return_code'Img );
            end if;
         end;
      end loop;
      end_time := Clock;
      Put_Line( "thread " & tnum'Img & " stopping " );
      accept Stop(
         time_taken       : out Duration; 
         num_errors       : out Natural ) do
         time_taken := end_time - start_time;
         num_errors := l_num_errors;
      end Stop;
   end Getter_Worker;
   
   procedure Run( num_threads : Positive ) is
      t_time_taken       : Duration := 0.0; 
      t_requests_per_sec : Long_Float := 0.0; 
      t_num_errors       : Natural := 0;
      time_taken         : Duration := 0.0; 
      requests_per_sec   : Long_Float := 0.0; 
      num_errors         : Natural := 0;
      type Workers_Array is array( 1 .. num_threads ) of Getter_Worker;
      workers : Workers_Array;
      successes : Natural := 0;
      start_time   : Time := Clock;
   begin
      for i in workers'Range loop
         workers( i ).Start( i );
      end loop;
      Put_Line( "all started " );
      for i in workers'Range loop
         workers( i ).Stop( time_taken, num_errors );
         -- Put_Line( "thread[" & i'Img & " ] = " & time_taken'Img );
         t_num_errors := t_num_errors + num_errors; 
      end loop;
      t_time_taken := Clock - start_time;
      successes := num_threads * requests_per_thread - t_num_errors;
      requests_per_sec := Long_Float( successes ) / Long_Float( t_time_taken );
      Put_Line( "threads " & num_threads'Img & " requests per thread " & requests_per_thread'Img );
      Put_Line( "total time taken " & t_time_taken'Img & " total errors " & t_num_errors'Img & " successes " & successes'Img );
      Put_Line( "successes/sec = " & requests_per_sec'Img );       
   end Run;

use Ada.Command_Line;
begin
   if( Argument_Count = 3 )then
      url := To_Unbounded_String( Argument( 1 ));
      requests_per_thread := Positive'Value( Argument( 3 ));
      declare
         num_threads : constant Positive := Positive'Value( Argument( 2 ));
      begin
         Run( num_threads );
      end;
   else
      Put_Line( "use: url num_threads num_requests_per_thread " );
   end if;
end Multi_Get;
