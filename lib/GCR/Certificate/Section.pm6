use v6.c;

use Method::Also;

use NativeCall;

use GCR::Raw::Types;

use GCR::Enums;

use GLib::Roles::Object;
use GLib::Roles::Implementor;
use GIO::Roles::ListModel;

our subset GcrCertificateSectionAncestry is export of Mu
  where GcrCertificateSection | GObject;

class GCR::Certificate::Section {
  also does GLib::Roles::Object;

  has GcrCertificateSection $!gcs is implementor;

  submethod BUILD ( :$gcr-cert-section ) {
    self.setGcrCertificateSection($gcr-cert-section)
      if $gcr-cert-section
  }

  method setGcrCertificateSection (GcrCertificateSectionAncestry $_) {
    my $to-parent;

    $!gcs = do {
      when GcrCertificateSection {
        $to-parent = cast(GObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GcrCertificateSection, $_);
      }
    }
    self!setObject($to-parent);
  }

  method GCR::Raw::Definitions::GcrCertificateSection
    is also<GcrCertificateSection>
  { $!gcs }

  multi method new (
    $gcr-cert-section where * ~~ GcrCertificateSectionAncestry,

    :$ref = True
  ) {
    return unless $gcr-cert-section;

    my $o = self.bless( :$gcr-cert-section );
    $o.ref if $ref;
    $o;
  }

  # Type: GcrListModel
  method fields ( :$raw = False ) is rw  is g-property {
    my $gv = GLib::Value.new( GIO::ListModel.get_type );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('fields', $gv);
        propReturnObject(
          $gv.object,
          $raw,
          |GIO::ListModel.getTypePair
        );
      },
      STORE => -> $,  $val is copy {
        warn 'fields does not allow writing'
      }
    );
  }

  # Type: GcrCertificateSectionFlags
  method flags ( :set(:$flags) = True ) is rw  is g-property {
    my $gv = GLib::Value.new(
      GCR::Enums::Certificate::Section::Flags.get_type
    );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('flags', $gv);
        my $f = $gv.flags;
        return $f unless $flags;
        getFlags(GcrCertificateSectionFlagsEnum, $f);
      },
      STORE => -> $, Int() $val is copy {
        $gv.valueFromEnum(GcrCertificateSectionFlags) = $val;
        self.prop_set('flags', $gv);
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
        $gv.string = $val;
        self.prop_set('label', $gv);
      }
    );
  }

  method get_fields ( :$raw = False ) is also<get-fields> {
    propReturnObject(
      gcr_certificate_section_get_fields($!gcs),
      $raw,
      |GIO::ListModel.getTypePair
    );
  }

  method get_flags ( :set(:$flags) = True ) is also<get-flags> {
    my $f = gcr_certificate_section_get_flags($!gcs);
    return $f unless $flags;
    getFlags(GcrCertificateSectionFlagsEnum, $f);
  }

  method get_label is also<get-label> {
    gcr_certificate_section_get_label($!gcs);
  }

}

### /home/cbwood/Projects/gcr/gcr/gcr-certificate-section.h

sub gcr_certificate_section_get_fields (GcrCertificateSection $self)
  returns GListModel
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_section_get_flags (GcrCertificateSection $self)
  returns GcrCertificateSectionFlags
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_section_get_label (GcrCertificateSection $self)
  returns Str
  is      native(gcr)
  is      export
{ * }
