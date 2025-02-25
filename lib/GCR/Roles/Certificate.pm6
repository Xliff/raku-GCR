use v6.c;

use GCR::Raw::Types;
use GCR::Raw::Certificate;

use GLib::DateTime;

use GLib::Roles::Implementor;
use GLib::Roles::Object;

role GCR::Roles::Certificate {
  has GcrCertificate $!gc is implementor;

  # Type: string
  method description is rw  is g-property {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('description', $gv);
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        warn 'description does not allow writing'
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

  method gcr_certificate_get_basic_constraints (
    Int() $is_ca,
          $path_len is rw
  ) {
    my gboolean $i = $is_ca.so.Int;
    my gint     $p = 0;

    my $r = gcr_certificate_get_basic_constraints($!gc, $is_ca, $path_len);
    $path_len = $p;
    $r;
  }

  method gcr_certificate_get_der_data ($n_data is rw) {
    my gsize $n = $n_data;

    my $r = gcr_certificate_get_der_data($!gc, $n_data);
    $n_data = $n;
    $r;
  }

  method gcr_certificate_get_expiry_date {
    gcr_certificate_get_expiry_date($!gc);
  }

  method gcr_certificate_get_fingerprint (Int() $type, $n_length is rw) {
    my GChecksumType $t = $type;
    my gsize         $n = 0;

    my $r = gcr_certificate_get_fingerprint($!gc, $type, $n_length);
    $n_length = $n;
    $r;
  }

  method gcr_certificate_get_fingerprint_hex (Int() $type) {
    my GChecksumType $t = $type;

    gcr_certificate_get_fingerprint_hex($!gc, $t);
    $type = $t;
  }

  method gcr_certificate_get_interface_elements {
    gcr_certificate_get_interface_elements($!gc);
  }

  method gcr_certificate_get_issued_date {
    gcr_certificate_get_issued_date($!gc);
  }

  method gcr_certificate_get_issuer_cn {
    gcr_certificate_get_issuer_cn($!gc);
  }

  method gcr_certificate_get_issuer_dn {
    gcr_certificate_get_issuer_dn($!gc);
  }

  method gcr_certificate_get_issuer_name {
    gcr_certificate_get_issuer_name($!gc);
  }

  method gcr_certificate_get_issuer_part (Str() $part) {
    gcr_certificate_get_issuer_part($!gc, $part);
  }

  method gcr_certificate_get_issuer_raw ($n_data is rw) {
    my gsize $n = 0;

    my $r = gcr_certificate_get_issuer_raw($!gc, $n_data);
    $n_data = $n;
    $r;
  }

  method gcr_certificate_get_key_size {
    gcr_certificate_get_key_size($!gc);
  }

  method gcr_certificate_get_public_key_info {
    gcr_certificate_get_public_key_info($!gc);
  }

  method gcr_certificate_get_serial_number ($n_length is rw) {
    my gsize $n = $n_length;

    my $r = gcr_certificate_get_serial_number($!gc, $n);
    $n_length = $n;
    $r;
  }

  method gcr_certificate_get_serial_number_hex {
    gcr_certificate_get_serial_number_hex($!gc);
  }

  method gcr_certificate_get_subject_cn {
    gcr_certificate_get_subject_cn($!gc);
  }

  method gcr_certificate_get_subject_dn {
    gcr_certificate_get_subject_dn($!gc);
  }

  method gcr_certificate_get_subject_name {
    gcr_certificate_get_subject_name($!gc);
  }

  method gcr_certificate_get_subject_part (Str() $part) {
    gcr_certificate_get_subject_part($!gc, $part);
  }

  method gcr_certificate_get_subject_raw ($n_data is rw) {
    my gsize $n = 0;
    my       $r = gcr_certificate_get_subject_raw($!gc, $n_data);

    $n_data = $n;
    $r;
  }

  method gcr_certificate_get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &gcr_certificate_get_type, $n, $t );
  }

  method gcr_certificate_get_version {
    gcr_certificate_get_version($!gc);
  }

  method gcr_certificate_is_issuer (GcrCertificate() $issuer) {
    gcr_certificate_is_issuer($!gc, $issuer);
  }

  method gcr_certificate_list_extensions {
    gcr_certificate_list_extensions($!gc);
  }
}

# cw: Not sure how these work, so ignored... for now.
  # method gcr_certificate_mixin_class_init {
  #   gcr_certificate_mixin_class_init($!gc);
  # }
  #
  # method gcr_certificate_mixin_emit_notify {
  #   gcr_certificate_mixin_emit_notify($!gc);
  # }
  #
  # method gcr_certificate_mixin_get_property (
  #   GObject    $obj,
  #   guint      $prop_id,
  #   GValue     $value,
  #   GParamSpec $pspec
  # ) {
  #   gcr_certificate_mixin_get_property($!gc, $prop_id, $value, $pspec);
  # }


use GLib::Roles::Object;

our subset GcrCertificateAncestry is export of Mu
  where GcrCertificate | GObject;

class GCR::Certificate {
  also does GLib::Roles::Object;
  also does GCR::Roles::Certificate;

  submethod BUILD ( :$gcr-certificate ) {
    self.setGcrCertificate($gcr-certificate) if $gcr-certificate
  }

  method setGcrCertificate (GcrCertificateAncestry $_) {
    my $to-parent;

    $!gc = do {
      when GcrCertificate {
        $to-parent = cast(GObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GcrCertificate, $_);
      }
    }
    self!setObject($to-parent);
  }

  method Gcr::Raw::Definitions::GcrCertificate
    is also<GcrCertificate>
  { $!gc }

  multi method new (
    $gcr-certificate where * ~~ GcrCertificateAncestry ,

    :$ref = True
  ) {
    return unless $gcr-certificate;

    my $o = self.bless( :$gcr-certificate );
    $o.ref if $ref;
    $o;
  }

}
