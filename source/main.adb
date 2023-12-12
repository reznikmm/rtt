with Ada.Real_Time;

with STM32.Board;

with RTT_IO;

procedure Main is
   use type Ada.Real_Time.Time;

   Next : Ada.Real_Time.Time := Ada.Real_Time.Clock;

   type Counter is mod 8;
   Step : Counter := 0;

begin
   STM32.Board.Initialize_LEDs;

   loop
      STM32.Board.Toggle (STM32.Board.LCH_LED);
      RTT_IO.Put_Line ("Hello, Ada!");
      Step := Step + 1;
      RTT_IO.Put (Integer (Step), Index => 2);
      Next := Next + Ada.Real_Time.Milliseconds (200);
      delay until Next;
   end loop;
end Main;
