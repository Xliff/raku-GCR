use v6.c;

use Method::Also;

use NativeCall;

use GCR::Raw::Types;

use GLib::GList;

use GLib::Roles::Implementor;
use GLib::Roles::Object;

class GCR::SSH::Agent::Key::Info {
  also does GLib::Roles::Implementor;

  has GcrSshAgentKeyInfo $!gsaki is implementor;

  submethod BUILD ( :gcr-saki(:$!gsaki) )
  { }

  method GCR::Raw::Definitions::GcrSshAgentKeyInfo
    is also<GcrSshAgentKeyInfo>
  { $!gsaki; }

  multi method new (GcrSshAgentKeyInfo $gcr-saki) {
    $gcr-saki ?? self.bless( :$gcr-saki ) !! Nil;
  }
  multi method new {
    my $gcr-saki = GcrSshAgentKeyInfo.new;

    $gcr-saki ?? self.bless( :$gcr-saki ) !! Nil;
  }

  method copy ( :$raw = False ) {
    propReturnObject(
      gcr_ssh_agent_key_info_copy($!gsaki),
      $raw,
      |self.getTypePair
    )
  }

  method free {
    gcr_ssh_agent_key_info_free($!gsaki);
  }

}


our subset GcrSshAgentPreloadAncestry is export of Mu
  where GcrSshAgentPreload | GObject;

class GCR::SSH::Agent::Preload {
  also does GLib::Roles::Object;

  has GcrSshAgentPreload $!gsap is implementor;

  submethod BUILD ( :$gcr-agent-preload ) {
    self.setGcrSshAgentPreload($gcr-agent-preload) if $gcr-agent-preload
  }

  method setGcrSshAgentPreload (GcrSshAgentPreloadAncestry $_) {
    my $to-parent;

    $!gsap = do {
      when GcrSshAgentPreload {
        $to-parent = cast(GObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GcrSshAgentPreload, $_);
      }
    }
    self!setObject($to-parent);
  }

  method GCR::Raw::Definitions::GcrSshAgentPreload
    is also<GcrSshAgentPreload>
  { $!gsap }

  multi method new (
     $gcr-agent-preload where * ~~ GcrSshAgentPreloadAncestry ,

    :$ref = True
  ) {
    return unless $gcr-agent-preload;

    my $o = self.bless( :$gcr-agent-preload );
    $o.ref if $ref;
    $o;
  }

  multi method new {
    my $gcr-agent-preload = gcr_ssh_agent_preload_new();

    $gcr-agent-preload ?? self.bless( :$gcr-agent-preload ) !! Nil;
  }

  method get_keys ( :$raw = False, :gslist(:$glist) )
    is also<
      get-keys
      keys
    >
  {
    returnGList(
      gcr_ssh_agent_preload_get_keys($!gsap),
      $raw,
      $glist,
      |GCR::SSH::Agent::Key::Info.getTypePair
    );
  }

  proto method lookup_by_public_key (|)
    is also<lookup-by-public-key>
  { * }

  multi method lookup_by_public_key (@bytes) {
    samewith( GLib::Bytes.new(@bytes) );
  }
  multi method lookup_by_public_key (Blob $public-key) {
    samewith( CArray[uint8].new( $public-key ), $public-key.bytes );
  }
  multi method lookup_by_public_key (
    CArray[uint8] $public-key,
    Int()         $size        is copy = 0
  ) {
    {
      CATCH {
        default {
          if .message.starts-with("Don't know how many elements") {
            $*ERROR.say: "Must specify length of array!";
            return;
          } else {
            .rethrow
          }
        }
      }
      $size = $public-key.elems unless $size
    }

    samewith( GLib::Bytes.new($public-key, $size );
  }
  multi method lookup_by_public_key (
    $public-key where $public-key ~~ GLib::Bytes
  ) {
    samewith( $public-key.GBytes);
  }
  multi method lookup_by_public_key (GBytes $public_key) {
    propReturnObject(
      gcr_ssh_agent_preload_lookup_by_public_key($!gsap, $public_key),
      $raw,
      |GCR::SSH::Agent::Key::Info.getTypePair
    );
  }

}

### /home/cbwood/Projects/gcr/gcr/gcr-ssh-agent-preload.h

sub gcr_ssh_agent_key_info_copy (gpointer $boxed)
  returns Pointer
  is      native(gcr)
  is      export
{ * }

sub gcr_ssh_agent_key_info_free (gpointer $boxed)
  is      native(gcr)
  is      export
{ * }

sub gcr_ssh_agent_preload_get_keys (GcrSshAgentPreload $self)
  returns GList
  is      native(gcr)
  is      export
{ * }

sub gcr_ssh_agent_preload_lookup_by_public_key (
  GcrSshAgentPreload $self,
  GBytes             $public_key
)
  returns GcrSshAgentKeyInfo
  is      native(gcr)
  is      export
{ * }

sub gcr_ssh_agent_preload_new (Str $path)
  returns GcrSshAgentPreload
  is      native(gcr)
  is      export
{ * }
