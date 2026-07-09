# Neovim Configuration

基于 [NvChad v2.5](https://github.com/NvChad/NvChad) 的 Neovim 配置。

## 📋 目录

- [特性](#特性)
- [安装](#安装)
- [配置结构](#配置结构)
- [主要功能](#主要功能)
- [快捷键映射](#快捷键映射)
- [插件列表](#插件列表)
- [语言支持](#语言支持)
- [代码优化](#代码优化)

## ✨ 特性

- 🎨 **美观的界面**: 基于 OneDark 主题，现代化的 UI
- ⚡ **高性能**: 使用 lazy.nvim 进行插件懒加载
- 🔧 **LSP 支持**: 覆盖 C/C++、Python、Rust、Go、Dart、Java、Kotlin 等主力语言
- 📝 **代码格式化**: 集成多种格式化工具
- 🔎 **代码诊断**: 使用 nvim-lint 接入轻量级诊断工具
- 🎯 **智能补全**: 基于 LSP 的代码补全
- 🌳 **语法高亮**: TreeSitter 语法高亮
- 🧩 **C/CUDA 增强**: clangd 扩展、内联提示和 CUDA 语法支持
- 📱 **Flutter/Dart 支持**: Flutter 热重载、设备管理和 Dart LSP
- 🧪 **断点调试**: nvim-dap、DAP UI、codelldb、debugpy、delve、Java/Kotlin 调试和 STM32 ST-Link
- 📂 **文件管理**: NvimTree 文件浏览器
- 🔍 **快速搜索**: Telescope 模糊搜索
- 📊 **Git 集成**: Gitsigns Git 状态显示
- 🎭 **专注模式**: TrueZen 专注模式支持

## 🚀 安装

### 前置要求

- Neovim >= 0.10.0
- Git
- 可选: 各种语言服务器（通过 Mason 自动安装）
- 可选: STM32 调试需要系统安装 `openocd` 和 `arm-none-eabi-gdb`

### 安装步骤

1. **备份现有配置**（如果存在）:
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. **克隆或复制配置**:
   ```bash
   # 如果这是你的配置仓库
   git clone <your-repo-url> ~/.config/nvim
   
   # 或者直接使用当前配置
   ```

3. **启动 Neovim**:
   ```bash
   nvim
   ```

4. **等待插件安装**: 首次启动时会自动安装所有插件，这可能需要几分钟。

## 📁 配置结构

```
~/.config/nvim/
├── init.lua                 # 主入口文件
├── lazy-lock.json          # 插件锁定文件
├── README.md               # 本文件
├── LICENSE                 # 许可证
├── snippets/               # 代码片段目录
└── lua/
    ├── options.lua         # Neovim 选项配置
    ├── mappings.lua        # 快捷键映射
    ├── autocmds.lua        # 自动命令
    ├── functions.lua       # 自定义函数
    ├── helper.lua          # 辅助函数库
    ├── highlights.lua      # 高亮配置
    ├── chadrc.lua          # NvChad 配置
    ├── configs/            # 插件配置
    │   ├── lazy.lua        # Lazy.nvim 配置
    │   ├── lspconfig.lua   # LSP 配置
    │   ├── conform.lua     # Conform 配置
    │   ├── lint.lua        # nvim-lint 配置
    │   ├── dap.lua         # nvim-dap 配置
    │   ├── jdtls.lua       # Java LSP/DAP 配置
    │   ├── rustaceanvim.lua # Rust 专用增强配置
    │   ├── gitsigns.lua    # Gitsigns 配置
    │   ├── truezen.lua     # TrueZen 配置
    │   ├── cscope_maps.lua # Cscope 映射
    │   └── overrides.lua   # 插件覆盖配置
    └── plugins/            # 自定义插件
        └── init.lua        # 插件列表
```

## 🎯 主要功能

### 代码格式化

- **Lua**: stylua
- **Shell**: shfmt
- **C/C++**: clang-format
- **CUDA**: clang-format
- **Python**: ruff organize imports + ruff format
- **Rust**: rustfmt
- **Go**: goimports + gofumpt
- **Dart**: dart format
- **Java**: google-java-format
- **Kotlin**: ktlint
- **CMake**: cmake-format
- **Markdown/JSON/YAML**: prettierd，回退到 prettier

### 代码诊断

- **Lua**: lua-language-server
- **C/C++/CUDA**: clangd + clang-tidy
- **Shell**: shellcheck
- **Python**: basedpyright + ruff server
- **Rust**: rustaceanvim/rust-analyzer + clippy
- **Go**: gopls staticcheck + golangci-lint
- **Java**: nvim-jdtls
- **Kotlin**: kotlin-lsp + ktlint

### 断点调试

- **C/C++/CUDA/Rust**: codelldb
- **Python**: debugpy
- **Go**: delve
- **Java**: nvim-jdtls + java-debug-adapter/java-test
- **Kotlin**: kotlin-debug-adapter
- **STM32/ST-Link**: OpenOCD + `arm-none-eabi-gdb -i dap`，可选 cortex-debug
- **UI**: nvim-dap-ui 自动随调试会话打开和关闭
- **行内变量**: nvim-dap-virtual-text

### Flutter/Dart

- Dart 文件自动加载 flutter-tools
- 支持 Flutter run、设备/模拟器管理、Hot Reload 和 Hot Restart
- Flutter 调试会话通过 nvim-dap 运行

### STM32/ST-Link 调试

- `:STM32OpenOCD target/stm32f4x.cfg`: 使用 `interface/stlink.cfg` 启动 OpenOCD
- DAP 配置 `STM32 ST-Link OpenOCD attach`: 连接已经运行的 OpenOCD `localhost:3333`
- DAP 配置 `STM32 ST-Link OpenOCD attach + load`: 连接后执行 `load` 并复位
- DAP 配置 `STM32 ST-Link cortex-debug launch`: 走 cortex-debug，适合需要 RTT、内存视图和 `launch.json` 兼容参数的场景

### 自动文件头

自动为新文件插入文件头，支持：
- Shell 脚本 (shebang)
- Python 脚本 (shebang)
- C/C++ 文件 (版权信息 + includes)
- C/C++ 头文件 (header guards)
- 自动更新版权年份

### 编码转换

- `ToUTF8()`: 将文件编码转换为 UTF-8

### 文本转换

- Markdown ↔ LaTeX 转换
- 支持视觉选择模式和剪贴板模式

## ⌨️ 快捷键映射

### Leader 键

Leader 键设置为 `;`

### 文件操作

| 快捷键 | 功能 |
|--------|------|
| `<leader>w` | 保存文件 |
| `<leader>p` | 复制整个文件到剪贴板 |
| `<leader>db` | 删除缓冲区所有内容 |
| `<leader>fm` | 使用 conform 格式化当前文件或选区 |
| `<leader>j` | 切换工作目录到文件目录或返回 |

### 搜索

| 快捷键 | 功能 |
|--------|------|
| `<leader>s` | Telescope grep_string |
| `<leader>tl` | Telescope live_grep |
| `<leader>te` | 打开 Telescope |

### TrueZen 专注模式

| 快捷键 | 功能 |
|--------|------|
| `<leader>ta` | 进入 Ataraxis 模式 |
| `<leader>tm` | 进入 Minimalist 模式 |
| `<leader>tf` | 进入 Focus 模式 |

### Buffer 导航

| 快捷键 | 功能 |
|--------|------|
| `<A-j>` | 下一个缓冲区 |
| `<A-k>` | 上一个缓冲区 |

### 视觉模式搜索

| 快捷键 | 功能 |
|--------|------|
| `*` | 向前搜索选中文本 |
| `#` | 向后搜索选中文本 |
| `<leader>r` | 搜索并替换选中文本 |

### 其他

| 快捷键 | 功能 |
|--------|------|
| `<leader><space>` | 清理行尾空白 |
| `<leader>u` | 转换文件编码为 UTF-8 |
| `<leader>ha` | 打开 Harpoon 窗口 |

### DAP 调试

| 快捷键 | 功能 |
|--------|------|
| `<leader>dc` | 继续/启动调试 |
| `<leader>dB` | 切换断点 |
| `<leader>dC` | 清除所有断点 |
| `<leader>di` | 单步进入 |
| `<leader>do` | 单步跳过 |
| `<leader>dO` | 单步跳出 |
| `<leader>dr` | 打开 DAP REPL |
| `<leader>du` | 切换 DAP UI |
| `<leader>dx` | 终止调试 |
| `<leader>dl` | 设置日志断点 |

### Git 操作 (Gitsigns)

| 快捷键 | 功能 |
|--------|------|
| `]c` | 下一个 hunk |
| `[c` | 上一个 hunk |
| `<leader>hs` | 暂存 hunk |
| `<leader>hr` | 重置 hunk |
| `<leader>hS` | 暂存缓冲区 |
| `<leader>hu` | 撤销暂存 hunk |
| `<leader>hR` | 重置缓冲区 |
| `<leader>hp` | 预览 hunk |
| `<leader>hb` | 显示完整 blame |
| `<leader>tb` | 切换行 blame |
| `<leader>hd` | 显示 diff |
| `<leader>hD` | 显示 diff (~) |
| `<leader>td` | 切换删除行显示 |
| `ih` | 选择 hunk (文本对象) |

### Cscope 操作

| 快捷键 | 功能 |
|--------|------|
| `<leader>c...` | 各种 Cscope 操作 |

## 📦 插件列表

### 核心插件

- **NvChad**: 基础配置框架
- **lazy.nvim**: 插件管理器
- **plenary.nvim**: Lua 工具库

### LSP 和补全

- **nvim-lspconfig**: LSP 配置
- **mason.nvim**: LSP/DAP/Linter/Formatter 管理器
- **clangd_extensions.nvim**: clangd 增强能力
- **rustaceanvim**: Rust 专用 LSP、code action 和 DAP 增强
- **nvim-jdtls**: Java LSP、测试和调试工作流
- **flutter-tools.nvim**: Flutter/Dart 集成

### 语法和代码

- **nvim-treesitter**: 语法高亮和代码解析
- **conform.nvim**: 代码格式化
- **nvim-lint**: 代码诊断

### 调试和跨平台开发

- **nvim-dap**: Debug Adapter Protocol 客户端
- **nvim-dap-ui**: 调试 UI
- **mason-nvim-dap.nvim**: DAP 适配器安装和配置
- **nvim-dap-go**: Go/Delve 调试集成
- **nvim-dap-virtual-text**: 调试变量行内显示
- **nvim-dap-cortex-debug**: Cortex-M/STM32 调试增强

### UI 和导航

- **nvim-tree**: 文件浏览器
- **telescope.nvim**: 模糊查找器
- **TrueZen.nvim**: 专注模式
- **gitsigns.nvim**: Git 状态显示

### 编辑增强

- **nvim-surround**: 快速操作包围符号
- **better-escape.nvim**: 更好的退出插入模式
- **harpoon**: 快速文件导航
- **sniprun**: 代码片段运行

### 其他

- **cscope_maps.nvim**: Cscope 集成
- **fcitx.nvim**: 中文输入法支持
- **typst.vim**: Typst 文件支持

## 🌐 语言支持

### LSP 服务器

- **C/C++**: clangd
- **C/C++/CUDA 增强**: clangd_extensions.nvim + clang-tidy
- **Rust**: rustaceanvim 接管 rust-analyzer
- **Python**: basedpyright + ruff
- **Go**: gopls
- **Dart/Flutter**: flutter-tools 接管 dartls
- **Java**: nvim-jdtls
- **Kotlin**: kotlin-lsp
- **Bash**: bashls
- **Lua**: lua-language-server
- **CMake**: neocmakelsp
- **ASM**: asm-lsp
- **Markdown**: marksman
- **LaTeX**: texlab
- **Verilog**: verible
- **JSON**: jqls
- **Typst**: tinymist

### TreeSitter 解析器

- lua, vim, comment, dockerfile, json
- bash, python, cuda, asm, perl
- c, cpp, dart, rust, ron, toml, go, gomod, gosum, gowork
- java, kotlin, cmake, make
- verilog, markdown, markdown_inline

### 文件类型特定配置

- **Lua/Markdown/TeX**: 2 空格缩进
- **Python**: 120 字符行宽
- **Rust**: 100 字符行宽
- **C/C++ 头文件**: 8 空格 tab
- **C++ 源文件**: 2 空格 tab
- **Go/Kconfig/Make/DTS**: 使用 tab 而非空格

## 📝 自定义功能

### 文件头自动插入

创建新文件时自动插入适当的文件头：
- Shell/Python: shebang
- C/C++: 版权信息和 includes
- 头文件: header guards

### 版权信息自动更新

打开 C/C++ 文件时自动更新版权年份。

### 编码检测和转换

使用 `uchardet` 检测文件编码，使用 `iconv` 转换为 UTF-8。

### 文本格式转换

支持 Markdown 和 LaTeX 之间的转换，使用 pandoc。

## 🎨 主题

当前使用 **OneDark** 主题，可在 `lua/chadrc.lua` 中修改。

## 📄 许可证

查看 [LICENSE](LICENSE) 文件了解详情。

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📚 参考

- [NvChad 文档](https://nvchad.com/)
- [Neovim 文档](https://neovim.io/doc/)
- [Lazy.nvim 文档](https://github.com/folke/lazy.nvim)

---

**注意**: 本配置基于 NvChad v2.5，并进行了大量自定义和优化。建议在使用前了解 NvChad 的基本概念。
