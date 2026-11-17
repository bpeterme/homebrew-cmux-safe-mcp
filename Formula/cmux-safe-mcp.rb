class CmuxSafeMcp < Formula
  desc "MCP server with only the safe parts of cmux: agents can list, open, arrange and label workspaces and notify you, but never type into terminals, run commands or read screens"
  homepage "https://github.com/bpeterme/cmux-safe-mcp"
  url "https://github.com/bpeterme/cmux-safe-mcp/archive/refs/tags/2026.11.17.0.tar.gz"
  sha256 "e19d8a6020d720774f956202a228f51478453a6a6c30b072b2a104c8e97631c1"
  license "MIT"

  head "https://github.com/bpeterme/cmux-safe-mcp.git", branch: "dev"

  depends_on :macos

  def install
    version_str = build.head? ? "HEAD-#{`git rev-parse --short HEAD`.chomp}" : version.to_s
    inreplace "cmux-safe-mcp", 'VERSION = "dev"', "VERSION = \"#{version_str}\""
    bin.install "cmux-safe-mcp"
    (share/"cmux-safe-mcp").install "config.example"
  end

  def caveats
    <<~EOS
      Create your settings from the example, then list the repos agents may open:
        mkdir -p ~/.config/cmux-safe-mcp
        cp #{share}/cmux-safe-mcp/config.example ~/.config/cmux-safe-mcp/config

      In cmux's settings, choose password mode and set a password, so that
      cmux-safe-mcp can reach cmux from outside its terminals. Then check:
        cmux-safe-mcp check

      Add it to your MCP client, e.g. in an "mcpServers" entry:
        "cmux": { "command": "cmux-safe-mcp" }
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cmux-safe-mcp version")
  end
end
