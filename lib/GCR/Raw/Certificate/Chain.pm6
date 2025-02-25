use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GIO::Raw::Definitions;
use GCR::Raw::Definitions;
use GCR::Raw::Enums;

unit package GCR::Raw::Certificate::Chain;

### /home/cbwood/Projects/gcr/gcr/gcr-certificate-chain.h

sub gcr_certificate_chain_add (
  GcrCertificateChain $self,
  GcrCertificate      $certificate
)
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_chain_build (
  GcrCertificateChain      $self,
  Str                      $purpose,
  Str                      $peer,
  GcrCertificateChainFlags $flags,
  GCancellable             $cancellable,
  CArray[Pointer[GError]]  $error
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_chain_build_async (
  GcrCertificateChain      $self,
  Str                      $purpose,
  Str                      $peer,
  GcrCertificateChainFlags $flags,
  GCancellable             $cancellable,
  GAsyncReadyCallback      $callback,
  gpointer                 $user_data
)
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_chain_build_finish (
  GcrCertificateChain     $self,
  GAsyncResult            $result,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_chain_get_anchor (GcrCertificateChain $self)
  returns GcrCertificate
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_chain_get_certificate (
  GcrCertificateChain $self,
  guint               $index
)
  returns GcrCertificate
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_chain_get_endpoint (GcrCertificateChain $self)
  returns GcrCertificate
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_chain_get_length (GcrCertificateChain $self)
  returns guint
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_chain_get_status (GcrCertificateChain $self)
  returns GcrCertificateChainStatus
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_chain_get_type
  returns GType
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_chain_new
  returns GcrCertificateChain
  is      native(gcr)
  is      export
{ * }
