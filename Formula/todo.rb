# frozen_string_literal: true

# Homebrew formula for Taskwarrior (renamed as `todo` binary) with custom completions.
class Todo < Formula
  desc 'Feature-rich console based todo list manager (renamed from taskwarrior)'
  homepage 'https://taskwarrior.org/'
  url 'https://github.com/GothenburgBitFactory/taskwarrior/releases/download/v3.4.1/task-3.4.1.tar.gz'
  sha256 '23eb60f73e42f16111cc3912b44ee12be6768860a2db2a9c6a47f8ac4786bac3'
  license 'MIT'
  head 'https://github.com/GothenburgBitFactory/taskwarrior.git', branch: 'develop'

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on 'cmake' => :build
  depends_on 'corrosion' => :build
  depends_on 'rust' => :build

  on_linux do
    depends_on 'linux-headers@5.15' => :build
    depends_on 'readline'
    depends_on 'util-linux'
  end

  def install
    configure_build
    rename_binary
    relocate_upstream_completions
    install_todo_completions
    rename_manpage
  end

  def configure_build
    system 'cmake', '-S', '.', '-B', 'build', *std_cmake_args
    system 'cmake', '--build', 'build'
    system 'cmake', '--install', 'build'
  end

  def rename_binary
    mv bin / 'task', bin / 'todo'
  end

  def relocate_upstream_completions
    dir = pkgshare / 'upstream-completions'
    dir.mkpath

    safe_mv(share / 'zsh/site-functions/_task', dir / '_task')
    safe_mv(bash_completion / 'task.sh',        dir / 'task.sh')
    safe_mv(fish_completion / 'task.fish',      dir / 'task.fish')
  end

  def safe_mv(src, dest)
    return unless src.exist?

    mv src, dest
  end

  def install_todo_completions
    bash_completion.install 'scripts/bash/task.sh'   => 'todo.sh'
    zsh_completion.install  'scripts/zsh/_task'      => '_todo'
    fish_completion.install 'scripts/fish/task.fish' => 'todo.fish'
  end

  def rename_manpage
    src = man1 / 'task.1'
    mv src, man1 / 'todo.1' if src.exist?
  end

  test do
    (testpath / '.taskrc').write('') # ensure config exists
    system bin / 'todo', 'add', 'Write', 'a', 'test'
    assert_match 'Write a test', shell_output("#{bin}/todo list")
  end
end
