use v6.c;

use Method::Also;

use NativeCall;

use GCR::Raw::Types;
use GCK::Raw::Module;

use GLib::GList;
use GCK::Enumerator;
use GCK::Object;
use GCK::Session;
use GCK::Slot;

use GLib::Roles::Implementor;
use GLib::Roles::Object;
use GLib::Roles::StaticClass;
use GCK::Roles::Signals::Module;

our subset GckModuleAncestry is export of Mu
  where GckModule | GObject;

class GCK::Module {
  also does GLib::Roles::Object;
  also does GCK::Roles::Signals::Module;

  has GckModule $!gm is implementor;

  submethod BUILD ( :$gck-module ) {
    self.setGckModule($gck-module) if $gck-module
  }

  method setGckModule (GckModuleAncestry $_) {
    my $to-parent;

    $!gm = do {
      when GckModule {
        $to-parent = cast(GObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GckModule, $_);
      }
    }
    self!setObject($to-parent);
  }

  method GCR::Raw::Definitions::GckModule
    is also<GckModule>
  { $!gm }

  multi method new ($gck-module where * ~~ GckModuleAncestry , :$ref = True) {
    return unless $gck-module;

    my $o = self.bless( :$gck-module );
    $o.ref if $ref;
    $o;
  }
  multi method new (gpointer $funcs) {
    my $gck-module = gck_module_new($funcs);

    $gck-module ?? self.bless( :$gck-module ) !! Nil;
  }
  multi method new (
    $path,
    $cancellable = GCancellable,
    $error       = gerror
  ) {
    self.initialize($path, $cancellable, $error);
  }
  method initialize (
    Str()                   $path,
    GCancellable()          $cancellable = GCancellable,
    CArray[Pointer[GError]] $error       = gerror
  ) {
    clear_error;
    my $gck-module = gck_module_initialize($!gm, $cancellable, $error);
    set_error($error);

    $gck-module ?? self.bless( :$gck-module ) !! Nil;
  }
  multi method new (
                    $path,
                    &callback,
                    $error              = gerror,
    GCancellable() :$cancellable        = GCancellable,
                   :$async is required
  ) {
    self.initialize_async($path, $cancellable, &callback, $error);
  }
  method initialize_async (
    Str()          $path,
    GCancellable() $cancellable,
                   &callback,
    gpointer       $user_data = gpointer
  )
    is also<initialize-async>
  {
    gck_module_initialize_async($!gm, $cancellable, &callback, $user_data);
  }
  multi method new_finish ($result, $error = gerror)  is also<new-finish> {
    self.initialize_finish($result, $error);
  }
  method initialize_finish (
    GAsyncResult()          $result,
    CArray[Pointer[GError]] $error   = gerror;
  )
    is also<initialize-finish>
  {
    clear_error;
    my $gck-module = gck_module_initialize_finish($result, $error);
    set_error($error);

    $gck-module ?? self.bless( :$gck-module ) !! Nil;
  }

  method Authenticate-Object ( :$raw = False ) {
    self.connect-authenticate-object($!gm, :$raw);
  }

  method Authenticate-Slot ( :$raw = False ) {
    self.connect-authenticate-slot($!gm, :$raw);
  }

  method equal (GckModule() $module2) {
    gck_module_equal($!gm, $module2);
  }

  method get_functions is also<get-functions> {
    gck_module_get_functions($!gm);
  }

  method get_info is also<get-info> {
    gck_module_get_info($!gm);
  }

  method get_path is also<get-path> {
    gck_module_get_path($!gm);
  }

  method get_slots (
    Int()  $token_present,
          :$raw            = False,
          :gslist(:$glist) = False
 )
    is also<get-slots>
  {
    my gboolean $t = $token_present.so.Int;

    returnGList(
      gck_module_get_slots($!gm, $t),
      $raw,
      $glist,
      |GCK::Slot.getTypePair
    )
  }

  method hash {
    gck_module_hash($!gm);
  }

  method match (GckUriData() $uri) {
    so gck_module_match($!gm, $uri);
  }

}

class GCK::Modules {
  also does GLib::Roles::StaticClass;

  method enumerate_objects (
    GList()          $modules,
    GckAttributes()  $attrs,
    Int()            $session_options      = 0,
                    :$raw                  = False,
                    :$rw,
                    :$user,
                    :auth(:$authenticate)
  )
    is also<enumerate-objects>
  {
    my GckSessionOptions $o = processSessionOptions(
       $session_options,
      :$rw,
      :$user,
      :$authenticate
    );

    propReturnObject(
      gck_modules_enumerate_objects($modules, $attrs, $o),
      $raw,
      |GCK::Enumerator.getTypePair
    );
  }

  method enumerate_uri (
    GList()                  $modules,
    Str()                    $uri,
    Int()                    $session_options      = 0,
    CArray[Pointer[GError]]  $error                = gerror,
                            :$raw                  = False,
                            :$rw,
                            :$user,
                            :auth(:$authenticate)
  )
    is also<enumerate-uri>
  {
    clear_error;
    my $r = gck_modules_enumerate_uri(
      $modules,
      $uri,
      $session_options,
      $error
    );
    set_error($error);
    propReturnObject($r, $raw, |GCK::Enumerator.getTypePair)
  }

  method get_slots (
    GList()  $modules,
    Int()    $token_present,
            :$raw            = False,
            :gslist(:$glist) = False
  )
    is also<get-slots>
  {
    my gboolean $t = $token_present.so.Int;

    propReturnObject(
      gck_modules_get_slots($modules, $t),
      $raw,
      $glist,
      |GCK::Slot.getTypePair
    );
  }

  method initialize_registered (
    GCancellable()           $cancellable    = GCancellable,
    CArray[Pointer[GError]]  $error          = gerror,
                            :$raw            = False,
                            :gslist(:$glist) = False
  )
    is also<initialize-registered>
  {
    clear_error;
    my $r = gck_modules_initialize_registered($cancellable, $error);
    set_error($error);
    returnGList($r, $raw, $glist, |GCK::Module.getTypePair);
  }

  method initialize_registered_async (
    GCancellable() $cancellable,
                   &callback     = GCancellable,
    gpointer       $user_data    = gpointer
  )
    is also<initialize-registered-async>
  {
    gck_modules_initialize_registered_async(
      $cancellable,
      &callback,
      $user_data
    );
  }

  method initialize_registered_finish (
    GAsyncResult()           $result,
    CArray[Pointer[GError]]  $error          = gerror,
                            :$raw            = False,
                            :gslist(:$glist) = False
  )
    is also<initialize-registered-finish>
  {
    clear_error;
    my $r = gck_modules_initialize_registered_finish($result, $error);
    set_error($error);
    returnGList($r, $raw, $glist, |GCK::Modules.getTypePair)
  }

  method tokens_for_uri (
    GList()                  $modules,
    Str()                    $uri,
    CArray[Pointer[GError]]  $error          = gerror,
                            :$raw            = False,
                            :gslist(:$glist) = False
  )
    is also<tokens-for-uri>
  {
    returnGList(
      gck_modules_tokens_for_uri($modules, $uri, $error),
      $raw,
      $glist,
      |GCK::Slot.getTypePair
    );
  }

  proto method object_for_uri (|)
    is also<object-for-uri>
  { * }

  multi method object_for_uri (
     $modules,
     $uri,
     $error                                       = gerror,
    :options(:session-options(:$session_options)) = 0,
    :$rw,
    :$user,
    :auth(:$authenticate)
  ) {
    samewith(
      $modules,
      $uri,
      processSessionOptions($session_options, :$rw, :$user, :$authenticate);
      $error
    )
  }
  multi method object_for_uri (
    GList()                  $modules,
    Str()                    $uri,
    Int()                    $session_options  = 0,
    CArray[Pointer[GError]]  $error            = gerror,
                            :$raw              = False
  ) {
    my GckSessionOptions $s = $session_options;

    clear_error;
    my $r = gck_modules_object_for_uri($modules, $uri, $s, $error);
    set_error($error);

    propReturnObject($r, $raw, |GCK::Object.getTypePair);
  }

  proto method objects_for_uri (|)
    is also<objects-for-uri>
  { * }

  multi method objects_for_uri (
     $modules,
     $uri,
     $error                                       = gerror,
    :$raw                                         = False,
    :gslist(:$glist)                              = False,
    :options(:session-options(:$session_options)) = 0,
    :$rw,
    :$user,
    :auth(:$authenticate)
  ) {
    samewith(
       $modules,
       $uri,
       processSessionOptions($session_options, :$rw, :$user, :$authenticate),
       $error,
      :$raw,
      :$glist
    )
  }
  multi method objects_for_uri (
    GList()                  $modules,
    Str()                    $uri,
    Int()                    $session_options,
    CArray[Pointer[GError]]  $error            = gerror,
                            :$raw              = False,
                            :gslist(:$glist)   = False
  ) {
    my GckSessionOptions $s = $session_options;

    clear_error;
    my $r = gck_modules_objects_for_uri(
      $modules,
      $uri,
      $s,
      $error
    );
    set_error($error);
    returnGList($r, $raw, $glist, |GCK::Object.getTypePair)
  }

}

class GCK::Module::Info {
  also does GLib::Roles::Implementor;

  has GckModuleInfo $!gm is implementor;

  submethod BUILD ( :$gck-module-info ) {
    $!gm = $gck-module-info if $gck-module-info
  }

  method GCR::Raw::Definitions::GckModuleInfo
    is also<GckModuleInfo>
  { $!gm }

  method new (GckModuleInfo $gck-module-info) {
    $gck-module-info ?? self.bless( :$gck-module-info ) !! Nil;
  }

  method copy ( :$raw = False ) {
    propReturnObject(
      gck_module_info_copy($!gm),
      $raw,
      |self.getTypePair
    );
  }

  method free {
    gck_module_info_free($!gm);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gck_module_info_get_type, $n, $t );
  }

}
