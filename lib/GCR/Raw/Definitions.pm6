use v6.c;

use GLib::Raw::Definitions;

use GLib::Roles::Pointers;

unit package GCR::Raw::Definitions;

constant gcr is export = 'gcr-4',v4;

class GckAllocator                is repr<CPointer> does GLib::Roles::Pointers is export { }
class GckAttributes               is repr<CPointer> does GLib::Roles::Pointers is export { }
class GckObject                   is repr<CPointer> does GLib::Roles::Pointers is export { }
class GckModule                   is repr<CPointer> does GLib::Roles::Pointers is export { }
class GckSession                  is repr<CPointer> does GLib::Roles::Pointers is export { }


class GcrCertificate              is repr<CPointer> does GLib::Roles::Pointers is export { }
class GcrCertificateChain         is repr<CPointer> does GLib::Roles::Pointers is export { }
class GcrCertificateField         is repr<CPointer> does GLib::Roles::Pointers is export { }
class GcrCertificateExtension     is repr<CPointer> does GLib::Roles::Pointers is export { }
class GcrCertificateExtensionList is repr<CPointer> does GLib::Roles::Pointers is export { }
class GcrCertificateSection       is repr<CPointer> does GLib::Roles::Pointers is export { }
class GcrPkcs11Certificate        is repr<CPointer> does GLib::Roles::Pointers is export { }
class GcrPrompt                   is repr<CPointer> does GLib::Roles::Pointers is export { }
class GcrSecretExchange           is repr<CPointer> does GLib::Roles::Pointers is export { }
class GcrSimpleCertificate        is repr<CPointer> does GLib::Roles::Pointers is export { }
class GcrSubjectPublicKeyInfo     is repr<CPointer> does GLib::Roles::Pointers is export { }
class GcrSystemPrompt             is repr<CPointer> does GLib::Roles::Pointers is export { }
class GcrSystemPrompter           is repr<CPointer> does GLib::Roles::Pointers is export { }

sub gcr-resources is export { %?RESOURCES }
