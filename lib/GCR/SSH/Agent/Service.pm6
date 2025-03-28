use v6.c;

use Method::Also;

use NativeCall;

use GCR::Raw::Types;

use GLib::Roles::Implementor;
use GLib::Roles::Object;

our subset GcrSshAgentServiceAncestry is export of Mu
  where GcrSshAgentService | GObject;

class GCR::SSH::Agent::Service {
  also does GLib::Roles::Object;

  has GcrSshAgentService $!gsas is implementor;

  submethod BUILD ( :$gcr-agent-service ) {
    self.setGcrSshAgentService($gcr-agent-service) if $gcr-agent-service
  }

  method setGcrSshAgentService (GcrSshAgentServiceAncestry $_) {
    my $to-parent;

    $!gsas = do {
      when GcrSshAgentService {
        $to-parent = cast(GObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GcrSshAgentService, $_);
      }
    }
    self!setObject($to-parent);
  }

  method GCR::Raw::Definitions::GcrSshAgentService
    is also<GcrSshAgentService>
  { $!gsas }

  multi method new (
    $gcr-agent-service where * ~~ GcrSshAgentServiceAncestry,

    :$ref = True
  ) {
    return unless $gcr-agent-service;

    my $o = self.bless( :$gcr-agent-service );
    $o.ref if $ref;
    $o;
  }
  multi method new (@args, $preload) {
    samewith( ArrayToCArray(Str, @args, :null), $preload );
  }
  multi method new (GStrv $ssh_agent_args, GcrSshAgentPreload() $preload) {
    my $gcr-agent-service = gcr_ssh_agent_service_new(
      $ssh_agent_args,
      $preload
    );
  }

  method get_preload ( :$raw = False ) is also<get-preload> {
    propReturnObject(
      gcr_ssh_agent_service_get_preload($!gsas),
      $raw,
      |GCR::SSH::Agent::Preload.getTypePair
    );
  }

  method get_process ( :$raw = False ) is also<get-process> {
    propReturnObject(
      gcr_ssh_agent_service_get_process($!gsas),
      $raw,
      |GCR::SSH::Agent::Process.getTypePair
    );
  }

  proto method lookup_key (|)
    is also<lookup-key>
  { * }

  multi method lookup_key (@bytes) {
    samewith( GLib::Bytes.new(@bytes) );
  }
  multi method lookup_key (Blob $public-key) {
    samewith( CArray[uint8].new( $public-key ), $public-key.bytes );
  }
  multi method lookup_key (
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

    samewith( GLib::Bytes.new($public-key, $size) );
  }
  multi method lookup_key (
    $public-key where $public-key ~~ GLib::Bytes
  ) {
    samewith( $public-key.GBytes);
  }
  multi method lookup_key (GBytes $key) {
    so gcr_ssh_agent_service_lookup_key($!gsas, $key);
  }

  method start {
    so gcr_ssh_agent_service_start($!gsas);
  }

  method stop {
    gcr_ssh_agent_service_stop($!gsas);
  }
}

### /home/cbwood/Projects/gcr/gcr/gcr-ssh-agent-service.h

sub gcr_ssh_agent_service_get_preload (GcrSshAgentService $self)
  returns GcrSshAgentPreload
  is      native(gcr)
  is      export
{ * }

sub gcr_ssh_agent_service_get_process (GcrSshAgentService $self)
  returns GcrSshAgentProcess
  is      native(gcr)
  is      export
{ * }

sub gcr_ssh_agent_service_lookup_key (
  GcrSshAgentService $self,
  GBytes             $key
)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gcr_ssh_agent_service_new (
  Str                $path,
  GStrv              $ssh_agent_args,
  GcrSshAgentPreload $preload
)
  returns GcrSshAgentService
  is      native(gcr)
  is      export
{ * }

sub gcr_ssh_agent_service_start (GcrSshAgentService $self)
  returns uint32
  is      native(gcr)
  is      export
{ * }

sub gcr_ssh_agent_service_stop (GcrSshAgentService $self)
  is      native(gcr)
  is      export
{ * }
