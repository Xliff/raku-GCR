use v6.c;

use Method::Also;

use NativeCall;

use GCR::Raw::Types;

use GLib::Roles::Object;
use GCR::Roles::Certificate;

our subset GcrSimpleCertificateAncestry is export of Mu
  where GcrSimpleCertificate | GcrCertificate | GObject;

class GCR::Simple::Certificate {
  also does GLib::Roles::Object;
  also does GCR::Roles::Certificate;

  has GcrSimpleCertificate $!gsc is implementor;

  submethod BUILD ( :$gcr-simple-certificate ) {
    self.setGcrSimpleCertificate($gcr-simple-certificate)
      if $gcr-simple-certificate
  }

  method setGcrSimpleCertificate (GcrSimpleCertificateAncestry $_) {
    my $to-parent;

    $!gsc = do {
      when GcrSimpleCertificate {
        $to-parent = cast(GObject, $_);
        $_;
      }

      when GcrCertificate {
        $to-parent = cast(GObject, $_);
        $!gc       = $_;
        cast(GcrSimpleCertificate, $_);
      }

      default {
        $to-parent = $_;
        cast(GcrSimpleCertificate, $_);
      }
    }
    self!setObject($to-parent);
    self.roleInit-GcrCertificate;
  }

  method Gcr::Raw::Definitions::GcrSimpleCertificate
    is also<GcrSimpleCertificate>
  { $!gsc }

  proto method new (|)
  { * }

  multi method new (
    $gcr-simple-certificate where * ~~ GcrSimpleCertificateAncestry,

    :$ref = True
  ) {
    return unless $gcr-simple-certificate;

    my $o = self.bless( :$gcr-simple-certificate );
    $o.ref if $ref;
    $o;
  }

  multi method new (SizedCArray $contents) {
    samewith($contents.CArray, $contents.elems);
  }
  multi method new (@contents) {
    samewith( ArrayToCArray(uint8, @contents) );
  }
  multi method new (
    CArray[uint8] $contents,
    Int()         $n_data    = $contents.elems
  ) {
    my gsize $n = $n_data;

    my $gcr-simple-certificate = gcr_simple_certificate_new($contents, $n);

    $gcr-simple-certificate ?? self.bless( :$gcr-simple-certificate ) !! Nil;
  }

  proto method new_static (|)
    is also<new-static>
  { * }

  multi method new_static (@contents) {
    samewith( ArrayToCArray(uint8, @contents) );
  }
  multi method new_static (
    CArray[uint8] $contents,
    Int()         $n_data    = $contents.elems
  ) {
    my gsize $n = $n_data;

    my $gcr-simple-certificate = gcr_simple_certificate_new_static(
      $contents,
      $n
    );

    $gcr-simple-certificate ?? self.bless( :$gcr-simple-certificate ) !! Nil;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gcr_simple_certificate_get_type, $n, $t );
  }

}

### /home/cbwood/Projects/gcr/gcr/gcr-simple-certificate.h

sub gcr_simple_certificate_get_type
  returns GType
  is      native(gcr)
  is      export
{ * }

sub gcr_simple_certificate_new (
  CArray[uint8] $data,
  gsize         $n_data
)
  returns GcrCertificate
  is      native(gcr)
  is      export
{ * }

sub gcr_simple_certificate_new_static (
  CArray[uint8] $data,
  gsize         $n_data
)
  returns GcrCertificate
  is      native(gcr)
  is      export
{ * }
