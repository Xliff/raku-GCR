use v6.c;

use GLib::Raw::Definitions;
use GIO::Raw::Definitions;
use GCR::Raw::Definitions;
use GCR::Raw::Enums;

unit package GCR::Raw::System::Prompter;

### /home/cbwood/Projects/gcr/gcr/gcr-system-prompter.h

sub gcr_system_prompter_get_mode (GcrSystemPrompter $self)
  returns GcrSystemPrompterMode
  is      native(gcr)
  is      export
{ * }

sub gcr_system_prompter_get_prompt_type (GcrSystemPrompter $self)
  returns GType
  is      native(gcr)
  is      export
{ * }

sub gcr_system_prompter_get_prompting (GcrSystemPrompter $self)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gcr_system_prompter_get_type
  returns GType
  is      native(gcr)
  is      export
{ * }

sub gcr_system_prompter_new (
  GcrSystemPrompterMode $mode,
  GType                 $prompt_type
)
  returns GcrSystemPrompter
  is      native(gcr)
  is      export
{ * }

sub gcr_system_prompter_register (
  GcrSystemPrompter $self,
  GDBusConnection   $connection
)
  is      native(gcr)
  is      export
{ * }

sub gcr_system_prompter_unregister (
  GcrSystemPrompter $self,
  gboolean          $wait
)
  is      native(gcr)
  is      export
{ * }
