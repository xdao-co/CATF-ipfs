# CATF IPFS CAS Plugin (+ Optional gRPC Daemon)

This repository contains the **IPFS-backed CAS provider** for CATF, implemented as a Go module plugin:

- Go module: `xdao.co/catf-ipfs`
- Plugin package: `xdao.co/catf-ipfs/ipfs`

It also ships an optional **standalone CAS gRPC daemon** you can run as a separate process:

- Binary: `xdao-casgrpcd-ipfs`

That daemon exposes the CATF CAS gRPC protocol (so any CATF consumer can talk to it via the `grpc` backend, without linking the IPFS plugin into their own binary).

## What this repo does

- Provides an `ipfs` backend that shells out to the local Kubo `ipfs` CLI (offline/local repo usage is supported).
- Registers itself into CATF’s CAS registry via `init()` (so CATF binaries can enable it with a blank import).

## Using the plugin from CATF

In a Go program (or CATF binary) that uses `storage/casregistry`, enable the plugin by importing it:

- Import side-effect: `_ "xdao.co/catf-ipfs/ipfs"`

Then open it via CATF’s registry (flags) or config (`storage/casconfig`).

## Using the downloadable daemon (recommended for non-Go consumers)

If you don’t want to recompile CATF (or you’re not writing Go), run the gRPC daemon and point CATF at it.

1) Start the daemon:

- `./xdao-casgrpcd-ipfs --listen 127.0.0.1:7777 --backend ipfs --ipfs-path /path/to/ipfs/repo`

1) Use CATF via gRPC CAS:

- `xdao-cascli put --backend grpc --grpc-target 127.0.0.1:7777 ./file`

Or with JSON config in CATF (example):

- `xdao-cascli put --cas-config ./cas.json --backend grpc ./file`

## Release artifacts

This repository’s GitHub Releases publish prebuilt archives for:

- Linux (`linux/amd64`)
- macOS Apple Silicon (`darwin/arm64`)

Each release includes `.tar.gz` archives and `.sha256` checksum files.
