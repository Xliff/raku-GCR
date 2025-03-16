use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GIO::Raw::Definitions;
use GCR::Raw::Definitions;

unit package GCK::Raw::Attribute;

### /home/cbwood/Projects/gcr/gck/gck.h

sub gck_attribute_clear (GckAttribute $attr)
  is      native(gcr)
  is      export
{ * }

sub gck_attribute_dump (GckAttribute $attr)
  is      native(gcr)
  is      export
{ * }

sub gck_attribute_dup (GckAttribute $attr)
  returns GckAttribute
  is      native(gcr)
  is      export
{ * }

sub gck_attribute_equal (
  GckAttribute $attr1,
  GckAttribute $attr2
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gck_attribute_free (GckAttribute $attr)
  is      native(gcr)
  is      export
{ * }

sub gck_attribute_get_boolean (GckAttribute $attr)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gck_attribute_get_data (
  GckAttribute $attr,
  gsize        $length is rw
)
  returns CArray[uint8]
  is      native(gcr)
  is      export
{ * }

sub gck_attribute_get_date (
  GckAttribute $attr,
  GDate        $value
)
  is      native(gcr)
  is      export
{ * }

sub gck_attribute_get_string (GckAttribute $attr)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gck_attribute_get_type
  returns GType
  is      native(gcr)
  is      export
{ * }

sub gck_attribute_get_ulong (GckAttribute $attr)
  returns gulong
  is      native(gcr)
  is      export
{ * }

sub gck_attribute_hash (GckAttribute $attr)
  returns guint
  is      native(gcr)
  is      export
{ * }

sub gck_attribute_init (
  GckAttribute $attr,
  gulong       $attr_type,
  Str          $value,
  gsize        $length
)
  is      native(gcr)
  is      export
{ * }

sub gck_attribute_init_boolean (
  GckAttribute $attr,
  gulong       $attr_type,
  gboolean     $value
)
  is      native(gcr)
  is      export
{ * }

sub gck_attribute_init_copy (
  GckAttribute $dest,
  GckAttribute $src
)
  is      native(gcr)
  is      export
{ * }

sub gck_attribute_init_date (
  GckAttribute $attr,
  gulong       $attr_type,
  GDate        $value
)
  is      native(gcr)
  is      export
{ * }

sub gck_attribute_init_empty (
  GckAttribute $attr,
  gulong       $attr_type
)
  is      native(gcr)
  is      export
{ * }

sub gck_attribute_init_invalid (
  GckAttribute $attr,
  gulong       $attr_type
)
  is      native(gcr)
  is      export
{ * }

sub gck_attribute_init_string (
  GckAttribute $attr,
  gulong       $attr_type,
  Str          $value
)
  is      native(gcr)
  is      export
{ * }

sub gck_attribute_init_ulong (
  GckAttribute $attr,
  gulong       $attr_type,
  gulong       $value
)
  is      native(gcr)
  is      export
{ * }

sub gck_attribute_is_invalid (GckAttribute $attr)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gck_attribute_new (
  gulong $attr_type,
  Str    $value,
  gsize  $length
)
  returns GckAttribute
  is      native(gcr)
  is      export
{ * }

sub gck_attribute_new_boolean (
  gulong   $attr_type,
  gboolean $value
)
  returns GckAttribute
  is      native(gcr)
  is      export
{ * }

sub gck_attribute_new_date (
  gulong $attr_type,
  GDate  $value
)
  returns GckAttribute
  is      native(gcr)
  is      export
{ * }

sub gck_attribute_new_empty (gulong $attr_type)
  returns GckAttribute
  is      native(gcr)
  is      export
{ * }

sub gck_attribute_new_invalid (gulong $attr_type)
  returns GckAttribute
  is      native(gcr)
  is      export
{ * }

sub gck_attribute_new_string (
  gulong $attr_type,
  Str    $value
)
  returns GckAttribute
  is      native(gcr)
  is      export
{ * }

sub gck_attribute_new_ulong (
  gulong $attr_type,
  gulong $value
)
  returns GckAttribute
  is      native(gcr)
  is      export
{ * }
