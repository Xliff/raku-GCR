use v6.c;

use Method::Also;

use NativeCall;

use GCR::Raw::Types;

use GIO::SocketConnection;

use GLib::Roles::Implementor;
use GLib::Roles::Object;

our subset GcrSshAgentProcessAncestry is export of Mu
  where GcrSshAgentProcess | GObject;

class GCR::SSH::Agent::Process {
  also does GLib::Roles::Object;

  has GcrSshAgentProcess $!gsap is implementor;

  submethod BUILD ( :$ssh-agent-process ) {
    self.setGcrSshAgentProcess($ssh-agent-process) if $ssh-agent-process
  }

  method setGcrSshAgentProcess (GcrSshAgentProcessAncestry $_) {
    my $to-parent;

    $!gsap = do {
      when GcrSshAgentProcess {
        $to-parent = cast(GObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GcrSshAgentProcess, $_);
      }
    }
    self!setObject($to-parent);
  }

  method GCR::Raw::Definitions::GcrSshAgentProcess
    is also<GcrSshAgentProcess>
  { $!gsap }

  multi method new (
    $ssh-agent-process where * ~~ GcrSshAgentProcessAncestry,

    :$ref = True
  ) {
    return unless $ssh-agent-process;

    my $o = self.bless( :$ssh-agent-process );
    $o.ref if $ref;
    $o;
  }

  multi method new (Str() $path, @args) {
    samewith( $path, ArrayToCArray(Str, @args, :null) )
  }
  multi method new (Str() $path, CArray[Str] $ssh_agent_args) {
    my $gcr-agent-process = gcr_ssh_agent_process_new($path, $ssh_agent_args);

     $gcr-agent-process ?? self.bless( :$gcr-agent-process ) !! Nil;
  }

  multi method connect (
    GCancellable()           $cancellable = GCancellable,
    CArray[Pointer[GError]]  $error       = gerror,
                            :$raw         = False
  ) {
    propReturnObject(
      gcr_ssh_agent_process_connect($!gsap, $cancellable, $error),
      $raw,
      |GIO::SocketConnection.getTypePair
    );
  }

  method get_pid
    is also<
      get-pid
      pid
    >
  {
    gcr_ssh_agent_process_get_pid($!gsap);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gcr_ssh_agent_process_get_type, $n, $t );
  }

}

### /home/cbwood/Projects/gcr/gcr/gcr-ssh-agent-process.h

sub gcr_ssh_agent_process_connect (
  GcrSshAgentProcess      $self,
  GCancellable            $cancellable,
  CArray[Pointer[GError]] $error
)
  returns GSocketConnection
  is      native(gcr)
  is      export
{ * }

sub gcr_ssh_agent_process_get_pid (GcrSshAgentProcess $self)
  returns GPid
  is      native(gcr)
  is      export
{ * }

sub gcr_ssh_agent_process_new (Str $path, CArray[Str] $ssh_agent_args)
  returns GcrSshAgentProcess
  is      native(gcr)
  is      export
{ * }

sub gcr_ssh_agent_process_get_type
  returns GType
  is      native(gcr)
  is      export
{ * }
