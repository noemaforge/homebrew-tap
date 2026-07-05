class Vimanam < Formula
  desc "OpenAPI/Swagger to Markdown documentation generator with grouping, filtering, and detail levels for docs and LLM context"
  homepage "https://github.com/noemaforge/vimanam"
  version "1.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/noemaforge/vimanam/releases/download/v1.0.0/vimanam-aarch64-apple-darwin.tar.xz"
      sha256 "ee94a50d997956b659986a15ad77300f1ee41291f98dc59cad5ff1cd2ea1af59"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noemaforge/vimanam/releases/download/v1.0.0/vimanam-x86_64-apple-darwin.tar.xz"
      sha256 "5d7e82c3a609e787ba8945b9df0a842d65f4a10993ba0e55366a00b0effdfe34"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/noemaforge/vimanam/releases/download/v1.0.0/vimanam-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2ebf7d2e843689b69ad2e4399a0b60b0f1c8317997966b0093fcfdbd57102abf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noemaforge/vimanam/releases/download/v1.0.0/vimanam-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "283d31f7464f60334e9bd42fba9100ee869d1a00de8df63a7b9a56f7eb4c1cae"
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
