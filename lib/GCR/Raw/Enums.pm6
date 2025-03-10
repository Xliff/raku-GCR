use v6.c;

use GLib::Raw::Definitions;

unit package GCR::Raw::Enums;

constant GckBuilderFlags is export := guint32;
our enum GckBuilderFlagsEnum is export <
  GCK_BUILDER_NONE
  GCK_BUILDER_SECURE_MEMORY
>;

constant GckSessionOptions is export := guint32;
our enum GckSessionOptionsEnum is export (
  GCK_SESSION_READ_ONLY    => 0,
  GCK_SESSION_READ_WRITE   => 1 +< 1,
  GCK_SESSION_LOGIN_USER   => 1 +< 2,
  GCK_SESSION_AUTHENTICATE => 1 +< 3
);

constant GckUriError is export := guint32;
our enum GckUriErrorEnum is export <
  GCK_URI_BAD_SCHEME
  GCK_URI_BAD_ENCODING
  GCK_URI_BAD_SYNTAX
  GCK_URI_BAD_VERSION
  GCK_URI_NOT_FOUND
>;

constant GckUriFlags is export := guint32;
our enum GckUriFlagsEnum is export <
  GCK_URI_FOR_OBJECT
  GCK_URI_FOR_TOKEN
  GCK_URI_FOR_MODULE
  GCK_URI_WITH_VERSION
  GCK_URI_FOR_ANY
>;

constant GcrCertificateChainFlags is export := guint32;
our enum GcrCertificateChainFlagsEnum is export <
  GCR_CERTIFICATE_CHAIN_NONE
  GCR_CERTIFICATE_CHAIN_NO_LOOKUPS
>;

constant GcrCertificateChainStatus is export := guint32;
our enum GcrCertificateChainStatusEnum is export <
  GCR_CERTIFICATE_CHAIN_UNKNOWN
  GCR_CERTIFICATE_CHAIN_INCOMPLETE
  GCR_CERTIFICATE_CHAIN_DISTRUSTED
  GCR_CERTIFICATE_CHAIN_SELFSIGNED
  GCR_CERTIFICATE_CHAIN_PINNED
  GCR_CERTIFICATE_CHAIN_ANCHORED
>;

constant GcrCertificateExtensionKeyUsageBits is export := guint32;
our enum GcrCertificateExtensionKeyUsageBitsEnum is export <
  GCR_KEY_USAGE_DIGITAL_SIGNATURE
  GCR_KEY_USAGE_NON_REPUDIATION
  GCR_KEY_USAGE_KEY_ENCIPHERMENT
  GCR_KEY_USAGE_DATA_ENCIPHERMENT
  GCR_KEY_USAGE_KEY_AGREEMENT
  GCR_KEY_USAGE_KEY_CERT_SIGN
  GCR_KEY_USAGE_CRL_SIGN
  GCR_KEY_USAGE_ENCIPHER_ONLY
  GCR_KEY_USAGE_DECIPHER_ONLY
>;

constant GcrCertificateExtensionParseError is export := guint32;
our enum GcrCertificateExtensionParseErrorEnum is export <
  GCR_CERTIFICATE_EXTENSION_PARSE_ERROR_GENERAL
>;

constant GcrCertificateRequestFormat is export := guint32;
our enum GcrCertificateRequestFormatEnum is export <
  GCR_CERTIFICATE_REQUEST_PKCS10
>;

constant GcrCertificateSectionFlags is export := guint32;
our enum GcrCertificateSectionFlagsEnum is export <
  GCR_CERTIFICATE_SECTION_NONE
  GCR_CERTIFICATE_SECTION_IMPORTANT
>;

constant GcrDataError is export := gint32;
our enum GcrDataErrorEnum is export <
  GCR_ERROR_FAILURE
  GCR_ERROR_UNRECOGNIZED
  GCR_ERROR_CANCELLED
  GCR_ERROR_LOCKED
>;

constant GcrDataFormat is export := gint32;
our enum GcrDataFormatEnum is export <
  GCR_FORMAT_ALL
  GCR_FORMAT_INVALID
  GCR_FORMAT_DER_PRIVATE_KEY
  GCR_FORMAT_DER_PRIVATE_KEY_RSA
  GCR_FORMAT_DER_PRIVATE_KEY_DSA
  GCR_FORMAT_DER_PRIVATE_KEY_EC
  GCR_FORMAT_DER_SUBJECT_PUBLIC_KEY
  GCR_FORMAT_DER_CERTIFICATE_X509
  GCR_FORMAT_DER_PKCS7
  GCR_FORMAT_DER_PKCS8
  GCR_FORMAT_DER_PKCS8_PLAIN
  GCR_FORMAT_DER_PKCS8_ENCRYPTED
  GCR_FORMAT_DER_PKCS10
  GCR_FORMAT_DER_SPKAC
  GCR_FORMAT_BASE64_SPKAC
  GCR_FORMAT_DER_PKCS12
  GCR_FORMAT_OPENSSH_PUBLIC
  GCR_FORMAT_OPENPGP_PACKET
  GCR_FORMAT_OPENPGP_ARMOR
  GCR_FORMAT_PEM
  GCR_FORMAT_PEM_PRIVATE_KEY_RSA
  GCR_FORMAT_PEM_PRIVATE_KEY_DSA
  GCR_FORMAT_PEM_CERTIFICATE_X509
  GCR_FORMAT_PEM_PKCS7
  GCR_FORMAT_PEM_PKCS8_PLAIN
  GCR_FORMAT_PEM_PKCS8_ENCRYPTED
  GCR_FORMAT_PEM_PKCS12
  GCR_FORMAT_PEM_PRIVATE_KEY
  GCR_FORMAT_PEM_PKCS10
  GCR_FORMAT_PEM_PRIVATE_KEY_EC
  GCR_FORMAT_PEM_PUBLIC_KEY
>;

constant GcrGeneralNameType is export := guint32;
our enum GcrGeneralNameTypeEnum is export <
  GCR_GENERAL_NAME_OTHER
  GCR_GENERAL_NAME_RFC822
  GCR_GENERAL_NAME_DNS
  GCR_GENERAL_NAME_X400
  GCR_GENERAL_NAME_DN
  GCR_GENERAL_NAME_EDI
  GCR_GENERAL_NAME_URI
  GCR_GENERAL_NAME_IP
  GCR_GENERAL_NAME_REGISTERED_ID
>;

constant GcrGnupgProcessFlags is export := guint32;
our enum GcrGnupgProcessFlagsEnum is export <
  GCR_GNUPG_PROCESS_NONE
  GCR_GNUPG_PROCESS_RESPECT_LOCALE
  GCR_GNUPG_PROCESS_WITH_STATUS
  GCR_GNUPG_PROCESS_WITH_ATTRIBUTES
>;

constant GcrOpenpgpAlgo is export := guint32;
our enum GcrOpenpgpAlgoEnum is export <
  GCR_OPENPGP_ALGO_RSA
  GCR_OPENPGP_ALGO_RSA_E
  GCR_OPENPGP_ALGO_RSA_S
  GCR_OPENPGP_ALGO_ELG_E
  GCR_OPENPGP_ALGO_DSA
>;

constant GcrOpenpgpParseFlags is export := guint32;
our enum GcrOpenpgpParseFlagsEnum is export <
  GCR_OPENPGP_PARSE_NONE
  GCR_OPENPGP_PARSE_KEYS
  GCR_OPENPGP_PARSE_NO_RECORDS
  GCR_OPENPGP_PARSE_SIGNATURES
  GCR_OPENPGP_PARSE_ATTRIBUTES
>;

constant GcrPromptReply is export := guint32;
our enum GcrPromptReplyEnum is export <
  GCR_PROMPT_REPLY_CANCEL
  GCR_PROMPT_REPLY_CONTINUE
>;

constant GcrRecordAttributeColumns is export := guint32;
our enum GcrRecordAttributeColumnsEnum is export <
  GCR_RECORD_ATTRIBUTE_KEY_FINGERPRINT
  GCR_RECORD_ATTRIBUTE_LENGTH
  GCR_RECORD_ATTRIBUTE_TYPE
  GCR_RECORD_ATTRIBUTE_TIMESTAMP
  GCR_RECORD_ATTRIBUTE_EXPIRY
  GCR_RECORD_ATTRIBUTE_FLAGS
>;

constant GcrRecordColumns is export := guint32;
our enum GcrRecordColumnsEnum is export <
  GCR_RECORD_SCHEMA
  GCR_RECORD_TRUST
>;

constant GcrRecordFprColumns is export := guint32;
our enum GcrRecordFprColumnsEnum is export <
  GCR_RECORD_FPR_FINGERPRINT
  GCR_RECORD_FPR_MAX
>;

constant GcrRecordImportColumns is export := guint32;
our enum GcrRecordImportColumnsEnum is export <
  GCR_RECORD_IMPORT_REASON
  GCR_RECORD_IMPORT_FINGERPRINT
>;

constant GcrRecordKeyColumns is export := guint32;
our enum GcrRecordKeyColumnsEnum is export <
  GCR_RECORD_KEY_BITS
  GCR_RECORD_KEY_ALGO
  GCR_RECORD_KEY_KEYID
  GCR_RECORD_KEY_TIMESTAMP
  GCR_RECORD_KEY_EXPIRY
  GCR_RECORD_KEY_OWNERTRUST
>;

constant GcrRecordPubColumns is export := guint32;
our enum GcrRecordPubColumnsEnum is export <
  GCR_RECORD_PUB_CAPS
  GCR_RECORD_PUB_MAX
>;

constant GcrRecordRvkColumns is export := guint32;
our enum GcrRecordRvkColumnsEnum is export <
  GCR_RECORD_RVK_ALGO
  GCR_RECORD_RVK_FINGERPRINT
  GCR_RECORD_RVK_CLASS
  GCR_RECORD_RVK_MAX
>;

constant GcrRecordSecColumns is export := guint32;
our enum GcrRecordSecColumnsEnum is export <
  GCR_RECORD_SEC_MAX
>;

constant GcrRecordSigColumns is export := guint32;
our enum GcrRecordSigColumnsEnum is export <
  GCR_RECORD_SIG_STATUS
  GCR_RECORD_SIG_ALGO
  GCR_RECORD_SIG_KEYID
  GCR_RECORD_SIG_TIMESTAMP
  GCR_RECORD_SIG_EXPIRY
  GCR_RECORD_SIG_USERID
  GCR_RECORD_SIG_CLASS
  GCR_RECORD_SIG_MAX
>;

constant GcrRecordUatColumns is export := guint32;
our enum GcrRecordUatColumnsEnum is export <
  GCR_RECORD_UAT_TRUST
  GCR_RECORD_UAT_FINGERPRINT
  GCR_RECORD_UAT_COUNT_SIZE
  GCR_RECORD_UAT_MAX
>;

constant GcrRecordUidColumns is export := guint32;
our enum GcrRecordUidColumnsEnum is export <
  GCR_RECORD_UID_TIMESTAMP
  GCR_RECORD_UID_EXPIRY
  GCR_RECORD_UID_FINGERPRINT
  GCR_RECORD_UID_USERID
  GCR_RECORD_UID_MAX
>;

constant GcrSystemPromptError is export := guint32;
our enum GcrSystemPromptErrorEnum is export <
  GCR_SYSTEM_PROMPT_IN_PROGRESS
>;

constant GcrSystemPrompterMode is export := guint32;
our enum GcrSystemPrompterModeEnum is export <
  GCR_SYSTEM_PROMPTER_SINGLE
  GCR_SYSTEM_PROMPTER_MULTIPLE
>;
