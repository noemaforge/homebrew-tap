class Vimanam < Formula
  desc "OpenAPI/Swagger to Markdown documentation generator with grouping, filtering, and detail levels for docs and LLM context"
  homepage "https://github.com/noemaforge/vimanam"
  version "1.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/noemaforge/vimanam/releases/download/v1.5.0/vimanam-aarch64-apple-darwin.tar.xz"
      sha256 "ad820b062d5cfed4b1c5e9506d27ea68eac61a78345578fbe8371382db8932c0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noemaforge/vimanam/releases/download/v1.5.0/vimanam-x86_64-apple-darwin.tar.xz"
      sha256 "46b1d8c49a1a68ec8cf1d5e24ed53a5d045c861abc736e9eed9734c5d82724b9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/noemaforge/vimanam/releases/download/v1.5.0/vimanam-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "aba80342c9afc35b24bdb88822ff25e0a5495d926a049d2fe3afc62a74b06fe2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noemaforge/vimanam/releases/download/v1.5.0/vimanam-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c5272c6e18857bb9fe1322ef3965d44d8d1ff53a9f040b9b083529bc0adbc575"
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
