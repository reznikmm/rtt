--  SPDX-FileCopyrightText: 2023-2026 Max Reznik <reznikmm@gmail.com>
--  SPDX-FileCopyrightText: 2025      Kevin Chadwick
--
--  SPDX-License-Identifier: BSD-3-Clause
---------------------------------------------------------------------

package body RTT_IO
  with Refined_State => (State => Control_Block)
is

   Control_Block : aliased RTT.Control_Block :=
     (Max_Up_Buffers   => RTT.Up_Buffers,
      Max_Down_Buffers => RTT.Down_Buffers,
      Up               =>
        (1 => (Name    => Terminal'Address,
               Buffer  => Terminal_Output'Address,
               Size    => Terminal_Output'Length,
               others  => <>)),
      others           => <>)
    with Export, External_Name => "_SEGGER_RTT";

   procedure Put
     (Text  : String;
      Index : Positive := 1) is
   begin
      RTT.Put
        (Text  => Text,
         Index => Index,
         Block => Control_Block'Access);
   end Put;

   procedure Put_Line
     (Text  : String;
      Index : Positive := 1) is
   begin
      RTT.Put_Line
        (Text  => Text,
         Index => Index,
         Block => Control_Block'Access);
   end Put_Line;

   procedure Put
     (Value : Integer;
      Index : Positive := 1) is
   begin
      RTT.Put
        (Value,
         Index => Index,
         Block => Control_Block'Access);
   end Put;

end RTT_IO;
