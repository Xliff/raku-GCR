use v6.c;

use NativeCall;

use GLib::Raw::ReturnedValue;

use GCR::Raw::Types;

role GCK::Roles::Signals::Module {
  has %!signals-gm;

  # GckModule* self, GckObject, Str, CArray[Str] $out-pw, gpointer
  multi method connect-authenticate-object (
     $obj is copy,
     $signal,
     &handler?,
    :$raw          = False
  ) {
    my $hid;
    %!signals-gm{$signal} //= do {
      my $s = Supplier.new;
      my $r = ReturnedValue.new;

      $hid = g-connect-authenticate-object(
        $obj,
        $signal,
        -> $, $o is copy, $l, $p, $ud, $r --> gboolean {

          $o = GCK::Object.new($o) unless $raw;

          $s.emit( [self, $o, $l, $p, $ud, $r] );
          CATCH { default { note($_) } }

          my gboolean $rv = $r.r.Int;
          $rv;
        },
        Pointer,
        0
      );
      [ self.create-signal-supply($signal, $s), $obj, $hid ];
    };
    %!signals-gm{$signal}[0].tap(&handler) with &handler;
    %!signals-gm{$signal}[0];
  }

  multi method connect-authenticate-slot (
     $obj is copy,
     $signal,
     &handler?,
    :$raw          = False
  ) {
    my $hid;
    %!signals-gm{$signal} //= do {
      my $s = Supplier.new;
      my $r = ReturnedValue.new;

      $hid = g-connect-authenticate-slot(
        $obj,
        $signal,
        -> $, $s is copy, $l, $p, $ud, $r --> gboolean {

          $s = GCK::Slot.new($s) unless $raw;

          $s.emit( [self, $s, $l, $p, $ud, $r] );
          CATCH { default { note($_) } }

          my gboolean $rv = $r.r.Int;
          $rv;
        },
        Pointer,
        0
      );
      [ self.create-signal-supply($signal, $s), $obj, $hid ];
    };
    %!signals-gm{$signal}[0].tap(&handler) with &handler;
    %!signals-gm{$signal}[0];
  }

}

sub g-connect-authenticate-object (
  Pointer $app,
  Str     $name,
          &handler (
            GckModule,
            GckObject,
            Str,
            CArray[Str],
            gpointer --> gboolean
          ),
  Pointer $data,
  uint32  $flags
)
  returns uint64
  is      native(gobject)
  is      symbol('g_signal_connect_object')
{ * }

sub g-connect-authenticate-slot (
  Pointer $app,
  Str     $name,
          &handler (
            GckModule,
            GckSlot,
            Str,
            CArray[Str],
            gpointer --> gboolean
          ),
  Pointer $data,
  uint32  $flags
)
  returns uint64
  is      native(gobject)
  is      symbol('g_signal_connect_object')
{ * }
