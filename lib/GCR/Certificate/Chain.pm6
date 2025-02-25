use v6.c;

use Method::Also;
use NativeCall;

use GCR::Raw::Types;
use GCR::Raw::Certificate::Chain;

use GLib::Roles::Implementor;
use GLib::Roles::Object;

our subset GcrCertificateChainAncestry is export of Mu
  where GcrCertificateChain | GObject;

class GCR::Certificate::Chain {
  also does GLib::Roles::Object;
  also does Positional;
  also does Iterable;

  has GcrCertificateChain $!gcc is implementor;

  submethod BUILD ( :$gcr-certificate-chain ) {
    self.setGcrCertificateChain($gcr-certificate-chain)
      if $gcr-certificate-chain
  }

  method setGcrCertificateChain (GcrCertificateChainAncestry $_) {
    my $to-parent;

    $!gcc = do {
      when GcrCertificateChain {
        $to-parent = cast(GObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GcrCertificateChain, $_);
      }
    }
    self!setObject($to-parent);
  }

  method Gcr::Raw::Definitions::GcrCertificateChain
    is also<GcrCertificateChain>
  { $!gcc }

  multi method new (
    $gcr-certificate-chain where * ~~ GcrCertificateChainAncestry ,

    :$ref = True
  ) {
    return unless $gcr-certificate-chain;

    my $o = self.bless( :$gcr-certificate-chain );
    $o.ref if $ref;
    $o;
  }
  multi method new {
    my $gcr-certificate-chain = gcr_certificate_chain_new();

    $gcr-certificate-chain ?? self.bless( :$gcr-certificate-chain ) !! Nil;
  }

  method add (GcrCertificate() $certificate) {
    gcr_certificate_chain_add($!gcc, $certificate);
  }

  method build (
    Str()                   $purpose,
    Str()                   $peer,
    Int()                   $flags,
    GCancellable()          $cancellable = GCancellable,
    CArray[Pointer[GError]] $error       = gerror
  ) {
    my GcrCertificateChainFlags $f = $flags;

    clear_error;
    my $r = gcr_certificate_chain_build(
      $!gcc,
      $purpose,
      $peer,
      $f,
      $cancellable,
      $error
    );
    set_error($error);
    $r;
  }

  proto method build_async (|)
    is also<build-async>
  { * }

  multi method build_async (
     $purpose,
     $peer,
     $flags,
     &callback,
     $user_data    = gpointer,
    :$cancellable  = GCancellable
  ) {
    samewith(
      $purpose,
      $peer,
      $flags,
      $cancellable,
      &callback,
      $user_data
    );
  }
  multi method build_async (
    Str()          $purpose,
    Str()          $peer,
    Int()          $flags,
    GCancellable() $cancellable,
                   &callback,
    gpointer       $user_data    = gpointer
  ) {
    my GcrCertificateChainFlags $f = $flags;

    gcr_certificate_chain_build_async(
      $!gcc,
      $purpose,
      $peer,
      $f,
      $cancellable,
      &callback,
      $user_data
    );
  }

  method build_finish (
    GAsyncResult()          $result,
    CArray[Pointer[GError]] $error    = gerror
  )
    is also<build-finish>
  {
    clear_error;
    my $r = gcr_certificate_chain_build_finish($!gcc, $result, $error);
    set_error($error);
    $r;
  }

  method get_anchor ( :$raw = False ) is also<get-anchor> {
    propReturnObject(
      gcr_certificate_chain_get_anchor($!gcc),
      $raw,
      |GCR::Certificate.getTypePair
    );
  }

  method get_certificate (Int() $index, :$raw = False)
    is also<get-certificate>
  {
    my guint $i = $index;

    propReturnObject(
      gcr_certificate_chain_get_certificate($!gcc, $i),
      $raw,
      |GCR::Certificate.getTypePair
    );
  }

  method get_endpoint ( :$raw = False ) is also<get-endpoint> {
    propReturnObject(
      gcr_certificate_chain_get_endpoint($!gcc),
      $raw,
      |GCR::Certificate.getTypePair
    );
  }

  method get_length
    is also<
      get-length
      length
      elems
    >
  {
    gcr_certificate_chain_get_length($!gcc);
  }

  method get_status ( :$enum = True )
    is also<
      get-status
      status
    >
  {
    my GcrCertificateChainStatus $s = gcr_certificate_chain_get_status($!gcc);

    return $s unless $enum;
    GcrCertificateChainStatusEnum($s);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gcr_certificate_chain_get_type, $n, $t );
  }

  ## Positional
  method AT-POS (\k) is also<AT_POS> {
    return Nil unless k ~~ Int && k ~~ 0 ..^ $.get_length;

    $.get_certificate(k);
  }

  ## Iterable
  method iterator {
    generate-iterator(
      self,
      sub      { self.get_length },
      sub ($_) { self.get_certificate($_) }
    )
  }

}
