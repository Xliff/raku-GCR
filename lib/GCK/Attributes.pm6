use v6.c;

use NativeCall;

use GCR::Raw::Types;
use GCK::Raw::Attributes;

use GCK::Attribute;

use GLib::Roles::Implementor;

class GCK::Attributes {
  also does GLib::Roles::Implementor;
  also does Positional;
  also does Iterable;

  has GckAttributes $!ga is implementor;

  submethod BUILD ( :$gck-attributes ) {
    $!ga = $gck-attributes if $gck-attributes
  }

  method GCR::Raw::Definitions::GckAttributes
  { $!ga }

  multi method new (GckAttributes $gck-attributes) {
    $gck-attributes ?? self.bless( :$gck-attributes ) !! Nil;
  }
  multi method new {
    my $gck-attributes = gck_attributes_new();

    $gck-attributes ?? self.bless( :$gck-attributes ) !! Nil;
  }

  # cw: va-list not supported.
  # method new_empty {
  #   my $gck-attributes = gck_attributes_new_empty();
  #
  #   $gck-attributes ?? self.bless( :$gck-attributes ) !! Nil;
  # }

  method at (Int() $index, :$raw = False) {
    my guint $i = $index;

    propReturnObject(
      gck_attributes_at($!ga, $i),
      $raw,
      |GCK::Attribute.getTypePair
    );
  }

  method contains (GckAttribute() $match) {
    gck_attributes_contains($!ga, $match);
  }

  method count {
    gck_attributes_count($!ga);
  }

  method dump {
    gck_attributes_dump($!ga);
  }

  method find (Int() $attr_type, :$raw = False) {
    my gulong $a = $attr_type;

    propReturnObject(
      gck_attributes_find($!ga, $a),
      $raw,
      |GCK::Attribute.getTypePair
    );
  }

  has $!ga-f;

  method fingerprint {
    unless $!ga-f {
      my $a = $!ga;

      $!ga-f = (
        class :: {

          proto method from_attributes (|)
          { * }

          multi method from_attributes (
             $checksum_type,
            :$raw            = False,
            :$blob           = True
          ) {
            samewith($checksum_type, $, :$raw, :$blob);
          }
          multi method from_attributes (
            Int()  $checksum_type,
                   $n_fingerprint  is rw,
                  :$raw                   = False,
                  :$blob                  = True
          ) {
            my GChecksumType $c = $checksum_type;
            my gsize         $n = 0;

            my $r = gcr_fingerprint_from_attributes($a, $c, $n);
            $n_fingerprint = $n;
            return ($r, $n) if $raw;

            $r = SizedCArray.new($r, $n)
            return $r unless $blob;

            Blob[uint8].new($r);
          }

          # cw: Might need to be moved to another object!
          method from_subject_public_key_info (
            CArray[uint8]  $key_info,
            Int()          $n_key_info,
            Int()          $checksum_type,
                           $n_fingerprint   is rw,
                          :$raw                    = False,
                          :$blob                   = True

          ) {
            my GChecksumType  $c        = $checksum_type;
            my gsize         ($nk, $nf) = ($n_key_info, 0);

            my $r = gcr_fingerprint_from_subject_public_key_info(
              $key_info,
              $nk,
              $c,
              $nf
            );
            $n_fingerprint = $nf;
            return ($r, $nf) if $raw;

            $r = SizedCArray.new($r, $nf)
            return $r unless $blob;

            Blob[uint8].new($r);
          }
        }
      ).new;

      $!ga-f;
    }
  }

  method find_boolean (
    gulong        $attr_type,
    gboolean      $value
  ) {
    gck_attributes_find_boolean($!ga, $attr_type, $value);
  }

  method find_date (
    gulong        $attr_type,
    GDate         $value
  ) {
    gck_attributes_find_date($!ga, $attr_type, $value);
  }

  method find_string (
    gulong        $attr_type,
    CArray[Str]   $value
  ) {
    gck_attributes_find_string($!ga, $attr_type, $value);
  }

  method find_ulong (
    gulong        $attr_type,
    gulong        $value
  ) {
    gck_attributes_find_ulong($!ga, $attr_type, $value);
  }

  method get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &gck_attributes_get_type, $n, $t );
  }

  method ref {
    gck_attributes_ref($!ga);
  }

  method Str {
    $.to_string;
  }
  method to_string {
    gck_attributes_to_string($!ga);
  }

  method unref {
    gck_attributes_unref($!ga);
  }

  # Positional
  method AT-POS (\k) {
    return Nil unless k ~~ 0 ..^ $.count;

    $.get(k);
  }

  # Iterable
  method iterator {
    generate-iterator(
      self,
      sub      { self.count  },
      sub (\i) { self.get(i) }
    )
  }
}
