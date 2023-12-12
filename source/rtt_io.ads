with Interfaces.C;

with HAL;

with RTT;

package RTT_IO is
   use type Interfaces.C.char_array;

   Terminal : constant Interfaces.C.char_array :=
     ("Terminal" & Interfaces.C.nul);

   Terminal_Output : HAL.UInt8_Array (1 .. 256);

   Control_Block : aliased RTT.Control_Block :=
     (Max_Up_Buffers   => 1,
      Max_Down_Buffers => 0,
      Up               =>
        (1 => (Name    => Terminal'Address,
               Buffer  => Terminal_Output'Address,
               Size    => Terminal_Output'Length,
               others  => <>)),
      others           => <>)
    with Export, External_Name => "_SEGGER_RTT";

   procedure Put
     (Text  : String;
      CB    : access RTT.Control_Block := Control_Block'Access;
      Index : Positive := 1) renames RTT.Put;
   --  Put Text.

   procedure Put_Line
     (Text  : String;
      CB    : access RTT.Control_Block := Control_Block'Access;
      Index : Positive := 1) renames RTT.Put_Line;
   --  Put Text and CR, LF.

   procedure Put
     (Value : Integer;
      CB    : access RTT.Control_Block := Control_Block'Access;
      Index : Positive := 1) renames RTT.Put;
   --  Dump Value in binary format. Could be used for plotting graphs with
   --  Cortex Debug.

end RTT_IO;
