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
  version "1.0.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/lexlapax/allbert-assist/releases/download/v1.0.0/allbert-v1.0.0-macos-arm64.tar.gz"
      sha256 "4a6df5feffc12bae54e9495533e74a38b06c0aee17ac7c7771fcac50f6f8cc48"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/lexlapax/allbert-assist/releases/download/v1.0.0/allbert-v1.0.0-linux-x64.tar.gz"
      sha256 "b99f3d60240ff17197ae4f856a01b31a29fa91e2b855ee25ead99ed3ebf13e46"
    end
    on_arm do
      url "https://github.com/lexlapax/allbert-assist/releases/download/v1.0.0/allbert-v1.0.0-linux-arm64.tar.gz"
      sha256 "ec5b69ad84a05ca122f51e166a3876bbde51ac0058c0dec631286f00b62b0584"
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
