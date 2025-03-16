use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GIO::Raw::Definitions;
use GIO::Raw::Structs;
use GCR::Raw::Definitions;
use GCR::Raw::Enums;

unit package GCR::Raw::Definitions;

### /home/cbwood/Projects/gcr/gcr/gcr-parser.h

sub gcr_parser_add_password (
  GcrParser $self,
  Str       $password
)
  is      native(gcr)
  is      export
{ * }

sub gcr_parser_format_disable (
  GcrParser     $self,
  GcrDataFormat $format
)
  is      native(gcr)
  is      export
{ * }

sub gcr_parser_format_enable (
  GcrParser     $self,
  GcrDataFormat $format
)
  is      native(gcr)
  is      export
{ * }

sub gcr_parser_format_supported (
  GcrParser     $self,
  GcrDataFormat $format
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gcr_parsed_get_attributes (GcrParsed $parsed)
  returns GckAttributes
  is      native(gcr)
  is      export
{ * }

sub gcr_parsed_get_bytes (GcrParsed $parsed)
  returns GBytes
  is      native(gcr)
  is      export
{ * }

sub gcr_parsed_get_data (
  GcrParsed $parsed,
  gsize     $n_data
)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gcr_parsed_get_description (GcrParsed $parsed)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gcr_parsed_get_filename (GcrParsed $parsed)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gcr_parsed_get_format (GcrParsed $parsed)
  returns GcrDataFormat
  is      native(gcr)
  is      export
{ * }

sub gcr_parsed_get_label (GcrParsed $parsed)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gcr_parsed_get_type
  returns GType
  is      native(gcr)
  is      export
{ * }

sub gcr_parsed_ref (GcrParsed $parsed)
  returns GcrParsed
  is      native(gcr)
  is      export
{ * }

sub gcr_parsed_unref (GcrParsed $parsed)
  is      native(gcr)
  is      export
{ * }

sub gcr_parser_get_filename (GcrParser $self)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gcr_parser_get_parsed (GcrParser $self)
  returns GcrParsed
  is      native(gcr)
  is      export
{ * }

sub gcr_parser_get_parsed_attributes (GcrParser $self)
  returns GckAttributes
  is      native(gcr)
  is      export
{ * }

sub gcr_parser_get_parsed_block (
  GcrParser $self,
  gsize     $n_block
)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gcr_parser_get_parsed_bytes (GcrParser $self)
  returns GBytes
  is      native(gcr)
  is      export
{ * }

sub gcr_parser_get_parsed_description (GcrParser $self)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gcr_parser_get_parsed_format (GcrParser $self)
  returns GcrDataFormat
  is      native(gcr)
  is      export
{ * }

sub gcr_parser_get_parsed_label (GcrParser $self)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gcr_parser_get_type
  returns GType
  is      native(gcr)
  is      export
{ * }

sub gcr_parser_new
  returns GcrParser
  is      native(gcr)
  is      export
{ * }

sub gcr_parser_parse_bytes (
  GcrParser               $self,
  GBytes                  $data,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gcr_parser_parse_data (
  GcrParser               $self,
  CArray[uint8]           $data,
  gsize                   $n_data,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gcr_parser_parse_stream (
  GcrParser               $self,
  GInputStream            $input,
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gcr_parser_parse_stream_async (
  GcrParser    $self,
  GInputStream $input,
  GCancellable $cancellable,
               &callback (GcrParser, GAsyncResult, gpointer),
  gpointer     $user_data
)
  is      native(gcr)
  is      export
{ * }

sub gcr_parser_parse_stream_finish (
  GcrParser               $self,
  GAsyncResult            $result,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gcr_parser_set_filename (
  GcrParser $self,
  Str       $filename
)
  is      native(gcr)
  is      export
{ * }
