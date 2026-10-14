class Vimanam < Formula
  desc "OpenAPI/Swagger to Markdown documentation generator with grouping, filtering, and detail levels for docs and LLM context"
  homepage "https://github.com/noemaforge/vimanam"
  version "2.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/noemaforge/vimanam/releases/download/v2.0.0/vimanam-aarch64-apple-darwin.tar.xz"
      sha256 "9bdeaf49dcb248b527f7f5f2dff563693e26481792dfb9e427cedad53fd0f3cf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noemaforge/vimanam/releases/download/v2.0.0/vimanam-x86_64-apple-darwin.tar.xz"
      sha256 "27b360ffb60ca9babba6f95d81553dfd83db21e33533c7f8438d79ea0898450a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/noemaforge/vimanam/releases/download/v2.0.0/vimanam-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d8733449899f1648fe60f2854320e981c7993444f8fcea64baa60cf30fc8e66a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noemaforge/vimanam/releases/download/v2.0.0/vimanam-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "343cd31e9e8d1311743be96b3f34003ef25aef51874a4135a075ab2552767c9a"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "vimanam"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "vimanam"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "vimanam"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "vimanam"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
