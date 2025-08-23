class Todo < Formula
  desc "Feature-rich console based todo list manager (renamed from taskwarrior)"
  homepage "https://taskwarrior.org/"
  url "https://github.com/GothenburgBitFactory/taskwarrior/releases/download/v3.4.1/task-3.4.1.tar.gz"
  sha256 "23eb60f73e42f16111cc3912b44ee12be6768860a2db2a9c6a47f8ac4786bac3"
  license "MIT"
  head "https://github.com/GothenburgBitFactory/taskwarrior.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "cmake" => :build
  depends_on "corrosion" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "linux-headers@5.15" => :build
    depends_on "readline"
    depends_on "util-linux"
  end

def install
  system "cmake", "-S", ".", "-B", "build", *std_cmake_args
  system "cmake", "--build", "build"
  system "cmake", "--install", "build"

  # Rename the binary to `todo`
  mv bin/"task", bin/"todo"

  # Install our own renamed completions (instead of upstream-installed ones)
  bash_completion.install "scripts/bash/task.sh" => "todo.sh"
  zsh_completion.install  "scripts/zsh/_task"    => "_todo"
  fish_completion.install "scripts/fish/task.fish" => "todo.fish"

  # Optional: rename manpage to avoid conflicts
  (man1/"task.1").exist? && mv(man1/"task.1", man1/"todo.1")
end

  test do
    touch testpath/".taskrc"
    system bin/"todo", "add", "Write", "a", "test"
    assert_match "Write a test", shell_output("#{bin}/todo list")
  end
end
