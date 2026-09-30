class Vimanam < Formula
  desc "OpenAPI/Swagger to Markdown documentation generator with grouping, filtering, and detail levels for docs and LLM context"
  homepage "https://github.com/noemaforge/vimanam"
  version "1.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/noemaforge/vimanam/releases/download/v1.4.1/vimanam-aarch64-apple-darwin.tar.xz"
      sha256 "3137039ecb11f1d03392039c5ab4acf83e03232b0f1a9358b131957763082243"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noemaforge/vimanam/releases/download/v1.4.1/vimanam-x86_64-apple-darwin.tar.xz"
      sha256 "3cf9afb94c14923cf8c883aca747f90c45a23f644876298a846c399dd8698a48"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/noemaforge/vimanam/releases/download/v1.4.1/vimanam-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "906218945cc663f9f8ebf81d0f02b3941571920b82d1861562cf9bf372f4a6ec"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noemaforge/vimanam/releases/download/v1.4.1/vimanam-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "019dd1ae626d883a58c98a5492e163765b8c192c7f2c3f78858b7cfd74f7f531"
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
