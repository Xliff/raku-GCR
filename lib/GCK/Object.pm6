use v6.c;

use Method::Also;
use NativeCall;

use GCR::Raw::Types;
use GCK::Raw::Object;

use GLib::Roles::Implementor;
use GLib::Roles::Object;

our subset GckObjectAncestry is export of Mu
  where GckObject | GObject;

class GCK::Object {
  also does GLib::Roles::Object;

  has GckObject $!gck-o is implementor;

  submethod BUILD ( :$gck-object ) {
    self.setGckObject($gck-object) if $gck-object
  }

  method setGckObject (GckObjectAncestry $_) {
    my $to-parent;

    $!gck-o = do {
      when GckObject {
        $to-parent = cast(GObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GckObject, $_);
      }
    }
    self!setObject($to-parent);
  }

  method GCR::Raw::Definitions::GckObject
    is also<GckObject>
  { $!gck-o }

  multi method new (
    $gck-object where * ~~ GckObjectAncestry,

    :$ref = True
  ) {
    return unless $gck-object;

    my $o = self.bless( :$gck-object );
    $o.ref if $ref;
    $o;
  }

  method from_handle (GckSession() $session, Int() $object_handle)
    is also<from-handle>
  {
    my gulong $o = $object_handle;

    my $gck-object  = gck_object_from_handle($session, $o);

    $gck-object ?? self.bless( :$gck-object ) !! Nil;
  }

  # Type: string
  method handle is rw  is g-property {
    my $gv = GLib::Value.new( G_TYPE_LONG );
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

  # Type: GckSession
  method session ( :$raw = False ) is rw  is g-property {
    my $gv = GLib::Value.new( GCK::Session.get_type );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('session', $gv);
        propReturnObject(
          $gv.object,
          $raw,
          |GCK::Session.getTypePair
        );
      },
      STORE => -> $, GckSession() $val is copy {
        $gv.object = $val;
        self.prop_set('session', $gv);
      }
    );
  }

  method destroy (
    GCancellable()          $cancellable = GCancellable,
    CArray[Pointer[GError]] $error       = gerror
  ) {
    clear_error;
    my $r = so gck_object_destroy($!gck-o, $cancellable, $error);
    set_error($error);
    $r;
  }

  proto method destroy_async (|)
    is also<destroy-async>
  { * }

  multi method destroy_async (
    &callback,
    $user_data   = gpointer,
    $cancellable = GCancellable
  ) {
    samewith($cancellable, &callback, $user_data);
  }
  multi method destroy_async (
    GCancellable() $cancellable,
                   &callback,
    gpointer       $user_data     = gpointer
  ) {
    gck_object_destroy_async($!gck-o, $cancellable, &callback, $user_data);
  }

  method destroy_finish (
    GAsyncResult()          $result,
    CArray[Pointer[GError]] $error   = gerror
  )
    is also<destroy-finish>
  {
    clear_error;
    my $r = so gck_object_destroy_finish($!gck-o, $result, $error);
    set_error($error);
    $r;
  }

  method equal (GckObject() $object2) {
    so gck_object_equal($!gck-o, $object2);
  }

  method get (
    GCancellable()           $cancellable = GCancellable,
    CArray[Pointer[GError]]  $error       = gerror,
                            :$raw         = False
  ) {
    clear_error;
    my $r = gck_object_get($!gck-o, $cancellable, $error);
    set_error($error);
    propReturnObject($r, $raw, |GCK::Attributes.getTypePair);
  }

  proto method get_async (|)
    is also<get-async>
  { * }

  multi method get_async (
     $attr_types,
     $n_attr_types,
     &callback,
     $user_data      = gpointer,
    :$cancellable    = GCancellable
  ) {
    samewith(
      $attr_types,
      $n_attr_types,
      $cancellable,
      &callback,
      $user_data
    );
  }
  multi method get_async (
    Int()          $attr_types,
    Int()          $n_attr_types,
    GCancellable() $cancellable,
                   &callback,
    gpointer       $user_data     = gpointer
  ) {
    my guint  $n = $n_attr_types;
    my gulong $a = $attr_types;

    gck_object_get_async($!gck-o, $a, $n, $cancellable, &callback, $user_data);
  }

  proto method get_data (|)
    is also<get-data>
  { * }

  multi method get_data (
     $attr_type,
     $error        = gerror,
    :$cancellable  = GCancellable
  ) {
    samewith(
      $attr_type,
      $cancellable,
      $,
      $error
    );
  }
  multi method get_data (
    Int()                    $attr_type,
    GCancellable()           $cancellable,
                             $n_data       is rw,
    CArray[Pointer[GError]]  $error               = gerror,
                            :$raw                 = False
  ) {
    my gulong $a = $attr_type;
    my gsize  $n = 0;

    clear_error;
    my $r = gck_object_get_data($!gck-o, $attr_type, $cancellable, $n, $error);
    set_error($error);
    $n_data = $n;
    $raw ?? ($r, $n_data) !! SizedCArray.new($r, $n);
  }

  proto method get_data_async (|)
    is also<get-data-async>
  { * }

  multi method get_data_async (
     $attr_type,
     $allocator,
     &callback,
     $user_data    = gpointer,
    :$cancellable  = GCancellable
  ) {
    samewith(
      $attr_type,
      $allocator,
      $cancellable,
      &callback,
      $user_data
    );
  }
  multi method get_data_async (
    Int()          $attr_type,
    GckAllocator() $allocator,
    GCancellable() $cancellable,
                   &callback,
    gpointer       $user_data     = gpointer
  ) {
    my gulong $a = $attr_type;

    gck_object_get_data_async(
      $!gck-o,
      $a,
      $allocator,
      $cancellable,
      &callback,
      $user_data
    );
  }

  method get_data_finish (
    GAsyncResult()           $result,
                             $n_data  is rw,
    CArray[Pointer[GError]]  $error          = gerror,
                            :$raw            = False
  )
    is also<get-data-finish>
  {
    my gsize $n = 0;

    clear_error;
    my $r = gck_object_get_data_finish($!gck-o, $result, $n, $error);
    $n_data = $n;
    set_error($error);
    $raw ?? ($r, $n_data) !! SizedCArray.new($r, $n);
  }

  proto method get_data_full (|)
    is also<get-data-full>
  { * }

  multi method get_data_full (
     $attr_type,
     $allocator,
     $error       = gerror,
    :$cancellable = GCancellable
  ) {
    samewith(
      $attr_type,
      $allocator,
      $cancellable,
      $,
      $error
    );
  }
  multi method get_data_full (
    Int()                    $attr_type,
    GckAllocator()           $allocator,
    GCancellable()           $cancellable,
                             $n_data       is rw,
    CArray[Pointer[GError]]  $error               = gerror,
                            :$raw                 = False
  ) {
    my gulong $a = $attr_type;
    my gsize  $n = 0;

    clear_error;
    my $r = gck_object_get_data_full(
      $!gck-o,
      $a,
      $allocator,
      $cancellable,
      $n,
      $error
    );
    set_error($error);
    $n_data = $n;
    $raw ?? ($r, $n_data) !! SizedCArray.new($r, $n);
  }

  method get_finish (
    GAsyncResult()           $result,
    CArray[Pointer[GError]]  $error   = gerror,
                            :$raw     = False
  )
    is also<get-finish>
  {
    clear_error;
    my $r = gck_object_get_finish($!gck-o, $result, $error);
    set_error($error);
    propReturnObject($r, $raw, |GCK::Attributes.getTypePair);
  }

  proto method get_full (|)
    is also<get-full>
  { * }

  multi method get_full (
    Int()                   $attr_types,
    GCancellable()          $cancellable = GCancellable,
    CArray[Pointer[GError]] $error       = gerror
  ) {
    samewith($attr_types, $, $cancellable, $error);
  }
  multi method get_full (
    Int()                    $attr_type,
                             $n_attr_types is rw,
    GCancellable()           $cancellable         = GCancellable,
    CArray[Pointer[GError]]  $error               = gerror,
                            :$raw                 = False
  ) {
    my gulong $a = $attr_type;
    my guint  $n = 0;

    clear_error;
    my $r = gck_object_get_full($!gck-o, $a, $n, $cancellable, $error);
    set_error($error);
    propReturnObject($r, $raw, |GCK::Attributes.getTypePair);
  }

  method get_template_finish (
    GAsyncResult()           $result,
    CArray[Pointer[GError]]  $error   = gerror,
                            :$raw     = False
  )
    is also<get-template-finish>
  {
    clear_error;
    my $r = gck_object_get_template_finish($!gck-o, $result, $error);
    set_error($error);
    propReturnObject($r, $raw, |GCK::Attributes.getTypePair);
  }

  method hash {
    gck_object_hash($!gck-o);
  }

  method set (
    GckAttributes()         $attrs,
    GCancellable()          $cancellable = GCancellable,
    CArray[Pointer[GError]] $error       = gerror
  ) {
    clear_error;
    gck_object_set($!gck-o, $attrs, $cancellable, $error);
    set_error($error);
  }

  proto method set_async (|)
    is also<set-async>
  { * }

  multi method set_async (
    $attrs,
    $cancellable,
    &callback,
    $user_data     = gpointer
  ) {
    samewith(
      $attrs,
      $cancellable,
      &callback,
      $user_data
    );
  }
  multi method set_async (
    GckAttributes() $attrs,
    GCancellable()  $cancellable,
                    &callback,
    gpointer        $user_data     = gpointer
  ) {
    gck_object_set_async(
      $!gck-o,
      $attrs,
      $cancellable,
      &callback,
      $user_data
    );
  }

  method set_finish (
    GAsyncResult()          $result,
    CArray[Pointer[GError]] $error   = gerror
  )
    is also<set-finish>
  {
    clear_error;
    gck_object_set_finish($!gck-o, $result, $error);
    set_error($error);
  }

  method set_template (
    Int()                   $attr_type,
    GckAttributes()         $attrs,
    GCancellable()          $cancellable = GCancellable,
    CArray[Pointer[GError]] $error       = gerror
  )
    is also<set-template>
  {
    my gulong $a = $attr_type;

    clear_error;
    gck_object_set_template($!gck-o, $a, $attrs, $cancellable, $error);
    set_error($error);
  }

  proto method set_template_async (|)
    is also<set-template-async>
  { * }

  multi method set_template_async (
     $attr_type,
     $attrs,
     &callback,
     $user_data   = gpointer,
    :$cancellable = GCancellable
  ) {
    samewith(
      $attr_type,
      $attrs,
      $cancellable,
      &callback,
      $user_data
    );
  }
  multi method set_template_async (
    Int()           $attr_type,
    GckAttributes() $attrs,
    GCancellable()  $cancellable,
                    &callback,
    gpointer        $user_data    = gpointer
  ) {
    my gulong $a = $attr_type;

    gck_object_set_template_async(
      $!gck-o,
      $a,
      $attrs,
      $cancellable,
      &callback,
      $user_data
    );
  }

  method set_template_finish (
    GAsyncResult()          $result,
    CArray[Pointer[GError]] $error   = gerror
  )
    is also<set-template-finish>
  {
    clear_error;
    gck_object_set_template_finish($!gck-o, $result, $error);
    set_error($error)
  }
}
