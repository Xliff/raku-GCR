use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GCR::Raw::Definitions;

unit package GCR::Raw::Subject::PublicKey::Info;

### /home/cbwood/Projects/gcr/gcr/gcr-subject-public-key-info.h

sub gcr_subject_public_key_info_copy (GcrSubjectPublicKeyInfo $self)
  returns GcrSubjectPublicKeyInfo
  is      native(gcr)
  is      export
{ * }

sub gcr_subject_public_key_info_free (GcrSubjectPublicKeyInfo $self)
  is      native(gcr)
  is      export
{ * }

sub gcr_subject_public_key_info_get_algorithm_description (GcrSubjectPublicKeyInfo $self)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gcr_subject_public_key_info_get_algorithm_oid (GcrSubjectPublicKeyInfo $self)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gcr_subject_public_key_info_get_algorithm_parameters_raw (GcrSubjectPublicKeyInfo $self)
  returns GBytes
  is      native(gcr)
  is      export
{ * }

sub gcr_subject_public_key_info_get_key (GcrSubjectPublicKeyInfo $self)
  returns GBytes
  is      native(gcr)
  is      export
{ * }

sub gcr_subject_public_key_info_get_key_size (GcrSubjectPublicKeyInfo $self)
  returns gint
  is      native(gcr)
  is      export
{ * }

sub gcr_subject_public_key_info_get_type
  returns GType
  is      native(gcr)
  is      export
{ * }
