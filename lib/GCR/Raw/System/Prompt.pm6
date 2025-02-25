use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GIO::Raw::Definitions;
use GCR::Raw::Definitions;

unit package GCR::Raw::System::Prompt;

### /home/cbwood/Projects/gcr/gcr/gcr-system-prompt.h

sub gcr_system_prompt_close (
  GcrSystemPrompt         $self,
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gcr_system_prompt_close_async (
  GcrSystemPrompt $self,
  GCancellable    $cancellable,
                  &callback (GcrSystemPrompt, GAsyncResult, gpointer),
  gpointer        $user_data
)
  is      native(gcr)
  is      export
{ * }

sub gcr_system_prompt_close_finish (
  GcrSystemPrompt         $self,
  GAsyncResult            $result,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gcr_system_prompt_error_get_domain
  returns GQuark
  is      native(gcr)
  is      export
{ * }

sub gcr_system_prompt_get_secret_exchange (GcrSystemPrompt $self)
  returns GcrSecretExchange
  is      native(gcr)
  is      export
{ * }

sub gcr_system_prompt_get_type
  returns GType
  is      native(gcr)
  is      export
{ * }

sub gcr_system_prompt_open (
  gint                    $timeout_seconds,
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns GcrPrompt
  is      native(gcr)
  is      export
{ * }

sub gcr_system_prompt_open_async (
  gint         $timeout_seconds,
  GCancellable $cancellable,
               &callback (GcrSystemPrompt, GAsyncResult, gpointer),
  gpointer     $user_data
)
  is      native(gcr)
  is      export
{ * }

sub gcr_system_prompt_open_finish (
  GAsyncResult            $result,
  CArray[Pointer[GError]] $error
)
  returns GcrPrompt
  is      native(gcr)
  is      export
{ * }

sub gcr_system_prompt_open_for_prompter (
  Str                     $prompter_name,
  gint                    $timeout_seconds,
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns GcrPrompt
  is      native(gcr)
  is      export
{ * }

sub gcr_system_prompt_open_for_prompter_async (
  Str          $prompter_name,
  gint         $timeout_seconds,
  GCancellable $cancellable,
               &callback (GcrSystemPrompt, GAsyncResult, gpointer),
  gpointer     $user_data
)
  is      native(gcr)
  is      export
{ * }
