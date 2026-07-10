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
  version "0.64.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/lexlapax/allbert-assist/releases/download/v0.64.3/allbert-v0.64.3-macos-arm64.tar.gz"
      sha256 "0a1a2f428cdbe0bc88629a1102f4bc83641ff74a23542d1f5a4e926702bbb46c"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/lexlapax/allbert-assist/releases/download/v0.64.3/allbert-v0.64.3-linux-x64.tar.gz"
      sha256 "d558eb227b288584b4db84b33ba273088324f389415e6f931bcbb7535230af64"
    end
    on_arm do
      url "https://github.com/lexlapax/allbert-assist/releases/download/v0.64.3/allbert-v0.64.3-linux-arm64.tar.gz"
      sha256 "6af2bdf80f321db5de05570c2ab398ccc245ba407cb6c79d3d27a81a50af56a8"
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
