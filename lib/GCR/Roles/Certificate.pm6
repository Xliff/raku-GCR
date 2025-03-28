use v6.c;

use GCR::Raw::Types;
use GCR::Raw::Certificate;
use GCR::Raw::Trust;

use GLib::DateTime;
use GCR::Certificate::Section;

use GLib::Roles::Implementor;
use GLib::Roles::Object;

role GCR::Roles::Certificate {
  has GcrCertificate $!gc is implementor;

  method roleInit-GcrCertificate {
    return if $!gc;

    my \i = findProperImplementor(self.^attributes);
    $!gc = cast( GcrCertificate, i.get_value(self) );
  }

  method GCR::Raw::Definitions::GcrCertificate { $!gc }
  method GcrCertificate                        { $!gc }

  # Type: string
  method description is rw  is g-property {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('description', $gv);
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        warn 'd
        escription does not allow writing'
      }
    );
  }

  # Type: GDateTime
  method expiry-date ( :$raw = False ) is rw  is g-property {
    my $gv = GLib::Value.new( GLib::DateTime.get_type );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('expiry-date', $gv);
        propReturnObject(
          $gv.pointer,
          $raw,
          |GLib::DateTime.getTypePair
        );
      },
      STORE => -> $,  $val is copy {
        warn 'expiry-date does not allow writing'
      }
    );
  }

  # Type: string
  method issuer-name is rw  is g-property {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('issuer-name', $gv);
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        warn 'issuer-name does not allow writing'
      }
    );
  }

  # Type: string
  method label is rw  is g-property {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('label', $gv);
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        warn 'label does not allow writing'
      }
    );
  }

  # Type: string
  method subject-name is rw  is g-property {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('subject-name', $gv);
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        warn 'subject-name does not allow writing'
      }
    );
  }

  proto method get_basic_constraints (|)
  { * }

  multi method get_basic_constraints {
    samewith($, $);
  }
  multi method get_basic_constraints (
    $is_ca    is rw,
    $path_len is rw
  ) {
    my gboolean $i = 0;
    my gint     $p = 0;

    my $r = gcr_certificate_get_basic_constraints($!gc, $i, $p);
    return (Nil, Nil) unless $r;
    ($is_ca, $path_len) = ($i, $p);
  }

  method get_der_data ($n_data is rw) {
    my gsize $n = $n_data;

    my $r = gcr_certificate_get_der_data($!gc, $n_data);
    $n_data = $n;
    $r;
  }

  method get_expiry_date ( :$raw = False, :$raku = True ) {
    my $d = propReturnObject(
      gcr_certificate_get_expiry_date($!gc),
      $raw,
      |GLib::DateTime.getTypePair
    );
    return $d unless $raku;
    $d.DateTime;
  }

  proto method get_fingerprint (|)
  { * }

  multi method get_fingerprint (Int() $type, :$sized = True) {
    samewith($type, $, :$sized);
  }
  multi method get_fingerprint (Int() $type, $n_length is rw, :$sized = True) {
    my GChecksumType $t = $type;
    my gsize         $n = 0;

    my $r = gcr_certificate_get_fingerprint($!gc, $type, $n);
    $n_length = $n;
    return ($r, $n_length) unless $sized;
    SizedCArray.new($r, $n_length);
  }

  method get_fingerprint_hex (Int() $type) {
    my GChecksumType $t = $type;

    gcr_certificate_get_fingerprint_hex($!gc, $t);
  }

  method get_interface_elements (
    :$raw            = False,
    :gslist(:$glist) = False
  ) {
    returnGList(
      gcr_certificate_get_interface_elements($!gc),
      $raw,
      $glist,
      |GCR::Certificate::Section.getTypePair
    )
  }

  method get_issued_date ( :$raw = False, :$raku = True ) {
    my $d = propReturnObject(
      gcr_certificate_get_issued_date($!gc),
      $raw,
      |GLib::DateTime.getTypePair
    );
    return $d unless $raku;
    $d.DateTime;
  }

  method get_issuer_cn {
    gcr_certificate_get_issuer_cn($!gc);
  }

  method get_issuer_dn {
    gcr_certificate_get_issuer_dn($!gc);
  }

  method get_issuer_name {
    gcr_certificate_get_issuer_name($!gc);
  }

  method get_issuer_part (Str() $part) {
    gcr_certificate_get_issuer_part($!gc, $part);
  }

  proto method get_issuer_raw (|)
  { * }

  multi method get_issuer_raw {
    samewith($);
  }
  multi method get_issuer_raw ($n_data is rw) {
    my gsize $n = 0;

    my $r = gcr_certificate_get_issuer_raw($!gc, $n);
    $n_data = $n;
    SizedCArray.new($r, $n);
  }

  method get_key_size {
    gcr_certificate_get_key_size($!gc);
  }

  method get_public_key_info {
    gcr_certificate_get_public_key_info($!gc);
  }

  method get_serial_number ($n_length is rw) {
    my gsize $n = $n_length;

    my $r = gcr_certificate_get_serial_number($!gc, $n);
    $n_length = $n;
    $r;
  }

  method get_serial_number_hex {
    gcr_certificate_get_serial_number_hex($!gc);
  }

  method get_subject_cn {
    gcr_certificate_get_subject_cn($!gc);
  }

  method get_subject_dn {
    gcr_certificate_get_subject_dn($!gc);
  }

  method get_subject_name {
    gcr_certificate_get_subject_name($!gc);
  }

  method get_subject_part (Str() $part) {
    gcr_certificate_get_subject_part($!gc, $part);
  }

  proto method get_subject_raw (|)
  { * }

  multi method get_subject_raw {
    samewith($);
  }
  multi method get_subject_raw ($n_data is rw, :$sized = True) {
    my gsize $n = 0;
    my       $r = gcr_certificate_get_subject_raw($!gc, $n);

    $n_data = $n;
    return ($r, $n_data) unless $sized;
    SizedCArray.new($r, $n);
  }

  method gcrcertificate_get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &gcr_certificate_get_type, $n, $t );
  }

  method get_version {
    gcr_certificate_get_version($!gc);
  }

  method is_issuer (GcrCertificate() $issuer) {
    gcr_certificate_is_issuer($!gc, $issuer);
  }

  method list_extensions {
    gcr_certificate_list_extensions($!gc);
  }
}

# cw: Not sure how these work, so ignored... for now.
  # method mixin_class_init {
  #   gcr_certificate_mixin_class_init($!gc);
  # }
  #
  # method mixin_emit_notify {
  #   gcr_certificate_mixin_emit_notify($!gc);
  # }
  #
  # method mixin_get_property (
  #   GObject    $obj,
  #   guint      $prop_id,
  #   GValue     $value,
  #   GParamSpec $pspec
  # ) {
  #   gcr_certificate_mixin_get_property($!gc, $prop_id, $value, $pspec);
  # }

use GLib::Roles::Implementor;

class GCR::Certificate {
  also does GLib::Roles::Implementor;
  also does GCR::Roles::Certificate;

  submethod BUILD ( :$gcr-certificate ) {
    $!gc = $gcr-certificate if $gcr-certificate;
  }

  method Gcr::Raw::Definitions::GcrCertificate
    is also<GcrCertificate>
  { $!gc }

  multi method new (GcrCertificate $gcr-certificate) {
    return unless $gcr-certificate;

    self.bless( :$gcr-certificate );
  }

  method get_type {
    self.gcrcertificate_get_type;
  }

  # Trust

  method add_pinned_certificate (
    Str()                   $purpose,
    Str()                   $peer,
    GCancellable()          $cancellable,
    CArray[Pointer[GError]] $error        = gerror
  ) {
    clear_error;
    my $r = gcr_trust_add_pinned_certificate(
      $!gc,
      $purpose,
      $peer,
      $cancellable,
      $error
    );
    set_error($error);
    $r;
  }

  proto method add_pinned_certificate_async (|)
  { * }

  multi method add_pinned_certificate_async (
     $purpose,
     $peer,
     &callback,
     $user_data   = gpointer,
    :$cancellable = GCancellable
  ) {
    samewith(
      $purpose,
      $peer,
      $cancellable,
      &callback,
      $user_data
    );
  }
  multi method add_pinned_certificate_async (
    Str()          $purpose,
    Str()          $peer,
    GCancellable() $cancellable,
                   &callback,
    gpointer       $user_data     = gpointer
  ) {
    gcr_trust_add_pinned_certificate_async(
      $!gc,
      $purpose,
      $peer,
      $cancellable,
      &callback,
      $user_data
    );
  }

  method add_pinned_certificate_finish (
    GAsyncResult()          $result,
    CArray[Pointer[GError]] $error    = gerror
  ) {
    clear_error;
    my $r = gcr_trust_add_pinned_certificate_finish($result, $error);
    set_error($error);
  }

  method is_certificate_anchored (
    Str()                   $purpose,
    GCancellable()          $cancellable = GCancellable,
    CArray[Pointer[GError]] $error       = gerror
  ) {
    clear_error;
    my $r = gcr_trust_is_certificate_anchored(
      $!gc,
      $purpose,
      $cancellable,
      $error
    );
    set_error($error);
    $r;
  }

  proto method is_certificate_anchored_async (|)
  { * }

  multi method is_certificate_anchored_async (
     $purpose,
     &callback,
     $user_data   = gpointer,
    :$cancellable = GCancellable
  ) {
    samewith(
      $purpose,
      $cancellable,
      &callback,
      $user_data
    )
  }
  multi method is_certificate_anchored_async (
    Str()          $purpose,
    GCancellable() $cancellable,
                   &callback,
    gpointer       $user_data     = gerror
  ) {
    gcr_trust_is_certificate_anchored_async($!gc, $purpose, $cancellable, $callback, $user_data);
  }

  method is_certificate_anchored_finish (
    GAsyncResult            $result,
    CArray[Pointer[GError]] $error   = gerror
  ) {
    clear_error;
    my $r = so gcr_trust_is_certificate_anchored_finish($result, $error);
    set_error($error);
    $r;
  }

  proto method is_certificate_distrusted (|)
  { * }

  multi method is_certificate_distrusted (
    Str                      $serial_nr,
    Str                      $issuer,
                             $cancellable = GCancellable,
    CArray[Pointer[GError]]  $error       = gerror,
                            :$encoding    = 'utf8'
  ) {
    samewith(
      $serial_nr.encode($encoding),
      $issuer.encode($encoding),
      $cancellable,
      $error
    );
  }
  multi method is_certificate_distrusted (
    Blob[uint8]             $serial_nr,
    Blob[uint8]             $issuer,
                            $cancellable = GCancellable,
    CArray[Pointer[GError]] $error       = gerror
  ) {
    samewith(
      CArray[uint8].new($serial_nr),
      $sserial_nr.bytes,
      CArray[uint8].new($issuer),
      $issuer.bytes,
      $cancellable,
      $error
    );
  }
  method method is_certificate_distrusted (
    CArray[uint8]           $serial_nr,
    Int()                   $serial_nr_len,
    CArray[uint8]           $issuer,
    Int()                   $issuer_len,
    GCancellable()          $cancellable    = GCancellable,
    CArray[Pointer[GError]] $error          = gerror
  ) {
    my size_t($s, $i) = ($serial_nr_len, $issuer_len);

    clear_error;
    my $r = so gcr_trust_is_certificate_distrusted(
      $serial_nr,
      $s,
      $issuer,
      $i,
      $cancellable,
      $error
    );
    set_error($error);
    $r;
  }

  method is_certificate_distrusted_async (
    size_t              $serial_nr_len,
    Str                 $issuer,
    size_t              $issuer_len,
    GCancellable        $cancellable,
    GAsyncReadyCallback $callback,
    Pointer             $user_data
  ) {
    gcr_trust_is_certificate_distrusted_async($!gc, $serial_nr_len, $issuer, $issuer_len, $cancellable, $callback, $user_data);
  }

  method is_certificate_distrusted_finish (
    GAsyncResult            $result,
    CArray[Pointer[GError]] $error   = gerror
  ) {
    clear_error;
    my $r = so gcr_trust_is_certificate_distrusted_finish($result, $error);
    set_error($error);
    $r;
  }

  method is_certificate_pinned (
    Str()                   $purpose,
    Str()                   $peer,
    GCancellable()          $cancellable = GCancellable,
    CArray[Pointer[GError]] $error       = gpointer
  ) {
    clear_error;
    my $r = so gcr_trust_is_certificate_pinned(
      $!gc,
      $purpose,
      $peer,
      $cancellable,
      $error
    );
    set_error($error);
    $r;
  }

  proto method is_certificate_pinned_async (|)
  { * }

  multi method is_certificate_pinned_async (
     $purpose,
     $peer,
     &callback,
     $user_data   = gpointer,
    :$cancellable = GCancellable
  ) {
    samewith(
      $purpose,
      $peer,
      $cancellable,
      &callback,
      $user_data
    );
  }
  multi method is_certificate_pinned_async (
    Str()          $purpose,
    Str()          $peer,
    GCancellable() $cancellable,
                   &callback,
    gpointer       $user_data     = gpointer
  ) {
    gcr_trust_is_certificate_pinned_async(
      $!gc,
      $purpose,
      $peer,
      $cancellable,
      &callback,
      $user_data
    );
  }

  method is_certificate_pinned_finish (
    GAsyncResult()          $result,
    CArray[Pointer[GError]] $error    = gerror
  ) {
    clear_error;
    my $r = gcr_trust_is_certificate_pinned_finish($result, $error);
    set_error($error);
    $r;
  }

  method remove_pinned_certificate (
    Str()                   $purpose,
    Str()                   $peer,
    GCancellable()          $cancellable,
    CArray[Pointer[GError]] $error        = gerror
  ) {
    clear_error;
    my $r = gcr_trust_remove_pinned_certificate(
      $!gc,
      $purpose,
      $peer,
      $cancellable,
      $error
    );
    set_error($error);
    $r
  }

  proto method remove_pinned_certificate_async (|)
  { * }

  multi method remove_pinned_certificate_async (
     $purpose,
     $peer,
     &callback,
     $user_data   = gpointer,
    :$cancellable = GCancellable
  ) {
    samewith(
      $purpose,
      $peer,
      $cancellable,
      &callback,
      $user_data
    );
  }
  multi method remove_pinned_certificate_async (
    Str()          $purpose,
    Str()          $peer,
    GCancellable() $cancellable,
                   &callback,
    gpointer       $user_data
  ) {
    gcr_trust_remove_pinned_certificate_async(
      $!gc,
      $purpose,
      $peer,
      $cancellable,
      &callback,
      $user_data
    );
  }

  method remove_pinned_certificate_finish (
    GAsyncResult()          $result,
    CArray[Pointer[GError]] $error   = gerror
  ) {
    clear_error;
    my $r = gcr_trust_remove_pinned_certificate_finish($result, $error);
    set_error($error);
    $r;
  }

}
