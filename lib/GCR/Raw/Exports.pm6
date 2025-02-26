use v6.c;

unit package GCR::Raw::Exports;

our @gcr-exports is export;

BEGIN {
  @gcr-exports = <
    GCR::Raw::Definitions
    GCR::Raw::Enums
    GCK::Raw::Structs
  >;
}
