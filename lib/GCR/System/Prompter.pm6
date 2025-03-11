use v6.c;

use Method::Also;

use GCR::Raw::Types;
use GCR::Raw::System::Prompter;

use GLib::Roles::Implementor;
use GLib::Roles::Object;

our subset GcrSystemPrompterAncestry is export of Mu
  where GcrSystemPrompter | GObject;

class GCR::System::Prompter {
  also does GLib::Roles::Object;

  has GcrSystemPrompter $!gsp is implementor;

  submethod BUILD ( :$gcr-system-prompter ) {
    self.setGcrSystemPrompter($gcr-system-prompter) if $gcr-system-prompter
  }

  method setGcrSystemPrompter (GcrSystemPrompterAncestry $_) {
    my $to-parent;

    $!gsp = do {
      when GcrSystemPrompter {
        $to-parent = cast(GObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GcrSystemPrompter, $_);
      }
    }
    self!setObject($to-parent);
  }

  method GCR::Raw::Definitions::GcrSystemPrompter
    is also<GcrSystemPrompter>
  { $!gsp }

  multi method new (
    $gcr-system-prompter where * ~~ GcrSystemPrompterAncestry,

    :$ref = True
  ) {
    return unless $gcr-system-prompter;

    my $o = self.bless( :$gcr-system-prompter );
    $o.ref if $ref;
    $o;
  }
  multi method new (Int() $mode, Int() $prompt_type) {
    my GcrSystemPrompterMode $m = $mode;
    my GType                 $p = $prompt_type;

    my $gcr-system-prompter = gcr_system_prompter_new($m, $p);

    $gcr-system-prompter ?? self.bless( :$gcr-system-prompter ) !! Nil;
  }

  # Type: GcrSystemPrompterMode
  method mode ( :$enum = True ) is rw  is g-property {
    my $gv = GLib::Value.new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('mode', $gv);
        my $m = $gv.enum;
        return $m unless $enum;
        GcrSystemPrompterModeEnum($m);
      },
      STORE => -> $, Int() $val is copy {
        $gv.valueFromEnum(GcrSystemPrompterMode) = $val;
        self.prop_set('mode', $gv);
      }
    );
  }

  # Type: GType
  method prompt-type is rw  is g-property {
    my $gv = GLib::Value.new( G_TYPE_UINT64 );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('prompt-type', $gv);
        $gv.uint64;
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint64 = $val;
        self.prop_set('prompt-type', $gv);
      }
    );
  }

  # Type: boolean
  method prompting is rw  is g-property {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('prompting', $gv);
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        warn 'prompting does not allow writing'
      }
    );
  }

  method get_mode ( :$enum = True ) is also<get-mode> {
    my $m = gcr_system_prompter_get_mode($!gsp);
    return $m unless $enum;
    GcrSystemPrompterModeEnum($m);
  }

  method get_prompt_type is also<get-prompt-type> {
    gcr_system_prompter_get_prompt_type($!gsp);
  }

  method get_prompting is also<get-prompting> {
    gcr_system_prompter_get_prompting($!gsp);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gcr_system_prompter_get_type, $n, $t );
  }

  method register (GDBusConnection() $connection) {
    gcr_system_prompter_register($!gsp, $connection);
  }

  method unregister (Int() $wait) {
    my gboolean $w = $wait.so.Int;

    gcr_system_prompter_unregister($!gsp, $w);
  }

}
