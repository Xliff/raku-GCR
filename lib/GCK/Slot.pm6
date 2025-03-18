use v6.c;

use GCR::Raw::Types;
use GCK::Raw::Slot;

use NativeCall;

#use GCK::Module;
use GCK::Session;

use GLib::Roles::Implementor;
use GLib::Roles::Object;

our subset GckSlotAncestry is export of Mu
  where GckSlot | GObject;

class GCK::Slot {
  also does GLib::Roles::Object;

  has GckSlot $!gs is implementor;

  submethod BUILD ( :$gck-slot ) {
    self.setGckSlot($gck-slot) if $gck-slot
  }

  method setGckSlot (GckSlotAncestry $_) {
    my $to-parent;

    $!gs = do {
      when GckSlot {
        $to-parent = cast(GObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GckSlot, $_);
      }
    }
    self!setObject($to-parent);
  }

  method GCR::Raw::Definitions::GckSlot
    is also<GckSlot>
  { $!gs }

  multi method new ($gck-slot where * ~~ GckSlotAncestry , :$ref = True) {
    return unless $gck-slot;

    my $o = self.bless( :$gck-slot );
    $o.ref if $ref;
    $o;
  }
  multi method new ($module, $slot_id) {
    self.from_handle($module, $slot_id);
  }
  method from_handle (
    GckModule() $module,
    Int()       $slot_id
  ) {
    my gulong $s = $slot_id;

    my $gck-slot = gck_slot_from_handle($module, $slot_id);

    $gck-slot ?? self.bless( :$gck-slot ) !! Nil;
  }

  # Type: uint64
  method handle is rw  is g-property {
    my $gv = GLib::Value.new( G_TYPE_ULONG );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('handle', $gv);
        $gv.uint64;
      },
      STORE => -> $, Str() $val is copy {
        $gv.uint64 = $val;
        self.prop_set('handle', $gv);
      }
    );
  }

  method module ( :$raw = False ) is rw  is g-property {
    my $gv = GLib::Value.new( GCK::Module.get_type );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('module', $gv);
        propReturnObject(
          $gv.object,
          $raw,
          |GCK::Module.getTypePair
        );
      },
      STORE => -> $, GckModule() $val is copy {
        $gv.object = $val;
        self.prop_set('module', $gv);
      }
    );
  }

  method enumerate_objects (
    GckAttributes()  $match,
    Int()            $options,
                    :$raw      = False
  ) {
    my GckSessionOptions $o = $options;

    propReturnObject(
      gck_slot_enumerate_objects($!gs, $match, $o),
      $raw,
      |GCK::Enumerator.getTypePair
    );
  }

  method equal (GckSlot() $slot2) {
    so gck_slot_equal($!gs, $slot2);
  }

  method get_handle {
    gck_slot_get_handle($!gs);
  }

  method get_info {
    gck_slot_get_info($!gs);
  }

  method get_mechanism_info (Int() $mech_type) {
    my gulong $m = $mech_type;

    gck_slot_get_mechanism_info($!gs, $m);
  }

  method get_mechanisms ( :$raw = False ) {
    my $r = propReturnObject(
      gck_slot_get_mechanisms($!gs),
      $raw,
      |GLib::Array::Integer.getTypePair
    );

    ( .double, .signed ) = (True, False) given $r;

    $r
  }

  method get_module ( :$raw = False ) {
    propReturnObject(
      gck_slot_get_module($!gs),
      $raw,
      |GCK::Module.getTypePair
    );
  }

  method get_token_info {
    gck_slot_get_token_info($!gs);
  }

  method has_flags (Int() $flags) {
    my gulong $f = $flags;

    so gck_slot_has_flags($!gs, $f);
  }

  method hash {
    gck_slot_hash($!gs);
  }

  method match (GckUriData() $uri) {
    gck_slot_match($!gs, $uri);
  }

  proto method open_session (|)
  { * }

  multi method open_session (
     $options             = 0,
     $error               = gerror,
    :$interaction         = GTlsInteraction,
    :$cancellable         = GCancellable,
    :$raw                 = False,
    :$rw,
    :$user,
    :auth($authenticate)
  ) {
    samewith(
      processSessionOptions($options, :$rw, :$user, :$authenticate),
      $interaction,
      $cancellable,
      $error
    );
  }
  multi method open_session (
    Int()                    $options,
    GTlsInteraction()        $interaction,
    GCancellable()           $cancellable  = GCancellable,
    CArray[Pointer[GError]]  $error        = gerror,
                            :$raw          = False
  ) {
    my GckSessionOptions $o = $options;

    clear_error;
    my $r = gck_slot_open_session(
      $!gs,
      $o,
      $interaction,
      $cancellable,
      $error
    );
    set_error($error);
    propReturnObject($r, $raw, |GCK::Session.getTypePair);
  }

  proto method open_session_async (|)
  { * }

  multi method open_session_async (
                       &callback,
    Int()             :$options            = 0,
    GTlsInteraction() :$interaction        = GTlsInteraction,
    GCancellable()    :$cancellable        = GCancellable,
    gpointer          :$user_data          = gpointer,
                      :$raw                = False,
                      :$rw,
                      :$user,
                      :auth($authenticate)
  ) {
    samewith(
      processSessionOptions($options, :$rw, :$user, :$authenticate),
      $interaction,
      $cancellable,
      &callback,
      $user_data
    );
  }
  multi method open_session_async (
    Int()             $options,
    GTlsInteraction() $interaction,
    GCancellable()    $cancellable,
                      &callback,
    gpointer          $user_data     = gpointer
  ) {
    my GckSessionOptions $o = $options;

    gck_slot_open_session_async(
      $!gs,
      $options,
      $interaction,
      $cancellable,
      &callback,
      $user_data
    );
  }

  method open_session_finish (
    GAsyncResult()           $result,
    CArray[Pointer[GError]]  $error   = gerror,
                            :$raw     = False
  ) {
    clear_error;
    my $r = gck_slot_open_session_finish($!gs, $result, $error);
    set_error($error);
    propReturnObject($r, $raw, |GCK::Session.getTypePair);
  }

  proto method open_session_full (|)
  { * }

  multi method open_session_full (
     &notify,
     $error               = gerror,
    :$options             = 0,
    :$interaction         = GTlsInteraction,
    :$app_data            = gpointer,
    :$pkcs11_flags        = 0,
    :$cancellable         = GCancellable,
    :$raw                 = False,
    :$rw,
    :$user,
    :auth($authenticate)
  ) {
    samewith(
       processSessionOptions($options, :$rw, :$user, :$authenticate),
       $interaction,
       $pkcs11_flags,
       $app_data,
       &notify,
       $cancellable,
       $error,
      :$raw
    );
  }
  multi method open_session_full (
    Int()                    $options,
    GTlsInteraction()        $interaction,
    Int()                    $pkcs11_flags,
    gpointer                 $app_data,
                             &notify,
    GCancellable()           $cancellable,
    CArray[Pointer[GError]]  $error        = gerror,
                            :$raw          = False
  ) {
    my GckSessionOptions $o = $options;
    my gulong            $p = $pkcs11_flags;

    clear_error;
    my $r = gck_slot_open_session_full(
      $!gs,
      $o,
      $interaction,
      $p,
      $app_data,
      &notify,
      $cancellable,
      $error
    );
    set_error($error);
    propReturnObject($r, $raw, |GCK::Session.getTypePair)
  }

  proto method open_session_full_async (|)
  { * }

  multi method open_session_full_async (
     &callback,
     $user_data                           = gpointer,
    :&notify                              = SUB( { } ),
    :$options                             = 0,
    :$interaction                         = GTlsInteraction,
    :flags(:pkcs11-flags(:$pkcs11_flags)) = 0,
    :data(:app-data($app_data))           = gpointer,
    :$cancellable                         = GCancellable,
    :$rw,
    :$user,
    :auth(:$authenticate)
  ) {
    samewith(
      processSessionOptions($options, :$rw, :$user, :$authenticate),
      $interaction,
      $pkcs11_flags,
      $app_data,
      &notify,
      $cancellable,
      &callback,
      $user_data
    );
  }
  multi method open_session_full_async (
    Int()             $options,
    GTlsInteraction() $interaction,
    Int()             $pkcs11_flags,
    gpointer          $app_data,
                      &notify,
    GCancellable()    $cancellable,
                      &callback,
    gpointer          $user_data       = gpointer
  ) {
    my GckSessionOptions $o = $options;
    my gulong            $p = $pkcs11_flags;

    gck_slot_open_session_full_async(
      $!gs,
      $o,
      $interaction,
      $p,
      $app_data,
      &notify,
      $cancellable,
      &callback,
      $user_data
    );
  }

}

class GCK::Slots {

  method enumerate_objects (
    GList()          $slots,
    GckAttributes()  $match,
    Int()            $options = 0,
                    :$raw     = False,
                    :$rw,
                    :$user,
                    :auth($authenticate)
  ) {
    my GckSessionOptions $o = $options;

    propReturnObject(
      gck_slots_enumerate_objects(
        $slots,
        $match,
        processSessionOptions($o, :$rw, :$user, :$authenticate),
      ),
      $raw,
      |GCK::Enumerator.getTypePair
    );
  }

}

# method info_copy {
#   gck_slot_info_copy($!gs);
# }
#
# method info_free {
#   gck_slot_info_free($!gs);
# }
#
# method info_get_type {
#   gck_slot_info_get_type();
# }
