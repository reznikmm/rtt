package body RTT is

   --------------
   -- Put_Line --
   --------------

   procedure Put_Line
     (Text  : String;
      Block : not null access Control_Block;
      Index : Positive)
   is
      subtype UInt8_Array is HAL.UInt8_Array (Text'Range);
      Data  : UInt8_Array with Import, Address => Text'Address;
   begin
      Write (Block.all, Index, Data);
      Write (Block.all, Index, (16#0D#, 16#0A#));
   end Put_Line;

   ----------------
   -- SEGGER_RTT --
   ----------------

   function SEGGER_RTT return String_16 is
      use type Interfaces.C.size_t;
      use type Interfaces.C.char_array;

      Reversed : constant String_16 :=
        (1 .. 6 => Interfaces.C.nul) & "TTR REGGES";
      --  Keep value reversed to avoid a match
   begin
      return Result : String_16 do
         for J in Reversed'Range loop
            Result (J) := Reversed (17 - J);
         end loop;
      end return;
   end SEGGER_RTT;

   -----------
   -- Write --
   -----------

   procedure Write
     (Block : in out Control_Block;
      Index : Positive;
      Data  : HAL.UInt8_Array)
   is
      use type Interfaces.C.unsigned;

      type Unbounded_UInt8_Array is
        array (0 .. Interfaces.C.unsigned'Last) of HAL.UInt8;

      Buffer : RTT.Buffer renames Block.Up (Index);

      Target : Unbounded_UInt8_Array
        with Import, Address => Buffer.Buffer;

      Left   : Interfaces.C.unsigned;
      From   : Natural := Data'First;
      Length : Natural;

      Write_Offset : Interfaces.C.unsigned := Buffer.Write_Offset;
   begin
      while From <= Data'Last loop
         Left := Buffer.Size - Buffer.Write_Offset;
         Length := Natural'Min (Data'Last - From + 1, Natural (Left));

         for J in 1 .. Length loop
            Target (Write_Offset) := Data (From);
            Write_Offset := Write_Offset + 1;
            From := From + 1;
         end loop;

         if Write_Offset >= Buffer.Size then
            Write_Offset := 0;
         end if;

         Buffer.Write_Offset := Write_Offset;
      end loop;
   end Write;

end RTT;
