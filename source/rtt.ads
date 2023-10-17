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

   subtype String_16 is Interfaces.C.char_array (1 .. 16);

   function SEGGER_RTT return String_16;
   --  Predefined control block identifier value

   type Control_Block_Id is array (1 .. 16) of Interfaces.C.char
     with Pack, Atomic_Components;

   type Control_Block
     (Max_Up_Buffers   : Natural;
      Max_Down_Buffers : Natural) is
   limited record
      ID   : Control_Block_Id := Control_Block_Id (SEGGER_RTT);
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

   procedure Put_Line
     (Text  : String;
      Block : not null access Control_Block;
      Index : Positive);

end RTT;
