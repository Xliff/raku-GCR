use v6.c;

use Method::Also;

use GCR::Raw::Types;
use GCR::Raw::Subject::PublicKey::Info;

use GLib::Bytes;

use GLib::Roles::Implementor;
use GLib::Roles::Object;

our subset GcrSubjectPublicKeyInfoAncestry is export of Mu
  where GcrSubjectPublicKeyInfo | GObject;

class GCR::Subject::PublicKey::Info {
  also does GLib::Roles::Object;
  
  has GcrSubjectPublicKeyInfo $!gpki is implementor;

  submethod BUILD ( :$gcr-pubkey-info ) {
    self.setGcrSubjectPublicKeyInfo($gcr-pubkey-info)
      if $gcr-pubkey-info
  }

  method setGcrSubjectPublicKeyInfo (GcrSubjectPublicKeyInfoAncestry $_) {
    my $to-parent;

    $!gpki = do {
      when GcrSubjectPublicKeyInfo {
        $to-parent = cast(GObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GcrSubjectPublicKeyInfo, $_);
      }
    }
    self!setObject($to-parent);
  }

  method GCR::Raw::Definitions::GcrSubjectPublicKeyInfo
    is also<GcrSubjectPublicKeyInfo>
  { $!gpki }

  multi method new (
    $gcr-pubkey-info where * ~~ GcrSubjectPublicKeyInfoAncestry,

    :$ref = True
  ) {
    return unless $gcr-pubkey-info;

    my $o = self.bless( :$gcr-pubkey-info );
    $o.ref if $ref;
    $o;
  }

  method copy ( :$raw = False )  {
    propReturnObject(
      gcr_subject_public_key_info_copy($!gpki),
      $raw,
      |self.getTypePair
    );
  }

  method free {
    gcr_subject_public_key_info_free($!gpki);
  }

  method get_algorithm_description is also<get-algorithm-description> {
    gcr_subject_public_key_info_get_algorithm_description($!gpki);
  }

  method get_algorithm_oid is also<get-algorithm-oid> {
    gcr_subject_public_key_info_get_algorithm_oid($!gpki);
  }

  method get_algorithm_parameters_raw ( :$raw = False )
    is also<get-algorithm-parameters-raw>
  {
    propReturnObject(
      gcr_subject_public_key_info_get_algorithm_parameters_raw(
        $!gpki
      ),
      $raw,
      |GLib::Bytes.getTypePair
    );
  }

  method get_key ( :$raw = False ) is also<get-key> {
    propReturnObject(
      gcr_subject_public_key_info_get_key($!gpki),
      $raw,
      |GLib::Bytes.getTypePair
    );
  }

  method get_key_size is also<get-key-size> {
    gcr_subject_public_key_info_get_key_size($!gpki);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &gcr_subject_public_key_info_get_type,
      $n,
      $t
    );
  }

}
