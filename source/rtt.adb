--  SPDX-FileCopyrightText: 2023-2026 Max Reznik <reznikmm@gmail.com>
--  SPDX-FileCopyrightText: 2025      Kevin Chadwick
--
--  SPDX-License-Identifier: BSD-3-Clause
---------------------------------------------------------------------

package body RTT is

   procedure Put
     (Value  : Integer;
      Block : not null access Control_Block;
      Index : Index_Up_Max := 1)
   is
      Copy : aliased Integer := Value;
      subtype UInt8_Array is Byte_Array (1 .. 4);
      Data  : UInt8_Array
        with Import, Address => Copy'Address;
   begin
      Write (Block.all, Index, Data);
   end Put;

   ---------
   -- Put --
   ---------

   procedure Put
     (Text  : String;
      Block : not null access Control_Block;
      Index : Index_Up_Max := 1)
   is
      subtype UInt8_Array is Byte_Array (Text'Range);
      Data  : UInt8_Array with Import, Address => Text'Address;
   begin
      Write (Block.all, Index, Data);
   end Put;

   --------------
   -- Put_Line --
   --------------

   procedure Put_Line
     (Text  : String;
      Block : not null access Control_Block;
      Index : Index_Up_Max := 1)
   is
      subtype UInt8_Array is Byte_Array (Text'Range);
      Data  : UInt8_Array with Import, Address => Text'Address;
   begin
      Write (Block.all, Index, Data);
      Write (Block.all, Index, (16#0D#, 16#0A#));
   end Put_Line;

   -----------
   -- Write --
   -----------

   procedure Write
     (Block : in out Control_Block;
      Index : Index_Up_Max;
      Data  : Byte_Array)
   is
      use type Interfaces.C.unsigned;

      type Unbounded_UInt8_Array is
        array (0 .. Interfaces.C.unsigned'Last) of Interfaces.Unsigned_8;

      Target : Unbounded_UInt8_Array
        with Import, Address => Block.Up (Index).Buffer;

      Left   : Interfaces.C.unsigned;
      From   : Natural := Data'First;
      Length : Natural;

      Write_Offset : Interfaces.C.unsigned := Block.Up (Index).Write_Offset;
   begin
      while From <= Data'Last loop
         Left := Block.Up (Index).Size - Block.Up (Index).Write_Offset;
         Length := Natural'Min (Data'Last - From + 1, Natural (Left));

         for J in 1 .. Length loop
            Target (Write_Offset) := Data (From);
            Write_Offset := Write_Offset + 1;
            From := From + 1;
         end loop;

         if Write_Offset >= Block.Up (Index).Size then
            Write_Offset := 0;
         end if;

         Block.Up (Index).Write_Offset := Write_Offset;
      end loop;
   end Write;

end RTT;
