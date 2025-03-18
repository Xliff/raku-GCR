use v6.c;

use Method::Also;

use NativeCall;

use GCR::Raw::Types;
use GCK::Raw::Session;

use GLib::GList;
use GIO::TlsInteraction;
use GCK::Object;

use GLib::Roles::Implementor;
use GLib::Roles::Object;

our subset GckSessionAncestry is export of Mu
  where GckSession | GObject;

class GCK::Session {
  also does GLib::Roles::Object;

  has GckSession $!gs is implementor;

  submethod BUILD ( :$gck-session ) {
    self.setGckSession($gck-session) if $gck-session
  }

  method setGckSession (GckSessionAncestry $_) {
    my $to-parent;

    $!gs = do {
      when GckSession {
        $to-parent = cast(GObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GckSession, $_);
      }
    }
    self!setObject($to-parent);
  }

  method GCR::Raw::Definitions::GckSession
    is also<GckSession>
  { $!gs }

  multi method new (
    $gck-session where * ~~ GckSessionAncestry,

    :$ref = True
  ) {
    return unless $gck-session;

    my $o = self.bless( :$gck-session );
    $o.ref if $ref;
    $o;
  }
  multi method new ($slot, $session_handle, $options) {
    self.from_handle($slot, $session_handle, $options)
  }
  method from_handle (
    GckSlot() $slot,
    Int()     $session_handle,
    Int()     $options
  )
    is also<from-handle>
  {
    my gulong            $s = $session_handle;
    my GckSessionOptions $o = $options;

    my $gck-session = gck_session_from_handle($slot, $s, $o);

    $gck-session ?? self.bless( :$gck-session ) !! Nil;
  }

  multi method open (
    GckSlot()                $slot,
    CArray[Pointer[GError]]  $error              = gerror,
    Int()                   :$options            = GCK_SESSION_READ_WRITE,
    GTlsInteraction()       :$interaction        = GTlsInteraction,
    GCancellable()          :$cancellable        = GCancellable,
                            :$ro,
                            :$rw,
                            :$login,
                            :authenticate($auth)
  ) {
    samewith(
      $slot,
      processSessionOptions($options, :$ro, :$rw, :$login, :$auth),
      $interaction,
      $cancellable,
      $error
    );
  }
  multi method open (
    GckSlot()               $slot,
    Int()                   $options,
    GTlsInteraction()       $interaction,
    GCancellable()          $cancellable  = GCancellable,
    CArray[Pointer[GError]] $error        = gerror
  ) {
    my GckSessionOptions $o = $options;

    clear_error;
    my $gck-session = gck_session_open(
      $slot,
      $o,
      $interaction,
      $cancellable,
      $error
    );
    set_error($error);

    $gck-session ?? self.bless( :$gck-session ) !! Nil;
  }

  proto method open_async (|)
    is also<open-async>
  { * }

  multi method open_async (
     $slot,
     &callback,
     $user_data           = gpointer,
    :$options             = GCK_SESSION_READ_WRITE,
    :$interaction         = GTlsInteraction,
    :$cancellable         = GCancellable,
    :$ro,
    :$rw,
    :$login,
    :authenticate($auth)
  ) {
    samewith(
      $slot,
      processSessionOptions($options, :$ro, :$rw, :$login, :$auth),
      $interaction,
      $cancellable,
      &callback,
      $user_data
    );
  }
  multi method open_async (
    GckSlot()         $slot,
    Int()             $options,
    GTlsInteraction() $interaction,
    GCancellable()    $cancellable,
                      &callback,
    gpointer          $user_data     = gpointer
  ) {
    gck_session_open_async(
      $slot,
      $options,
      $interaction,
      $cancellable,
      &callback,
      $user_data
    );
  }

  method open_finish (
    GAsyncResult()          $result,
    CArray[Pointer[GError]] $error   = gerror
  )
    is also<open-finish>
  {
    clear_error;
    my $gck-session = gck_session_open_finish($result, $error);
    set_error($error);

    $gck-session ?? self.bless( :$gck-session ) !! Nil;
  }

  # Type: pointer
  method app-data is rw  is g-property is also<app_data> {
    my $gv = GLib::Value.new( G_TYPE_POINTER );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('app-data', $gv);
        $gv.pointer;
      },
      STORE => -> $, gpointer $val is copy {
        $gv.pointer = $val;
        self.prop_set('app-data', $gv);
      }
    );
  }

  # Type: uint64
  method handle is rw  is g-property {
    my $gv = GLib::Value.new( G_TYPE_ULONG );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('handle', $gv);
        $gv.uint64;
      },
      STORE => -> $, Str() $val is copy {
        $gv.uint64 = $val;
        self.prop_set('handle', $gv);
      }
    );
  }

  method module ( :$raw = False ) is rw  is g-property {
    my $gv = GLib::Value.new( GCK::Module.get_type );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('module', $gv);
        propReturnObject(
          $gv.object,
          $raw,
          |GCK::Module.getTypePair
        );
      },
      STORE => -> $, GckModule() $val is copy {
        $gv.object = $val;
        self.prop_set('module', $gv);
      }
    );
  }

  # Type: uint64
  method opening-flags is rw  is g-property is also<opening_flags> {
    my $gv = GLib::Value.new( G_TYPE_ULONG );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('opening-flags', $gv);
        $gv.uint64;
      },
      STORE => -> $, Str() $val is copy {
        $gv.uint64 = $val;
        self.prop_set('opening-flags', $gv);
      }
    );
  }

  method slot ( :$raw = False ) is rw  is g-property {
    my $gv = GLib::Value.new( GCK::Slot.get_type );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('slot', $gv);
        propReturnObject(
          $gv.object,
          $raw,
          |GCK::Slot.getTypePair
        );
      },
      STORE => -> $, GckModule() $val is copy {
        $gv.object = $val;
        self.prop_set('slot', $gv);
      }
    );
  }

  method interaction ( :$raw = False ) is rw  is g-property {
    my $gv = GLib::Value.new( GIO::TlsInteraction.get_type );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('interaction', $gv);
        propReturnObject(
          $gv.object,
          $raw,
          |GIO::TlsInteraction.getTypePair
        );
      },
      STORE => -> $, GTlsInteraction() $val is copy {
        $gv.object = $val;
        self.prop_set('interaction', $gv);
      }
    );
  }

  # Type: GckSessionOptions
  method options ( :set(:$flags) = False ) is rw  is g-property {
    my $gv = GLib::Value.new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('options', $gv);
        my $f = $gv.uint;
        return $f unless $flags;
        getFlags(GckSessionOptionsEnum, $f);
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('options', $gv);
      }
    );
  }

  method Discard-Handle is g-signal is also<Discard_Handle> {
    self.connect-ulong($!gs, 'discard-handle');
  }

  method create_object (
    GckAttributes()          $attrs,
    GCancellable()           $cancellable = GCancellable,
    CArray[Pointer[GError]]  $error       = gerror,
                            :$raw         = False
  )
    is also<create-object>
  {
    clear_error;
    my $o = gck_session_create_object($!gs, $attrs, $cancellable, $error);
    set_error($error);
    propReturnObject($o, $raw, |GCK::Object.getTypePair);
  }

  proto method create_object_async (|)
    is also<create-object-async>
  { * }

  multi method create_object_async (
     $attrs,
     &callback,
     $user_data   = gpointer,
    :$cancellable = GCancellable
  ) {
    samewith(
      $attrs,
      $cancellable,
      &callback,
      $user_data
    );
  }
  multi method create_object_async (
    GckAttributes() $attrs,
    GCancellable()  $cancellable,
                    &callback,
    gpointer        $user_data     = gpointer
  ) {
    gck_session_create_object_async(
      $!gs,
      $attrs,
      $cancellable,
      &callback,
      $user_data
    );
  }

  method create_object_finish (
    GAsyncResult()           $result,
    CArray[Pointer[GError]]  $error    = gerror,
                            :$raw      = False
  )
    is also<create-object-finish>
  {
    clear_error;
    my $o = gck_session_create_object_finish($!gs, $result, $error);
    set_error($error);
    propReturnObject($o, $raw, |GCK::Object.getTypePair);
  }

  multi method decrypt (
         $key,
         $mech_type,
    Str  $input,
         $cancellable        = GCancellable,
         $error              = gerror,
        :$encoding           = 'utf8',
        :$raw                = False
  ) {
    samewith(
       $key,
       $mech_type,
       $input.encode($encoding),
       $cancellable,
       $error,
      :$raw
    );
  }
  multi method decrypt (
          $key,
          $mech_type,
    Blob  $input,
          $cancellable        = GCancellable,
          $error              = gerror,
         :$raw                = False
  ) {
    samewith(
       $key,
       $mech_type,
       CArray.new($input),
       $input.bytes,
       $cancellable,
       $error,
      :$raw
    );
  }
  multi method decrypt (
     $key,
     $mech_type,
     @input,
     $cancellable        = GCancellable,
     $error              = gerror,
    :$raw                = False
  ) {
    samewith(
       $key,
       $mech_type,
       ArrayToCArray(@input, typed => uint8),
       @input.elems,
       $,
       $cancellable,
       $error,
      :$raw
    );
  }
  multi method decrypt (
                   $key,
                   $mech_type,
    CArray[uint8]  $input,
                   $size,
                   $cancellable        = GCancellable,
                   $error              = gerror,
                  :$raw                = False
  ) {
    samewith(
       $key,
       $mech_type,
       $input,
       $size,
       $,
       $cancellable,
       $error,
      :$raw
    );
  }
  multi method decrypt (
    GckObject()              $key,
    Int()                    $mech_type,
    CArray[uint8]            $input,
    Int()                    $n_input,
                             $n_result    is rw,
    GCancellable()           $cancellable        = GCancellable,
    CArray[Pointer[GError]]  $error              = gerror,
                            :$raw                = False
  ) {
    my gulong $m  = $mech_type;
    my gsize  $ni = $n_input;
    my gsize  $no = 0;

    my $r = gck_session_decrypt(
      $!gs,
      $key,
      $m,
      $input,
      $ni,
      $no,
      $cancellable,
      $error
    );
    $n_result = $no;
    return ($r, $no) if $raw;
    SizedCArray.new($r, $no);
  }

  proto method decrypt_async (|)
    is also<decrypt-async>
  { * }

  multi method decrypt_async (
                     $key,
                     $mechanism,
    Str              $input,
                     &callback,
                     $user_data   = gpointer,
                    :$encoding    = 'utf8',
    GCancellable()  :$cancellable = GCancellable
  ) {
    samewith(
      $key,
      $mechanism,
      $input.encode($encoding),
      $cancellable,
      &callback,
      $user_data
    );
  }
  multi method decrypt_async (
                     $key,
                     $mechanism,
    Blob             $input,
                     &callback,
                     $user_data   = gpointer,
    GCancellable()  :$cancellable = GCancellable
  ) {
    samewith(
      $key,
      $mechanism,
      CArray[uint8].new($input),
      $input.bytes,
      $cancellable,
      &callback,
      $user_data
    );
  }
  multi method decrypt_async (
                     $key,
                     $mechanism,
                     @input,
                     &callback,
                     $user_data   = gpointer,
    GCancellable()  :$cancellable = GCancellable
  ) {
    samewith(
      $key,
      $mechanism,
      ArrayToCArray(@input, typed => uint8),
      @input.elems,
      $cancellable,
      &callback,
      $user_data
    );
  }
  multi method decrypt_async (
                     $key,
                     $mechanism,
    CArray[uint8]    $input,
                     $n_input,
                     &callback,
                     $user_data   = gpointer,
    GCancellable()  :$cancellable = GCancellable
  ) {
    samewith(
      $key,
      $mechanism,
      $input,
      $n_input,
      $cancellable,
      &callback,
      $user_data
    );
  }
  multi method decrypt_async (
    GckObject()     $key,
    GckMechanism()  $mechanism,
    CArray[uint8]   $input,
    Int()           $n_input,
    GCancellable()  $cancellable,
                    &callback,
    gpointer        $user_data
  ) {
    my gsize $n = $n_input;

    gck_session_decrypt_async(
      $!gs,
      $key,
      $mechanism,
      $input,
      $n,
      $cancellable,
      &callback,
      $user_data
    );
  }

  proto method decrypt_finish (|)
    is also<decrypt-finish>
  { * }

  multi method decrypt_finish (
    GAsyncResult()           $result,
    CArray[Pointer[GError]]  $error   = gerror,
                            :$raw     = False
  ) {
    samewith($result, $, $error);
  }
  multi method decrypt_finish (
    GAsyncResult()           $result,
                             $n_result is rw,
    CArray[Pointer[GError]]  $error,
                            :$raw = False
  ) {
    my gsize $n = 0;

    clear_error;
    my $r = gck_session_decrypt_finish($!gs, $result, $n, $error);
    $n_result = $n;
    set_error($error);
    return ($r, $n) if $raw;
    SizedCArray.new($r, $n);
  }

  proto method decrypt_full (|)
    is also<decrypt-full>
  { * }

  multi method decrypt_full (
         $key,
         $mechanism,
    Str  $input,
         $cancellable                 = GCancellable,
         $error                       = gerror,
        :$raw                         = False,
        :$array                       = False,
        :$encoding                    = 'utf8',
        :src_encoding(:$src-encoding) = $encoding
  ) {
    samewith(
       $key,
       $mechanism,
       $input.encode($src-encoding),
       $cancellable,
       $error,
      :$raw,
      :$array,
      :$encoding
    )
  }
  multi method decrypt_full (
          $key,
          $mechanism,
    Blob  $input,
          $cancellable                 = GCancellable,
          $error                       = gerror,
         :$raw                         = False,
         :$array                       = False,
         :$encoding                    = 'utf8',
  ) {
    samewith(
       $key,
       $mechanism,
       CArray[uint8].new($input),
       $input.bytes,
       $cancellable,
       $error,
      :$raw,
      :$array,
      :$encoding
    )
  }
  multi method decrypt_full (
       $key,
       $mechanism,
       @input,
       $cancellable         = GCancellable,
       $error               = gerror,
      :$raw                 = False,
      :$array               = False,
      :$encoding            = 'utf8'
  ) {
    samewith(
       $key,
       $mechanism,
       ArrayToCArray(@input, typed => uint8),
       @input.elems,
       $cancellable,
       $error,
      :$raw,
      :$array,
      :$encoding
    )
  }
  multi method decrypt_full (
    GckObject()              $key,
    GckMechanism()           $mechanism,
    CArray[uint8]            $input,
    Int()                    $n_input,
    GCancellable             $cancellable         = GCancellable,
    CArray[Pointer[GError]]  $error               = gerror,
                            :$raw                 = False,
                            :$array               = False,
                            :$encoding            = 'utf8'
  ) {
    samewith(
      $key,
      $mechanism,
      $input,
      $n_input,
      $,
      $cancellable,
      $error,
     :$raw,
     :$array,
     :$encoding
    );
  }
  multi method decrypt_full (
    GckObject()              $key,
    GckMechanism()           $mechanism,
    CArray[uint8]            $input,
    Int()                    $n_input,
                             $n_result     is rw,
    GCancellable             $cancellable         = GCancellable,
    CArray[Pointer[GError]]  $error               = gerror,
                            :$raw                 = False,
                            :$array               = False,
                            :$encoding            = 'utf8'
  ) {
    my gsize ($ni, $nr) = ($n_input, 0);

    my $r = gck_session_decrypt_full(
      $!gs,
      $key,
      $mechanism,
      $input,
      $ni,
      $nr,
      $cancellable,
      $error
    );
    $n_result = $nr,
    return ($r, $nr) if $raw;
    my $ca = SizedCArray.new($r, $nr);
    return $ca if $array;
    Buf[uint8].new($ca).decode($encoding);
  }

  method derive_key (
    GckObject()              $base,
    Int()                    $mech_type,
    GckAttributes()          $attrs,
    GCancellable()           $cancellable = GCancellable,
    CArray[Pointer[GError]]  $error       = gerror,
                            :$raw         = False
  )
    is also<derive-key>
  {
    my gulong $m = $mech_type;

    clear_error;
    my $r = gck_session_derive_key(
      $!gs,
      $base,
      $m,
      $attrs,
      $cancellable,
      $error
    );
    set_error($error);
    propReturnObject($r, $raw, |GCK::Object.getTypePair);
  }

  proto method derive_key_async (|)
    is also<derive-key-async>
  { * }

  multi method derive_key_async (
     $base,
     $mechanism,
     $attrs,
     &callback,
     $user_data    = gpointer,
    :$cancellable  = GCancellable
  ) {
    gck_session_derive_key_async(
      $!gs,
      $base,
      $mechanism,
      $attrs,
      $cancellable,
      &callback,
      $user_data
    );
  }
  multi method derive_key_async (
    GckObject()         $base,
    GckMechanism()      $mechanism,
    GckAttributes()     $attrs,
    GCancellable()      $cancellable,
                        &callback,
    gpointer            $user_data    = gpointer
  ) {
    gck_session_derive_key_async(
      $!gs,
      $base,
      $mechanism,
      $attrs,
      $cancellable,
      &callback,
      $user_data
    );
  }

  method derive_key_finish (
    GAsyncResult()           $result,
    CArray[Pointer[GError]]  $error    = gerror,
                            :$raw      = False
  )
    is also<derive-key-finish>
  {
    clear_error;
    my $r = gck_session_derive_key_finish($!gs, $result, $error);
    set_error($error);
    propReturnObject($r, $raw, |GCK::Object.getTypePair);
  }

  method derive_key_full (
    GckObject()              $base,
    GckMechanism()           $mechanism,
    GckAttributes()          $attrs,
    GCancellable()           $cancellable  = GCancellable,
    CArray[Pointer[GError]]  $error        = gerror,
                            :$raw          = False
  )
    is also<derive-key-full>
  {
    clear_error;
    my $r = gck_session_derive_key_full(
      $!gs,
      $base,
      $mechanism,
      $attrs,
      $cancellable,
      $error
    );
    set_error($error);
    propReturnObject($r, $raw, |GCK::Object.getTypePair);
  }

  multi method encrypt (
          $key,
          $mech_type,
    Str   $input,
          $error               = gerror,
         :$cancellable         = GCancellable,
         :$raw                 = False,
         :$buf                 = False,
         :$encoding            = 'utf8',
  ) {
    samewith(
       $key,
       $mech_type,
       $input.encode($encoding),
       $error,
      :$cancellable,
      :$raw,
      :$buf
    );
  }
  multi method encrypt (
          $key,
          $mech_type,
    Blob  $input,
          $error               = gerror,
         :$cancellable         = GCancellable,
         :$raw                 = False,
         :$buf                 = False
  ) {
    samewith(
       $key,
       $mech_type,
       CArray[uint8].new($input),
       $input.bytes,
       $error,
      :$cancellable,
      :$raw,
      :$buf
    );
  }
  multi method encrypt (
     $key,
     $mech_type,
     @input,
     $error               = gerror,
    :$cancellable         = GCancellable,
    :$raw                 = False,
    :$buf                 = False
  ) {
    samewith(
       $key,
       $mech_type,
       CArray[uint8].new(@input),
       @input.elems,
       $error,
      :$cancellable,
      :$raw,
      :$buf
    );
  }
  multi method encrypt (
    GckObject()              $key,
    Int()                    $mech_type,
    CArray[uint8]            $input,
    Int()                    $n_input,
    CArray[Pointer[GError]]  $error               = gerror,
    GCancellable()          :$cancellable         = GCancellable,
                            :$raw                 = False,
                            :$buf                 = False
  ) {
    samewith(
      $key,
      $mech_type,
      $input,
      $n_input,
      $cancellable,
      $error
    );
  }
  multi method encrypt (
    GckObject()              $key,
    Int()                    $mech_type,
    CArray[uint8]            $input,
    Int()                    $n_input,
                             $n_result     is rw,
    GCancellable()           $cancellable         = GCancellable,
    CArray[Pointer[GError]]  $error               = gerror,
                            :$raw                 = False,
                            :$buf                 = False
  ) {
    my gulong  $m        =  $mech_type,
    my gsize  ($ni, $nr) = ($n_input, 0);

    clear_error;
    my $r = gck_session_encrypt(
      $!gs,
      $key,
      $mech_type,
      $input,
      $ni,
      $nr,
      $cancellable,
      $error
    );
    set_error($error);
    $n_result = $nr;

    $r = ($r, $nr);
    return $r if $raw;

    $r = SizedCArray.new( |$r );
    return $r unless $buf;

    Buf[uint8].new($r);
  }

  proto method encrypt_async (|)
    is also<encrypt-async>
  { * }

  multi method encrypt_async (
          $key,
          $mechanism,
     Str  $input,
          &callback,
          $user_data   = gpointer,
         :$cancellable = GCancellable,
         :$encoding    = 'utf8'
  ) {
    samewith(
      $key,
      $mechanism,
      $input.encode($encoding),
      $cancellable,
      &callback,
      $user_data
    )
  }
  multi method encrypt_async (
           $key,
           $mechanism,
     Blob  $input,
           &callback,
           $user_data   = gpointer,
          :$cancellable = GCancellable
  ) {
    samewith(
      $key,
      $mechanism,
      CArray[uint8].new($input),
      $input.bytes,
      $cancellable,
      &callback,
      $user_data
    )
  }
  multi method encrypt_async (
     $key,
     $mechanism,
     @input,
     &callback,
     $user_data   = gpointer,
    :$cancellable = GCancellable
  ) {
    samewith(
      $key,
      $mechanism,
      ArrayToCArray(@input, typed => uint8),
      @input.elems,
      $cancellable,
      &callback,
      $user_data
    )
  }
  multi method encrypt_async (
                   $key,
                   $mechanism,
    CArray[uint8]  $input,
                   $n_input,
                   &callback,
                   $user_data   = gpointer,
                  :$cancellable = GCancellable
  ) {
    samewith(
      $key,
      $mechanism,
      $input,
      $n_input,
      $cancellable,
      &callback,
      $user_data
    )
  }
  multi method encrypt_async (
    GckObject()    $key,
    GckMechanism() $mechanism,
    CArray[uint8]  $input,
    Int()          $n_input,
    GCancellable() $cancellable,
                   &callback,
    gpointer       $user_data    = gpointer
  ) {
    my $ni = $n_input;

    gck_session_encrypt_async(
      $!gs,
      $key,
      $mechanism,
      $input,
      $ni,
      $cancellable,
      &callback,
      $user_data
    );
  }

  proto method encrypt_finish (|)
    is also<encrypt-finish>
  { * }

  multi method encrypt_finish (
     $result,
     $error            = gerror,
    :$raw              = False,
    :$buf              = False
  ) {
    samewith($result, $, $error, :$raw, :$buf);
  }
  multi method encrypt_finish (
    GAsyncResult()           $result,
                             $n_result is rw,
    CArray[Pointer[GError]]  $error            = gerror,
                            :$raw              = False,
                            :$buf              = False
  ) {
    my gsize $n = 0;

    clear_error;
    my $r = gck_session_encrypt_finish($!gs, $result, $n, $error);
    $n_result = $n;

    $r = ($r, $n);
    return $r if $raw;

    $r = SizedCArray.new( |$r );
    return $r unless $buf;

    Buf[uint8].new($r);
  }

  proto method encrypt_full (|)
    is also<encrypt-full>
  { * }

  multi method encrypt_full (
         $key,
         $mechanism,
    Str  $input,
         $error               = gerror,
        :$raw                 = False,
        :$cancellable         = GCancellable,
        :$encoding            = 'utf8'
  ) {
    samewith(
       $key,
       $mechanism,
       $input.encode($encoding),
       $error,
      :$raw
      :$cancellable,
    );
  }
  multi method encrypt_full (
          $key,
          $mechanism,
    Blob  $input,
          $error               = gerror,
         :$raw                 = False,
         :$cancellable         = GCancellable
  ) {
    samewith(
       $key,
       $mechanism,
       CArray[uint8].new($input),
       $input.bytes,
       $cancellable,
       $error,
      :$raw
    );
  }
  multi method encrypt_full (
     $key,
     $mechanism,
     @input,
     $error               = gerror,
    :$raw                 = False,
    :$cancellable         = GCancellable
  ) {
    samewith(
       $key,
       $mechanism,
       ArrayToCArray( @input, typed => uint8 ),
       @input.elems,
       $error,
      :$raw,
      :$cancellable
    );
  }
  multi method encrypt_full (
                   $key,
                   $mechanism,
    CArray[uint8]  $input,
                   $n_input,
                   $error               = gerror,
                  :$raw                 = False,
                  :$cancellable         = GCancellable
  ) {
    samewith(
       $key,
       $mechanism,
       $input,
       $n_input,
       $,
       $cancellable,
       $error,
      :$raw
    );
  }
  multi method encrypt_full (
    GckObject()              $key,
    GckMechanism()           $mechanism,
    CArray[uint8]            $input,
    Int()                    $n_input,
                             $n_result     is rw,
    GCancellable             $cancellable         = GCancellable,
    CArray[Pointer[GError]]  $error               = gerror,
                            :$raw                 = False,
  ) {
    my gsize ($ni, $nr) = ($n_input, 0);

    my $r = gck_session_encrypt_full(
      $!gs,
      $key,
      $mechanism,
      $input,
      $ni,
      $nr,
      $cancellable,
      $error
    );
    $n_result = $nr;
    return ($r, $nr) if $raw;
    SizedCArray.new($r, $nr);
  }

  method enumerate_objects (GckAttributes() $match, :$raw = False)
    is also<enumerate-objects>
  {
    propReturnObject(
      gck_session_enumerate_objects($!gs, $match),
      $raw,
      |GCK::Enumerator.getTypePair
    );
  }

  proto method find_handles (|)
    is also<find-handles>
  { * }

  multi method find_handles (
     $match,
     $error       = gerror,
    :$cancellable = GCancellable
  ) {
    samewith($match, $cancellable, $, $error);
  }
  multi method find_handles (
    GckAttributes            $match,
    GCancellable             $cancellable,
                             $n_handles    is rw,
    CArray[Pointer[GError]]  $error,
                            :$raw                 = False
  ) {
    my gulong $n = 0;

    clear_error;
    my $r = gck_session_find_handles($!gs, $match, $cancellable, $n, $error);
    set_error($error);
    $n_handles = $n;
    return ($r, $n) if $raw;
    SizedCArray.new($r, $n);
  }

  proto method find_handles_async (|)
    is also<find-handles-async>
  { * }

  multi method find_handles_async (
     $match,
     &callback,
     $user_data   = gpointer,
    :$cancellable = GCancellable
  ) {
    samewith($match, $cancellable, &callback, $user_data);
  }
  multi method find_handles_async (
    GckAttributes() $match,
    GCancellable()  $cancellable,
                    &callback,
    gpointer        $user_data     = gpointer
  ) {
    gck_session_find_handles_async(
      $!gs,
      $match,
      $cancellable,
      &callback,
      $user_data
    );
  }

  method find_handles_finish (
    GAsyncResult()           $result,
                             $n_handles is rw,
    CArray[Pointer[GError]]  $error            = gerror,
                            :$raw              = False
  )
    is also<find-handles-finish>
  {
    my gulong $n = 0;

    clear_error;
    my $r = gck_session_find_handles_finish($!gs, $result, $n, $error);
    set_error($error);
    $n_handles = $n;
    return ($r, $n) if $raw;
    SizedCArray.new($r, $n);
  }

  method find_objects (
    GckAttributes()          $match,
    GCancellable()           $cancellable    = GCancellable,
    CArray[Pointer[GError]]  $error          = gerror,
                            :$raw            = False,
                            :gslist(:$glist) = False
  )
    is also<find-objects>
  {
    clear_error;
    my $r = gck_session_find_objects($!gs, $match, $cancellable, $error);
    set_error($error);
    returnGList($r, $raw, $glist, |GCK::Object.getTypePair);
  }

  proto method find_objects_async (|)
    is also<find-objects-async>
  { * }

  multi method find_objects_async (
    $match,
    &callback,
    $user_data   = gpointer,
    $cancellable = GCancellable
  ) {
    samewith(
      $match,
      $cancellable,
      &callback,
      $user_data
    );
  }
  multi method find_objects_async (
    GckAttributes()  $match,
    GCancellable()   $cancellable,
                     &callback,
    gpointer         $user_data    = gpointer
  ) {
    gck_session_find_objects_async(
      $!gs,
      $match,
      $cancellable,
      &callback,
      $user_data
    );
  }

  method find_objects_finish (
    GAsyncResult()          $result,
    CArray[Pointer[GError]] $error           = gerror,
                            :$raw            = False,
                            :gslist(:$glist) = False
  )
    is also<find-objects-finish>
  {
    clear_error;
    my $r = gck_session_find_objects_finish($!gs, $result, $error);
    set_error($error);
    returnGList($r, $raw, $glist, |GCK::Object.getTypePair);
  }

  proto method generate_key_pair (|)
    is also<generate-key-pair>
  { * }

  multi method generate_key_pair (
     $mech_type,
     $public_attrs,
     $private_attrs,
     $error          = gerror,
    :$public_key     = newCArray(GckObject),
    :$private_key    = newCArray(GckObject),
    :$cancellable    = GCancellable,
    :$raw            = False
  ) {
    samewith(
       $mech_type,
       $public_attrs,
       $private_attrs,
       $public_key,
       $private_key,
       $cancellable,
       $error,
      :$raw
    );
  }
  multi method generate_key_pair (
    Int()                    $mech_type,
    GckAttributes()          $public_attrs,
    GckAttributes()          $private_attrs,
    CArray[GckObject]        $public_key     = newCArray(GckObject),
    CArray[GckObject]        $private_key    = newCArray(GckObject),
    GCancellable()           $cancellable    = GCancellable,
    CArray[Pointer[GError]]  $error          = gerror,
                            :$raw            = False
  ) {
    my gulong $m = $mech_type;

    clear_error;
    my $r = gck_session_generate_key_pair(
      $!gs,
      $m,
      $public_attrs,
      $private_attrs,
      $public_key,
      $private_key,
      $cancellable,
      $error
    );
    set_error($error);

    return Nil unless $r;

    return (
      propReturnObject( ppr($public_key),  $raw, |GCK::Object.getTypePair ),
      propReturnObject( ppr($private_key), $raw, |GCK::Object.getTypePair )
    )
  }

  proto method generate_key_pair_async (|)
    is also<generate-key-pair-async>
  { * }

  multi method generate_key_pair_async (
     $mechanism,
     $public_attrs,
     $private_attrs,
     &callback,
     $user_data   = gpointer,
    :$cancellable = GCancellable
  ) {
    samewith(
      $mechanism,
      $public_attrs,
      $private_attrs,
      $cancellable,
      &callback,
      $user_data
    )
  }
  multi method generate_key_pair_async (
    GckMechanism()  $mechanism,
    GckAttributes() $public_attrs,
    GckAttributes() $private_attrs,
    GCancellable()  $cancellable,
                    &callback,
    gpointer        $user_data       = gpointer
  ) {
    gck_session_generate_key_pair_async(
      $!gs,
      $mechanism,
      $public_attrs,
      $private_attrs,
      $cancellable,
      &callback,
      $user_data
    );
  }

  proto method generate_key_pair_finish (|)
    is also<generate-key-pair-finish>
  { * }

  multi method generate_key_pair_finish (
     $result,
     $error        = gerror,
    :$public_key   = newCArray(GckObject),
    :$private_key  = newCArray(GckObject),
    :$raw          = False
  ) {
    samewith($result, $public_key, $private_key, $error, :$raw);
  }
  multi method generate_key_pair_finish (
    GAsyncResult()           $result,
    CArray[GckObject]        $public_key   = newCArray(GckObject),
    CArray[GckObject]        $private_key  = newCArray(GckObject),
    CArray[Pointer[GError]]  $error        = gerror,
                            :$raw          = False
  ) {
    clear_error;
    my $r = gck_session_generate_key_pair_finish(
      $!gs,
      $result,
      $public_key,
      $private_key,
      $error
    );
    set_error($error);

    return Nil unless $r;

    return (
      propReturnObject( ppr($public_key),  $raw, |GCK::Object.getTypePair ),
      propReturnObject( ppr($private_key), $raw, |GCK::Object.getTypePair )
    )
  }

  proto method generate_key_pair_full (|)
    is also<generate-key-pair-full>
  { * }

  multi method generate_key_pair_full (
     $mechanism,
     $public_attrs,
     $private_attrs,
     $error           = gerror,
    :$cancellable     = GCancellable,
    :$public_key      = newCArray(GckObject),
    :$private_key     = newCArray(GckObject)
  ) {
    samewith(
      $mechanism,
      $public_attrs,
      $private_attrs,
      $public_key,
      $private_key,
      $cancellable,
      $error
    );
  }
  multi method generate_key_pair_full (
    GckMechanism()           $mechanism,
    GckAttributes()          $public_attrs,
    GckAttributes()          $private_attrs,
    CArray[GckObject]        $public_key,
    CArray[GckObject]        $private_key,
    GCancellable()           $cancellable    = GCancellable,
    CArray[Pointer[GError]]  $error          = gerror,
                            :$raw            = False
  ) {
    clear_error;
    my $r = gck_session_generate_key_pair_full(
      $!gs,
      $mechanism,
      $public_attrs,
      $private_attrs,
      $public_key,
      $private_key,
      $cancellable,
      $error
    );
    set_error($error);

    return Nil unless $r;

    return (
      propReturnObject( ppr($public_key),  $raw, |GCK::Object.getTypePair ),
      propReturnObject( ppr($private_key), $raw, |GCK::Object.getTypePair )
    )
  }

  method get_handle is also<get-handle> {
    gck_session_get_handle($!gs);
  }

  method get_info is also<get-info> {
    gck_session_get_info($!gs);
  }

  method get_interaction ( :$raw = False ) is also<get-interaction> {
    propReturnObject(
      gck_session_get_interaction($!gs),
      $raw,
      |GIO::TlsInteraction.getTypePair
    )
  }

  method get_module ( :$raw = False ) is also<get-module> {
    propReturnObject(
      gck_session_get_module($!gs),
      $raw,
      |GCK::Module.getTypePair
    );
  }

  method get_options ( :set(:$flags) = True ) is also<get-options> {
    my $f = gck_session_get_options($!gs);
    return $f unless $flags;
    getFlags(GckSessionOptionsEnum, $f);
  }

  method get_slot ( :$raw = False ) is also<get-slot> {
    propReturnObject(
      gck_session_get_slot($!gs),
      $raw,
      |GCK::Slot.getTypePair
    );
  }

  method get_state is also<get-state> {
    gck_session_get_state($!gs);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gck_session_get_type, $n, $t );
  }

  proto method init_pin (|)
    is also<init-pin>
  { * }

  multi method init_pin (
    $cancellable = GCancellable,
    $error       = gerror
  ) {
    samewith(Str, 0, $cancellable, $error);
  }
  multi method init_pin (
    Str()                   $pin,
    Int()                   $n_pin,
    GCancellable()          $cancellable = GCancellable,
    CArray[Pointer[GError]] $error       = gerror
  ) {
    my gsize $n = $n_pin;

    so gck_session_init_pin($!gs, $pin, $n, $cancellable, $error);
  }

  proto method init_pin_async (|)
    is also<init-pin-async>
  { * }

  multi method init_pin_async (
     &callback,
     $user_data                           = gpointer,
    :$cancellable                         = GCancellable
  ) {
    samewith(
       Str,
       &callback,
       $user_data,
      :n_pin(0),
      :$cancellable
    );
  }
  multi method init_pin_async (
     $pin,
     &callback,
     $user_data                           = gpointer,
    :pin_size(:pin-size(:n-pin(:$n_pin))) = $pin.chars,
    :$cancellable                         = GCancellable
  ) {
    samewith(
      $pin,
      $n_pin,
      $cancellable,
      &callback,
      $user_data
    );
  }
  multi method init_pin_async (
    Str()          $pin,
    Int()          $n_pin,
    GCancellable() $cancellable,
                   &callback,
    gpointer       $user_data     = gpointer
  ) {
    my gsize $n = $n_pin;

    gck_session_init_pin_async(
      $!gs,
      $pin,
      $n,
      $cancellable,
      &callback,
      $user_data
    );
  }

  method init_pin_finish (
    GAsyncResult()          $result,
    CArray[Pointer[GError]] $error   = gerror
  )
    is also<init-pin-finish>
  {
    clear_error
    my $r = so gck_session_init_pin_finish($!gs, $result, $error);
    set_error($error);
    $r;
  }

  multi method login (
     $user_type,
     $error                                = gerror,
    :$cancellable                         = GCancellable
  ) {
    samewith(
       $user_type,
       Str,
       $error,
      :$cancellable,
      :n_pin(0)
    )
  }
  multi method login (
     $user_type,
     $pin,
     $error                                = gerror,
     :$cancellable                         = GCancellable,
     :pin_size(:pin-size(:n-pin(:$n_pin))) = $pin.chars,
  ) {
    samewith($user_type, $pin, $n_pin, $cancellable, $error);
  }
  multi method login (
    Int()                   $user_type,
    Str()                   $pin,
    Int()                   $n_pin,
    GCancellable()          $cancellable = GCancellable,
    CArray[Pointer[GError]] $error       = gerror
  ) {
    my gulong $u = $user_type;
    my gsize  $n = $n_pin;

    clear_error;
    my $r = gck_session_login($!gs, $u, $pin, $n, $cancellable, $error);
    set_error($error);
    $r;
  }

  proto method login_async (|)
    is also<login-async>
  { * }

  multi method login_async (
     $user_type,
     &callback,
     $user_data                           = gpointer,
    :$cancellable                         = GCancellable
  ) {
    samewith(
       $user_type,
       Str,
       &callback,
       $user_data,
      :n_pin(0),
      :$cancellable
    );
  }
  multi method login_async (
     $user_type,
     $pin,
     &callback,
     $user_data                           = gpointer,
    :pin_size(:pin-size(:n-pin(:$n_pin))) = $pin.chars,
    :$cancellable                         = GCancellable
  ) {
    samewith(
      $user_type,
      $pin,
      $n_pin,
      $cancellable,
      &callback,
      $user_data
    );
  }
  multi method login_async (
    Int()          $user_type,
    Str()          $pin,
    Int()          $n_pin,
    GCancellable() $cancellable,
                   &callback,
    gpointer       $user_data
  ) {
    my gulong $u = $user_type;
    my gsize  $n = $n_pin;

    gck_session_login_async(
      $!gs,
      $u,
      $pin,
      $n,
      $cancellable,
      &callback,
      $user_data
    );
  }

  method login_finish (
    GAsyncResult()          $result,
    CArray[Pointer[GError]] $error   = gerror
  )
    is also<login-finish>
  {
    gck_session_login_finish($!gs, $result, $error);
  }

  proto method login_interactive (|)
    is also<login-interactive>
  { * }

  multi method login_interactive (
     $user_type,
     $error       = gerror,
    :$interaction = GTlsInteraction,
    :$cancellable = GCancellable
  ) {
    samewith($user_type, $interaction, $cancellable, $error);
  }
  multi method login_interactive (
    Int()                   $user_type,
    GTlsInteraction()       $interaction,
    GCancellable()          $cancellable,
    CArray[Pointer[GError]] $error        = gerror
  ) {
    my gulong $u = $user_type;

    clear_error;
    my $r = gck_session_login_interactive(
      $!gs,
      $u,
      $interaction,
      $cancellable,
      $error
    );
    set_error($error);
    $r;
  }

  proto method login_interactive_async (|)
    is also<login-interactive-async>
  { * }

  multi method login_interactive_async (
     $user_type,
     &callback,
     $user_data   = gpointer,
    :$interaction = GTlsInteraction,
    :$cancellable = GCancellable
  ) {
    samewith(
      $user_type,
      $interaction,
      $cancellable,
      &callback,
      $user_data
    );
  }
  multi method login_interactive_async (
    Int()             $user_type,
    GTlsInteraction() $interaction,
    GCancellable()    $cancellable,
                      &callback,
    gpointer          $user_data     = gpointer
  ) {
    my gulong $u = $user_type;

    gck_session_login_interactive_async(
      $!gs,
      $u,
      $interaction,
      $cancellable,
      &callback,
      $user_data
    );
  }

  method login_interactive_finish (
    GAsyncResult()          $result,
    CArray[Pointer[GError]] $error   = gerror
  )
    is also<login-interactive-finish>
  {
    clear_error;
    my $r = gck_session_login_interactive_finish($!gs, $result, $error);
    set_error($error);
    $r;
  }

  method logout (
    GCancellable            $cancellable = GCancellable,
    CArray[Pointer[GError]] $error       = gerror
  ) {
    clear_error;
    my $r = gck_session_logout($!gs, $cancellable, $error);
    set_error($error);
    $r;
  }

  proto method logout_async (|)
    is also<logout-async>
  { * }

  multi method logout_async (
     &callback,
     $user_data   = gpointer,
    :$cancellable = GCancellable
  ) {
    samewith($cancellable, &callback, $user_data);
  }
  multi method logout_async (
    GCancellable() $cancellable,
                   &callback,
    gpointer       $user_data     = gpointer
  ) {
    gck_session_logout_async($!gs, $cancellable, &callback, $user_data);
  }

  method logout_finish (
    GAsyncResult()          $result,
    CArray[Pointer[GError]] $error    = gerror
  )
    is also<logout-finish>
  {
    clear_error
    my $r = gck_session_logout_finish($!gs, $result, $error);
    set_error($error);
    $r;
  }

  method set_interaction (GTlsInteraction() $interaction) is also<set-interaction> {
    gck_session_set_interaction($!gs, $interaction);
  }

  proto method set_pin (|)
    is also<set-pin>
  { * }

  multi method set_pin (
     $new_pin,
     $error                                               = gerror,
    :new_pin_size(:new-pin-size(:n-new-pin(:$n_new_pin))) = $new_pin.chars,
    :$cancellable = GCancellable,

    :no_old_pin($no-old-pin) is required where *.so
  ) {
    samewith(
       Str,
       $new_pin,
       $error,
      :$n_new_pin
      :n_old_pin(0)
      :$cancellable
    )
  }
  multi method set_pin (
     $old_pin,
     $error                                               = gerror,
    :old_pin_size(:old-pin_size(:n-old-pin(:$n_old_pin))) = $old_pin.chars,
    :$cancellable = GCancellable,

    :no_new_pin($no-new-pin) is required where *.so
  ) {
    samewith(
       $old_pin,
       Str,
       $error,
      :$n_old_pin
      :n_new_pin(0)
      :$cancellable
    )
  }
  multi method set_pin (
     $old_pin,
     $new_pin,
     $error                                               = gerror,
    :old_pin_size(:old-pin_size(:n-old-pin(:$n_old_pin))) = $old_pin.chars,
    :new_pin_size(:new-pin-size(:n-new-pin(:$n_new_pin))) = $new_pin.chars,
    :$cancellable = GCancellable,
  ) {
    samewith(
      $old_pin,
      $n_old_pin,
      $new_pin,
      $n_new_pin,
      $cancellable,
      $error
    )
  }
  multi method set_pin (
    Str()                   $old_pin,
    Int()                   $n_old_pin,
    Str()                   $new_pin,
    Int()                   $n_new_pin,
    GCancellable()          $cancellable = GCancellable,
    CArray[Pointer[GError]] $error       = gerror
  ) {
    my gsize ($o, $n) = ($n_old_pin, $n_new_pin);

    clear_error;
    my $r = gck_session_set_pin(
      $!gs,
      $old_pin,
      $o,
      $new_pin,
      $n,
      $cancellable,
      $error
    );
    set_error($error);
    $r;
  }

  proto method set_pin_async (|)
    is also<set-pin-async>
  { * }

  multi method set_pin_async (
     $new_pin,
     &callback,
     $error                                               = gerror,
    :new_pin_size(:new-pin-size(:n-new-pin(:$n_new_pin))) = $new_pin.chars,
    :$cancellable = GCancellable,

    :no_old_pin($no-old-pin) is required where *.so
  ) {
    samewith(
       Str,
       $new_pin,
       &callback,
       $error,
      :$n_new_pin
      :n_old_pin(0)
      :$cancellable
    )
  }
  multi method set_pin_async (
     $old_pin,
     &callback,
     $error                                               = gerror,
    :old_pin_size(:old-pin_size(:n-old-pin(:$n_old_pin))) = $old_pin.chars,
    :$cancellable = GCancellable,

    :no_new_pin($no-new-pin) is required where *.so
  ) {
    samewith(
       $old_pin,
       Str,
       &callback,
       $error,
      :$n_old_pin
      :n_new_pin(0)
      :$cancellable
    )
  }
  multi method set_pin (
     $old_pin,
     $new_pin,
     &callback,
     $error                                               = gerror,
    :old_pin_size(:old-pin_size(:n-old-pin(:$n_old_pin))) = $old_pin.chars,
    :new_pin_size(:new-pin-size(:n-new-pin(:$n_new_pin))) = $new_pin.chars,
    :$cancellable = GCancellable,
  ) {
    samewith(
      $old_pin,
      $n_old_pin,
      $new_pin,
      $n_new_pin,
      $cancellable,
      &callback,
      $error
    )
  }
  multi method set_pin_async (
    Str()          $old_pin,
    Int()          $n_old_pin,
    Str()          $new_pin,
    Int()          $n_new_pin,
    GCancellable() $cancellable,
                   &callback,
    gpointer       $user_data     = gpointer
  ) {
    my gsize ($o, $n) = ($n_old_pin, $n_new_pin);

    gck_session_set_pin_async(
      $!gs,
      $old_pin,
      $o,
      $new_pin,
      $n,
      $cancellable,
      &callback,
      $user_data
    );
  }

  method set_pin_finish (
    GAsyncResult()          $result,
    CArray[Pointer[GError]] $error    = gerror
  )
    is also<set-pin-finish>
  {
    clear_error
    my $r = so gck_session_set_pin_finish($!gs, $result, $error);
    set_error($error);
    $r;
  }


  multi method sign (
    GckObject()              $key,
    Int()                    $mech_type,
    Blob                     $input,
    GCancellable()           $cancellable          = GCancellable,
    CArray[Pointer[GError]]  $error                = gerror,
                            :$raw                  = False,
                            :$buf                  = True
  ) {
    samewith(
       $key,
       $mech_type,
       CArray[uint8].new($input),
       $input.bytes,
       $,
       $cancellable,
       $error,
      :$raw,
      :$buf
    );
  }
  multi method sign (
    GckObject()              $key,
    Int()                    $mech_type,
    CArray[uint8]            $input,
    Int()                    $n_input,
                             $n_result     is rw,
    GCancellable()           $cancellable          = GCancellable,
    CArray[Pointer[GError]]  $error                = gerror,
                            :$raw                  = False,
                            :$buf                  = True
  ) {
    my gulong  $m      = $mech_type;
    my gsize  ($i, $r) = ($n_input, 0);

    clear_error;
    my $o = gck_session_sign(
      $!gs,
      $key,
      $m,
      $input,
      $i,
      $r,
      $cancellable,
      $error
    );
    set_error($error);

    $n_result = $r,
    return ($o, $r) if $raw;
    my $ca = SizedCArray.new($o, $r);
    return $ca unless $buf;
    Buf[uint8].new($ca);
  }

  proto method sign_async (|)
    is also<sign-async>
  { * }

  multi method sign_async (
          $key,
          $mechanism,
    Buf   $input,
          &callback,
          $user_data   = gpointer,
         :$cancellable = GCancellable
  ) {
    samewith(
      $key,
      $mechanism,
      CArray[uint8].new($input),
      $input.bytes,
      $cancellable,
      &callback,
      $user_data
    );
  }
  multi method sign_async (
                   $key,
                   $mechanism,
    CArray[uint8]  $input,
                   $n_input,
                   &callback,
                   $user_data   = gpointer,
                  :$cancellable = GCancellable
  ) {
    samewith(
      $key,
      $mechanism,
      $input,
      $n_input,
      $cancellable,
      &callback,
      $user_data
    );
  }
  multi method sign_async (
    GckObject()         $key,
    GckMechanism()      $mechanism,
    CArray[uint8]       $input,
    Int()               $n_input,
    GCancellable()      $cancellable,
                        &callback,
    gpointer            $user_data     = gpointer
  ) {
    my gsize $ni = $n_input;

    gck_session_sign_async(
      $!gs,
      $key,
      $mechanism,
      $input,
      $n_input,
      $cancellable,
      &callback,
      $user_data
    );
  }

  method sign_finish (
    GAsyncResult()           $result,
                             $n_result is rw,
    CArray[Pointer[GError]]  $error           = gerror,
                            :$raw             = False,
                            :$buf             = True
  )
    is also<sign-finish>
  {
    my gsize $nr = 0;

    clear_error;
    my $r = gck_session_sign_finish($!gs, $result, $nr, $error);
    set_error($error);
    $n_result = $nr;
    return ($r, $nr) if $raw;
    my $ca = SizedCArray.new($r, $nr);
    return $ca unless $buf;
    Buf[uint8].new($ca);
  }

  proto method sign_full (|)
    is also<sign-full>
  { * }

  multi method sign_full (
         $key,
         $mechanism,
    Buf  $input,
         $error               = gerror,
        :$raw                 = False,
        :$buf                 = True,
        :$cancellable         = GCancellable,
   ) {
    samewith(
       $key,
       $mechanism,
       CArray[uint8].new($input),
       $input.bytes,
       $,
       $cancellable,
       $error,
      :$raw,
      :$buf
    );
  }
  multi method sign_full (
    GckObject()              $key,
    GckMechanism()           $mechanism,
    CArray[uint8]            $input,
    Int()                    $n_input,
                             $n_result     is rw,
    GCancellable()           $cancellable         = GCancellable,
    CArray[Pointer[GError]]  $error               = gerror,
                            :$raw                 = False,
                            :$buf                 = True
  ) {
    my gsize  ($i, $r) = ($n_input, 0);

    clear_error;
    my $o = gck_session_sign_full(
      $!gs,
      $key,
      $mechanism,
      $input,
      $i,
      $r,
      $cancellable,
      $error
    );
    set_error($error);

    $n_result = $r;
    return ($o, $r) if $raw;
    my $ca = SizedCArray.new($o, $r);
    return $ca unless $buf;
    Buf[uint8].new($ca);
  }

  proto method unwrap_key (|)
    is also<unwrap-key>
  { * }

  multi method unwrap_key (
           $wrapper,
           $mech_type,
    Buf    $input,
           $attrs,
           $error        = gerror,
          :$raw          = False,
          :$cancellable  = GCancellable
  ) {
    samewith(
      $wrapper,
      $mech_type,
      CArray[uint8].new($input),
      $input.bytes,
      $attrs,
      $cancellable,
      $error
    )
  }
  multi method unwrap_key (
    GckObject()              $wrapper,
    Int()                    $mech_type,
    CArray[uint8]            $input,
    Int()                    $n_input,
    GckAttributes()          $attrs,
    GCancellable()           $cancellable  = GCancellable,
    CArray[Pointer[GError]]  $error        = gerror,
                            :$raw          = False
  ) {
    my gulong $m = $mech_type;
    my gsize  $i = $n_input;

    clear_error;
    my $r = gck_session_unwrap_key(
      $!gs,
      $wrapper,
      $m,
      $input,
      $i,
      $attrs,
      $cancellable,
      $error
    );
    set_error($error);
    propReturnObject($r, $raw, |GCK::Object.getTypePair);
  }

  proto method unwrap_key_async (|)
    is also<unwrap-key-async>
  { * }

  multi method unwrap_key_async (
         $wrapper,
         $mechanism,
    Buf  $input,
         $attrs,
         &callback,
         $user_data     = gpointer,
        :$cancellable   = GCancellable,
  ) {
    samewith(
       $wrapper,
       $mechanism,
       CArray[uint8].new($input),
       $input.bytes,
       $attrs,
       &callback,
       $user_data,
      :$cancellable,
    );
  }
  multi method unwrap_key_async (
                   $wrapper,
                   $mechanism,
    CArray[uint8]  $input,
                   $n_input,
                   $attrs,
                   &callback,
                   $user_data   = gpointer,
                  :$cancellable = GCancellable
  ) {
    samewith(
      $wrapper,
      $mechanism,
      $input,
      $n_input,
      $attrs,
      $cancellable,
      &callback,
      $user_data
    );
  }
  multi method unwrap_key_async (
    GckObject()      $wrapper,
    GckMechanism()   $mechanism,
    CArray[uint8]    $input,
    Int()            $n_input,
    GckAttributes()  $attrs,
    GCancellable()   $cancellable,
                     &callback,
    gpointer         $user_data     = gpointer
  ) {
    my gsize $i = $n_input;

    gck_session_unwrap_key_async(
      $!gs,
      $wrapper,
      $mechanism,
      $input,
      $i,
      $attrs,
      $cancellable,
      &callback,
      $user_data
    );
  }

  method unwrap_key_finish (
    GAsyncResult()           $result,
    CArray[Pointer[GError]]  $error   = gerror,
                            :$raw     = False
  )
    is also<unwrap-key-finish>
  {
    clear_error;
    my $o = gck_session_unwrap_key_finish($!gs, $result, $error);
    set_error($error);
    propReturnObject($o, $raw, |GCK::Object.getTypePair);
  }

  proto method unwrap_key_full (|)
    is also<unwrap-key-full>
  { * }

  multi method unwrap_key_full (
            $wrapper,
            $mechanism,
      Blob  $input,
            $attrs,
            $error       = gerror,
           :$raw         = False,
           :$cancellable = GCancellable,
  ) {
    samewith(
       $wrapper,
       $mechanism,
       CArray[uint8].new($input),
       $input.bytes,
       $attrs,
       $cancellable,
       $error,
      :$raw
    );
  }
  multi method unwrap_key_full (
    GckObject()              $wrapper,
    GckMechanism()           $mechanism,
    CArray[uint8]            $input,
    Int()                    $n_input,
    GckAttributes()          $attrs,
    GCancellable()           $cancellable = GCancellable,
    CArray[Pointer[GError]]  $error       = gerror,
                            :$raw         = False
  ) {
    my gsize $i = $n_input;

    clear_error;
    my $o = gck_session_unwrap_key_full(
      $!gs,
      $wrapper,
      $mechanism,
      $input,
      $i,
      $attrs,
      $cancellable,
      $error
    );
    set_error($error);
    propReturnObject($o, $raw, |GCK::Object.getTypePair);
  }

  sub getBufferSize ($_) {
    when Str           { .chars }
    when Blob          { .bytes }

    when CArray[uint8] {
      CATCH {
        default {
          X::GLib::CArrayUnknownSize.new.throw
            if .message.contains( q<Don't know how many elements> );
        }
      }
      .elems
    }
  }

  multi method verify (
    $key,
    $mech_type,
    $input,
    $signature,
    $cancellable           = GCancellable,
    $error                 = gerror,

    :input_size(:input-size(:n-input(:$n_input)))     is copy,
    :sig_size(:sig-size(:n-signature(:$n_signature))) is copy,
  ) {
    $n_input     //= getBufferSize($input);
    $n_signature //= getBufferSize($signature);

    samewith(
      $key,
      $mech_type,
      resolveBuffer($input),
      $n_input,
      resolveBuffer($signature),
      $n_signature,
      $cancellable,
      $error
    )
  }
  multi method verify (
    GckObject()             $key,
    Int()                   $mech_type,
    CArray[uint8]           $input,
    Int()                   $n_input,
    CArray[uint8]           $signature,
    Int()                   $n_signature,
    GCancellable()          $cancellable  = GCancellable,
    CArray[Pointer[GError]] $error        = gerror
  ) {
    my gulong  $m         =  $mech_type;
    my gsize  ($ni, $ns)  = ($n_input, $n_signature);

    clear_error;
    my $r = so gck_session_verify(
      $!gs,
      $key,
      $mech_type,
      $input,
      $ni,
      $signature,
      $n_signature,
      $cancellable,
      $error
    );
    set_error($error);
    $r;
  }

  proto method verify_async (|)
    is also<verify-async>
  { * }

  multi method verify_async (
    GckObject()     $key,
    Int()           $mech_type,
                    $input,
                    $signature,
                    &callback,
    gpointer        $user_data   = gpointer,
    GCancellable() :$cancellable = GCancellable,

    :input_size(:input-size(:n-input(:$n_input)))     is copy,
    :sig_size(:sig-size(:n-signature(:$n_signature))) is copy,
  ) {
    $n_input     //= getBufferSize($input);
    $n_signature //= getBufferSize($signature);

    samewith(
      $key,
      $mech_type,
      resolveBuffer($input),
      $n_input,
      resolveBuffer($signature),
      $n_signature,
      $cancellable,
      &callback,
      $user_data
    )
  }
  multi method verify_async (
    GckObject()             $key,
    Int()                   $mech_type,
    CArray[uint8]           $input,
    Int()                   $n_input,
    CArray[uint8]           $signature,
    Int()                   $n_signature,
    GCancellable()          $cancellable,
                            &callback,
    gpointer                $user_data    = gpointer
  ) {
    my gulong  $m         =  $mech_type;
    my gsize  ($ni, $ns)  = ($n_input, $n_signature);

    gck_session_verify_async(
      $!gs,
      $key,
      $m,
      $input,
      $ni,
      $signature,
      $ns,
      $cancellable,
      &callback,
      $user_data
    );
  }

  method verify_finish (
    GAsyncResult()          $result,
    CArray[Pointer[GError]] $error    = gerror
  )
    is also<verify-finish>
  {
    clear_error;
    my $r = so gck_session_verify_finish($!gs, $result, $error);
    set_error($error);
  }

  proto method verify_full (|)
    is also<verify-full>
  { * }

  multi method verify_full (
    $key,
    $mechanism,
    $input,
    $signature,
    $cancellable           = GCancellable,
    $error                 = gerror,

    :input_size(:input-size(:n-input(:$n_input)))     is copy,
    :sig_size(:sig-size(:n-signature(:$n_signature))) is copy,
  ) {
    $n_input     //= getBufferSize($input);
    $n_signature //= getBufferSize($signature);

    samewith(
      $key,
      $mechanism,
      resolveBuffer($input),
      $n_input,
      resolveBuffer($signature),
      $n_signature,
      $cancellable,
      $error
    )
  }
  multi method verify_full (
    GckObject()             $key,
    GckMechanism()          $mechanism,
    CArray[uint8]           $input,
    Int()                   $n_input,
    CArray[uint8]           $signature,
    Int()                   $n_signature,
    GCancellable()          $cancellable  = GCancellable,
    CArray[Pointer[GError]] $error        = gerror
  ) {
    my gsize  ($ni, $ns)  = ($n_input, $n_signature);

    clear_error;
    my $r = so gck_session_verify_full(
      $!gs,
      $key,
      $mechanism,
      $input,
      $ni,
      $signature,
      $ns,
      $cancellable,
      $error
    );
    set_error($error);
    $r;
  }

  proto method wrap_key (|)
    is also<wrap-key>
  { * }

  multi method wrap_key (
    GckObject()              $wrapper,
    Int()                    $mech_type,
    GckObject()              $wrapped,
    GCancellable()           $cancellable          = GCancellable,
    CArray[Pointer[GError]]  $error                = gerror,
                            :$raw                  = False,
                            :$buf                  = False
  ) {
    samewith(
       $wrapper,
       $mech_type,
       $wrapped,
       $,
       $cancellable,
       $error,
      :$raw,
      :$buf
    );
  }
  multi method wrap_key (
    GckObject()              $wrapper,
    Int()                    $mech_type,
    GckObject()              $wrapped,
                             $n_result      is rw,
    GCancellable()           $cancellable          = GCancellable,
    CArray[Pointer[GError]]  $error                = gerror,
                            :$raw                  = False,
                            :$buf                  = False
  ) {
    my gulong $m = $mech_type;
    my gsize  $n = 0;

    clear_error;
    my $r = gck_session_wrap_key(
      $!gs,
      $wrapper,
      $m,
      $wrapped,
      $n,
      $cancellable,
      $error
    );
    set_error($error);

    $n_result = $n;
    return ($r, $n) if $raw;
    my $ca = SizedCArray.new($r, $n);
    return $ca unless $buf;
    Buf[uint8].new($ca);
  }

  proto method wrap_key_async (|)
    is also<wrap-key-async>
  { * }

  multi method wrap_key_async (
    GckObject()     $wrapper,
    GckMechanism()  $mechanism,
    GckObject()     $wrapped,
                    &callback,
    gpointer        $user_data   = gpointer,
    GCancellable() :$cancellable = GCancellable
  ) {
    samewith(
      $wrapper,
      $mechanism,
      $wrapped,
      $cancellable,
      &callback,
      $user_data
    );
  }
  multi method wrap_key_async (
    GckObject()         $wrapper,
    GckMechanism()      $mechanism,
    GckObject()         $wrapped,
    GCancellable()      $cancellable,
                        &callback,
    gpointer            $user_data    = gpointer
  ) {
    gck_session_wrap_key_async(
      $!gs,
      $wrapper,
      $mechanism,
      $wrapped,
      $cancellable,
      &callback,
      $user_data
    );
  }

  proto method wrap_key_finish (|)
    is also<wrap-key-finish>
  { * }

  multi method wrap_key_finish (
    GAsyncResult()           $result,
                             $n_result is rw,
    CArray[Pointer[GError]]  $error           = gerror,
                            :$raw             = False,
                            :$buf             = True
  ) {
    my gsize $n = $n_result;

    clear_error;
    my $r = gck_session_wrap_key_finish($!gs, $result, $n, $error);
    set_error($error);

    $n_result = $n;
    return ($r, $n) if $raw;
    my $ca = SizedCArray.new($r, $n);
    return $ca unless $buf;
    Buf[uint8].new($ca);
  }

  proto method wrap_key_full (|)
    is also<wrap-key-full>
  { * }

  multi method wrap_key_full (
    GckObject()              $wrapper,
    GckMechanism()           $mechanism,
    GckObject()              $wrapped,
    CArray[Pointer[GError]]  $error                = gerror,
    GCancellable()          :$cancellable          = GCancellable,
                            :$raw                  = False,
                            :$buf                  = True
  ) {
    samewith(
      $wrapper,
      $mechanism,
      $wrapped,
      $,
      $cancellable,
      $error
    );
  }
  multi method wrap_key_full (
    GckObject()              $wrapper,
    GckMechanism()           $mechanism,
    GckObject()              $wrapped,
                             $n_result     is rw,
    GCancellable()           $cancellable          = GCancellable,
    CArray[Pointer[GError]]  $error                = gerror,
                            :$raw                  = False,
                            :$buf                  = True
  ) {
    my gsize $n = $n_result;

    clear_error;
    my $r = gck_session_wrap_key_full(
      $!gs,
      $wrapper,
      $mechanism,
      $wrapped,
      $n,
      $cancellable,
      $error
    );
    set_error($error);

    $n_result = $n;
    return ($r, $n) if $raw;
    my $ca = SizedCArray.new($r, $n);
    return $ca unless $buf;
    Buf[uint8].new($ca);
  }

}

sub processSessionOptions (
  Int() $options is copy,
  :$ro,
  :$rw      is copy,
  :$login,
  :$auth
)
  is export
{
  $rw = $ro.not if $ro.defined;
  for $rw, $login, $auth {
    $options +|= .so ?? .so !! +^( .so ) with $_;
  }

  $options;
}
