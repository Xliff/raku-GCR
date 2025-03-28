use v6.c;

use Method::Also;
use NativeCall;

use GCR::Raw::Types;
use GCR::Raw::PKCS11;

use GLib::GList;
use GCK::Module;
use GCK::Slot;

use GLib::Roles::StaticClass;

class GCR::PKCS11 {
  also does GLib::Roles::StaticClass;

  method add_module (GckModule() $module) is also<add-module> {
    gcr_pkcs11_add_module($module);
  }

  method add_module_from_file (
    Str()                   $module_path,
    gpointer                $unused       = gpointer,
    CArray[Pointer[GError]] $error        = gerror
  )
    is also<add-module-from-file>
  {
    clear_error;
    my $r = so gcr_pkcs11_add_module_from_file($module_path, $unused, $error);
    set_error($error);
    $r;
  }

  method get_modules ( :$raw = False, :gslist(:$glist) = False )
    is also<
      get-modules
      modules
    >
  {
    returnGList(
      gcr_pkcs11_get_modules(),
      $raw,
      $glist,
      |GCK::Module.getTypePair
    );
  }

  method get_trust_lookup_slots ( :$raw = False, :gslist(:$glist) = False )
    is also<
      get-trust-lookup-slots
      trust-lookup-slots
      trust_lookup_slots
    >
  {
    returnGList(
      gcr_pkcs11_get_trust_lookup_slots(),
      $raw,
      $glist,
      |GCK::Slot.getTypePair
    );
  }

  method get_trust_lookup_uris ( :$raw = False )
    is also<
      get-trust-lookup-uris
      trust-lookup-uris
      trust_lookup_uriss
    >
  {
    my $ca = gcr_pkcs11_get_trust_lookup_uris();
    return $ca if $raw;
    CArrayToArray($ca);
  }

  method get_trust_store_slot ( :$raw = False )
    is also<
      get-trust-store-slot
      trust-store-slot
      trust_store_slot
    >
  {
    propReturnObject(
      gcr_pkcs11_get_trust_store_slot(),
      $raw,
      |GCK::Slot.getTypePair
    );
  }

  method get_trust_store_uri
    is also<
      get-trust-store-uri
      trust-store-uri
      trust_store_uri
    >
  {
    gcr_pkcs11_get_trust_store_uri();
  }

  method initialize (
    GCancellable()          $cancellable = GCancellable,
    CArray[Pointer[GError]] $error       = gerror
  ) {
    clear_error;
    my $r = so gcr_pkcs11_initialize($cancellable, $error);
    set_error($error);
    $r;
  }

  proto method initialize_async (|)
    is also<initialize-async>
  { * }

  multi method initialize_async (
     &callback,
     $user_data   = gpointer,
    :$cancellable = GCancellable
  ) {
    samewith($cancellable, &callback, $user_data);
  }
  multi method initialize_async (
    GCancellable() $cancellable,
                   &callback,
    gpointer       $user_data     = gpointer
  ) {
    gcr_pkcs11_initialize_async($cancellable, &callback, $user_data);
  }

  method initialize_finish (
    GAsyncResult()          $result,
    CArray[Pointer[GError]] $error   = gerror
  )
    is also<initialize-finish>
  {
    clear_error;
    my $r = so gcr_pkcs11_initialize_finish($result, $error);
    set_error($error);
    $r;
  }

  proto method set_modules (|)
    is also<set-modules>
  { * }

  multi method set_modules (*@modules) {
    samewith(@modules);
  }
  multi method set_modules (@modules) {
    samewith( GLib::GList.new(@modules, typed => GckModule) );
  }
  multi method set_modules (GList() $modules) {
    gcr_pkcs11_set_modules($modules);
  }

  proto method set_trust_lookup_uris (|)
    is also<set-trust-lookup-uris>
  { * }

  multi method set_trust_lookup_uris (*@uris) {
    samewith(@uris);
  }
  multi method set_trust_lookup_uris (@uris) {
    samewith( ArrayToCArray(Str, @uris) );
  }
  multi method set_trust_lookup_uris (CArray[Str] $pkcs11_uris) {
    gcr_pkcs11_set_trust_lookup_uris($pkcs11_uris);
  }

  method set_trust_store_uri (Str() $pkcs11_uri)
    is also<set-trust-store-uri>
  {
    gcr_pkcs11_set_trust_store_uri($pkcs11_uri);
  }

}

INIT {
  GCR::PKCS11.initialize if $PKCS11-INITIALIZE-AT-START;
}
