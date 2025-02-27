use v6.c;

use Method::Also;

use NativeCall;

use GCR::Raw::Types;

use GCR::Certificate::Extension;

use GLib::Roles::Implementor;
use GLib::Roles::Object;
use GIO::Roles::ListModel;

our subset GcrCertificateExtensionListAncestry is export of Mu
  where GcrCertificateExtensionList | GListModel | GObject;

class GCR::ExtensionList {
  also does GLib::Roles::Object;
  also does GIO::Roles::ListMode;
  also does Positional;
  also does Iterable;

  has GcrCertificateExtensionList $!gcel is implementor;

  submethod BUILD ( :$gcr-extension-list ) {
    self.setGcrCertificateExtensionList($gcr-extension-list)
      if $gcr-extension-list
  }

  method setGcrCertificateExtensionList (
    GcrCertificateExtensionListAncestry $_
  ) {
    my $to-parent;

    $!gcel = do {
      when GcrCertificateExtensionList {
        $to-parent = cast(GObject, $_);
        $_;
      }

      when GListModel {
        $to-parent = cast(GObject, $_);
        $!lm       = $_;
        cast(GcrCertificateExtensionList, $_);
      }

      default {
        $to-parent = $_;
        cast(GcrCertificateExtensionList, $_);
      }
    }
    self!setObject($to-parent);
    self.roleInit-GListModel;
  }

  method GCR::Raw::Definitions::GcrCertificateExtensionList
    is also<GcrCertificateExtensionList>
  { $!gcel }

  multi method new (
    $gcr-extension-list where * ~~ GcrCertificateExtensionListAncestry,

    :$ref = True
  ) {
    return unless $gcr-extension-list;

    my $o = self.bless( :$gcr-extension-list );
    $o.ref if $ref;
    $o;
  }

  # Type: uint
  method n-items is rw  is g-property {
    my $gv = GLib::Value.new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('n-items', $gv);
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        warn 'n-items does not allow writing'
      }
    );
  }

  method find_by_oid (Str() $oid) is also<find-by-oid> {
    propReturnObject(
      gcr_certificate_extension_list_find_by_oid($!gcel, $oid),
      $raw,
      |GCR::Certificate::Extension.getTypePair
    );
  }

  method get_extension (Int() $position) is also<get-extension> {
    my gint $p = $position;

    propReturnObject(
      gcr_certificate_extension_list_get_extension($!gcel, $p),
      $raw,
      |GCR::Certificate::Extension.getTypePair
    );
  }

  # Positional

  method AT-POS (\k) {
    return Nil unless k ~~ Int && k ~~ 0 .. self.elems;
    $.get_extension(k);
  }

  method iterator {
    generic-iterator(
      self,
      SUB      { self.elems     }
      sub (\k) { self.AT-POS(k) }
    );
  }

}

### /home/cbwood/Projects/gcr/gcr/gcr-certificate-extension-list.h

sub gcr_certificate_extension_list_find_by_oid (
  GcrCertificateExtensionList $self,
  Str                         $oid
)
  returns GcrCertificateExtension
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_extension_list_get_extension (
  GcrCertificateExtensionList $self,
  gint                        $position
)
  returns GcrCertificateExtension
  is      native(gcr)
  is      export
{ * }
