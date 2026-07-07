
# Project Aliases (Zsh Plugin)

A lightweight **Zsh plugin** to manage **per-project shell aliases**.  
Aliases are **loaded automatically** when you enter a project folder and **removed automatically** when you leave.  

![Project Aliases demo](/assets/project-aliases.svg)

---

## ⚡ Quick Start
```bash
# Inside your project folder
echo "alias run='npm run dev'" > .proj_aliases
echo "alias test='npm test'" >> .proj_aliases

cd ~/my-project
# [project-aliases] Warning: Untrusted .proj_aliases found. Run 'palias allow' to trust and load it.

palias allow
# [project-aliases] Loaded and trusted aliases for project: /Users/username/my-project

run
# Executes: npm run dev

cd ..
# [project-aliases] Project aliases removed
```

---

## ✨ Features
- Define aliases per project in a `.proj_aliases` file.
- **🔒 Security-First**: Requires explicit trust (`palias allow`) before loading a `.proj_aliases` file. If the file is modified externally, the trust is invalidated, preventing silent execution of untrusted code.
- Automatically **load aliases** when entering a trusted project folder.
- Automatically **unload them** when leaving.
- Keep a clean shell environment — no alias pollution between projects.
- Helper commands:
    - `palias list` → view currently active project aliases
    - `palias edit` → edit currently project aliases
    - `palias reload` → reload aliases for the current project without leaving the folder
    - `palias allow` → trust and load aliases for the current project
    - `palias deny` → untrust and unload aliases for the current project

---

## 📦 Installation

### **Oh My Zsh**
1. Clone the plugin into your Oh My Zsh custom plugins folder:
   ```bash
   git clone https://github.com/dvigo/project-aliases.git ~/.oh-my-zsh/custom/plugins/project-aliases
   ```
2. Enable it in your `~/.zshrc`:
   ```bash
   plugins=(... project-aliases)
   ```
3. Reload Zsh:
   ```bash
   source ~/.zshrc
   ```

---

## 🎥 Demo

TBD

---

## ⚙️ Configuration

No extra configuration is needed.  
Simply create a `.proj_aliases` file in the root of any project you want to use aliases in.

**Example `.proj_aliases`**
```bash
alias run="npm run dev"
alias lint="eslint src/"
alias up="docker-compose up -d"
alias down="docker-compose down"
```

---

## 🖊️ Usage

### Available commands:
```bash
palias list    # Shows active project aliases
palias edit    # Opens the current project's .proj_aliases in your editor
palias reload  # Reload aliases from the current project's .proj_aliases
palias allow   # Trust and load the current project's .proj_aliases
palias deny    # Untrust and unload the current project's .proj_aliases
```

### Example session:
```bash
cd ~/dev/my-api
# [project-aliases] Warning: Untrusted .proj_aliases found. Run 'palias allow' to trust and load it.

palias allow
# [project-aliases] Loaded and trusted aliases for project: /Users/username/dev/my-api

up      # runs docker-compose up -d
down    # runs docker-compose down

# If you modify .proj_aliases, it becomes untrusted again. Re-run allow to load it:
palias allow

cd ..
# [project-aliases] Project aliases removed
```

---

## 🔧 Roadmap
- [ ] Add support for `.proj_aliases.d/` folder with multiple alias files.
- [ ] Add an option to persist aliases across shells until manually cleared.
- [ ] Add support for project-specific environment variables.

---

## 📜 License
GNU General Public License v3.0 — See [LICENSE](LICENSE) for details.

---