# Allbert Homebrew formula template. Bumped per release and copied to the tap repo
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
  version "1.0.4"
  license "MIT"

  depends_on "node"

  on_macos do
    on_arm do
      url "https://github.com/lexlapax/allbert-assist/releases/download/v1.0.4/allbert-v1.0.4-macos-arm64.tar.gz"
      sha256 "7104cc265d6e854f30f23d36e692a4188daec7d039e02c319331824136177cfa"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/lexlapax/allbert-assist/releases/download/v1.0.4/allbert-v1.0.4-linux-x64.tar.gz"
      sha256 "b6297710ea0385b7a00e90047a148f5a31927747f6c5d2cc0681415da50a267b"
    end
    on_arm do
      url "https://github.com/lexlapax/allbert-assist/releases/download/v1.0.4/allbert-v1.0.4-linux-arm64.tar.gz"
      sha256 "b80d4aced4a1ed725854ebde6e2875810bafd3faa80271373e9a38b5b3bf9757"
    end
  end

  def install
    libexec.install Dir["*"]
    (bin/"allbert").write_env_script libexec/"bin/allbert", SHELL: "/bin/sh"
  end

  def caveats
    <<~EOS
      Browser/research is optional and its runtime is intentionally not bundled.
      Install Playwright into a host-managed directory without downloading a browser:

        PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1 npm install \
          --prefix "$HOME/.local/share/allbert/playwright-1.58.2" \
          --ignore-scripts --no-audit --no-fund --no-save playwright@1.58.2
        allbert admin settings set browser.driver.node_module_path \
          "$HOME/.local/share/allbert/playwright-1.58.2/node_modules"
        allbert admin settings set browser.driver.version_pin 1.58.2
        allbert admin settings set browser.driver.binary_path \
          /absolute/path/to/your/OS-managed/chromium-or-chrome

      Node is a formula dependency. Chromium/Chrome remains an OS-managed host
      package. Allbert never runs npm or a browser downloader at runtime.
    EOS
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
