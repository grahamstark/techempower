--
-- $Revision $
-- $Author $
-- $Date $
--
with Ada.Text_IO;
with Ada.Strings.Unbounded;

with AWS.Config.Set; 
with AWS.Config; 
with AWS.Dispatchers.Callback;
with AWS.Mime;
with AWS.Server.Log;
with AWS.Server;
with AWS.Services.Dispatchers.URI;
with AWS.Services.Page_Server;
with AWS.Services;
with AWS.Default;
with Ada.Command_Line;

with Callbacks;
with Connection_Pool;
with GNATColl.Traces;
with Global_Settings;
with Signal_Handler;
with Environment;

procedure Tech_Server is
   
   use AWS.Services;
   use AWS.Config;
   use AWS.Config.Set;
   use Ada.Text_IO;
   
   log_trace : GNATColl.Traces.Trace_Handle := GNATColl.Traces.Create( "TECH_SERVER" );
   
   procedure Log( s : String ) is
   begin
      GNATColl.Traces.Trace( log_trace, s );
   end Log;
 
   my_dispatcher : AWS.Services.Dispatchers.URI.Handler;
   my_config     : AWS.Config.Object := AWS.Config.Get_Current;
   
   package awsc renames AWS.Config; 
   
   SEP : constant String := Global_Settings.Dir_Separator;
    
   default_handler : AWS.Dispatchers.Callback.Handler;

begin
   
   awsc.Set.Server_Name( my_config, "Tech Tests Server" );
   awsc.Set.Server_Port( my_config, Global_Settings.port );
   awsc.Set.WWW_Root( my_config, Global_Settings.Physical_Root & "web" );
   awsc.Set.Session( my_config, true );
   awsc.Set.Session_Lifetime( Duration( 48*60*60 ) ); -- 48 hours
   awsc.Set.Max_Connection( my_config,  60 );
   awsc.Set.Accept_Queue_Size( my_config, 120 ); -- default 60
   -- awsc.Set.Free_Slots_Keep_Alive_Limit( my_config, 160 ); -- default 80
   -- awsc.Set.Line_Stack_Size( my_config, AWS.Default.Line_Stack_Size*10 );
   Put_Line( "Call me on port" &
         Positive'Image( Global_Settings.Port ) & "; serving web root |" & 
         Global_Settings.Web_Root &
         "| press ctl-break to stop me ...");

   Connection_Pool.Initialise(
      Environment.Get_Server_Name,
      Environment.Get_Database_Name,
      Environment.Get_Username,
      Environment.Get_Password,
      90 -- postgres can't start with > 100 here on my machine
      );

   Dispatchers.URI.Register_Regexp( 
      my_dispatcher, 
      Global_Settings.Web_Root & "db", 
      Callbacks.Test2_Callback'Access );
      
   Dispatchers.URI.Register_Regexp( 
      my_dispatcher, 
      Global_Settings.Web_Root & "queries", 
      Callbacks.Test3_Callback'Access );
      
   Dispatchers.URI.Register_Regexp( 
      my_dispatcher, 
      Global_Settings.Web_Root & "fortunes", 
      Callbacks.Test4_Callback'Access );
      
   GNATColl.Traces.Parse_Config_File( "./etc/logging_config_file.txt" );
   AWS.Server.Log.Start( 
      Web_Server => Signal_Handler.aws_web_server,
      Filename_Prefix => "logs/request_log",
      Auto_Flush => False  );
   
   Log( "started the logger" );
   AWS.Server.Start( 
      Signal_Handler.aws_web_server,
      Dispatcher => my_dispatcher,
      Config     => my_config );
   Log( "started the server" );
   
   AWS.Server.Wait( AWS.Server.forever );
   Log( "server shutting down" );
end Tech_Server;
