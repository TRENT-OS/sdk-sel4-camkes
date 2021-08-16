# Changelog

All notable changes by HENSOLDT Cyber GmbH to the 3rd party modules used by this
meta-module included in TRENTOS-M SDK will be documented in this file.

For more details it is recommended to compare the module at hand with the
previous release or the baseline of the 3rd party module.

## [1.3]

### Added

- Updated 3rd party modules:

| Name                        | Source                                       | Commit (Tag)         |
|-----------------------------|----------------------------------------------|----------------------|
| capdl                       | <https://github.com/seL4/capdl>              | 141bbe013cf          |
| kernel                      | <https://github.com/seL4/seL4>               | d1643774cde          |
| libs/muslibc                | <https://github.com/seL4/musllibc>           | c7aa943a2ad4         |
| libs/projects_libs          | <https://github.com/seL4/projects_libs>      | 3b5c4cdf9e17         |
| libs/sel4_global_components | <https://github.com/seL4/global-components>  | 02133497ed12         |
| libs/sel4_libs              | <https://github.com/seL4/seL4_libs>          | cf104b85d7db         |
| libs/sel4_projects_libs     | <https://github.com/seL4/sel4_projects_libs> | 2e30fdeb1d32         |
| libs/sel4_util_libs         | <https://github.com/seL4/util_libs>          | c446df1f1a3e         |
| libs/sel4runtime            | <https://github.com/seL4/sel4runtime>        | e1c51c9b5067         |
| tools/camkes                | <https://github.com/seL4/camkes-tool>        | 74decfb8a133         |
| tools/nanopb                | <https://github.com/nanopb/nanopb>           | 847ac296b509         |
| tools/opensbi               | <https://github.com/riscv/opensbi>           | 234ed8e427f4 (v.0.9) |
| tools/sel4                  | <https://github.com/seL4/seL4_tools>         | 3927f8f5fd34         |

## [1.2]

### Fixed

- libs/sel4_util_libs:
  - Strip CRC sum when passing frame to network stack.

## [1.1]

### Changed

- kernel:
  - Add support for i.MX6 Nitrogen6_SoloX board.
- libs/sel4_util_libs:
  - Add support for i.MX6 Nitrogen6_SoloX board.
- tools/camkes:
  - Add support for i.MX6 Nitrogen6_SoloX board.
- tools/sel4:
  - Add support for i.MX6 Nitrogen6_SoloX board.

### Added

- Updated 3rd party modules:

| Name                        | Source                                       | Commit (Tag)                |
|-----------------------------|----------------------------------------------|-----------------------------|
| capdl                       | <https://github.com/seL4/capdl>              | c43be6b80676                |
| kernel                      | <https://github.com/seL4/seL4>               | dc83859f6a22 (12.0.0)       |
| libs/muslibc                | <https://github.com/seL4/musllibc>           | 4a8335b2248d                |
| libs/projects_libs          | <https://github.com/seL4/projects_libs>      | 88736edacee0                |
| libs/sel4_global_components | <https://github.com/seL4/global-components>  | 34797e42bdfd                |
| libs/sel4_libs              | <https://github.com/seL4/seL4_libs>          | 74de7febfdf9                |
| libs/sel4_projects_libs     | <https://github.com/seL4/sel4_projects_libs> | 3bb4f1334b89                |
| libs/sel4_util_libs         | <https://github.com/seL4/util_libs>          | 3e406b59f61b                |
| libs/sel4runtime            | <https://github.com/seL4/sel4runtime>        | 2755b9d840a4                |
| tools/camkes                | <https://github.com/seL4/camkes-tool>        | 891ce6f26170 (camkes-3.9.0) |
| tools/nanopb                | <https://github.com/nanopb/nanopb>           | 847ac296b509                |
| tools/sel4                  | <https://github.com/seL4/seL4_tools>         | 31d847ce5f59                |

## [1.0]

### Changed

- libs/sel4_global_components:
  - Add seL4-connectors.cmake to exclude global components.

### Added

- Updated 3rd party modules:

| Name                        | Source                                       | Commit (Tag) |
|-----------------------------|----------------------------------------------|--------------|
| capdl                       | <https://github.com/seL4/capdl>              | cb30c4b7bf15 |
| kernel                      | <https://github.com/seL4/seL4>               | d84e2bfae989 |
| libs/muslibc                | <https://github.com/seL4/musllibc>           | 2af3006b0ccf |
| libs/projects_libs          | <https://github.com/seL4/projects_libs>      | cfbfec4d8730 |
| libs/sel4_global_components | <https://github.com/seL4/global-components>  | 3bf7643ffc2d |
| libs/sel4_libs              | <https://github.com/seL4/seL4_libs>          | a46a435a596c |
| libs/sel4_projects_libs     | <https://github.com/seL4/sel4_projects_libs> | 8dc52bb3181b |
| libs/sel4_util_libs         | <https://github.com/seL4/util_libs>          | 5330b55c07d9 |
| tools/camkes                | <https://github.com/seL4/camkes-tool>        | b49512fa2ec7 |
| tools/nanopb                | <https://github.com/nanopb/nanopb>           | 847ac296b509 |
| tools/sel4                  | <https://github.com/seL4/seL4_tools>         | 3f04d3acd67a |

## [0.9]

### Added

- Added 3rd party modules:

| Name                    | Source                                       | Commit (Tag) |
|-------------------------|----------------------------------------------|--------------|
| capdl                   | <https://github.com/seL4/capdl>              | ff50aee8272f |
| kernel                  | <https://github.com/seL4/seL4>               | 735b154abbcd |
| libs/muslibc            | <https://github.com/seL4/musllibc>           | a0a3af0e3a54 |
| libs/sel4_libs          | <https://github.com/seL4/seL4_libs>          | 996f4e635a78 |
| libs/sel4_projects_libs | <https://github.com/seL4/sel4_projects_libs> | 60b20d1d346b |
| libs/sel4_util_libs     | <https://github.com/seL4/util_libs>          | 5f213acb9a30 |
| libs/sel4runtime        | <https://github.com/seL4/sel4runtime>        | 8fddd5e8c1d7 |
| tools/camkes            | <https://github.com/seL4/camkes-tool>        | 4b53b1187fd1 |
| tools/sel4              | <https://github.com/seL4/seL4_tools>         | 149182809113 |
