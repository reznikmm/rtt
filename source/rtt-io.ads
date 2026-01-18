--  SPDX-FileCopyrightText: 2023-2026 Max Reznik <reznikmm@gmail.com>
--  SPDX-FileCopyrightText: 2025      Kevin Chadwick
--
--  SPDX-License-Identifier: BSD-3-Clause
---------------------------------------------------------------------

with Interfaces.C;

with RTT;

package RTT.IO
  with
    Abstract_State => State,
    Initializes => State
is

   procedure Put
     (Text   : String;
      Buffer : Up_Buffer_Index := 1);
   --  Put Text over RTT.

   procedure Put_Line
     (Text   : String;
      Buffer : Up_Buffer_Index := 1);
   --  Put Text and CR, LF over RTT.

   procedure Dump
     (Value  : Integer;
      Buffer : Up_Buffer_Index := 1);
   --  Dump Value in binary format. Could be used for plotting graphs with
   --  Cortex Debug.

end RTT.IO;
