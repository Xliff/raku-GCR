use v6.c;

use Method::Also;
use NativeCall;

use GLib::Raw::Traits;
use GCR::Raw::Types;
use GCR::Raw::System::Prompt;

use GCR::Secret::Exchange;

our subset GcrSystemPromptAncestry is export of Mu
  where GcrSystemPrompt | GObject;

class GCR::System::Prompt {
  also does GLib::Roles::Object;

  has GcrSystemPrompt $!gcp is implementor;

  submethod BUILD ( :$gcr-system-prompt ) {
    self.setGcrSystemPrompt($gcr-system-prompt) if $gcr-system-prompt
  }

  method setGcrSystemPrompt (GcrSystemPromptAncestry $_) {
    my $to-parent;

    $!gcp = do {
      when GcrSystemPrompt {
        $to-parent = cast(GObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GcrSystemPrompt, $_);
      }
    }
    self!setObject($to-parent);
  }

  method GCR::Raw::Definitions::GcrSystemPrompt
    is also<GcrSystemPrompt>
  { $!gcp }

  multi method new (
    $gcr-system-prompt where * ~~ GcrSystemPromptAncestry,

    :$ref = True
  ) {
    return unless $gcr-system-prompt;

    my $o = self.bless( :$gcr-system-prompt );
    $o.ref if $ref;
    $o;
  }

  method open (
    Int()                   $timeout_seconds,
    GCancellable()          $cancellable       = GCancellable,
    CArray[Pointer[GError]] $error             = gerror
  ) {
    my gint $t = $timeout_seconds;

    clear_error;
    my $gcr-system-prompt = gcr_system_prompt_open($t, $cancellable, $error);
    set_error($error);

    $gcr-system-prompt ?? self.bless( :$gcr-system-prompt ) !! Nil;
  }

  proto method open_async (|)
    is also<open-async>
  { * }

  multi method open_async (
    $timeout_seconds,
    &callback,
    $user_data        = gpointer,
    $cancellable      = GCancellable
  ) {
    samewith(
      $timeout_seconds,
      $cancellable,
      &callback,
      $user_data
    );
  }
  multi method open_async (
    Int()          $timeout_seconds,
    GCancellable() $cancellable,
                   &callback,
    gpointer       $user_data        = gpointer
  ) {
    gcr_system_prompt_open_async($!gcp, $cancellable, &callback, $user_data);
  }

  method open_finish (
    GAsyncResult()          $result,
    CArray[Pointer[GError]] $error   = gerror
  )
    is also<open-finish>
  {
    clear_error;
    my $gcr-system-prompt = gcr_system_prompt_open_finish($result, $error);
    set_error($error);

    $gcr-system-prompt ?? self.bless( :$gcr-system-prompt ) !! Nil;
  }

  method open_for_prompter (
    Str()                   $prompter_name,
    Int()                   $timeout_seconds,
    GCancellable()          $cancellable      = GCancellable,
    CArray[Pointer[GError]] $error            = gerror
  )
    is also<open-for-prompter>
  {
    my gint $t = $timeout_seconds;

    clear_error;
    my $gcr-system-prompt = gcr_system_prompt_open_for_prompter(
      $t,
      $!gcp,
      $cancellable,
      $error
    );
    set_error($error);

    $gcr-system-prompt ?? self.bless( :$gcr-system-prompt ) !! Nil
  }

  proto method open_for_prompter_async (|)
    is also<open-for-prompter-async>
  { * }

  multi method open_for_prompter_async (
    Str()          $prompter_name,
    Int()          $timeout_seconds,
    GCancellable() $cancellable,
                   &callback,
    gpointer       $user_data        = gpointer
  ) {
    samewith(
      $prompter_name,
      $timeout_seconds,
      $cancellable,
      &callback,
      $user_data
    );
  }
  multi method open_for_prompter_async (
    Str()          $prompter_name,
    Int()          $timeout_seconds,
    GCancellable() $cancellable,
                   &callback,
    gpointer       $user_data         = gpointer
  ) {
    my gint $t = $timeout_seconds;

    gcr_system_prompt_open_for_prompter_async(
      $!gcp,
      $t,
      $cancellable,
      &callback,
      $user_data
    );
  }

  # Type: string
  method bus-name is rw  is g-property is also<bus_name> {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('bus-name', $gv);
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('bus-name', $gv);
      }
    );
  }

  # Type: GcrSecretExchange
  method secret-exchange ( :$raw = False )
    is rw
    is g-property
    is also<secret_exchange>
  {
    my $gv = GLib::Value.new( GCR::Secret::Exchange.get_type );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('secret-exchange', $gv);
        propReturnObject(
          $gv.object,
          $raw,
          |GCR::Secret::Exchange.getTypePair
        );
      },
      STORE => -> $, GcrSecretExchange() $val is copy {
        $gv.object = $val;
        self.prop_set('secret-exchange', $gv);
      }
    );
  }

  # Type: int
  method timeout-seconds is rw  is g-property is also<timeout_seconds> {
    my $gv = GLib::Value.new( G_TYPE_INT );
    Proxy.new(
      FETCH => sub ($) {
        warn 'timeout-seconds does not allow reading' if $DEBUG;
        0;
      },
      STORE => -> $, Int() $val is copy {
        $gv.int = $val;
        self.prop_set('timeout-seconds', $gv);
      }
    );
  }

  method close (
    GCancellable()          $cancellable,
    CArray[Pointer[GError]] $error        = gerror
  ) {
    clear_error;
    gcr_system_prompt_close($!gcp, $cancellable, $error);
    set_error($error);
  }

  proto method close_async (|)
    is also<close-async>
  { * }

  multi method close_async (
     &callback,
     $user_data   = gerror,
    :$cancellable = GCancellable
  ) {
    samewith($cancellable, &callback, $user_data);
  }
  multi method close_async (
    GCancellable() $cancellable,
                   &callback,
    gpointer       $user_data     = gpointer
  ) {
    gcr_system_prompt_close_async($!gcp, $cancellable, &callback, $user_data);
  }

  method close_finish (
    GAsyncResult()          $result,
    CArray[Pointer[GError]] $error   = gerror
  )
    is also<close-finish>
  {
    clear_error;
    gcr_system_prompt_close_finish($!gcp, $result, $error);
    set_error($error);
  }

  method get_secret_exchange ( :$raw = False ) is also<get-secret-exchange> {
    propReturnObject(
      gcr_system_prompt_get_secret_exchange($!gcp),
      $raw,
      |GCR::System::Exchange.getTypePair
    );
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gcr_system_prompt_get_type, $n, $t );
  }

}

use GLib::Roles::StaticClass;

class GCR::System::Prompt::Error {
  also does GLib::Roles::StaticClass;

  method get_domain is also<get-domain> {
    gcr_system_prompt_error_get_domain;
  }
}
