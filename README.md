# homebrew-allbert

Homebrew tap for [Allbert](https://github.com/lexlapax/allbert-assist).

```sh
brew tap lexlapax/allbert
brew install allbert
allbert serve
```

`Formula/allbert.rb` pins per-platform prebuilt release artifacts and their
SHA256 checksums. After a new release-artifacts workflow run publishes a GitHub
release + `SHA256SUMS`, update the formula:

```sh
# from an allbert-assist checkout:
gh release download vX.Y.Z --repo lexlapax/allbert-assist --pattern SHA256SUMS --dir /tmp
homebrew/fill-sha256.sh /tmp/SHA256SUMS Formula/allbert.rb   # in this tap
git commit -am "allbert vX.Y.Z" && git push
```

Supported: macOS arm64, Linux x64, Linux arm64 (Windows via WSL2). The binary
bundles its own ERTS — no Elixir/Erlang toolchain required.
