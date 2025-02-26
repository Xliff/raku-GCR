use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GIO::Raw::Definitions;
use GCK::Raw::Definitions;

unit package GCK::Raw::Attributes;

### /home/cbwood/Projects/gcr/gck/gck.h

sub gck_attributes_at (
  GckAttributes $attrs,
  guint         $index
)
  returns GckAttribute
  is      native(gcr)
  is      export
{ * }

sub gck_attributes_contains (
  GckAttributes $attrs,
  GckAttribute  $match
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gck_attributes_count (GckAttributes $attrs)
  returns gulong
  is      native(gcr)
  is      export
{ * }

sub gck_attributes_dump (GckAttributes $attrs)
  is      native(gcr)
  is      export
{ * }

sub gck_attributes_find (
  GckAttributes $attrs,
  gulong        $attr_type
)
  returns GckAttribute
  is      native(gcr)
  is      export
{ * }

sub gck_attributes_find_boolean (
  GckAttributes $attrs,
  gulong        $attr_type,
  gboolean      $value
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gck_attributes_find_date (
  GckAttributes $attrs,
  gulong        $attr_type,
  GDate         $value
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gck_attributes_find_string (
  GckAttributes $attrs,
  gulong        $attr_type,
  CArray[Str]   $value
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gck_attributes_find_ulong (
  GckAttributes $attrs,
  gulong        $attr_type,
  gulong        $value
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gck_attributes_get_type
  returns GType
  is      native(gcr)
  is      export
{ * }

sub gck_attributes_new
  returns GckAttributes
  is      native(gcr)
  is      export
{ * }

sub gck_attributes_new_empty (gulong $first_type)
  returns GckAttributes
  is      native(gcr)
  is      export
{ * }

sub gck_attributes_ref (GckAttributes $attrs)
  returns GckAttributes
  is      native(gcr)
  is      export
{ * }

sub gck_attributes_to_string (GckAttributes $attrs)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gck_attributes_unref (gpointer $attrs)
  is      native(gcr)
  is      export
{ * }
