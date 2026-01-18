--  SPDX-FileCopyrightText: 2023-2026 Max Reznik <reznikmm@gmail.com>
--  SPDX-FileCopyrightText: 2025      Kevin Chadwick
--
--  SPDX-License-Identifier: BSD-3-Clause
---------------------------------------------------------------------

with Interfaces.C;

with RTT;

package RTT_IO
  with
    Abstract_State => State,
    Initializes => State
is
   use type Interfaces.C.char_array;

   Terminal : constant Interfaces.C.char_array :=
     ("Terminal" & Interfaces.C.nul);

   Graph : constant Interfaces.C.char_array := ("Graph" & Interfaces.C.nul);

   Terminal_Output : RTT.Byte_Array (1 .. 256);
   Graph_Output : RTT.Byte_Array (1 .. 16);

   procedure Put
     (Text  : String;
      Index : Positive := 1);
   --  Put Text.

   procedure Put_Line
     (Text  : String;
      Index : Positive := 1);
   --  Put Text and CR, LF.

   procedure Put
     (Value : Integer;
      Index : Positive := 1);
   --  Dump Value in binary format. Could be used for plotting graphs with
   --  Cortex Debug.

end RTT_IO;
