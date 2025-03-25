use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GIO::Raw::Definitions;
use GCR::Raw::Definitions;
use GCR::Raw::Enums;

unit package GCK::Raw::Module;

sub gck_module_equal (
  GckModule $module1,
  GckModule $module2
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gck_module_get_functions (GckModule $self)
  returns gpointer    # CK_FUNCTION_LIST_PTR
  is      native(gcr)
  is      export
{ * }

sub gck_module_get_info (GckModule $self)
  returns GckModuleInfo
  is      native(gcr)
  is      export
{ * }

sub gck_module_get_path (GckModule $self)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gck_module_get_slots (
  GckModule $self,
  gboolean  $token_present
)
  returns GList
  is      native(gcr)
  is      export
{ * }

sub gck_module_hash (GckModule $module)
  returns guint
  is      native(gcr)
  is      export
{ * }

sub gck_module_info_copy (GckModuleInfo $module_info)
  returns GckModuleInfo
  is      native(gcr)
  is      export
{ * }

sub gck_module_info_free (GckModuleInfo $module_info)
  is      native(gcr)
  is      export
{ * }

sub gck_module_info_get_type
  returns GType
  is      native(gcr)
  is      export
{ * }

sub gck_module_initialize (
  Str                     $path,
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns GckModule
  is      native(gcr)
  is      export
{ * }

sub gck_module_initialize_async (
  Str                 $path,
  GCancellable        $cancellable,
  GAsyncReadyCallback $callback,
  gpointer            $user_data
)
  is      native(gcr)
  is      export
{ * }

sub gck_module_initialize_finish (
  GAsyncResult            $result,
  CArray[Pointer[GError]] $error
)
  returns GckModule
  is      native(gcr)
  is      export
{ * }

sub gck_module_match (
  GckModule  $self,
  GckUriData $uri
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gck_module_new (
  gpointer $funcs #= CK_FUNCTION_LIST_PTR
)
  returns GckModule
  is      native(gcr)
  is      export
{ * }

sub gck_modules_enumerate_objects (
  GList             $modules,
  GckAttributes     $attrs,
  GckSessionOptions $session_options
)
  returns GckEnumerator
  is      native(gcr)
  is      export
{ * }

sub gck_modules_enumerate_uri (
  GList                   $modules,
  Str                     $uri,
  GckSessionOptions       $session_options,
  CArray[Pointer[GError]] $error
)
  returns GckEnumerator
  is      native(gcr)
  is      export
{ * }

sub gck_modules_get_slots (
  GList    $modules,
  gboolean $token_present
)
  returns GList
  is      native(gcr)
  is      export
{ * }

sub gck_modules_initialize_registered (
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns GList
  is      native(gcr)
  is      export
{ * }

sub gck_modules_initialize_registered_async (
  GCancellable $cancellable,
               &callback (gpointer, GAsyncResult, gpointer),
  gpointer     $user_data
)
  is      native(gcr)
  is      export
{ * }

sub gck_modules_object_for_uri (
  GList                   $modules,
  Str                     $uri,
  GckSessionOptions       $session_options,
  CArray[Pointer[GError]] $error
)
  returns GckObject
  is      native(gcr)
  is      export
{ * }

sub gck_modules_objects_for_uri (
  GList                   $modules,
  Str                     $uri,
  GckSessionOptions       $session_options,
  CArray[Pointer[GError]] $error
)
  returns GList
  is      native(gcr)
  is      export
{ * }

sub gck_modules_token_for_uri (
  GList                   $modules,
  Str                     $uri,
  CArray[Pointer[GError]] $error
)
  returns GckSlot
  is      native(gcr)
  is      export
{ * }

sub gck_modules_tokens_for_uri (
  GList                   $modules,
  Str                     $uri,
  CArray[Pointer[GError]] $error
)
  returns GList
  is      native(gcr)
  is      export
{ * }

sub gck_modules_initialize_registered_finish (
  GAsyncResult            $result,
  CArray[Pointer[GError]] $error
)
  returns GList
  is      native(gcr)
  is      export
{ * }
