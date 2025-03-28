use v6.c;

use NativeCall;
use Method::Also;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GLib::Raw::Subs;

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
class GcrSshAgentPreload          is repr<CPointer> does GLib::Roles::Pointers is export { }
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

class GckSlotInfo is repr<CStruct> does GLib::Roles::Pointers is export {
  has Str    $.slot_description;
  has Str    $.manufacturer_id;
  has gulong $.flags;
  has guint8 $.hardware_version_major;
  has guint8 $.hardware_version_minor;
  has guint8 $.firmware_version_major;
  has guint8 $.firmware_version_minor;
}

class GckTokenInfo is repr<CStruct> does GLib::Roles::Pointers is export {
  has Str       $.label;
  has Str       $.manufacturer_id;
  has Str       $.model;
  has Str       $.serial_number;
  has gulong    $.flags;
  has glong     $.max_session_count;
  has glong     $.session_count;
  has glong     $.max_rw_session_count;
  has glong     $.rw_session_count;
  has glong     $.max_pin_len;
  has glong     $.min_pin_len;
  has glong     $.total_public_memory;
  has glong     $.free_public_memory;
  has glong     $.total_private_memory;
  has glong     $.free_private_memory;
  has guint8    $.hardware_version_major;
  has guint8    $.hardware_version_minor;
  has guint8    $.firmware_version_major;
  has guint8    $.firmware_version_minor;
  has GDateTime $!utc_time;

  method utc-time ( :$raw = False, :raku(:dt(:$datetime)) = True ) is also<utc_time> {
    use GLib::DateTime;

    my $r = propReturnObject( $!utc_time, $raw, |GLib::DateTime.getTypePair );
    return $r unless $datetime;
    $r.DateTime
  }

  method posix-time {
    use GLib::Raw::DateTime;

    g_date_time_to_unix($!utc_time);
  }
}

class GckMechanismInfo is repr<CStruct> does GLib::Roles::Pointers is export {
  has gulong $.min_key_size;
  has gulong $.max_key_size;
  has gulong $.flags;
}

class GckModuleInfo is repr<CStruct> does GLib::Roles::Pointers is export {
  has guint8        $.pkcs11_version_major;
  has guint8        $.pkcs11_version_minor;
  has CArray[uint8] $!manufacturer_id;
  has gulong        $.flags;
  has CArray[uint8] $!library_description;
  has guint8        $.library_version_major;
  has guint8        $.library_version_minor;

  method manufacturer_id ( :$raw = False, :$encoding = 'utf8' )
    is also<manufacturer-id>
  {
    return $!manufacturer_id if $raw;

    Blob[uint8].new(
      nullTerminatedBuffer($!manufacturer_id)
    ).decode($encoding)
  }

  method library_description ( :$raw = False, :$encoding = 'utf8' )
    is also<library-description>
  {
    return $!library_description if $raw;

    Blob[uint8].new(
      nullTerminatedBuffer($!library_description)
    ).decode($encoding)
  }
}

class GckUriData is repr<CStruct> does GLib::Roles::Pointers is export {
  has gboolean      $.any_unrecognized;
  has GckModuleInfo $.module_info;
  has GckTokenInfo  $.token_info;
  has GckAttributes $.attributes;
  HAS gpointer      @.dummy[4]    is CArray;
}

class GcrSshAgentKeyInfo is repr<CStruct> does GLib::Roles::Pointers is export {
  has Str    $.filename;
  has GBytes $.public_key;
  has Str    $.comment;
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

our $PKCS11-INITIALIZE-AT-START is export = True;
