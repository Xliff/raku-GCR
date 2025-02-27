use v6.c;

use Test;

use GCR::Raw::Types;

use GCR::Simple::Certificate;

use GIO::Roles::GFile;

my %test;
my ($cert, $dsa, $dhan);

sub setup {
  %test{ .head } = GCR::Simple::Certificate.new(
    |GIO::File.get_contents( gcr-resources{ .tail }.IO.absolute )
  ) for [
    ['certificate',  'fixtures/der-certificate.crt'    ],
    ['dsa-cert',     'fixtures/der-certificate-dsa.cer'],
    ['dhansak-cert', 'fixtures/dhansak-collabora.cer'  ]
  ];

  $cert := %test<certificate>;
  $dsa  := %test<dsa-cert>;
  $dhan := %test<dhansak-cert>;
}

sub test-list-extensions {
  my $exts = $dsa.list_extensions;

  ok
    $exts.get_item_type == GCR::Certificate::Extension.get_type,
    'Return value of .list-extensions is the proper type.';

  my $i = $exts.elems;
  ok
    $i == 9,
    'Returned list has the proper number of elements';

  ok
    $exts.n-items == $i,
    'Element count property matches value retrieved by method.';

  nok
    $exts.get_item(9),
    'Element 9 does not exist, since it is beyond the end of the list!';

  for $exts {
    ok $_, "Extension List Element { $_ } is non-null";

    is
      .get_type,
      GCR::Certificate::Extension.get_type,
      "Extension List Element { $_ } is the proper type";
  }

  # cw: These may need to be implemented.
  #
  # ok
  #   $exts.find-by-oid( GLib::Quart.to-string(GCR_OID_BASIC_CONSTRAINTS) ),
  #   'GCR_OID_BASIC_CONSTRAINT Extension was found';
  #
  # ok
  #   $exts.find-by-oid( GLib::Quark.to-string(GCR_OID_SUBJECT_ALT_NAME) ),
  #   'GCR_OID_SUBJECT_ALT_NAME Extension was found';

}

sub MAIN {
  setup();

  is
    $cert.get_issuer_cn,
    'http://www.valicert.com/',
    'Cert matches proper issuer';

  is
    $cert.get_issuer_dn,
    'L=ValiCert Validation Network, O=ValiCert, Inc., OU=ValiCert Class 3 Policy Validation Authority, CN=http://www.valicert.com/, EMAIL=info@valicert.com',
    'Cert matches proper DN';

  is
    $cert.get_issuer_part('l'),
    'ValiCert Validation Network',
    'Cert matches proper Issuer part "l"';

  is
    $cert.get_issuer_raw.elems,
    190,
    'Cert issuer raw size matches expected value.';

  is
    $cert.get_subject_cn,
    'http://www.valicert.com/',
    'Cert subject cn matches';

  is
    $dhan.get_subject_cn,
    'dhansak.collabora.co.uk',
    'dhansak certificate has proper URL as subject cn';

  is
    $cert.get_subject_dn,
    'L=ValiCert Validation Network, O=ValiCert, Inc., OU=ValiCert Class 3 Policy Validation Authority, CN=http://www.valicert.com/, EMAIL=info@valicert.com',
    'Cert matches full subject DN';

  is
    $dhan.get_subject_dn,
    'CN=dhansak.collabora.co.uk, EMAIL=sysadmin@collabora.co.uk',
    'dhansak certificate has proper full DN';

  is
    $cert.get_subject_part('OU'),
    'ValiCert Class 3 Policy Validation Authority',
    'Cert matches subject OU';

  is
    $dhan.get_subject_part('EMAIL'),
    'sysadmin@collabora.co.uk',
    'dhansak certificate has proper subject EMAIL';

  is
    $dhan.get_subject_raw.elems,
    77,
    'dhan certificiate raw size matches expectations';

  {
    my $d = $cert.get_issued_date;

    is $d.year,  1999, 'Cert was issued in the proper year';
    is $d.month, 6,    'Cert was issued in the proper month';
    is $d.day,   26,   'Cert was issued on the proper day';
  }

  {
    my $d = $cert.get_expiry_date;

    is $d.year,  2019, 'Cert expires in the proper year';
    is $d.month, 6,    'Cert expires in the proper month';
    is $d.day,   26,   'Cert expires on the proper day';
  }

  is
    $cert.get_version,
    1,
    'Certificate has the proper version number';

  ok
    $cert.get_fingerprint(G_CHECKSUM_MD5).Array ~~
    (
      0xA2, 0x6F, 0x53, 0xB7, 0xEE, 0x40, 0xDB, 0x4A,
      0x68, 0xE7, 0xFA, 0x18, 0xD9, 0x10, 0x4B, 0x72
    ),
    'Fingerprint matches raw data';

  is
    $cert.get_fingerprint_hex(G_CHECKSUM_MD5),
    'A2 6F 53 B7 EE 40 DB 4A 68 E7 FA 18 D9 10 4B 72',
    'Fingerprint matches expected string representation';

  is
    $cert.get_key_size,
    1024,
    'Certificate matches expected key size';

  is
    $dsa.get_key_size,
    1024,
    'DSA certificate matches expected key size';

  ok
    $cert.is_issuer($cert),
    'Cert issuer is itself';

  nok
    $cert.is_issuer($dsa),
    'Cert does not use DSA cert as an issuer.';

  # cw: Aparently no longer supported by GCR-4
  #test-list-extensions;

  my ($i, $p) = $dsa.get_basic_constraints;

  ok $i.defined,
     'Call to .get_basic_constraints was successful';

  nok $i,     'DSA cert is not a CA';
  is  $p, -1, 'DSA cert has a path length of -1';



}
