use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GIO::Raw::Definitions;
use GCR::Raw::Definitions;
use GCR::Raw::Enums;

unit package GCR::Raw::Slot;

sub gck_slot_enumerate_objects (
  GckSlot           $self,
  GckAttributes     $match,
  GckSessionOptions $options
)
  returns GckEnumerator
  is      native(gcr)
  is      export
{ * }

sub gck_slot_equal (
  GckSlot $slot1,
  GckSlot $slot2
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gck_slot_from_handle (
  GckModule $module,
  gulong    $slot_id
)
  returns GckSlot
  is      native(gcr)
  is      export
{ * }

sub gck_slot_get_handle (GckSlot $self)
  returns gulong
  is      native(gcr)
  is      export
{ * }

sub gck_slot_get_info (GckSlot $self)
  returns GckSlotInfo
  is      native(gcr)
  is      export
{ * }

sub gck_slot_get_mechanism_info (
  GckSlot $self,
  gulong  $mech_type
)
  returns GckMechanismInfo
  is      native(gcr)
  is      export
{ * }

sub gck_slot_get_mechanisms (GckSlot $self)
  returns GArray
  is      native(gcr)
  is      export
{ * }

sub gck_slot_get_module (GckSlot $self)
  returns GckModule
  is      native(gcr)
  is      export
{ * }

sub gck_slot_get_token_info (GckSlot $self)
  returns GckTokenInfo
  is      native(gcr)
  is      export
{ * }

sub gck_slot_has_flags (
  GckSlot $self,
  gulong  $flags
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gck_slot_hash (GckSlot $slot)
  returns guint
  is      native(gcr)
  is      export
{ * }

sub gck_slot_info_copy (GckSlotInfo $slot_info)
  returns GckSlotInfo
  is      native(gcr)
  is      export
{ * }

sub gck_slot_info_free (GckSlotInfo $slot_info)
  is      native(gcr)
  is      export
{ * }

sub gck_slot_info_get_type
  returns GType
  is      native(gcr)
  is      export
{ * }

sub gck_slot_match (
  GckSlot    $self,
  GckUriData $uri
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gck_slot_open_session (
  GckSlot                 $self,
  GckSessionOptions       $options,
  GTlsInteraction         $interaction,
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns GckSession
  is      native(gcr)
  is      export
{ * }

sub gck_slot_open_session_async (
  GckSlot             $self,
  GckSessionOptions   $options,
  GTlsInteraction     $interaction,
  GCancellable        $cancellable,
                      &callback (GckSlot, GAsyncResult, gpointer),
  gpointer            $user_data
)
  is      native(gcr)
  is      export
{ * }

sub gck_slot_open_session_finish (
  GckSlot                 $self,
  GAsyncResult            $result,
  CArray[Pointer[GError]] $error
)
  returns GckSession
  is      native(gcr)
  is      export
{ * }

sub gck_slot_open_session_full (
  GckSlot                 $self,
  GckSessionOptions       $options,
  GTlsInteraction         $interaction,
  gulong                  $pkcs11_flags,
  gpointer                $app_data,
                          &notify (gulong, gulong, gpointer), #= &CK_NOTIFY
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns GckSession
  is      native(gcr)
  is      export
{ * }

sub gck_slot_open_session_full_async (
  GckSlot             $self,
  GckSessionOptions   $options,
  GTlsInteraction     $interaction,
  gulong              $pkcs11_flags,
  gpointer            $app_data,
                      &notify (gulong, gulong, gpointer), #= &CK_NOTIFY
  GCancellable        $cancellable,
  GAsyncReadyCallback $callback,
  gpointer            $user_data
)
  is      native(gcr)
  is      export
{ * }

sub gck_slots_enumerate_objects (
  GList             $slots,
  GckAttributes     $match,
  GckSessionOptions $options
)
  returns GckEnumerator
  is      native(gcr)
  is      export
{ * }
