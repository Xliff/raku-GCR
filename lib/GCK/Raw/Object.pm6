use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GIO::Raw::Definitions;
use GCR::Raw::Definitions;

unit package GCK::Raw::Object;

sub gck_object_destroy (
  GckObject               $self,
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gck_object_destroy_async (
  GckObject           $self,
  GCancellable        $cancellable,
  GAsyncReadyCallback $callback,
  gpointer            $user_data
)
  is      native(gcr)
  is      export
{ * }

sub gck_object_destroy_finish (
  GckObject               $self,
  GAsyncResult            $result,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gck_object_equal (
  GckObject $object1,
  GckObject $object2
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gck_object_from_handle (
  GckSession $session,
  gulong     $object_handle
)
  returns GckObject
  is      native(gcr)
  is      export
{ * }

sub gck_object_get (
  GckObject               $self,
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns GckAttributes
  is      native(gcr)
  is      export
{ * }

sub gck_object_get_async (
  GckObject           $self,
  gulong              $attr_types,
  guint               $n_attr_types,
  GCancellable        $cancellable,
  GAsyncReadyCallback $callback,
  gpointer            $user_data
)
  is      native(gcr)
  is      export
{ * }

sub gck_object_get_data (
  GckObject               $self,
  gulong                  $attr_type,
  GCancellable            $cancellable,
  gsize                   $n_data,
  CArray[Pointer[GError]] $error
)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gck_object_get_data_async (
  GckObject           $self,
  gulong              $attr_type,
  GckAllocator        $allocator,
  GCancellable        $cancellable,
  GAsyncReadyCallback $callback,
  gpointer            $user_data
)
  is      native(gcr)
  is      export
{ * }

sub gck_object_get_data_finish (
  GckObject               $self,
  GAsyncResult            $result,
  gsize                   $n_data,
  CArray[Pointer[GError]] $error
)
  returns CArray[uint8]
  is      native(gcr)
  is      export
{ * }

sub gck_object_get_data_full (
  GckObject               $self,
  gulong                  $attr_type,
  GckAllocator            $allocator,
  GCancellable            $cancellable,
  gsize                   $n_data,
  CArray[Pointer[GError]] $error
)
  returns CArray[uint8]
  is      native(gcr)
  is      export
{ * }

sub gck_object_get_finish (
  GckObject               $self,
  GAsyncResult            $result,
  CArray[Pointer[GError]] $error
)
  returns GckAttributes
  is      native(gcr)
  is      export
{ * }

sub gck_object_get_full (
  GckObject               $self,
  gulong                  $attr_types,
  guint                   $n_attr_types,
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns GckAttributes
  is      native(gcr)
  is      export
{ * }

sub gck_object_get_handle (GckObject $self)
  returns gulong
  is      native(gcr)
  is      export
{ * }

sub gck_object_get_module (GckObject $self)
  returns GckModule
  is      native(gcr)
  is      export
{ * }

sub gck_object_get_session (GckObject $self)
  returns GckSession
  is      native(gcr)
  is      export
{ * }

sub gck_object_get_template (
  GckObject               $self,
  gulong                  $attr_type,
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns GckAttributes
  is      native(gcr)
  is      export
{ * }

sub gck_object_get_template_async (
  GckObject           $self,
  gulong              $attr_type,
  GCancellable        $cancellable,
  GAsyncReadyCallback $callback,
  gpointer            $user_data
)
  is      native(gcr)
  is      export
{ * }

sub gck_object_get_template_finish (
  GckObject               $self,
  GAsyncResult            $result,
  CArray[Pointer[GError]] $error
)
  returns GckAttributes
  is      native(gcr)
  is      export
{ * }

sub gck_object_hash (GckObject $object)
  returns guint
  is      native(gcr)
  is      export
{ * }

sub gck_object_set (
  GckObject               $self,
  GckAttributes           $attrs,
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gck_object_set_async (
  GckObject           $self,
  GckAttributes       $attrs,
  GCancellable        $cancellable,
  GAsyncReadyCallback $callback,
  gpointer            $user_data
)
  is      native(gcr)
  is      export
{ * }

sub gck_object_set_finish (
  GckObject               $self,
  GAsyncResult            $result,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gck_object_set_template (
  GckObject               $self,
  gulong                  $attr_type,
  GckAttributes           $attrs,
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gck_object_set_template_async (
  GckObject           $self,
  gulong              $attr_type,
  GckAttributes       $attrs,
  GCancellable        $cancellable,
  GAsyncReadyCallback $callback,
  gpointer            $user_data
)
  is      native(gcr)
  is      export
{ * }

sub gck_object_set_template_finish (
  GckObject               $self,
  GAsyncResult            $result,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gck_objects_from_handle_array (
  GckSession $session,
  gulong     $object_handles,
  gulong     $n_object_handles
)
  returns GList
  is      native(gcr)
  is      export
{ * }
