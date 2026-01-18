--  SPDX-FileCopyrightText: 2023-2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: BSD-3-Clause
---------------------------------------------------------------------

with Ada.Real_Time;

with RTT.IO;

procedure Main is
   use type Ada.Real_Time.Time;

   Next : Ada.Real_Time.Time := Ada.Real_Time.Clock;

   type Counter is mod 8;
   Step : Counter := 0;

begin
   loop
      RTT.IO.Put_Line ("Hello, Ada!" & Step'Image);
      Step := Step + 1;
      RTT.IO.Dump (Integer (Step), Buffer => 2);
      Next := Next + Ada.Real_Time.Milliseconds (200);
      delay until Next;
   end loop;
end Main;
