--  SPDX-FileCopyrightText: 2023-2026 Max Reznik <reznikmm@gmail.com>
--  SPDX-FileCopyrightText: 2025      Kevin Chadwick
--
--  SPDX-License-Identifier: BSD-3-Clause
---------------------------------------------------------------------

pragma Ada_2022;

package body RTT.IO
  with Refined_State => (State => (Control_Block, Output, Input))
is

   use type Interfaces.C.char_array;

   subtype Positive_9 is Natural range 1 .. 9;

   function Image (Value : Positive_9) return Interfaces.C.char is
     (case Value is
      when 1 => '1', when 2 => '2', when 3 => '3',
      when 4 => '4', when 5 => '5', when 6 => '6',
      when 7 => '7', when 8 => '8', when 9 => '9')
        with Static;

   Out_Terminal : constant array (Up_Buffer_Index) of
     Interfaces.C.char_array (1 .. 9) :=
       [for J in Up_Buffer_Index =>
         (if J = 1 then "Terminal" & Interfaces.C.nul
          else "Output_" & Image (J) & Interfaces.C.nul)];

   In_Terminal : constant array (Up_Buffer_Index) of
     Interfaces.C.char_array (1 .. 8) :=
       [for J in Up_Buffer_Index => "Input_" & Image (J) & Interfaces.C.nul];

   Output : array (Up_Buffer_Index) of RTT.Byte_Array (1 .. 256);
   Input  : array (Down_Buffer_Index) of RTT.Byte_Array (1 .. 256);

   pragma Warnings (Off, "value not in range");
   --  GNAT 15.2 raises a warning when Down_Buffers = 0

   Control_Block : aliased RTT.Control_Block :=
     (Max_Up_Buffers   => RTT.Up_Buffers,
      Max_Down_Buffers => RTT.Down_Buffers,
      ID               => <>,
      Up               =>
        [for J in 1 .. RTT.Up_Buffers =>
          (Name    => Out_Terminal (J)'Address,
           Buffer  => Output (J)'Address,
           Size    => 256,
           others  => <>)],
      Down             =>
        [for J in 1 .. RTT.Down_Buffers =>
          (Name    => In_Terminal (J)'Address,
           Buffer  => Input (J)'Address,
           Size    => 256,
           others  => <>)])
        with Export, External_Name => "_SEGGER_RTT";

   pragma Warnings (On, "value not in range");

   ----------
   -- Dump --
   ----------

   procedure Dump
     (Value  : Integer;
      Buffer : Up_Buffer_Index := 1) is
   begin
      RTT.Dump
        (Value,
         Index => Buffer,
         Block => Control_Block'Access);
   end Dump;

   ---------
   -- Put --
   ---------

   procedure Put
     (Text   : String;
      Buffer : Up_Buffer_Index := 1) is
   begin
      RTT.Put
        (Text  => Text,
         Index => Buffer,
         Block => Control_Block'Access);
   end Put;

   --------------
   -- Put_Line --
   --------------

   procedure Put_Line
     (Text   : String;
      Buffer : Up_Buffer_Index := 1) is
   begin
      RTT.Put_Line
        (Text  => Text,
         Index => Buffer,
         Block => Control_Block'Access);
   end Put_Line;

end RTT.IO;
