use v6.c;

use NativeCall;

use GCR::Raw::Types;
use GCK::Raw::Session;

use GLib::GList;
use GIO::TlsInteraction;
use GCK::Object;

use GLib::Roles::Implementor;
use GLib::Roles::Object;

class GCK::Session {
  also does GLib::Roles::Object;

  has GckSession $!gs is implementor;

  multi method new ($slot, $session_handle, $options) {
    self.from_handle($slot, $session_handle, $options)
  }
  method from_handle (
    GckSlot() $slot,
    Int()     $session_handle,
    Int()     $options
  ) {
    my gulong            $s = $session_handle;
    my GckSessionOptions $o = $options;

    my $gck-session = gck_session_from_handle($slot, $s, $o);

    $gck-session ?? self.bless( :$gck-session ) !! Nil;
  }

  method create_object (
    GckAttributes()          $attrs,
    GCancellable()           $cancellable = GCancellable,
    CArray[Pointer[GError]]  $error       = gerror,
                            :$raw         = False
  ) {
    clear_error;
    my $o = gck_session_create_object($!gs, $attrs, $cancellable, $error);
    set_error($error);
    propReturnObject($o, $raw, |GCK::Object.getTypePair);
  }

  proto method create_object_async (|)
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
  ) {
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
  ) {
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
  ) {
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
  ) {
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
    # samewith(
    #    $key
    #    $mechanism,
    #    ArrayToCArray( @input, typed => uint8 ),
    #    @input.elems,
    #    $cancellable,
    #    $error,
    #   :$raw
    # );
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

  method enumerate_objects (GckAttributes() $match, :$raw = False) {
    propReturnObject(
      gck_session_enumerate_objects($!gs, $match),
      $raw,
      |GCK::Enumerator.getTypePair
    );
  }

  proto method find_handles (|)
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
  ) {
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
  ) {
    clear_error;
    my $r = gck_session_find_objects($!gs, $match, $cancellable, $error);
    set_error($error);
    returnGList($r, $raw, $glist, |GCK::Object.getTypePair);
  }

  proto method find_objects_async (|)
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
  ) {
    clear_error;
    my $r = gck_session_find_objects_finish($!gs, $result, $error);
    set_error($error);
    returnGList($r, $raw, $glist, |GCK::Object.getTypePair);
  }

  proto method generate_key_pair (|)
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

  method get_handle {
    gck_session_get_handle($!gs);
  }

  method get_info {
    gck_session_get_info($!gs);
  }

  method get_interaction ( :$raw = False ) {
    propReturnObject(
      gck_session_get_interaction($!gs),
      $raw,
      |GIO::TlsInteraction.getTypePair
    )
  }

  method get_module ( :$raw = False ) {
    propReturnObject(
      gck_session_get_module($!gs),
      $raw,
      |GCK::Module.getTypePair
    );
  }

  method get_options ( :set(:$flags) = True ) {
    my $f = gck_session_get_options($!gs);
    return $f unless $flags;
    getFlags(GckSessionOptionsEnum, $f);
  }

  method get_slot ( :$raw = False ) {
    propReturnObject(
      gck_session_get_slot($!gs),
      $raw,
      |GCK::Slot.getTypePair
    );
  }

  method get_state {
    gck_session_get_state($!gs);
  }

  method get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &gck_session_get_type, $n, $t );
  }

  proto method init_pin (|)
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

    so gck_session_init_pin($!gck, $pin, $n, $cancellable, $error);
  }

  proto method init_pin_async (|)
  { * }

  multi method init_pin_async (
     &callback,
     $user_data                           = gpointer,
    :$cancellable                         = GCancellable
  ) {
    samewith(
       Str,
       &callback,
       $user_data
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
    my gsuze $n = $n_pin;

    gck_session_init_pin_async(
      $!gck,
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
  ) {
    clear_error
    my $r = so gck_session_init_pin_finish($!gck, $result, $error);
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
      :$cancellalble,
      :n_pin(0)
    )
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
    my $r = gck_session_login($!gck, $u, $pin, $n, $cancellable, $error);
    set_error($error);
    $r;
  }

  proto method login_async (|)
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
      $!gck,
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
  ) {
    gck_session_login_finish($!gck, $result, $error);
  }

  proto method login_interactive (|)
  { * }

  multi method login_interactive (
     $user_type,
     $error       = gerror
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
      $!gck,
      $u,
      $interaction,
      $cancellable,
      $error
    );
    set_error($error);
    $r;
  }

  proto method login_interactive_async (|)
  { * }

  multi method login_interactive_async (
     $user_type,
     &callback,
     $user_data   = gpointer
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
      $!gck,
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
  ) {
    clear_error;
    my $r = gck_session_login_interactive_finish($!gck, $result, $error);
    set_error($error);
    $r;
  }

  method logout (
    GCancellable            $cancellable = GCancellable,
    CArray[Pointer[GError]] $error       = gerror
  ) {
    clear_error;
    my $r = gck_session_logout($!gck, $cancellable, $error);
    set_error($error_;
    $r;
  }

  proto method logout_async (|)
  { * }

  method logout_async (
     $callback,
     $user_data   = gpointer,
    :$cancellable = GCncellable
  ) {
    samewith($cancellable, &callback, $user_data);
  }
  method logout_async (
    GCancellable() $cancellable,
                   $callback,
    gpointer       $user_data     = gpointer
  ) {
    gck_session_logout_async($!gck, $cancellable, &callback, $user_data);
  }

  method logout_finish (
    GAsyncResult()          $result,
    CArray[Pointer[GError]] $error    = gerror
  ) {
    clear_error
    my $r = gck_session_logout_finish($!gck, $result, $error);
    set_error($error);
    $r;
  }

  method processOptions (Int() $options is copy, $ro, $rw, $login, $auth) {
    for $ro, $rw, $login, $auth {
      $options +|= .so ?? .so !! +^( .so ) with $_;
    }

    $options;
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
      $.processOptions($options, $ro, $rw, $login, $auth),
      $interaction,
      $cancellable,
      $ereror
    );
  }
  method open (
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
      $.processOptions($options, $ro, $rw, $login, $auth),
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
      $callback,
      $user_data
    );
  }

  method open_finish (
    GAsyncResult()          $result,
    CArray[Pointer[GError]] $error   = gerror
  ) {
    clear_error;
    my $gck-session = gck_session_open_finish($!gck, $error);
    set_error($error);

    $gck-session ?? self.bless( :$gck-session ) !! Nil;
  }

  method set_interaction (GTlsInteraction() $interaction) {
    gck_session_set_interaction($!gck, $interaction);
  }

  proto method set_pin (|)
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
      $!gck,
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
      $!gck,
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
  ) {
    clear_error
    my $r = so gck_session_set_pin_finish($!gck, $result, $error);
    set_erorr($error);
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
        $
        $cancellable
        $error
      :$raw
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
      $!gck,
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
    return ($o, $nr) if $raw;
    my $ca = SizedCArray.new($o, $nr);
    return $ca unless $buf;
    Buf[uint8].new($ca);
  }

  proto method sign_async (|)
  { * }

  multi method sign_async (
          $key,
          $mechanism,
    Buf   $input,
          &callback,
          $user_data   = gpointer
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
                   $user_data   = gpointer
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
    CArray[uin8]        $input,
    Int()               $n_input,
    GCancellable()      $cancellable,
                        &callback,
    gpointer            $user_data     = gpointer
  ) {
    my gsize $ni = $n_input;

    gck_session_sign_async(
      $!gck,
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
  ) {
    my gsize $nr = 0;

    clear_error;
    my $r = gck_session_sign_finish($!gck, $result, $nr, $error);
    set_error($error);
    $n_result = $nr;
    return ($o, $nr) if $raw;
    my $ca = SizedCArray.new($o, $nr);
    return $ca unless $buf;
    Buf[uint8].new($ca);
  }

  proto method sign_full (|)
  { * }

  multi method sign_full (
         $key,
         $mechanism,
    Buf  $input,
         $error               = gerror,
        :$raw                 = False,
        :$buf                 = True
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
      $!gck,
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
    my $ca = SizedCArray.new($o, $nr);
    return $ca unless $buf;
    Buf[uint8].new($ca);
  }

  proto method unwrap_key (|)
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
      CAray[uint8].new($input),
      $input.bytes,
      $attrs,
      $cancellable,
      $error
    )
  }
  method unwrap_key (
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
      $!gck,
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
  { * }

  method unwrap_key_async (
         $wrapper,
         $mechanism,
    Buf  $input,
         $attrs,
         &callback,
         $user_data     = gpointer
        :$cancellable,
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
  method unwrap_key_async (
                   $wrapper,
                   $mechanism,
    CArray[uint8]  $input,
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
  method unwrap_key_async (
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
      $!gck,
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
  ) {
    clear_error;
    my $o = gck_session_unwrap_key_finish($!gck, $result, $error);
    set_error($error);
    propReturnObject($o, $raw, |GCK::Object.getTypePair);
  }

  proto method unwrap_key_full (|)
  { * }

  multi method unwrap_key_full (
            $wrapper,
            $mechanism,
      Blob  $input,
            $attrs,
            $error       = gerror,
           :$raw         = False
           :$cancellable = GCancellable,
  ) {
    samewith(
       $wrapper,
       $mechanism,
       CArray[uint8].new($input),
       $input.bytes,
       $attrs,
       $cancellable,
       $error
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
      $!gck,
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
    when Str           { $input.chars }
    when Blob          { $input.bytes }

    when CArray[uint8] {
      CATCH {
        default {
          X::GLib::CArrayUnknownSize.new.throw
            if .message.contains( q<Don't know how many elements> );
        }
      }
      $input.elems
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
      $!gck,
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

  proto multi method verify_async (|)
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
      $error
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
      $!gck,
      $key,
      $mechanism,
      $input,
      $ni,
      $signature,
      $ns,
      $cancellable,
      $callback,
      $user_data
    );
  }

  method verify_finish (
    GAsyncResult()          $result,
    CArray[Pointer[GError]] $error    = gerror
  ) {
    clear_error;
    my $r = so gck_session_verify_finish($!gck, $result, $error);
    set_error($error);
  }

  proto multi method verify_full (|)

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
      $!gck,
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

  method wrap_key (
    GckObject               $wrapper,
    gulong                  $mech_type,
    GckObject               $wrapped,
    gsize                   $n_result      is rw,
    GCancellable            $cancellable,
    CArray[Pointer[GError]] $error
  ) {
    gck_session_wrap_key($!gck, $wrapper, $mech_type, $wrapped, $n_result, $cancellable, $error);
  }

  method wrap_key_async (
    GckObject           $wrapper,
    GckMechanism        $mechanism,
    GckObject           $wrapped,
    GCancellable        $cancellable,
    GAsyncReadyCallback $callback,
    gpointer            $user_data
  ) {
    gck_session_wrap_key_async($!gck, $wrapper, $mechanism, $wrapped, $cancellable, $callback, $user_data);
  }

  method wrap_key_finish (
    GAsyncResult            $result,
    gsize                   $n_result is rw,
    CArray[Pointer[GError]] $error
  ) {
    gck_session_wrap_key_finish($!gck, $result, $n_result, $error);
  }

  method wrap_key_full (
    GckObject               $wrapper,
    GckMechanism            $mechanism,
    GckObject               $wrapped,
    gsize                   $n_result     is rw,
    GCancellable            $cancellable,
    CArray[Pointer[GError]] $error
  ) {
    gck_session_wrap_key_full($!gck, $wrapper, $mechanism, $wrapped, $n_result, $cancellable, $error);
  }

}
