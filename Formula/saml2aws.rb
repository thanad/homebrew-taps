class Saml2aws < Formula
  desc "Login and retrieve AWS temporary credentials using a SAML IDP"
  homepage "https://github.com/thanad/saml2aws"
  url "https://github.com/thanad/saml2aws/archive/refs/tags/v2.36.19.1.tar.gz"
  sha256 "f6121a58c9efad988e5ea5037286ae4ce7c26ea0738de0d05862355ce5f1d270"
  version "2.36.19.1"
  license "MIT"
  head "https://github.com/thanad/saml2aws.git", branch: "playwright"

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd/saml2aws"

    generate_completions_from_executable(bin/"saml2aws", shell_parameter_format: "--completion-script-",
                                                         shells:                 [:bash, :zsh])
  end

  test do
    assert_match "error building login details: Failed to validate account.: URL empty in idp account",
      shell_output("#{bin}/saml2aws script 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/saml2aws --version 2>&1")
  end
end
