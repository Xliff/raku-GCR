use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GIO::Raw::Definitions;
use GCR::Raw::Definitions;

unit package GCK::Raw::Enumerator;

sub gck_enumerator_get_chained (GckEnumerator $self)
  returns GckEnumerator
  is      native(gcr)
  is      export
{ * }

sub gck_enumerator_get_interaction (GckEnumerator $self)
  returns GTlsInteraction
  is      native(gcr)
  is      export
{ * }

sub gck_enumerator_get_object_type (GckEnumerator $self)
  returns GType
  is      native(gcr)
  is      export
{ * }

sub gck_enumerator_next (
  GckEnumerator           $self,
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns GckObject
  is      native(gcr)
  is      export
{ * }

sub gck_enumerator_next_async (
  GckEnumerator $self,
  gint          $max_objects,
  GCancellable  $cancellable,
                &callback (GckEnumerator, GAsyncResult, gpointer),
  gpointer      $user_data
)
  is      native(gcr)
  is      export
{ * }

sub gck_enumerator_next_finish (
  GckEnumerator           $self,
  GAsyncResult            $result,
  CArray[Pointer[GError]] $error
)
  returns GList
  is      native(gcr)
  is      export
{ * }

sub gck_enumerator_next_n (
  GckEnumerator           $self,
  gint                    $max_objects,
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns GList
  is      native(gcr)
  is      export
{ * }

sub gck_enumerator_set_chained (
  GckEnumerator $self,
  GckEnumerator $chained
)
  is      native(gcr)
  is      export
{ * }

sub gck_enumerator_set_interaction (
  GckEnumerator   $self,
  GTlsInteraction $interaction
)
  is      native(gcr)
  is      export
{ * }

sub gck_enumerator_set_object_type (
  GckEnumerator $self,
  GType         $object_type
)
  is      native(gcr)
  is      export
{ * }

sub gck_enumerator_set_object_type_full (
  GckEnumerator  $self,
  GType          $object_type,
  CArray[gulong] $attr_types,
  gint           $attr_count
)
  is      native(gcr)
  is      export
{ * }
