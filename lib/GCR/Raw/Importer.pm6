use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GIO::Raw::Definitions;
use GCR::Raw::Definitions;

unit package GCR::Raw::Importer;

### /home/cbwood/Projects/gcr/gcr/gcr-importer.h

sub gcr_importer_create_for_parsed (GcrParsed $parsed)
  returns GList
  is      native(gcr)
  is      export
{ * }

sub gcr_importer_get_interaction (GcrImporter $importer)
  returns GTlsInteraction
  is      native(gcr)
  is      export
{ * }

sub gcr_importer_import_async (
  GcrImporter   $importer,
  GCancellable  $cancellable,
                &callback (GcrImporter, GAsyncResult, gpointer),
  gpointer      $user_data
)
  is      native(gcr)
  is      export
{ * }

sub gcr_importer_import_finish (
  GcrImporter             $importer,
  GAsyncResult            $result,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gcr_importer_queue_and_filter_for_parsed (
  GList     $importers,
  GcrParsed $parsed
)
  returns GList
  is      native(gcr)
  is      export
{ * }

sub gcr_importer_queue_for_parsed (
  GcrImporter $importer,
  GcrParsed   $parsed
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gcr_importer_register (
  GType         $importer_type,
  GckAttributes $attrs
)
  is      native(gcr)
  is      export
{ * }

sub gcr_importer_register_well_known
  is      native(gcr)
  is      export
{ * }

sub gcr_importer_set_interaction (
  GcrImporter     $importer,
  GTlsInteraction $interaction
)
  is      native(gcr)
  is      export
{ * }
