use v6.c;

use GLib::Raw::Definitions;
use GCR::Raw::Definitions;

unit package GCR::Raw::Secret::Exchange;

### /home/cbwood/Projects/gcr/gcr/gcr-secret-exchange.h

sub gcr_secret_exchange_begin (GcrSecretExchange $self)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gcr_secret_exchange_get_protocol (GcrSecretExchange $self)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gcr_secret_exchange_get_secret (
  GcrSecretExchange $self,
  gsize             $secret_len
)
  returns Str
  is      native(gcr)
  is      export
{ * }

sub gcr_secret_exchange_get_type
  returns GType
  is      native(gcr)
  is      export
{ * }

sub gcr_secret_exchange_new (Str $protocol)
  returns GcrSecretExchange
  is      native(gcr)
  is      export
{ * }

sub gcr_secret_exchange_receive (
  GcrSecretExchange $self,
  Str               $exchange
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gcr_secret_exchange_send (
  GcrSecretExchange $self,
  Str               $secret,
  gssize            $secret_len
)
  returns Str
  is      native(gcr)
  is      export
{ * }
