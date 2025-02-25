use v6.c;

use Method::Also;

use GCR::Raw::Types;
use GCR::Raw::Secret::Exchange;

use GLib::Roles::Implementor;
use GLib::Roles::Object;

our subset GcrSecretExchangeAncestry is export of Mu
  where GcrSecretExchange | GObject;

class GCR::Secret::Exchange {
  also does GLib::Roles::Object;

  has GcrSecretExchange $!gse is implementor;

  submethod BUILD ( :$gcr-secret-exchange ) {
    self.setGcrSecretExchange($gcr-secret-exchange) if $gcr-secret-exchange
  }

  method setGcrSecretExchange (GcrSecretExchangeAncestry $_) {
    my $to-parent;

    $!gse = do {
      when GcrSecretExchange {
        $to-parent = cast(GObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GcrSecretExchange, $_);
      }
    }
    self!setObject($to-parent);
  }

  method Gcr::Raw::Definitions::GcrSecretExchange
    is also<GcrSecretExchange>
  { $!gse }

  multi method new (
    $gcr-secret-exchange where * ~~ GcrSecretExchangeAncestry ,

    :$ref = True
  ) {
    return unless $gcr-secret-exchange;

    my $o = self.bless( :$gcr-secret-exchange );
    $o.ref if $ref;
    $o;
  }
  multi method new (Str() $protocol) {
    my $gcr-secret-exchange = gcr_secret_exchange_new($protocol);

    $gcr-secret-exchange ?? self.bless( :$gcr-secret-exchange ) !! Nil;
  }

  # Type: string
  method protocol is rw  is g-property {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('protocol', $gv);
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('protocol', $gv);
      }
    );
  }

  method begin {
    gcr_secret_exchange_begin($!gse);
  }

  method get_protocol is also<get-protocol> {
    gcr_secret_exchange_get_protocol($!gse);
  }


  proto method get_secret (|)
    is also<get-secret>
  { * }

  multi method get_secret {
    samewith($);
  }
  multi method get_secret ($secret_len is rw) {
    my gsize $s = 0;
    my       $r = gcr_secret_exchange_get_secret($!gse, $s);

    $secret_len = $s;
    $r
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gcr_secret_exchange_get_type, $n, $t );
  }

  method receive (Str() $exchange) {
    gcr_secret_exchange_receive($!gse, $exchange);
  }

  method send (Str() $secret, Int() $secret_len = $secret.chars) {
    my gssize $s = $secret_len;

    gcr_secret_exchange_send($!gse, $secret, $s);
  }

}
