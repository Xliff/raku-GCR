use v6.c;

use GLib::Raw::Definitions;

use GLib::Roles::Pointers;

unit package GCR::Raw::Definitions;

constant gcr is export = 'gcr-4',v4;

class GcrCertificate              is repr<CPointer> does GLib::Roles::Pointers is export { }
class GcrCertificateChain         is repr<CPointer> does GLib::Roles::Pointers is export { }
class GcrCertificateExtensionList is repr<CPointer> does GLib::Roles::Pointers is export { }
class GcrPrompt                   is repr<CPointer> does GLib::Roles::Pointers is export { }
class GcrSecretExchange           is repr<CPointer> does GLib::Roles::Pointers is export { }
class GcrSubjectPublicKeyInfo     is repr<CPointer> does GLib::Roles::Pointers is export { }
class GcrSystemPrompt             is repr<CPointer> does GLib::Roles::Pointers is export { }
class GcrSystemPrompter           is repr<CPointer> does GLib::Roles::Pointers is export { }
