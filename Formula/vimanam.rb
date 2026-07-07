class Vimanam < Formula
  desc "OpenAPI/Swagger to Markdown documentation generator with grouping, filtering, and detail levels for docs and LLM context"
  homepage "https://github.com/noemaforge/vimanam"
  version "1.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/noemaforge/vimanam/releases/download/v1.0.1/vimanam-aarch64-apple-darwin.tar.xz"
      sha256 "edfcfc99039dfdfb882c902b552d7492489b063a1adf75dd06525f67d988aa20"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noemaforge/vimanam/releases/download/v1.0.1/vimanam-x86_64-apple-darwin.tar.xz"
      sha256 "d4e7bdfc78cf09c4a510a1ce006c0e67557b14b719cb3daf0332d1decacaf68c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/noemaforge/vimanam/releases/download/v1.0.1/vimanam-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "920346e3bbd3ddff1c156070fa1b63aafbf5072ff065ff7972d3103dbebf7ade"
    end
    if Hardware::CPU.intel?
      url "https://github.com/noemaforge/vimanam/releases/download/v1.0.1/vimanam-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4e651b98aa43b72c01a80f696d6ee2962cded5eec44b0ee22f37aebd76d413c3"
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
