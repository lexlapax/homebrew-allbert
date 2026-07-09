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
  version "0.63.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/lexlapax/allbert-assist/releases/download/v0.63.0/allbert-v0.63.0-macos-arm64.tar.gz"
      sha256 "3ec88b2911f0de2c915c3e34f6a07a63141d377f1904e697bd65041a3ea23e40"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/lexlapax/allbert-assist/releases/download/v0.63.0/allbert-v0.63.0-linux-x64.tar.gz"
      sha256 "17a06b01175d1ffa5a3c4293b668140380c0ee292cf8faf7d7c0b773e9b258c7"
    end
    on_arm do
      url "https://github.com/lexlapax/allbert-assist/releases/download/v0.63.0/allbert-v0.63.0-linux-arm64.tar.gz"
      sha256 "56974878069abd378f78eb9046331994c6c0781244179811a18e7c60464d84e8"
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
