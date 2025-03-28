use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GIO::Raw::Definitions;
use GCR::Raw::Definitions;

unit package GCR::Raw::PKCS11;

### /home/cbwood/Projects/gcr/gcr/gcr-library.h

sub gcr_pkcs11_add_module (GckModule $module)
  is      native(gcr)
  is      export
{ * }

sub gcr_pkcs11_add_module_from_file (
  Str                     $module_path,
  gpointer                $unused,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gcr_pkcs11_get_modules
  returns GList
  is      native(gcr)
  is      export
{ * }

sub gcr_pkcs11_get_trust_lookup_slots
  returns GList
  is      native(gcr)
  is      export
{ * }

sub gcr_pkcs11_get_trust_lookup_uris
  returns CArray[Str]
  is      native(gcr)
  is      export
{ * }

sub gcr_pkcs11_get_trust_store_slot
  returns GckSlot
  is      native(gcr)
  is      export
{ * }

sub gcr_pkcs11_get_trust_store_uri
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gcr_pkcs11_initialize (
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gcr_pkcs11_initialize_async (
  GCancellable $cancellable,
               &callback (gpointer, GAsyncResult, gpointer),
  gpointer     $user_data
)
  is      native(gcr)
  is      export
{ * }

sub gcr_pkcs11_initialize_finish (
  GAsyncResult            $result,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gcr_pkcs11_set_modules (GList $modules)
  is      native(gcr)
  is      export
{ * }

sub gcr_pkcs11_set_trust_lookup_uris (CArray[Str] $pkcs11_uris)
  is      native(gcr)
  is      export
{ * }

sub gcr_pkcs11_set_trust_store_uri (Str $pkcs11_uri)
  is      native(gcr)
  is      export
{ * }
