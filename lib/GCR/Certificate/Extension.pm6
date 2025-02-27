use v6.c;

use Method::Also;

use GCR::Raw::Types;

use GLib::Bytes;

use GLib::Roles::Implementor;
use GLib::Roles::Object;

our subset GcrCertificateExtensionAncestry is export of Mu
  where GcrCertificateExtension | GObject;

class GCR::Certificate::Extension {
  also does GLib::Roles::Object;

  has GcrCertificateExtension $!gce is implementor;

  submethod BUILD ( :$gcr-cert-extension ) {
    self.setGcrCertificateExtension($gcr-cert-extension)
      if $gcr-cert-extension
  }

  method setGcrCertificateExtension (GcrCertificateExtensionAncestry $_) {
    my $to-parent;

    $!gce = do {
      when GcrCertificateExtension {
        $to-parent = cast(GObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GcrCertificateExtension, $_);
      }
    }
    self!setObject($to-parent);
  }

  method GCR::Raw::Definitions::GcrCertificateExtension
    is also<GcrCertificateExtension>
  { $!gce }

  multi method new (
    $gcr-cert-extension where * ~~ GcrCertificateExtensionAncestry,

    :$ref = True
  ) {
    return unless $gcr-cert-extension;

    my $o = self.bless( :$gcr-cert-extension );
    $o.ref if $ref;
    $o;
  }

  # Type: boolean
  method critical is rw  is g-property {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('critical', $gv);
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('critical', $gv);
      }
    );
  }

  # Type: string
  method oid is rw  is g-property {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('oid', $gv);
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        warn 'oid does not allow writing'
      }
    );
  }

  # Type: GcrBytes
  method value ( :$raw = False ) is rw  is g-property {
    my $gv = GLib::Value.new( GLib::Bytes.get_type );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('value', $gv);
        propReturnObject(
          $gv.object,
          $raw,
          |GLib::Bytes.getTypePair
        );
      },
      STORE => -> $, GBytes() $val is copy {
        $gv.object = $val;
        self.prop_set('value', $gv);
      }
    );
  }

  method get_description
    is also<
      get-description
      description
      desc
    >
  {
    gcr_certificate_extension_get_description($!gce);
  }

  method get_oid is also<get-oid> {
    gcr_certificate_extension_get_oid($!gce);
  }

  method get_value ( :$raw = False ) is also<get-value> {
    propReturnObject(
      gcr_certificate_extension_get_value($!gce),
      $raw,
      |GLib::Bytes.getTypePair
    );
  }

  method is_critical is also<is-critical> {
    gcr_certificate_extension_is_critical($!gce);
  }

}

### /home/cbwood/Projects/gcr/gcr/gcr-certificate-extension.h

sub gcr_certificate_extension_get_description (GcrCertificateExtension $self)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_extension_get_oid (GcrCertificateExtension $self)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_extension_get_value (GcrCertificateExtension $self)
  returns GBytes
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_extension_is_critical (GcrCertificateExtension $self)
  returns uint32
  is      native(gcr)
  is      export
{ * }
