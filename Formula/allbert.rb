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
  version "0.64.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/lexlapax/allbert-assist/releases/download/v0.64.2/allbert-v0.64.2-macos-arm64.tar.gz"
      sha256 "2fba958835e6b5ca2996a6f44ddafb2498cbb3d10018e2ea1f81c259c5106db7"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/lexlapax/allbert-assist/releases/download/v0.64.2/allbert-v0.64.2-linux-x64.tar.gz"
      sha256 "824a8051feadc8999b3aa0178080b787cbc4c66ecbfa3af3b47e61b2e1d72cea"
    end
    on_arm do
      url "https://github.com/lexlapax/allbert-assist/releases/download/v0.64.2/allbert-v0.64.2-linux-arm64.tar.gz"
      sha256 "23cc81bcf5cc0b11b4458a3d8ef893fb1298dfb7f8f0e7cae2ddbc41b23b5036"
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
