raku-GCR

Raku bindings for Gnomes Certificate Handling library (GCR)

Example:

```
use GLib::Raw::Subs; 
use GLib::Raw::Structs; 
use GLib::Raw::Definitions; 
use GCR::Parser; 

my $c = <path to .crt file>.IO.slurp( :bin ); 
my $b = GLib::Bytes.new($c); 
my $p = GCR::Parser.new; 
$p.Parsed.tap: SUB { say "{ $p.get_parsed_attributes }" }; 
say $p.parse_bytes($b);
```
