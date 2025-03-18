use v6.c;

use Method::Also;
use NativeCall;

use GCR::Raw::Types;
use GCK::Raw::Enumerator;

use GLib::GList;

use GLib::Roles::Implementor;
use GLib::Roles::Object;

our subset GckEnumeratorAncestry is export of Mu
  where GckEnumerator | GObject;

class GCK::Enumerator {
  also does GLib::Roles::Object;
  also does Iterable;

  has GckEnumerator $!ge is implementor;

  submethod BUILD ( :$gck-enumerator ) {
    self.setGckEnumerator($gck-enumerator) if $gck-enumerator
  }

  method setGckEnumerator (GckEnumeratorAncestry $_) {
    my $to-parent;

    $!ge = do {
      when GckEnumerator {
        $to-parent = cast(GObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GckEnumerator, $_);
      }
    }
    self!setObject($to-parent);
  }

  method GCR::Raw::Definitions::GckEnumerator
    is also<GckEnumerator>
  { $!ge }

  multi method new (
     $gck-enumerator where * ~~ GckEnumeratorAncestry ,

    :$ref = True
  ) {
    return unless $gck-enumerator;

    my $o = self.bless( :$gck-enumerator );
    $o.ref if $ref;
    $o;
  }

  method get_chained ( :$raw = False ) is also<get-chained> {
    propReturnObject(
      gck_enumerator_get_chained($!ge),
      $raw,
      |self.getTypePair
    );
  }

  method get_interaction ( :$raw = False ) is also<get-interaction> {
    propReturnObject(
      gck_enumerator_get_interaction($!ge),
      $raw,
      |GIO::TlsInteraction.getTypePair
    );
  }

  method get_object_type is also<get-object-type> {
    gck_enumerator_get_object_type($!ge);
  }

  method next (
    GCancellable()           $cancellable  = GCancellable,
    CArray[Pointer[GError]]  $error        = gerror,
                            :$raw          = False
  ) {
    propReturnObject(
      gck_enumerator_next($!ge, $cancellable, $error),
      $raw,
      |GCK::Object.getTypePair
    );
  }

  proto method next_async (|)
    is also<next-async>
  { * }

  multi method next_async (
      &callback,
      $user_data                                          = gpointer,
     :n(:num(:number(:max(:max-objects(:$max_objects))))) = 1,
     :$cancellable                                        = GCancellable,
     :$raw                                                = False
  ) {
    samewith($max_objects, $cancellable, &callback, $user_data, :$raw);
  }
  multi method next_async (
    Int()           $max_objects,
    GCancellable()  $cancellable,
                    &callback,
    gpointer        $user_data     = gpointer,
                   :$raw           = False
  ) {
    my gint $m = $max_objects;

    propReturnObject(
      gck_enumerator_next_async($!ge, $m, $cancellable, &callback, $user_data),
      $raw,
      |GCK::Object.getTypePair
    );
  }

  method next_finish (
    GAsyncResult()           $result,
    CArray[Pointer[GError]]  $error          = gerror,
                            :$raw            = False,
                            :gslist(:$glist) = False
  )
    is also<next-finish>
  {
    clear_error;
    my $r = gck_enumerator_next_finish($!ge, $result, $error);
    set_error($error);
    returnGList($r, $raw, $glist, |GCK::Object.getTypePair);
  }

  method next_n (
    Int()                    $max_objects,
    GCancellable()           $cancellable    = GCancellable,
    CArray[Pointer[GError]]  $error          = gerror,
                            :$raw            = False,
                            :gslist(:$glist) = False
  )
    is also<next-n>
  {
    my gint $m = $max_objects;

    clear_error;
    my $r = gck_enumerator_next_n($!ge, $m, $cancellable, $error);
    set_error($error);
    returnGList($r, $raw, $glist, |GCK::Object.getTypePair);
  }

  method set_chained (GckEnumerator() $chained) is also<set-chained> {
    gck_enumerator_set_chained($!ge, $chained);
  }

  method set_interaction (GTlsInteraction() $interaction)
    is also<set-interaction>
  {
    gck_enumerator_set_interaction($!ge, $interaction);
  }

  method set_object_type (Int() $object_type) is also<set-object-type> {
    my GType $o = $object_type;

    gck_enumerator_set_object_type($!ge, $o);
  }

  proto method set_object_type_full (|)
    is also<set-object-type-full>
  { * }

  multi method set_object_type_full (Int() $object_type, @types) {
    samewith(
      $object_type,
      ArrayToCArray(@types, typed => gulong),
      @types.elems
    );
  }
  multi method set_object_type_full (
    Int()          $object_type,
    CArray[gulong] $attr_types,
    Int()          $attr_count
  ) {
    my GType  $o = $object_type;
    my gint   $c = $attr_count;

    gck_enumerator_set_object_type_full($!ge, $o, $attr_types, $c);
  }

  # Iterable
  method iterator {
    my $s = self;

    (
      class :: does Iterator {
        method pull-one {
          my $v = $s.next;
          $v ?? $v !! IterationEnd;
        }
      }
    ).new;
  }

}
