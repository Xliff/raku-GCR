use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Enums;
use GLib::Raw::Structs;
use GCR::Raw::Definitions;

unit package GCR::Raw::Certificate;

### /home/cbwood/Projects/gcr/gcr/gcr-certificate.h

sub gcr_certificate_get_basic_constraints (
  GcrCertificate $self,
  gboolean       $is_ca,
  gint           $path_len is rw
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_get_der_data (
  GcrCertificate $self,
  gsize          $n_data
)
  returns guint8
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_get_expiry_date (GcrCertificate $self)
  returns GDateTime
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_get_fingerprint (
  GcrCertificate $self,
  GChecksumType  $type,
  gsize          $n_length
)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_get_fingerprint_hex (
  GcrCertificate $self,
  GChecksumType  $type
)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_get_interface_elements (GcrCertificate $self)
  returns GList
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_get_issued_date (GcrCertificate $self)
  returns GDateTime
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_get_issuer_cn (GcrCertificate $self)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_get_issuer_dn (GcrCertificate $self)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_get_issuer_name (GcrCertificate $self)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_get_issuer_part (
  GcrCertificate $self,
  Str            $part
)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_get_issuer_raw (
  GcrCertificate $self,
  gsize          $n_data
)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_get_key_size (GcrCertificate $self)
  returns guint
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_get_public_key_info (GcrCertificate $self)
  returns GcrSubjectPublicKeyInfo
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_get_serial_number (
  GcrCertificate $self,
  gsize          $n_length
)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_get_serial_number_hex (GcrCertificate $self)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_get_subject_cn (GcrCertificate $self)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_get_subject_dn (GcrCertificate $self)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_get_subject_name (GcrCertificate $self)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_get_subject_part (
  GcrCertificate $self,
  Str            $part
)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_get_subject_raw (
  GcrCertificate $self,
  gsize          $n_data
)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_get_type
  returns GType
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_get_version (GcrCertificate $self)
  returns gulong
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_is_issuer (
  GcrCertificate $self,
  GcrCertificate $issuer
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gcr_certificate_list_extensions (GcrCertificate $self)
  returns GcrCertificateExtensionList
  is      native(gcr)
  is      export
{ * }

# sub gcr_certificate_mixin_class_init (GObjectClass $object_class)
#   is      native(gcr)
#   is      export
# { * }
#
# sub gcr_certificate_mixin_emit_notify (GcrCertificate $self)
#   is      native(gcr)
#   is      export
# { * }
#
# sub gcr_certificate_mixin_get_property (
#   GObject    $obj,
#   guint      $prop_id,
#   GValue     $value,
#   GParamSpec $pspec
# )
#   is      native(gcr)
#   is      export
# { * }
