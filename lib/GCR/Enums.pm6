use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Subs;
use GCR::Raw::Definitions;
use GCR::Raw::Enums;

class GCR::Enums::Certificate::Section::Flags {
  method get_type {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &gcr_certificate_section_flags_get_type,
      $n,
      $t
    )
  }
}

sub gcr_certificate_section_flags_get_type
  returns GType
  is      native(gcr)
  is      export
{ * }
