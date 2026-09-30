class Vimanam < Formula
  desc "OpenAPI/Swagger to Markdown documentation generator with grouping, filtering, and detail levels for docs and LLM context"
  homepage "https://github.com/noemaforge/vimanam"
  version "1.4.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/noemaforge/vimanam/releases/download/v1.4.2/vimanam-aarch64-apple-darwin.tar.xz"
      sha256 "eeefc9af92ff8a952949b8103c7a9c5e480fd17309de155cd449bd208497c5ea"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noemaforge/vimanam/releases/download/v1.4.2/vimanam-x86_64-apple-darwin.tar.xz"
      sha256 "49f2bcda55e861954d726e3a0db72e3e49c2269dfcea20c9a4dee8af10b90ef3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/noemaforge/vimanam/releases/download/v1.4.2/vimanam-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "42a15d4e62e8522ead3d4fe4420ef3017107ac2e42cd356d650dfeb26f8d9031"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noemaforge/vimanam/releases/download/v1.4.2/vimanam-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c6857a7951ea3d32954eec1491923beb0782605bf4214b57b41f605c67484385"
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
