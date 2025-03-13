use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GIO::Raw::Definitions;
use GCR::Raw::Definitions;
use GCR::Raw::Enums;

unit package GCK::Raw::Session;

sub gck_session_create_object (
  GckSession              $self,
  GckAttributes           $attrs,
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns GckObject
  is      native(gcr)
  is      export
{ * }

sub gck_session_create_object_async (
  GckSession     $self,
  GckAttributes  $attrs,
  GCancellable   $cancellable,
                 &callback (GckSession, GAsyncResult, gpointer),
  gpointer       $user_data
)
  is      native(gcr)
  is      export
{ * }

sub gck_session_create_object_finish (
  GckSession              $self,
  GAsyncResult            $result,
  CArray[Pointer[GError]] $error
)
  returns GckObject
  is      native(gcr)
  is      export
{ * }

sub gck_session_decrypt (
  GckSession              $self,
  GckObject               $key,
  gulong                  $mech_type,
  CArray[uint8]           $input,
  gsize                   $n_input,
  gsize                   $n_result is rw,
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns CArray[uint8]
  is      native(gcr)
  is      export
{ * }

sub gck_session_decrypt_async (
  GckSession          $self,
  GckObject           $key,
  GckMechanism        $mechanism,
  CArray[uint8]       $input,
  gsize               $n_input,
  GCancellable        $cancellable,
                      &callback (GckSession, GAsyncResult, gpointer),
  gpointer            $user_data
)
  is      native(gcr)
  is      export
{ * }

sub gck_session_decrypt_finish (
  GckSession              $self,
  GAsyncResult            $result,
  gsize                   $n_result is rw,
  CArray[Pointer[GError]] $error
)
  returns CArray[uint8]
  is      native(gcr)
  is      export
{ * }

sub gck_session_decrypt_full (
  GckSession              $self,
  GckObject               $key,
  GckMechanism            $mechanism,
  CArray[uint8]           $input,
  gsize                   $n_input,
  gsize                   $n_result is rw,
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns CArray[uint8]
  is      native(gcr)
  is      export
{ * }

sub gck_session_derive_key (
  GckSession              $self,
  GckObject               $base,
  gulong                  $mech_type,
  GckAttributes           $attrs,
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns GckObject
  is      native(gcr)
  is      export
{ * }

sub gck_session_derive_key_async (
  GckSession          $self,
  GckObject           $base,
  GckMechanism        $mechanism,
  GckAttributes       $attrs,
  GCancellable        $cancellable,
                      &callback (GckSession, GAsyncResult, gpointer),
  gpointer            $user_data
)
  is      native(gcr)
  is      export
{ * }

sub gck_session_derive_key_finish (
  GckSession              $self,
  GAsyncResult            $result,
  CArray[Pointer[GError]] $error
)
  returns GckObject
  is      native(gcr)
  is      export
{ * }

sub gck_session_derive_key_full (
  GckSession              $self,
  GckObject               $base,
  GckMechanism            $mechanism,
  GckAttributes           $attrs,
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns GckObject
  is      native(gcr)
  is      export
{ * }

sub gck_session_encrypt (
  GckSession              $self,
  GckObject               $key,
  gulong                  $mech_type,
  CArray[uint8]           $input,
  gsize                   $n_input,
  gsize                   $n_result is rw,
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns CArray[uint8]
  is      native(gcr)
  is      export
{ * }

sub gck_session_encrypt_async (
  GckSession          $self,
  GckObject           $key,
  GckMechanism        $mechanism,
  CArray[uint8]       $input,
  gsize               $n_input,
  GCancellable        $cancellable,
                      &callback (GckSession, GAsyncResult, gpointer),
  gpointer            $user_data
)
  is      native(gcr)
  is      export
{ * }

sub gck_session_encrypt_finish (
  GckSession              $self,
  GAsyncResult            $result,
  gsize                   $n_result,
  CArray[Pointer[GError]] $error
)
  returns CArray[uint8]
  is      native(gcr)
  is      export
{ * }

sub gck_session_encrypt_full (
  GckSession              $self,
  GckObject               $key,
  GckMechanism            $mechanism,
  CArray[uint8]           $input,
  gsize                   $n_input,
  gsize                   $n_result is rw,
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns CArray[uint8]
  is      native(gcr)
  is      export
{ * }

sub gck_session_enumerate_objects (
  GckSession    $self,
  GckAttributes $match
)
  returns GckEnumerator
  is      native(gcr)
  is      export
{ * }

sub gck_session_find_handles (
  GckSession              $self,
  GckAttributes           $match,
  GCancellable            $cancellable,
  gulong                  $n_handles,
  CArray[Pointer[GError]] $error
)
  returns gulong
  is      native(gcr)
  is      export
{ * }

sub gck_session_find_handles_async (
  GckSession          $self,
  GckAttributes       $match,
  GCancellable        $cancellable,
                      &callback (GckSession, GAsyncResult, gpointer),
  gpointer            $user_data
)
  is      native(gcr)
  is      export
{ * }

sub gck_session_find_handles_finish (
  GckSession              $self,
  GAsyncResult            $result,
  gulong                  $n_handles,
  CArray[Pointer[GError]] $error
)
  returns gulong
  is      native(gcr)
  is      export
{ * }

sub gck_session_find_objects (
  GckSession              $self,
  GckAttributes           $match,
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns GList
  is      native(gcr)
  is      export
{ * }

sub gck_session_find_objects_async (
  GckSession          $self,
  GckAttributes       $match,
  GCancellable        $cancellable,
                      &callback (GckSession, GAsyncResult, gpointer),
  gpointer            $user_data
)
  is      native(gcr)
  is      export
{ * }

sub gck_session_find_objects_finish (
  GckSession              $self,
  GAsyncResult            $result,
  CArray[Pointer[GError]] $error
)
  returns GList
  is      native(gcr)
  is      export
{ * }

sub gck_session_from_handle (
  GckSlot           $slot,
  gulong            $session_handle,
  GckSessionOptions $options
)
  returns GckSession
  is      native(gcr)
  is      export
{ * }

sub gck_session_generate_key_pair (
  GckSession              $self,
  gulong                  $mech_type,
  GckAttributes           $public_attrs,
  GckAttributes           $private_attrs,
  CArray[GckObject]       $public_key,
  CArray[GckObject]       $private_key,
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gck_session_generate_key_pair_async (
  GckSession          $self,
  GckMechanism        $mechanism,
  GckAttributes       $public_attrs,
  GckAttributes       $private_attrs,
  GCancellable        $cancellable,
                      &callback (GckSession, GAsyncResult, gpointer),
  gpointer            $user_data
)
  is      native(gcr)
  is      export
{ * }

sub gck_session_generate_key_pair_finish (
  GckSession              $self,
  GAsyncResult            $result,
  CArray[GckObject]       $public_key,
  CArray[GckObject]       $private_key,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gck_session_generate_key_pair_full (
  GckSession              $self,
  GckMechanism            $mechanism,
  GckAttributes           $public_attrs,
  GckAttributes           $private_attrs,
  CArray[GckObject]       $public_key,
  CArray[GckObject]       $private_key,
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gck_session_get_handle (GckSession $self)
  returns gulong
  is      native(gcr)
  is      export
{ * }

sub gck_session_get_info (GckSession $self)
  returns GckSessionInfo
  is      native(gcr)
  is      export
{ * }

sub gck_session_get_interaction (GckSession $self)
  returns GTlsInteraction
  is      native(gcr)
  is      export
{ * }

sub gck_session_get_module (GckSession $self)
  returns GckModule
  is      native(gcr)
  is      export
{ * }

sub gck_session_get_options (GckSession $self)
  returns GckSessionOptions
  is      native(gcr)
  is      export
{ * }

sub gck_session_get_slot (GckSession $self)
  returns GckSlot
  is      native(gcr)
  is      export
{ * }

sub gck_session_get_state (GckSession $self)
  returns gulong
  is      native(gcr)
  is      export
{ * }

sub gck_session_get_type
  returns GType
  is      native(gcr)
  is      export
{ * }

sub gck_session_init_pin (
  GckSession              $self,
  Str                     $pin,
  gsize                   $n_pin,
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gck_session_init_pin_async (
  GckSession          $self,
  Str                 $pin,
  gsize               $n_pin,
  GCancellable        $cancellable,
                      &callback (GckSession, GAsyncResult, gpointer),
  gpointer            $user_data
)
  is      native(gcr)
  is      export
{ * }

sub gck_session_init_pin_finish (
  GckSession              $self,
  GAsyncResult            $result,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gck_session_login (
  GckSession              $self,
  gulong                  $user_type,
  Str                     $pin,
  gsize                   $n_pin,
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gck_session_login_async (
  GckSession          $self,
  gulong              $user_type,
  Str                 $pin,
  gsize               $n_pin,
  GCancellable        $cancellable,
                      &callback (GckSession, GAsyncResult, gpointer),
  gpointer            $user_data
)
  is      native(gcr)
  is      export
{ * }

sub gck_session_login_finish (
  GckSession              $self,
  GAsyncResult            $result,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gck_session_login_interactive (
  GckSession              $self,
  gulong                  $user_type,
  GTlsInteraction         $interaction,
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gck_session_login_interactive_async (
  GckSession          $self,
  gulong              $user_type,
  GTlsInteraction     $interaction,
  GCancellable        $cancellable,
                      &callback (GckSession, GAsyncResult, gpointer),
  gpointer            $user_data
)
  is      native(gcr)
  is      export
{ * }

sub gck_session_login_interactive_finish (
  GckSession              $self,
  GAsyncResult            $result,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gck_session_logout (
  GckSession              $self,
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gck_session_logout_async (
  GckSession          $self,
  GCancellable        $cancellable,
                      &callback (GckSession, GAsyncResult, gpointer),
  gpointer            $user_data
)
  is      native(gcr)
  is      export
{ * }

sub gck_session_logout_finish (
  GckSession              $self,
  GAsyncResult            $result,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gck_session_open (
  GckSlot                 $slot,
  GckSessionOptions       $options,
  GTlsInteraction         $interaction,
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns GckSession
  is      native(gcr)
  is      export
{ * }

sub gck_session_open_async (
  GckSlot             $slot,
  GckSessionOptions   $options,
  GTlsInteraction     $interaction,
  GCancellable        $cancellable,
                      &callback (GckSession, GAsyncResult, gpointer),
  gpointer            $user_data
)
  is      native(gcr)
  is      export
{ * }

sub gck_session_open_finish (
  GAsyncResult            $result,
  CArray[Pointer[GError]] $error
)
  returns GckSession
  is      native(gcr)
  is      export
{ * }

sub gck_session_set_interaction (
  GckSession      $self,
  GTlsInteraction $interaction
)
  is      native(gcr)
  is      export
{ * }

sub gck_session_set_pin (
  GckSession              $self,
  Str                     $old_pin,
  gsize                   $n_old_pin,
  Str                     $new_pin,
  gsize                   $n_new_pin,
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gck_session_set_pin_async (
  GckSession          $self,
  Str                 $old_pin,
  gsize               $n_old_pin,
  Str                 $new_pin,
  gsize               $n_new_pin,
  GCancellable        $cancellable,
                      &callback (GckSession, GAsyncResult, gpointer),
  gpointer            $user_data
)
  is      native(gcr)
  is      export
{ * }

sub gck_session_set_pin_finish (
  GckSession              $self,
  GAsyncResult            $result,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gck_session_sign (
  GckSession              $self,
  GckObject               $key,
  gulong                  $mech_type,
  CArray[uint8]           $input,
  gsize                   $n_input,
  gsize                   $n_result is rw,
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns CArray[uint8]
  is      native(gcr)
  is      export
{ * }

sub gck_session_sign_async (
  GckSession          $self,
  GckObject           $key,
  GckMechanism        $mechanism,
  CArray[uint8]       $input,
  gsize               $n_input,
  GCancellable        $cancellable,
                      &callback (GckSession, GAsyncResult, gpointer),
  gpointer            $user_data
)
  is      native(gcr)
  is      export
{ * }

sub gck_session_sign_finish (
  GckSession              $self,
  GAsyncResult            $result,
  gsize                   $n_result is rw,
  CArray[Pointer[GError]] $error
)
  returns CArray[uint8]
  is      native(gcr)
  is      export
{ * }

sub gck_session_sign_full (
  GckSession              $self,
  GckObject               $key,
  GckMechanism            $mechanism,
  CArray[uint8]           $input,
  gsize                   $n_input,
  gsize                   $n_result is rw,
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns CArray[uint8]
  is      native(gcr)
  is      export
{ * }

sub gck_session_unwrap_key (
  GckSession              $self,
  GckObject               $wrapper,
  gulong                  $mech_type,
  CArray[uint8]           $input,
  gsize                   $n_input,
  GckAttributes           $attrs,
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns GckObject
  is      native(gcr)
  is      export
{ * }

sub gck_session_unwrap_key_async (
  GckSession          $self,
  GckObject           $wrapper,
  GckMechanism        $mechanism,
  CArray[uint8]       $input,
  gsize               $n_input,
  GckAttributes       $attrs,
  GCancellable        $cancellable,
                      &callback (GckSession, GAsyncResult, gpointer),
  gpointer            $user_data
)
  is      native(gcr)
  is      export
{ * }

sub gck_session_unwrap_key_finish (
  GckSession              $self,
  GAsyncResult            $result,
  CArray[Pointer[GError]] $error
)
  returns GckObject
  is      native(gcr)
  is      export
{ * }

sub gck_session_unwrap_key_full (
  GckSession              $self,
  GckObject               $wrapper,
  GckMechanism            $mechanism,
  CArray[uint8]           $input,
  gsize                   $n_input,
  GckAttributes           $attrs,
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns GckObject
  is      native(gcr)
  is      export
{ * }

sub gck_session_verify (
  GckSession              $self,
  GckObject               $key,
  gulong                  $mech_type,
  CArray[uint8]           $input,
  gsize                   $n_input,
  CArray[uint8]           $signature,
  gsize                   $n_signature,
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gck_session_verify_async (
  GckSession          $self,
  GckObject           $key,
  GckMechanism        $mechanism,
  CArray[uint8]       $input,
  gsize               $n_input,
  CArray[uint8]       $signature,
  gsize               $n_signature,
  GCancellable        $cancellable,
                      &callback (GckSession, GAsyncResult, gpointer),
  gpointer            $user_data
)
  is      native(gcr)
  is      export
{ * }

sub gck_session_verify_finish (
  GckSession              $self,
  GAsyncResult            $result,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gck_session_verify_full (
  GckSession              $self,
  GckObject               $key,
  GckMechanism            $mechanism,
  CArray[uint8]           $input,
  gsize                   $n_input,
  CArray[uint8]           $signature,
  gsize                   $n_signature,
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gck_session_wrap_key (
  GckSession              $self,
  GckObject               $wrapper,
  gulong                  $mech_type,
  GckObject               $wrapped,
  gsize                   $n_result is rw,
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns CArray[uint8]
  is      native(gcr)
  is      export
{ * }

sub gck_session_wrap_key_async (
  GckSession          $self,
  GckObject           $wrapper,
  GckMechanism        $mechanism,
  GckObject           $wrapped,
  GCancellable        $cancellable,
                      &callback (GckSession, GAsyncResult, gpointer),
  gpointer            $user_data
)
  is      native(gcr)
  is      export
{ * }

sub gck_session_wrap_key_finish (
  GckSession              $self,
  GAsyncResult            $result,
  gsize                   $n_result is rw,
  CArray[Pointer[GError]] $error
)
  returns CArray[uint8]
  is      native(gcr)
  is      export
{ * }

sub gck_session_wrap_key_full (
  GckSession              $self,
  GckObject               $wrapper,
  GckMechanism            $mechanism,
  GckObject               $wrapped,
  gsize                   $n_result is rw,
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns CArray[uint8]
  is      native(gcr)
  is      export
{ * }
