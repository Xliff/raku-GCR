use v6.c;

use Method::Also;

use NativeCall;

use GCR::Raw::Types;
use GCR::Raw::Parser;

use GLib::Bytes;
use GCK::Attributes;

use GLib::Roles::Implementor;
use GLib::Roles::Object;

our subset GcrParsedAncestry is export of Mu
  where GcrParsed | GObject;

class GCR::Parsed {
  also does GLib::Roles::Implementor;

  has GcrParsed $!gp is implementor;

  submethod BUILD ( :gcr-parser(:$!gp) ) { }

  method GCR::Raw::Definitions::GcrParsed
  { $!gp }

  method get_attributes ( :$raw = False ) is also<get-attributes> {
    propReturnObject(
      gcr_parsed_get_attributes($!gp),
      $raw,
      |::('GCR::Parser').getTypePair
    )
  }

  method get_bytes ( :$raw = False ) is also<get-bytes> {
    propReturnObject(
      gcr_parsed_get_bytes($!gp),
      $raw,
      |GLib::Bytes.getTypePair
    );
  }

  proto method get_data (|)
    is also<get-data>
  { * }

  multi method get_data (:$raw = False, :$buf = True) {
    samewith($, :$raw, :$buf);
  }
  multi method get_data ($n_data is rw, :$raw = False, :$buf = True) {
    my gsize $n = 0;

    my $data = gcr_parsed_get_data($!gp, $n);
    $n_data = $n;
    return $data if $raw;

    $data = SizedCArray.new($data, $n);
    return $data unless $buf;

    Buf[uint8].new($data);
  }

  method get_description is also<get-description> {
    gcr_parsed_get_description($!gp);
  }

  method get_filename is also<get-filename> {
    gcr_parsed_get_filename($!gp);
  }

  method get_format ( :$enum = True ) is also<get-format> {
    my $f = gcr_parsed_get_format($!gp);
    return $f unless $enum;
    GcrDataFormatEnum($f);
  }

  method get_label is also<get-label> {
    gcr_parsed_get_label($!gp);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gcr_parsed_get_type, $n, $t );
  }

  method ref {
    gcr_parsed_ref($!gp);
    self
  }

  method unref {
    gcr_parsed_unref($!gp);
  }

}

our subset GcrParserAncestry is export of Mu
  where GcrParser | GObject;

class GCR::Parser {
  also does GLib::Roles::Object;

  has GcrParser $!gp is implementor;

  submethod BUILD ( :$gcr-parser ) {
    self.setGcrParser($gcr-parser) if $gcr-parser
  }

  method setGcrParser (GcrParserAncestry $_) {
    my $to-parent;

    $!gp = do {
      when GcrParser {
        $to-parent = cast(GObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GcrParser, $_);
      }
    }
    self!setObject($to-parent);
  }

  method GCR::Raw::Definitions::GcrParser
    is also<GcrParser>
  { $!gp }

  multi method new (
    $gcr-parser where * ~~ GcrParserAncestry,

    :$ref = True
  ) {
    return unless $gcr-parser;

    my $o = self.bless( :$gcr-parser );
    $o.ref if $ref;
    $o;
  }
  multi method new {
    my $gcr-parser = gcr_parser_new();

    $gcr-parser ?? self.bless( :$gcr-parser ) !! Nil;
  }

  # Type: GcrAttributes
  method parsed-attributes ( :$raw = False )
    is rw
    is g-property
    is also<parsed_attributes>
  {
    my $gv = GLib::Value.new( GCK::Attributes.get_type );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('parsed-attributes', $gv);
        propReturnObject(
          $gv.object,
          $raw,
          |GCK::Attributes.getTypePair
        );
      },
      STORE => -> $,  $val is copy {
        warn 'parsed-attributes does not allow writing'
      }
    );
  }

  # Type: string
  method parsed-description
    is rw
    is g-property
    is also<parsed_description>
  {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('parsed-description', $gv);
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        warn 'parsed-description does not allow writing'
      }
    );
  }

  # Type: string
  method parsed-label is rw  is g-property is also<parsed_label> {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('parsed-label', $gv);
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        warn 'parsed-label does not allow writing'
      }
    );
  }

  method Authenticate {
    self.connect-int($!gp, 'authenticate');
  }

  method Parsed {
    self.connect($!gp, 'parsed');
  }

  method add_password (Str() $password) is also<add-password> {
    gcr_parser_add_password($!gp, $password);
  }

  method get_filename is also<get-filename> {
    gcr_parser_get_filename($!gp);
  }

  has $!gp-f;

  method format {
    my $p = $!gp;

    unless $!gp-f {
      $!gp-f = (
        class :: {
          method disable (Int() $format) {
            my GcrDataFormat $f = $format;

            gcr_parser_format_disable($p, $f);
          }

          method enable (Int() $format) {
            my GcrDataFormat $f = $format;

            gcr_parser_format_enable($p, $f);
          }

          method supported (Int() $format) {
            my GcrDataFormat $f = $format;

            gcr_parser_format_supported($p, $f);
          }
        }
      ).new;
    }

    $!gp-f;
  }

  method get_parsed ( :$raw = False ) is also<get-parsed> {
    propReturnObject(
      gcr_parser_get_parsed($!gp),
      $raw,
      |GCR::Parsed.getTypePair
    );
  }

  method get_parsed_attributes ( :$raw = False ) is also<get-parsed-attributes> {
    propReturnObject(
      gcr_parser_get_parsed_attributes($!gp),
      $raw,
      |GCK::Attributes.getTypePair
    );
  }

  method get_parsed_block ($n_block is rw) is also<get-parsed-block> {
    gcr_parser_get_parsed_block($!gp, $n_block);
  }

  method get_parsed_bytes ( :$raw = False ) is also<get-parsed-bytes> {
    propReturnObject(
      gcr_parser_get_parsed_bytes($!gp),
      $raw,
      |GLib::Bytes.getTypePair
    );
  }

  method get_parsed_description is also<get-parsed-description> {
    gcr_parser_get_parsed_description($!gp);
  }

  method get_parsed_format is also<get-parsed-format> {
    gcr_parser_get_parsed_format($!gp);
  }

  method get_parsed_label is also<get-parsed-label> {
    gcr_parser_get_parsed_label($!gp);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gcr_parser_get_type, $n, $t );
  }

  method parse_bytes (
    GBytes()                $data,
    CArray[Pointer[GError]] $error = gerror
  )
    is also<parse-bytes>
  {
    clear_error;
    my $r = so gcr_parser_parse_bytes($!gp, $data, $error);
    set_error($error);
    $r;
  }

  proto method parse_data (|)
    is also<parse-data>
  { * }

  multi method parse_data (
    Blob                    $data,
    CArray[Pointer[GError]] $error = gerror
  ) {
    samewith( CArray[uint8].new($data), $data.bytes, $error );
  }
  multi method parse_data (@data, CArray[Pointer[GError]] $error = gerror) {
    # cw: Checky, pls...
    samewith(
      ArrayToCArray(uint8, @data),
      @data.elems,
      $error
    );
  }
  multi method parse_data (
    CArray[uint8]           $data,
    Int()                   $n_data,
    CArray[Pointer[GError]] $error    = gerror
  ) {
    my gsize $n = $n_data;

    clear_error;
    my $r = so gcr_parser_parse_data($!gp, $data, $n, $error);
    set_error($error);
    $r;
  }

  method parse_stream (
    GInputStream()          $input,
    GCancellable()          $cancellable = GCancellable,
    CArray[Pointer[GError]] $error       = gerror
  )
    is also<parse-stream>
  {
    gcr_parser_parse_stream($!gp, $input, $cancellable, $error);
  }

  proto method parse_stream_async (|)
    is also<parse-stream-async>
  { * }

  multi method parse_stream_async (
    GInputStream()  $input,
                    &callback,
    gpointer        $user_data   = gpointer,
    GCancellable() :$cancellable = GCancellable
  ) {
    samewith($input, $cancellable, &callback, $user_data);
  }
  multi method parse_stream_async (
    GInputStream() $input,
    GCancellable() $cancellable,
                   &callback,
    gpointer       $user_data     = gpointer
  ) {
    gcr_parser_parse_stream_async(
      $!gp,
      $input,
      $cancellable,
      &callback,
      $user_data
    );
  }

  method parse_stream_finish (
    GAsyncResult()          $result,
    CArray[Pointer[GError]] $error    = gerror
  )
    is also<parse-stream-finish>
  {
    clear_error;
    my $r = so gcr_parser_parse_stream_finish($!gp, $result, $error);
    set_error($error);
    $r;
  }

  method set_filename (Str() $filename) is also<set-filename> {
    gcr_parser_set_filename($!gp, $filename);
  }

}
