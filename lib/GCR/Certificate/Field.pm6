use v6.c;

use Method::Also;

use NativeCall;

use GCR::Raw::Types;

use GLib::Value;
use GCR::Certificate::Section;

use GLib::Roles::Implementor;
use GLib::Roles::Object;

our subset GcrCertificateFieldAncestry is export of Mu
  where GcrCertificateField | GObject;

class GCR::Certificate::Field {
  also does GLib::Roles::Object;
  
  has GcrCertificateField $!gcf is implementor;

  submethod BUILD ( :$gcr-certificate-field ) {
    self.setGcrCertificateField($gcr-certificate-field)
      if $gcr-certificate-field
  }

  method setGcrCertificateField (GcrCertificateFieldAncestry $_) {
    my $to-parent;

    $!gcf = do {
      when GcrCertificateField {
        $to-parent = cast(GObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GcrCertificateField, $_);
      }
    }
    self!setObject($to-parent);
  }

  method GCR::Raw::Definitions::GcrCertificateField
    is also<GcrCertificateField>
  { $!gcf }

  method new (
    $gcr-certificate-field where * ~~ GcrCertificateFieldAncestry,

    :$ref = True
  ) {
    return unless $gcr-certificate-field;

    my $o = self.bless( :$gcr-certificate-field );
    $o.ref if $ref;
    $o;
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
        $gv.string = $val;
        self.prop_set('label', $gv);
      }
    );
  }

  # Type: GcrCertificateSection
  method section ( :$raw = False ) is rw  is g-property {
    my $gv = GLib::Value.new( GCR::Certificate::Section.get_type );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('section', $gv);
        propReturnObject(
          $gv.object,
          $raw,
          |GCR::Certificate::Section.getTypePair
        );
      },
      STORE => -> $, GcrCertificateSection() $val is copy {
        $gv.object = $val;
        self.prop_set('section', $gv);
      }
    );
  }

  # Type: GcrValue
  method value ( :$raw = False ) is rw  is g-property {
    my $gv = GLib::Value.new( GLib::Value.get_type );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('value', $gv);
        propReturnObject(
          $gv.object,
          $raw,
          |GLib::Value.getTypePair
        );
      },
      STORE => -> $,  $val is copy {
        warn 'value does not allow writing'
      }
    );
  }

  method get_label is also<get-label> {
    gcr_certificate_field_get_label($!gcf);
  }

  method get_section ( :$raw = False ) is also<get-section> {
    propReturnObject(
      gcr_certificate_field_get_section($!gcf),
      $raw,
      |GCR::Certificate::Section.get_type
    );
  }

  method get_value (GValue() $value, :$raw = False) is also<get-value> {
    propReturnObject(
      gcr_certificate_field_get_value($!gcf, $value),
      $raw,
      |GLib::Value.getTypePair
    );
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gcr_certificate_get_type, $n, $t );
  }

  method get_value_type is also<get-value-type> {
    gcr_certificate_field_get_value_type($!gcf);
  }

}

### /home/cbwood/Projects/gcr/gcr/gcr-certificate-field.h

sub gcr_certificate_field_get_label (GcrCertificateField $self)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_field_get_section (GcrCertificateField $self)
  returns GcrCertificateSection
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_field_get_value (
  GcrCertificateField $self,
  GValue              $value
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_field_get_value_type (GcrCertificateField $self)
  returns GType
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_get_type
  returns GType
  is      native(gcr)
  is      export
{ * }
