class Edge < Formula
  desc "CLI for building and running Edge applications"
  homepage "https://github.com/edgeengineer/edge-agent"
  url "https://github.com/edgeengineer/edge-agent/archive/refs/tags/2025.06.04-204316.tar.gz"
  sha256 "da2e7dd3a19f9152d8084f1aaed1c972a44761b6abe0fcfa4f73fb593f2ad04f"
  license "Apache-2.0"
  head "https://github.com/edgeengineer/edge-agent.git", branch: "main"

  depends_on xcode: ["16.3", :build]
  uses_from_macos "swift" => :build

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end

    system "./Scripts/inject-version.sh", version.to_s
    system "swift", "build", *args, "-c", "release", "--product", "edge"

    bin.install ".build/release/edge"
    # TODO: install resources, see: https://github.com/swiftlang/swift-package-manager/issues/8510
    prefix.install ".build/release/edge-agent_edge.bundle"
    bin.install_symlink prefix/"edge-agent_edge.bundle"
  end

  test do
    # TODO: It would be better to actually build something, instead of just checking the help text.
    system bin/"edge", "--help"
    assert_match "OVERVIEW: Edge CLI", shell_output("#{bin}/edge --help")
  end
end
