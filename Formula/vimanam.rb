class Vimanam < Formula
  desc "OpenAPI/Swagger to Markdown documentation generator with grouping, filtering, and detail levels for docs and LLM context"
  homepage "https://github.com/noemaforge/vimanam"
  version "1.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/noemaforge/vimanam/releases/download/v1.0.0/vimanam-aarch64-apple-darwin.tar.xz"
      sha256 "0fc146d8eede03e5b017f9169800b5a334bf42bc26843f6d533f66c9178cebd0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noemaforge/vimanam/releases/download/v1.0.0/vimanam-x86_64-apple-darwin.tar.xz"
      sha256 "cc9bb16a8cdfa8ee9214da3f5a985b9bef0d9f3071b21b13e1706154b2990443"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/noemaforge/vimanam/releases/download/v1.0.0/vimanam-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "219643d1e5783f42548088ac7d1391d8c0332eb8fb0cd150e92d43249433c989"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noemaforge/vimanam/releases/download/v1.0.0/vimanam-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "cdaefe75b3ba237f60d538c081e59396b2c8dff5db795f6f0754892c3b8cca40"
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
    bin.install "vimanam" if OS.mac? && Hardware::CPU.arm?
    bin.install "vimanam" if OS.mac? && Hardware::CPU.intel?
    bin.install "vimanam" if OS.linux? && Hardware::CPU.arm?
    bin.install "vimanam" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
