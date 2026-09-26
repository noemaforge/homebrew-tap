class Vimanam < Formula
  desc "OpenAPI/Swagger to Markdown documentation generator with grouping, filtering, and detail levels for docs and LLM context"
  homepage "https://github.com/noemaforge/vimanam"
  version "1.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/noemaforge/vimanam/releases/download/v1.3.0/vimanam-aarch64-apple-darwin.tar.xz"
      sha256 "fcf43e79a05353c8cf80a072733bc56c0de38f77fa19e4b19a5f2e8b06d1fb20"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noemaforge/vimanam/releases/download/v1.3.0/vimanam-x86_64-apple-darwin.tar.xz"
      sha256 "56e3260efeb2262fdbd50713f77a6c6be227b4697f5a87507509e8189628fa2f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/noemaforge/vimanam/releases/download/v1.3.0/vimanam-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fffac256bd5766109cacc4a28adba7d34a8875b2e6dbf4d21119f9292826a8fc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noemaforge/vimanam/releases/download/v1.3.0/vimanam-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0eeeb9dc65eb082d7cda7279bb23ff941bca7b3e55a8a352186555d2f12af827"
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
