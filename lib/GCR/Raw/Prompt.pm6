use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GIO::Raw::Definitions;
use GCR::Raw::Definitions;
use GCR::Raw::Enums;

unit package GCR::Raw::Prompt;

### /home/cbwood/Projects/gcr/gcr/gcr-prompt.h

sub gcr_prompt_close (GcrPrompt $prompt)
  is      native(gcr)
  is      export
{ * }

sub gcr_prompt_confirm (
  GcrPrompt               $prompt,
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns GcrPromptReply
  is      native(gcr)
  is      export
{ * }

sub gcr_prompt_confirm_async (
  GcrPrompt    $prompt,
  GCancellable $cancellable,
               &callback (GcrPrompt, GAsyncResult, gpointer),
  gpointer     $user_data
)
  is      native(gcr)
  is      export
{ * }

sub gcr_prompt_confirm_finish (
  GcrPrompt               $prompt,
  GAsyncResult            $result,
  CArray[Pointer[GError]] $error
)
  returns GcrPromptReply
  is      native(gcr)
  is      export
{ * }

sub gcr_prompt_confirm_run (
  GcrPrompt               $prompt,
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns GcrPromptReply
  is      native(gcr)
  is      export
{ * }

sub gcr_prompt_get_caller_window (GcrPrompt $prompt)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gcr_prompt_get_cancel_label (GcrPrompt $prompt)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gcr_prompt_get_choice_chosen (GcrPrompt $prompt)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gcr_prompt_get_choice_label (GcrPrompt $prompt)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gcr_prompt_get_continue_label (GcrPrompt $prompt)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gcr_prompt_get_description (GcrPrompt $prompt)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gcr_prompt_get_message (GcrPrompt $prompt)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gcr_prompt_get_password_new (GcrPrompt $prompt)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gcr_prompt_get_password_strength (GcrPrompt $prompt)
  returns gint
  is      native(gcr)
  is      export
{ * }

sub gcr_prompt_get_title (GcrPrompt $prompt)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gcr_prompt_get_warning (GcrPrompt $prompt)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gcr_prompt_password (
  GcrPrompt               $prompt,
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gcr_prompt_password_async (
  GcrPrompt    $prompt,
  GCancellable $cancellable,
               &callback (GcrPrompt, GAsyncResult, gpointer),
  gpointer     $user_data
)
  is      native(gcr)
  is      export
{ * }

sub gcr_prompt_password_finish (
  GcrPrompt               $prompt,
  GAsyncResult            $result,
  CArray[Pointer[GError]] $error
)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gcr_prompt_password_run (
  GcrPrompt               $prompt,
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gcr_prompt_reset (GcrPrompt $prompt)
  is      native(gcr)
  is      export
{ * }

sub gcr_prompt_set_caller_window (
  GcrPrompt $prompt,
  Str       $window_id
)
  is      native(gcr)
  is      export
{ * }

sub gcr_prompt_set_cancel_label (
  GcrPrompt $prompt,
  Str       $cancel_label
)
  is      native(gcr)
  is      export
{ * }

sub gcr_prompt_set_choice_chosen (
  GcrPrompt $prompt,
  gboolean  $chosen
)
  is      native(gcr)
  is      export
{ * }

sub gcr_prompt_set_choice_label (
  GcrPrompt $prompt,
  Str       $choice_label
)
  is      native(gcr)
  is      export
{ * }

sub gcr_prompt_set_continue_label (
  GcrPrompt $prompt,
  Str       $continue_label
)
  is      native(gcr)
  is      export
{ * }

sub gcr_prompt_set_description (
  GcrPrompt $prompt,
  Str       $description
)
  is      native(gcr)
  is      export
{ * }

sub gcr_prompt_set_message (
  GcrPrompt $prompt,
  Str       $message
)
  is      native(gcr)
  is      export
{ * }

sub gcr_prompt_set_password_new (
  GcrPrompt $prompt,
  gboolean  $new_password
)
  is      native(gcr)
  is      export
{ * }

sub gcr_prompt_set_title (
  GcrPrompt $prompt,
  Str       $title
)
  is      native(gcr)
  is      export
{ * }

sub gcr_prompt_set_warning (
  GcrPrompt $prompt,
  Str       $warning
)
  is      native(gcr)
  is      export
{ * }
