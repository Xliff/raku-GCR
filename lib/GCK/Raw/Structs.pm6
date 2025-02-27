use v6.c;

use NativeCall;

use GLib::Raw::Definitions;

use GLib::Roles::Pointers;

unit package GCK::Raw::Structs;

class GckAttribute is repr<CStruct> does GLib::Roles::Pointers is export {
  has gulong $.type    is rw;
  has Str    $!value;
  has gulong $.length  is rw;

  method value is rw {
    Proxy.new:
      FETCH => -> $     { $!value      },
      STORE => -> $, \v { $!value := v }
  }
}
