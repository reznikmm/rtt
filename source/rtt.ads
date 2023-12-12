--  This package provides Real Time Transfer implementation on a target side.
--
--  Real Time Transfer (RTT) is an interface specified by SEGGER based on basic
--  memory reads and writes to transfer data bidirectionally between target and
--  host. The specification is independent of the target architecture. Every
--  target that supports so called "background memory access", which means that
--  the target memory can be accessed by the debugger while the target is
--  running, can be used.

with System;
with Interfaces.C;

with HAL;

package RTT is
   pragma Preelaborate;

   type Operating_Mode is (No_Block_Skip, No_Block_Trim, Block_If_FIFO_Full);

   for Operating_Mode use
     (No_Block_Skip      => 0,
      No_Block_Trim      => 1,
      Block_If_FIFO_Full => 2);

   type Buffer_Flags is record
      Reserved : Natural range 0 .. 0 := 0;
      Mode     : Operating_Mode := No_Block_Skip;
   end record with Size => 32;

   for Buffer_Flags use record
      Reserved at 0 range 2 .. 31;
      Mode     at 0 range 0 .. 1;
   end record;

   type Buffer is limited record
      Name   : System.Address := System.Null_Address;
      --  Buffer's name such as "Terminal" or "SysView".
      Buffer : System.Address := System.Null_Address;
      --  Buffer pointer.
      Size   : Interfaces.C.unsigned := 0;
      --  Size of the buffer in bytes.
      Write_Offset : Interfaces.C.unsigned := 0 with Atomic;
      --  Next byte to be written
      Read_Offset : Interfaces.C.unsigned := 0 with Atomic;
      --  Next byte to be read
      Flags  : Buffer_Flags;
   end record;
   --  Ring buffer for target<-->host transfers

   type Buffer_Array is array (Positive range <>) of Buffer;

   use type Interfaces.C.char_array;

   type Control_Block
     (Max_Up_Buffers   : Natural;
      Max_Down_Buffers : Natural) is
   limited record
      ID   : Interfaces.C.char_array (1 .. 16) :=
        "SEGGER RTT" & (1 .. 6 => Interfaces.C.nul);
      --  Predefined control block identifier value
      Up   : Buffer_Array (1 .. Max_Up_Buffers);
      Down : Buffer_Array (1 .. Max_Down_Buffers);
   end record;
   --  Control block for RTT with number of buffers and their configuration

   for Control_Block use record
      ID               at 0 range 0 .. 128 - 1;
      Max_Up_Buffers   at 16 range 0 .. 32 - 1;
      Max_Down_Buffers at 20 range 0 .. 32 - 1;
   end record;

   procedure Write
     (Block : in out Control_Block;
      Index : Positive;
      Data  : HAL.UInt8_Array)
        with Pre => Index <= Block.Max_Up_Buffers;
   --  Write Data into Up buffer with given Index of the control block.

   procedure Put
     (Text  : String;
      Block : not null access Control_Block;
      Index : Positive := 1);
   --  Put Text into Up buffer with given Index of the control block.

   procedure Put_Line
     (Text  : String;
      Block : not null access Control_Block;
      Index : Positive := 1);
   --  Put Text and CR, LF into Up buffer with given Index of the control
   --  block.

   procedure Put
     (Value  : Integer;
      Block : not null access Control_Block;
      Index : Positive := 1);
   --  Dump Value in binary format. Could be used for plotting graphs with
   --  Cortex Debug.

end RTT;
