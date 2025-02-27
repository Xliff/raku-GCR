use v6.c;

use NativeCall;

use GLib::Raw::Traits;
use GCR::Raw::Types;
use GCR::Raw::Prompt;

role GCR::Roles::Prompt {
  has GcrPrompt $!gp is implementor;

  method roleInit-GcrPrompt {
    return if $!gp;

    my \i = findProperImplementor( self.^attributes );
    my \v = i.get_value(self);

    $!gp = cast( GcrPrompt, v );
  }

  method GCR::Raw::Definitions::GcrPrompt
  { $!gp }

  # Type: string
  method caller-window is rw  is g-property {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('caller-window', $gv);
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('caller-window', $gv);
      }
    );
  }

  # Type: string
  method cancel-label is rw  is g-property {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('cancel-label', $gv);
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('cancel-label', $gv);
      }
    );
  }

  # Type: boolean
  method choice-chosen is rw  is g-property {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('choice-chosen', $gv);
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('choice-chosen', $gv);
      }
    );
  }

  # Type: string
  method choice-label is rw  is g-property {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('choice-label', $gv);
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('choice-label', $gv);
      }
    );
  }

  # Type: string
  method continue-label is rw  is g-property {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('continue-label', $gv);
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('continue-label', $gv);
      }
    );
  }

  # Type: string
  method description is rw  is g-property {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('description', $gv);
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('description', $gv);
      }
    );
  }

  # Type: string
  method message is rw  is g-property {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('message', $gv);
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('message', $gv);
      }
    );
  }

  # Type: boolean
  method password-new is rw  is g-property {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('password-new', $gv);
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('password-new', $gv);
      }
    );
  }

  # Type: int
  method password-strength is rw  is g-property {
    my $gv = GLib::Value.new( G_TYPE_INT );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('password-strength', $gv);
        $gv.int;
      },
      STORE => -> $, Int() $val is copy {
        warn 'password-strength does not allow writing'
      }
    );
  }

  # Type: string
  method title is rw  is g-property {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('title', $gv);
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('title', $gv);
      }
    );
  }

  # Type: string
  method warning is rw  is g-property {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('warning', $gv);
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('warning', $gv);
      }
    );
  }

  method Prompt-Close {
    self.connect($!gp, 'prompt-close');
  }

  method close {
    gcr_prompt_close($!gp);
  }

  method confirm (
    GCancellable()          $cancellable,
    CArray[Pointer[GError]] $error        = gerror
  ) {
    clear_error;
    my $r = gcr_prompt_confirm($!gp, $cancellable, $error);
    set_error($error);
    $r;
  }

  proto method confirm_async (|)
  { * }

  multi method confirm_async (
    &callback,
    $cancellable = GCancellable,
    $user_data   = gpointer
  ) {
    samewith($cancellable, &callback, $user_data);
  }
  multi method confirm_async (
    GCancellable() $cancellable,
                   &callback,
    gpointer       $user_data    = gpointer
  ) {
    gcr_prompt_confirm_async($!gp, $cancellable, &callback, $user_data);
  }

  method confirm_finish (
    GAsyncResult()          $result,
    CArray[Pointer[GError]] $error   = gerror
  ) {
    clear_error;
    my $r = gcr_prompt_confirm_finish($!gp, $result, $error);
    set_error($error);
    $r;
  }

  method confirm_run (
    GCancellable()          $cancellable,
    CArray[Pointer[GError]] $error        = gerror
  ) {
    clear_error;
    my $r = gcr_prompt_confirm_run($!gp, $cancellable, $error);
    set_error($error);
    $r;
  }

  method get_caller_window {
    gcr_prompt_get_caller_window($!gp);
  }

  method get_cancel_label {
    gcr_prompt_get_cancel_label($!gp);
  }

  method get_choice_chosen {
    gcr_prompt_get_choice_chosen($!gp);
  }

  method get_choice_label {
    gcr_prompt_get_choice_label($!gp);
  }

  method get_continue_label {
    gcr_prompt_get_continue_label($!gp);
  }

  method get_description {
    gcr_prompt_get_description($!gp);
  }

  method get_message {
    gcr_prompt_get_message($!gp);
  }

  method get_password_new {
    gcr_prompt_get_password_new($!gp);
  }

  method get_password_strength {
    gcr_prompt_get_password_strength($!gp);
  }

  method get_title {
    gcr_prompt_get_title($!gp);
  }

  method gcrprompt_get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &gcr_prompt_get_type, $n, $t );
  }

  method get_warning {
    gcr_prompt_get_warning($!gp);
  }

  method password (
    GCancellable()          $cancellable,
    CArray[Pointer[GError]] $error        = gerror;
  ) {
    clear_error;
    my $r = gcr_prompt_password($!gp, $cancellable, $error);
    set_error($error);
    $r;
  }

  proto method password_async (|)
  { * }

  multi method password_async (
                   &callback,
    GCancellable() $cancellable = GCancellable,
    gpointer       $user_data   = gpointer
  ) {
    samewith($cancellable, &callback, $user_data);
  }
  multi method password_async (
    GCancellable() $cancellable,
                   &callback,
    gpointer       $user_data    = gpointer
  ) {
    gcr_prompt_password_async($!gp, $cancellable, &callback, $user_data);
  }

  method password_finish (
    GAsyncResult()          $result,
    CArray[Pointer[GError]] $error   = gerror
  ) {
    clear_error;
    my $r = gcr_prompt_password_finish($!gp, $result, $error);
    set_error($error);
    $r;
  }

  method password_run (
    GCancellable()          $cancellable = GCancellable,
    CArray[Pointer[GError]] $error       = gerror
  ) {
    clear_error;
    my $r = gcr_prompt_password_run($!gp, $cancellable, $error);
    set_error($error);
    $r;
  }

  method reset {
    gcr_prompt_reset($!gp);
  }

  method set_caller_window (Str() $window_id) {
    gcr_prompt_set_caller_window($!gp, $window_id);
  }

  method set_cancel_label (Str() $cancel_label) {
    gcr_prompt_set_cancel_label($!gp, $cancel_label);
  }

  method set_choice_chosen (Int() $chosen) {
    my gboolean $c = $chosen.so.Int;

    gcr_prompt_set_choice_chosen($!gp, $chosen);
  }

  method set_choice_label (Str() $choice_label) {
    gcr_prompt_set_choice_label($!gp, $choice_label);
  }

  method set_continue_label (Str() $continue_label) {
    gcr_prompt_set_continue_label($!gp, $continue_label);
  }

  method set_description (Str() $description) {
    gcr_prompt_set_description($!gp, $description);
  }

  method set_message (Str() $message) {
    gcr_prompt_set_message($!gp, $message);
  }

  method set_password_new (Int() $new_password) {
    my gboolean $n = $new_password.so.Int;

    gcr_prompt_set_password_new($!gp, $n);
  }

  method set_title (Str() $title) {
    gcr_prompt_set_title($!gp, $title);
  }

  method set_warning (Str() $warning) {
    gcr_prompt_set_warning($!gp, $warning);
  }

}

use GLib::Roles::Object;

our subset GcrPromptAncestry is export of Mu
  where GcrPrompt | GObject;

class GCR::Prompt {
  also does GLib::Roles::Object;
  also does GCR::Roles::Prompt;

  submethod BUILD ( :$gcr-prompt ) {
    self.setGcrPrompt($gcr-prompt) if $gcr-prompt
  }

  method setGcrPrompt (GcrPromptAncestry $_) {
    my $to-parent;

    $!gp = do {
      when GcrPrompt {
        $to-parent = cast(GObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GcrPrompt, $_);
      }
    }
    self!setObject($to-parent);
  }

  multi method new (
    $gcr-prompt where * ~~ GcrPromptAncestry,

    :$ref = True
  ) {
    return unless $gcr-prompt;

    my $o = self.bless( :$gcr-prompt );
    $o.ref if $ref;
    $o;
  }

  method get_type {
    self.gcrprompt_get_type
  }
}
