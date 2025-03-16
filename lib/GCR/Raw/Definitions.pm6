use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;

use GLib::Roles::Pointers;
use GCR::PKCS11::Constants;

use GLib::Roles::TypedBuffer;

unit package GCR::Raw::Definitions;

constant gcr is export = 'gcr-4',v4;

class GckAllocator                is repr<CPointer> does GLib::Roles::Pointers is export { }
class GckEnumerator               is repr<CPointer> does GLib::Roles::Pointers is export { }
class GckModule                   is repr<CPointer> does GLib::Roles::Pointers is export { }
class GckObject                   is repr<CPointer> does GLib::Roles::Pointers is export { }
class GckSession                  is repr<CPointer> does GLib::Roles::Pointers is export { }
class GckSlot                     is repr<CPointer> does GLib::Roles::Pointers is export { }

class GcrCertificate              is repr<CPointer> does GLib::Roles::Pointers is export { }
class GcrCertificateChain         is repr<CPointer> does GLib::Roles::Pointers is export { }
class GcrCertificateField         is repr<CPointer> does GLib::Roles::Pointers is export { }
class GcrCertificateExtension     is repr<CPointer> does GLib::Roles::Pointers is export { }
class GcrCertificateExtensionList is repr<CPointer> does GLib::Roles::Pointers is export { }
class GcrCertificateSection       is repr<CPointer> does GLib::Roles::Pointers is export { }
class GcrImporter                 is repr<CPointer> does GLib::Roles::Pointers is export { }
class GcrParsed                   is repr<CPointer> does GLib::Roles::Pointers is export { }
class GcrParser                   is repr<CPointer> does GLib::Roles::Pointers is export { }
class GcrPkcs11Certificate        is repr<CPointer> does GLib::Roles::Pointers is export { }
class GcrPrompt                   is repr<CPointer> does GLib::Roles::Pointers is export { }
class GcrSecretExchange           is repr<CPointer> does GLib::Roles::Pointers is export { }
class GcrSimpleCertificate        is repr<CPointer> does GLib::Roles::Pointers is export { }
class GcrSubjectPublicKeyInfo     is repr<CPointer> does GLib::Roles::Pointers is export { }
class GcrSystemPrompt             is repr<CPointer> does GLib::Roles::Pointers is export { }
class GcrSystemPrompter           is repr<CPointer> does GLib::Roles::Pointers is export { }

sub gcr-resources is export { %?RESOURCES }

class GckMechanism is repr<CStruct> does GLib::Roles::Pointers is export {
  has gulong           $.type        is rw;
  has CArray[gpointer] $.parameter;
  has gulong           $.n_parameter is rw;
}

class GckSessionInfo is repr<CStruct> does GLib::Roles::Pointers is export {
  has gulong $.slot_id      is rw;
  has gulong $.state        is rw;
  has gulong $.flags        is rw;
  has gulong $.device_error is rw;
}

class GckAttribute is repr<CStruct> does GLib::Roles::Pointers is export {
  has gulong        $.type  is rw;
  has CArray[uint8] $!value;
  has gulong        $.length;         #= size($.value)

  method value is rw {
    Proxy.new(
      FETCH => -> $     { SizedCArray.new($!value, $!length) },
      STORE => -> $, \v { $!value := v }
    );
  }
}

class GckAttributes is repr<CStruct> does GLib::Roles::Pointers is export {
  has gpointer $!data;   #= GckAttribute[]
  has gulong   $.count;  #= size($.data)
  has gint     $.refs;

  method data {
    GLib::Roles::TypedBuffer[GckAttribute].new-sized($!data, $!count);
  }
}

class GckRealBuilder is repr<CStruct> does GLib::Roles::Pointers is export {
  has GArray   $.array;
  has gboolean $.secure;
  has gint     $.refs;
}

constant GCR_DBUS_CALLBACK_INTERFACE        is export = 'org.gnome.keyring.internal.Prompter.Callback';
constant GCR_DBUS_CALLBACK_METHOD_DONE      is export = 'PromptDone';
constant GCR_DBUS_CALLBACK_METHOD_READY     is export = 'PromptReady';
constant GCR_DBUS_PROMPT_ERROR_FAILED       is export = 'org.gnome.keyring.Prompter.Failed';
constant GCR_DBUS_PROMPT_ERROR_IN_PROGRESS  is export = 'org.gnome.keyring.Prompter.InProgress';
constant GCR_DBUS_PROMPT_OBJECT_PREFIX      is export = '/org/gnome/keyring/Prompt';
constant GCR_DBUS_PROMPT_REPLY_NO           is export = 'no';
constant GCR_DBUS_PROMPT_REPLY_NONE         is export = '';
constant GCR_DBUS_PROMPT_REPLY_YES          is export = 'yes';
constant GCR_DBUS_PROMPT_TYPE_CONFIRM       is export = 'confirm';
constant GCR_DBUS_PROMPT_TYPE_PASSWORD      is export = 'password';
constant GCR_DBUS_PROMPTER_INTERFACE        is export = 'org.gnome.keyring.internal.Prompter';
constant GCR_DBUS_PROMPTER_METHOD_BEGIN     is export = 'BeginPrompting';
constant GCR_DBUS_PROMPTER_METHOD_PERFORM   is export = 'PerformPrompt';
constant GCR_DBUS_PROMPTER_METHOD_STOP      is export = 'StopPrompting';
constant GCR_DBUS_PROMPTER_MOCK_BUS_NAME    is export = 'org.gnome.keyring.MockPrompter';
constant GCR_DBUS_PROMPTER_OBJECT_PATH      is export = '/org/gnome/keyring/Prompter';
constant GCR_DBUS_PROMPTER_PRIVATE_BUS_NAME is export = 'org.gnome.keyring.PrivatePrompter';
constant GCR_DBUS_PROMPTER_SYSTEM_BUS_NAME  is export = 'org.gnome.keyring.SystemPrompter';
