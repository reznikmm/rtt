with Ada.Real_Time;

with STM32.Board;

with RTT_Instanse;

procedure Main is
   use type Ada.Real_Time.Time;

   Next : Ada.Real_Time.Time := Ada.Real_Time.Clock;
begin
   STM32.Board.Initialize_LEDs;

   loop
      STM32.Board.Toggle (STM32.Board.Green_LED);
      RTT_Instanse.Put_Line ("Hello, Ada!");
      Next := Next + Ada.Real_Time.Milliseconds (200);
      delay until Next;
   end loop;
end Main;
