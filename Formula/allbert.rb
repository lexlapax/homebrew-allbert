# Allbert Homebrew formula (v0.62 M2). Lives in the tap repo
# (lexlapax/homebrew-allbert) at release time; kept here as the source of
# truth. A FORMULA (not a cask) because Allbert wants `brew services` support
# for `allbert serve` (cask has no service block) and ships prebuilt
# per-platform binaries (the HashiCorp-tap pattern; homebrew-core's
# no-source-builds rule does not apply to third-party taps).
#
# The url/sha256 blocks are filled from the GitHub release + SHA256SUMS at
# release time (M8 / CI). Placeholders below are replaced by the release job.
class Allbert < Formula
  desc "Local-first personal AI assistant runtime, CLI, and web workspace"
  homepage "https://github.com/lexlapax/allbert-assist"
  version "0.66.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/lexlapax/allbert-assist/releases/download/v0.66.0/allbert-v0.66.0-macos-arm64.tar.gz"
      sha256 "e0eb84eba4dea2087c74d09c2ece894b761e7f903425aaa51dc040c76b4c07f7"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/lexlapax/allbert-assist/releases/download/v0.66.0/allbert-v0.66.0-linux-x64.tar.gz"
      sha256 "ed19834c773f196a176c68a0365bdeec0cd3a539f2e14485312aa98d50e165c4"
    end
    on_arm do
      url "https://github.com/lexlapax/allbert-assist/releases/download/v0.66.0/allbert-v0.66.0-linux-arm64.tar.gz"
      sha256 "93aed0fbc5a25b25be60a47dd75b5d6e5cd90b7d187e3abe1c18fa17bbcaec13"
    end
  end

  def install
    libexec.install Dir["*"]
    (bin/"allbert").write_env_script libexec/"bin/allbert", SHELL: "/bin/sh"
  end

  service do
    run [opt_bin/"allbert", "serve"]
    keep_alive true
    log_path var/"log/allbert.log"
    error_log_path var/"log/allbert.log"
  end

  test do
    assert_match "allbert", shell_output("#{bin}/allbert eval 'IO.puts(:allbert)'")
  end
end
