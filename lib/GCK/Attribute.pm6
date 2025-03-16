use v6.c;

use Method::Also;

use GCR::Raw::Types;
use GCK::Raw::Attribute;

use GLib::Date;

use GLib::Roles::Implementor;

class GCK::Attribute {
  also does GLib::Roles::Implementor;

  has GckAttribute $!ga is implementor;

  submethod BUILD ( :$gck-attribute ) {
    $!ga = $gck-attribute if $gck-attribute;
  }

  method GCK::Raw::Structs::GckAttribute
    is also<GckAttribute>
  { $!ga }

  multi method new (GckAttribute $gck-attribute) {
    $gck-attribute ?? self.bless( :$gck-attribute ) !! Nil;
  }
  multi method new (
    GckAttribute() $attr,
    Int()          $attr_type,
    Str()          $value,
    Int()          $length
  )
    is also<init>
  {
    my gulong $a = $attr_type;
    my gsize  $l = $length;

    my $gck-attribute = gck_attribute_init($attr, $a, $value, $l);

    $gck-attribute ?? self.bless( :$gck-attribute ) !! Nil;
  }

  method clear {
    gck_attribute_clear($!ga);
  }

  method dump {
    gck_attribute_dump($!ga);
  }

  method dup ( :$raw = False ) {
    propReturnObject(
      gck_attribute_dup($!ga),
      $raw,
      |self.getTypePair
    )
  }

  method equal (GckAttribute() $attr2) {
    so gck_attribute_equal($!ga, $attr2);
  }

  method free {
    gck_attribute_free($!ga);
  }

  method get_boolean is also<get-boolean> {
    so gck_attribute_get_boolean($!ga);
  }

  proto method get_data (|)
    is also<get-data>
  { * }

  multi method get_data ( :$raw = False, :$buf = True ) {
    samewith($, :$raw, :$buf);
  }
  multi method get_data ($length is rw, :$raw = False, :$buf = True) {
    my gsize $l = 0;

    my $r = gck_attribute_get_data($!ga, $l);
    $length = $l;
    return $r if $raw;

    $r = SizedCArray.new($r, $l);
    return $r unless $buf;

    Buf[uint8].new($r);
  }

  proto method get_date (|)
    is also<get-date>
  { * }

  multi method get_date {
    my $d = GLib::Date.new;
    samewith($d);
    $d;
  }
  multi method get_date (GDate() $value, :$raw = False) {
    propReturnObject(
      gck_attribute_get_date($!ga, $value),
      $raw,
      |GLib::Date.getTypePair
    );
  }

  method get_string is also<get-string> {
    gck_attribute_get_string($!ga);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gck_attribute_get_type, $n, $t );
  }

  method get_ulong is also<get-ulong> {
    gck_attribute_get_ulong($!ga);
  }

  method hash {
    gck_attribute_hash($!ga);
  }

  method is_invalid is also<is-invalid> {
    so gck_attribute_is_invalid($!ga);
  }

}

use GLib::Roles::StaticClass;

class GCK::Attrbute::Init {
  also does GLib::Roles::StaticClass;

  method boolean (
    GckAttribute() $attr,
    Int()          $attr_type,
    Int()          $value
  ) {
    my gulong   $a = $attr_type;
    my gboolean $v = $value;

    gck_attribute_init_boolean($attr, $a, $v);
  }

  method copy (
    GckAttribute() $dest,
    GckAttribute() $src
  ) {
    gck_attribute_init_copy($dest, $src);
  }

  method date (
    GckAttribute() $attr,
    Int()          $attr_type,
    GDate()        $value
  ) {
    my gulong $a = $attr_type;

    gck_attribute_init_date($attr, $a, $value);
  }

  method empty (
    GckAttribute() $attr,
    Int()          $attr_type
  ) {
    my gulong $a = $attr_type;

    gck_attribute_init_empty($attr, $a);
  }

  method invalid (
    GckAttribute() $attr,
    Int()          $attr_type
  ) {
    my gulong $a = $attr_type;

    gck_attribute_init_invalid($attr, $a);
  }

  method string (
    GckAttribute() $attr,
    Int()          $attr_type,
    Str()          $value
  ) {
    my gulong $a = $attr_type;

    gck_attribute_init_string($attr, $a, $value);
  }

  method ulong (
    GckAttribute() $attr,
    Int()          $attr_type,
    Int()          $value
  ) {
    my gulong ($a, $v) = ($attr_type, $value);

    gck_attribute_init_ulong($attr, $a, $v);
  }

}
