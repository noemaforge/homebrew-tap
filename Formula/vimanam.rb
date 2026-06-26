class Vimanam < Formula
  desc "OpenAPI/Swagger to Markdown documentation generator with grouping, filtering, and detail levels for docs and LLM context"
  homepage "https://github.com/noemaforge/vimanam"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/noemaforge/vimanam/releases/download/v0.6.0/vimanam-aarch64-apple-darwin.tar.xz"
      sha256 "955bf7f89bc9486b495d50e063b2c2c3e7b4fe8e5c4c67caf1808c9c99ea3cf1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noemaforge/vimanam/releases/download/v0.6.0/vimanam-x86_64-apple-darwin.tar.xz"
      sha256 "b25099f7a6602cb1ce291888e7ade8b3470393ea0f516fdff9eaab8b1169eabc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/noemaforge/vimanam/releases/download/v0.6.0/vimanam-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0b39e33accc273c9b4a02409660098ce45f4daecf275e226b0628a24230d93bc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noemaforge/vimanam/releases/download/v0.6.0/vimanam-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e00c040da9115853eb9e9d32fec2703901f331668852e09803d1a30a8f7174c4"
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
