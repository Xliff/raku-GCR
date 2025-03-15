use v6.c;

use Method::Also;
use NativeCall;

use GCR::Raw::Types;
use GCR::Raw::Importer;

use GLib::GList;

use GLib::Roles::Implementor;
use GLib::Roles::Object;

our subset GcrImporterAncestry is export of Mu
  where GcrImporter | GObject;

class GCR::Importer {
  also does GLib::Roles::Object;

  has GcrImporter $!gi is implementor;

  submethod BUILD ( :$gcr-importer ) {
    self.setGcrImporter($gcr-importer) if $gcr-importer
  }

  method setGcrImporter (GcrImporterAncestry $_) {
    my $to-parent;

    $!gi = do {
      when GcrImporter {
        $to-parent = cast(GObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GcrImporter, $_);
      }
    }
    self!setObject($to-parent);
  }

  method GCR::Raw::Definitions::GcrImporter
    is also<GcrImporter>
  { $!gi }

  multi method new (
    $gcr-importer where * ~~ GcrImporterAncestry,

    :$ref = True
  ) {
    return unless $gcr-importer;

    my $o = self.bless( :$gcr-importer );
    $o.ref if $ref;
    $o;
  }

  # Type: GcrTlsInteraction
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

  # Type: string
  method label is rw  is g-property {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('label', $gv);
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        warn 'label does not allow writing'
      }
    );
  }

  # Type: string
  method uri is rw  is g-property {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('uri', $gv);
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        warn 'uri does not allow writing'
      }
    );
  }

  method create_for_parsed (
    GcrParsed()  $parsed,
                :$raw            = False,
                :gslist(:$glist) = False
  )
    is also<create-for-parsed>
  {
    returnGList(
      gcr_importer_create_for_parsed($parsed),
      $raw,
      $glist,
      |self.getTypePair
    );
  }

  method get_interaction ( :$raw = False ) is also<get-interaction> {
    propReturnObject(
      gcr_importer_get_interaction($!gi),
      $raw,
      |GIO::TlsInteraction.getTypePair
    );
  }

  method import_async (
    GCancellable() $cancellable,
                   &callback,
    gpointer       $user_data     = gpointer
  )
    is also<import-async>
  {
    gcr_importer_import_async($!gi, $cancellable, &callback, $user_data);
  }

  method import_finish (
    GAsyncResult()          $result,
    CArray[Pointer[GError]] $error      = gerror
  )
    is also<import-finish>
  {
    clear_error;
    my $r = so gcr_importer_import_finish($!gi, $result, $error);
    set_error($error);
    $r;
  }

  method queue_and_filter_for_parsed (
    GcrParsed()  $parsed
                :$raw            = False,
                :gslist(:$glist) = False
  )
    is also<queue-and-filter-for-parsed>
  {
    propReturnObject(
      gcr_importer_queue_and_filter_for_parsed($!gi, $parsed),
      $raw,
      $glist,
      |self.getTypePair
    );
  }

  method queue_for_parsed (GcrParsed() $parsed) is also<queue-for-parsed> {
    so gcr_importer_queue_for_parsed($!gi, $parsed);
  }

  method register (
    Int()           $importer_type,
    GckAttributes() $attrs
  ) {
    my GType $i = $importer_type;

    gcr_importer_register($i, $attrs);
  }

  method register_well_known is also<register-well-known> {
    gcr_importer_register_well_known();
  }

  method set_interaction (GTlsInteraction() $interaction) is also<set-interaction> {
    gcr_importer_set_interaction($!gi, $interaction);
  }

}
