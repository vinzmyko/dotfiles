# Neovim Configuration Cheat Sheet

**Adding New Languages:**
1. Add LSP server to `servers` table in `lua/plugins/lsp.lua`
2. Add formatter to `formatters_by_ft` in `lua/plugins/formatting.lua`
3. Add linter to `linters_by_ft` if needed
4. Run `:Mason` to install tools

---

## 🔧 **Advanced Features**

### Git-Aware File Management
- **Neo-tree**: Automatically hides `.git/`, `node_modules/`, `target/`, build dirs
- **Telescope**: `<C-p>` searches only git-tracked files
- **Live Grep**: Searches only in relevant project files
- **Smart filtering**: Excludes binary files, dependencies, build artifacts

### Visual Enhancements
- **Buffer tabs**: Visual tabs at top with git status icons
- **Indent guides**: Subtle lines showing code structure (`:IBLDisable` to turn off)
- **Yank highlighting**: Text briefly highlights when copied
- **Relative line numbers**: Optimized for `{number}{motion}` navigation
- **Cursor line**: Current line highlighted
- **Matching brackets**: Automatically highlighted

### Session & Workflow
| Command | Action |
|---------|--------|
| `<leader>qs` | Restore session |
| `<leader>ql` | Restore last session |
| `<leader>qd` | Don't save current session |
| `<leader>cm` | Open Mason (LSP installer) |

---

## **Debugging (DAP)**

### Debug Session Control
| Command | Action |
|---------|--------|
| **`<leader>db`** | **Toggle breakpoint** |
| **`<leader>dc`** | **Continue/Start debugging** |
| **`<leader>di`** | **Step into function** |
| **`<leader>dO`** | **Step over line** |
| **`<leader>do`** | **Step out of function** |
| **`<leader>dt`** | **Terminate debug session** |
| **`<leader>du`** | **Toggle debug UI** |
| `<leader>dB` | Conditional breakpoint |
| `<leader>dC` | Run to cursor |
| `<leader>dr` | Toggle debug REPL |
| `<leader>de` | Evaluate expression |
| `<leader>dl` | Run last debug session |

### Debug UI
- **Breakpoints**: 🛑 (normal), 🔍 (conditional), ❌ (rejected)
- **Current line**: ➡️ when debugging
- **Automatic UI**: Opens when debug starts, closes when done
- **Languages**: Rust (codelldb) and C# (coreclr) configured

---------|--------|----------|
| **`<C-p>`** | **Find Git Files** | Files |
| **`<leader>ff`** | **Find All Files** | Files |
| **`<leader>fs`** | **Live Grep** | Search |
| **`<leader>fw`** | **Grep Word Under Cursor** | Search |
| **`<S-h>`** / **`<S-l>`** | **Previous/Next Buffer** | Buffers |
| **`<leader>bb`** | **Switch to Last Buffer** | Buffers |
| **`<leader>bd`** | **Delete Buffer** | Buffers |
| **`<leader>k`** | **LSP Hover** | Code |
| **`gd`** | **Go to Definition** | Code |
| **`<leader>gr`** | **Find References** | Code |
| **`<leader>.`** | **Code Actions** | Code |
| **`<leader>rn`** | **Rename Symbol** | Code |
| **`]d`** / **`[d`** | **Next/Prev Diagnostic** | Code |
| **`]e`** / **`[e`** | **Next/Prev Error** | Code |
| **`]f`** / **`[f`** | **Next/Prev Function** | Navigation |
| **`<leader>cf`** | **Format Code** | Editing |
| **`<leader>e`** | **File Explorer (reveal)** | Files |
| **`<leader>db`** | **Toggle Breakpoint** | Debug |
| **`<leader>dc`** | **Debug Continue** | Debug |

---

## 📁 **File Navigation**

### Telescope (Find Everything)
| Command | Action |
|---------|--------|
| **`<C-p>`** | **Find Git Files (main workflow)** |
| **`<leader>ff`** | **Find All Files** |
| `<leader>fb` | Find Open Buffers |
| `<leader>fr` | Find Recent Files |
| **`<leader>fs`** | **Live Grep (search in git files only)** |
| **`<leader>fw`** | **Grep Word Under Cursor (git files only)** |
| `<leader>fh` | Find Help Tags |
| `<leader>fc` | Find Commands |
| `<leader>fk` | Find Keymaps |
| `<leader>fd` | Find Diagnostics |

### Inside Telescope
| Command | Action |
|---------|--------|
| `<C-j>` / `<C-k>` | Navigate results |
| `<C-q>` | Send to quickfix list |
| `<Tab>` | Select multiple files |
| `<Esc>` | Close telescope |

### Neo-tree (File Explorer)
*Now git-aware - only shows relevant project files*
| Command | Action |
|---------|--------|
| **`<leader>e`** | **Toggle file explorer (reveal current)** |
| **`<leader>be`** | **Buffer explorer** |

### Inside Neo-tree
| Command | Action |
|---------|--------|
| `a` | Add file/folder |
| `d` | Delete |
| `r` | Rename |
| `c` | Copy |
| `m` | Move |
| `R` | Refresh |
| `q` | Close |
| `Y` | Copy path to clipboard |
| `O` | Open with system app |

---

## 💻 **Code & LSP**

### LSP Actions
| Command | Action |
|---------|--------|
| **`<leader>k`** | **Hover (show documentation)** |
| **`<leader>K`** | **Show diagnostics** |
| **`gd`** | **Go to definition** |
| **`<leader>gr`** | **Find references** |
| **`<leader>gi`** | **Go to implementation** |
| **`<leader>gt`** | **Go to type definition** |
| **`<leader>.`** | **Code actions** |
| **`<leader>rn`** | **Rename symbol** |

### Diagnostics Navigation
| Command | Action |
|---------|--------|
| **`]d`** / **`[d`** | **Next/previous diagnostic** |
| **`]e`** / **`[e`** | **Next/previous error** |
| **`]w`** / **`[w`** | **Next/previous warning** |
| `<leader>xx` | Open document diagnostics |
| `<leader>xX` | Open workspace diagnostics |

### Function Navigation (Treesitter)
| Command | Action |
|---------|--------|
| **`]f`** / **`[f`** | **Next/previous function** |
| `]c` / `[c` | Next/previous class |
| `]a` / `[a` | Next/previous parameter |

---

## 🔧 **Editing & Text Objects**

### Mini.ai Text Objects
*Use with verbs like `d` (delete), `c` (change), `v` (visual)*

| Command | Action |
|---------|--------|
| **`daf`** | **Delete around function** |
| **`dif`** | **Delete inside function** |
| `dac` / `dic` | Delete around/inside class |
| `daa` / `dia` | Delete around/inside argument |
| `da"` / `di"` | Delete around/inside quotes |
| `dab` / `dib` | Delete around/inside brackets |
| `dat` / `dit` | Delete around/inside HTML tags |

### Mini.surround
| Command | Action |
|---------|--------|
| `gsa` | Add surrounding (then choose what to surround with) |
| `gsd` | Delete surrounding |
| `gsr` | Replace surrounding |
| `gsf` / `gsF` | Find surrounding (right/left) |
| `gsh` | Highlight surrounding |

### Visual Selection & Movement
| Command | Action |
|---------|--------|
| **`J`** / **`K`** | **Move selected lines down/up (visual mode)** |
| `<` / `>` | Indent left/right (keeps selection) |
| `<C-space>` | Expand selection (treesitter) |
| `<bs>` | Shrink selection (in visual mode) |

### Text Manipulation
| Command | Action |
|---------|--------|
| **`<leader>cf`** | **Format current buffer** |
| `gcc` | Toggle line comment |
| `gc` | Toggle comment (visual mode) |
| `gco` / `gcO` | Add comment below/above |

---

## 🪟 **Windows & Buffers**

### Buffer Management
*Enhanced with visual tabs and pinning*
| Command | Action |
|---------|--------|
| **`<S-h>`** / **`<S-l>`** | **Previous/next buffer (see tabs)** |
| **`<leader>bb`** | **Switch to alternate buffer** |
| **`<leader>bd`** | **Delete current buffer (smart)** |
| **`<leader>bp`** | **Pin buffer (prevents auto-close)** |
| **`<leader>bP`** | **Delete all unpinned buffers** |
| `<leader>bo` | Delete other buffers |
| `<leader>br` | Delete buffers to the right |
| `<leader>bl` | Delete buffers to the left |
| `<leader>bD` | Force delete buffer |

*💡 **Pinned Buffer Workflow**: Pin important files with `<leader>bp`, then use `<leader>bP` to clean up all temporary buffers while keeping your pinned ones!*

### Window Management
| Command | Action |
|---------|--------|
| **`<leader>-`** | **Split horizontally** |
| **`<leader>|`** | **Split vertically** |
| `<leader>wd` | Delete window |
| `<leader>wm` | Maximize window (zoom) |
| **`<C-h/j/k/l>`** | **Navigate windows (works with tmux)** |
| `<C-Up/Down>` | Resize window height |
| `<C-Left/Right>` | Resize window width |

---

## 📝 **Git & Writing**

### Gitsigns (Git Changes)
| Command | Action |
|---------|--------|
| **`]h`** / **`[h`** | **Next/previous git hunk** |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hS` | Stage entire buffer |
| `<leader>hR` | Reset entire buffer |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line |
| `<leader>hd` | Diff this file |

### Git Tools
| Command | Action |
|---------|--------|
| `<leader>gg` | Open Neogit (git interface) |
| `<leader>gl` | Open LazyGit |
| `<leader>gd` | Open DiffView |
| `<leader>gc` | Close DiffView |

### Writing Mode
*Optimized for documentation and markdown*
| Command | Action |
|---------|--------|
| **`<leader>uw`** | **Toggle writing mode** |

**Writing Mode Features:**
- ✅ UK English spell checking (`en_gb`)
- ✅ Zen mode (hides UI elements)
- ✅ Word wrap enabled
- ✅ LSP diagnostics disabled
- ✅ Softer visual experience
- ✅ 80-character text width

### TODO Comments
| Command | Action |
|---------|--------|
| **`]t`** / **`[t`** | **Next/previous TODO comment** |
| `<leader>st` | Search all TODOs |
| `<leader>sT` | Search TODO/FIX/FIXME only |

---

## 🖥️ **Terminal & Tools**

### Terminal Management
*Floating terminals + tmux integration*
| Command | Action |
|---------|--------|
| **`<leader>ft`** | **Floating terminal** |
| `<leader>fT` | Terminal in current directory |
| **`<C-/>`** | **Quick toggle terminal** |
| **`<leader>gl`** | **LazyGit (git interface)** |
| `<leader>tp` | Python REPL |
| `<leader>tn` | Node REPL |

### In Terminal Mode
| Command | Action |
|---------|--------|
| `<Esc>` | Exit terminal mode |
| `jk` | Exit terminal mode (alternative) |
| `<C-h/j/k/l>` | Navigate windows from terminal |

*💡 **Workflow**: Use floating terminals for quick commands (git, cargo test) while keeping tmux for longer sessions*

---

## 🔍 **Search & Navigation**

### Better Movement
| Command | Action |
|---------|--------|
| **`j`** / **`k`** | **Smart down/up (handles wrapped lines)** |
| `<C-d>` / `<C-u>` | Half page down/up (centered) |
| `n` / `N` | Next/prev search (centered) |
| `J` | Join lines (cursor stays put) |

### Word Motions
| Command | Action |
|---------|--------|
| `<leader>w` | Next word (camelCase aware) |
| `<leader>b` | Previous word (camelCase aware) |
| `<leader>e` | End of word (camelCase aware) |

### Quickfix & Location Lists
| Command | Action |
|---------|--------|
| `]q` / `[q` | Next/prev quickfix item |
| `<leader>xQ` | Open quickfix in Trouble |
| `<leader>xL` | Open location list in Trouble |

---

## ⚙️ **Utility & Configuration**

### Session Management
| Command | Action |
|---------|--------|
| `<leader>qs` | Restore session |
| `<leader>ql` | Restore last session |
| `<leader>qd` | Don't save current session |

### Plugin Management
| Command | Action |
|---------|--------|
| `<leader>cm` | Open Mason (LSP installer) |
| `:Lazy` | Open Lazy plugin manager |
| `:ConformInfo` | Show formatting info |

### Insert Mode Shortcuts
| Command | Action |
|---------|--------|
| **`<C-BS>`** | **Delete word backward** |
| `<C-H>` | Delete word backward (alternative) |
| `,` / `.` / `;` | Add undo break-points |

---

## **Tips**

### Workflow Optimization
1. **Use `<C-p>` for 90% of file finding** (git files only, no build artifacts)
2. **Use `<leader>fw` to find all uses of word under cursor** (project-wide search)
3. **Use `<leader>bb` to quickly switch between two files** (last buffer)
4. **Use `]f` / `[f` to navigate functions instead of scrolling** (treesitter-aware)
5. **Use text objects like `daf` (delete around function) for quick editing**
6. **Use `<leader>uw` for distraction-free writing/documentation**
7. **Pin important buffers with `<leader>bp`**, then clean up with `<leader>bP`
8. **Use `<leader>gl` for git operations** instead of terminal commands

### Debug Workflow (Rust/C#)
1. **Set breakpoint**: `<leader>db` on the line you want to pause
2. **Start debugging**: `<leader>dc` (debug UI opens automatically)
3. **Navigate**: `<leader>di` (step into), `<leader>dO` (step over)
4. **Inspect**: Hover over variables or use `<leader>de` to evaluate
5. **Continue**: `<leader>dc` until next breakpoint
6. **Stop**: `<leader>dt` to terminate

### Git Integration Workflow
1. **See changes**: Gitsigns shows added/modified/deleted lines in gutter
2. **Stage hunks**: `<leader>hs` to stage current change
3. **Navigate changes**: `]h` / `[h` to jump between git hunks
4. **Full git UI**: `<leader>gl` for LazyGit interface
5. **View diffs**: `<leader>gd` for side-by-side diff view

### Language-Specific Features
- **Rust**: Full IDE with rust-analyzer, clippy, rustfmt, debugging with codelldb
- **C#**: Full IDE with OmniSharp, debugging with netcoredbg
- **YAML/Docker**: Linting, formatting, schema validation
- **Go/JS/TS**: Basic support with LSP, formatting, linting

### Quick Reference for Beginners
1. **File navigation**: `<C-p>` → type filename → Enter
2. **Search in files**: `<leader>fs` → type search term → Enter  
3. **Go to definition**: Cursor on symbol → `gd`
4. **Format code**: `<leader>cf`
5. **Toggle file tree**: `<leader>e` 
6. **Debug**: `<leader>db` (breakpoint) → `<leader>dc` (start)
7. **Git status**: File tree shows git icons, gutter shows changes
