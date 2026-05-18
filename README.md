# reuseable-agents-and-skills

一个用于沉淀可复用 `skill` 与 `custom agent` 资产的仓库，适用于 VS Code / Copilot / Codex 等智能体工作流。

当前仓库以技能定义为主，配套沉淀脚本、模板、静态资源、参考资料，以及可直接放入平台使用的 custom agent 配置。

## 项目目标

集中管理可复用的智能体能力定义，便于跨项目复用、迭代和规范化维护，主要包括：
- `SKILL.md`（技能）
- 自定义 Agent 配置（custom agent）

## 目录结构

- `.agents/skills/`: 技能目录
- `.agents/skills/<skill-name>/SKILL.md`: 技能主定义和执行说明
- `.agents/skills/<skill-name>/references/` 或 `.agents/skills/<skill-name>/reference/`（可选）: 技能引用文档
- `.agents/skills/<skill-name>/scripts/`（可选）: 技能辅助脚本
- `.agents/skills/<skill-name>/templates/`（可选）: 技能模板文件
- `.agents/skills/<skill-name>/assets/`（可选）: 图标、样例文件或其它静态资源
- `.agents/skills/<skill-name>/agents/`（可选）: 面向特定模型或运行时的补充配置
- `.agents/skills/<skill-name>/canvas-fonts/`（少数技能）: 设计类技能附带字体资源
- `.github/agents/`: custom agent 定义目录
- `.upstream/`: 外部上游仓库的 git submodule 工作副本，用于跟踪来源版本；不要在这里直接维护本仓库自定义内容

## 仓库概览

- 可发现 Skill 入口: 44 个（17 个本地目录入口 + 27 个 `azure-skills` 上游软链接入口）
- Custom Agents: 2 个
- 常见附属资产类型: `scripts`、`reference(s)`、`templates`、`assets`、`agents`、字体资源

## 本地 Skill 列表（不含 `azure-skills` 上游软链接）

| 序号 | Skill | 简要说明 |
|---|---|---|
| 1 | `algorithmic-art` | 基于 p5.js 的算法艺术生成与交互参数探索。 |
| 2 | `canvas-design` | 生成视觉设计产物（如 PNG/PDF）与设计哲学。 |
| 3 | `doc-coauthoring` | 文档共创流程（上下文收集、迭代、读者测试）。 |
| 4 | `docx` | Word 文档创建、编辑与内容处理。 |
| 5 | `frontend-design` | 高质量前端界面设计与实现。 |
| 6 | `jupyter-notebook` | Jupyter Notebook 脚手架、重构与结构化编写。 |
| 7 | `mcp-builder` | MCP Server 设计与实现指导。 |
| 8 | `pdf` | PDF 读写、拆分合并、OCR、水印与表单处理。 |
| 9 | `playwright` | 基于 CLI 的浏览器自动化与页面交互。 |
| 10 | `playwright-interactive` | 通过持久会话进行交互式 UI 调试。 |
| 11 | `ppt-master` | 多格式内容到 SVG/PPTX 的演示文稿生成流水线。 |
| 12 | `pptx` | 幻灯片创建、编辑、解析与重组。 |
| 13 | `sql-code-review` | SQL 安全性、可维护性与质量审查。 |
| 14 | `sql-optimization` | SQL 性能优化与索引/查询调优。 |
| 15 | `theme-factory` | 为文档/页面/演示应用主题与视觉风格。 |
| 16 | `web-artifacts-builder` | 构建复杂 HTML 前端 artifacts（React/Tailwind/shadcn）。 |
| 17 | `xlsx` | 电子表格文件（xlsx/csv/tsv）处理与生成。 |

`azure-skills` 上游技能通过软链接接入，数量和名称以 `.upstream/azure-skills/skills/` 为准，不在上表逐项展开。

## Custom Agent 列表（当前仓库）

当前仓库中的 custom agent 位于 `.github/agents/`：

| 序号 | Agent | 简要说明 |
|---|---|---|
| 1 | `code-review-and-planning` | 仓库只读审查与规划，输出中文审查报告和待办清单。 |
| 2 | `high-risk-secret-scan` | 高危 secrets 静态扫描；其 frontmatter 名称为 `code-high-risk-secrets-scan`。 |

## 使用方式

### 上游同步型 Skill

以下技能来源于外部仓库，本仓库通过 git submodule 跟踪上游，并通过软链接暴露到 `.agents/skills/`：

- `ppt-master`: 来源于 <https://github.com/hugohe3/ppt-master>，上游工作副本位于 `.upstream/ppt-master`，本地技能入口为 `.agents/skills/ppt-master`。其中 `SKILL.md`、`references`、`scripts`、`templates`、`workflows` 等顶层资产是相对软链接，指向 `.upstream/ppt-master/skills/ppt-master`。
- `azure-skills`: 来源于 <https://github.com/microsoft/azure-skills/tree/main/skills>，上游工作副本位于 `.upstream/azure-skills`。其中每个上游技能目录会作为 `.agents/skills/<skill-name>` 的直接软链接，例如 `.agents/skills/azure-storage -> ../../.upstream/azure-skills/skills/azure-storage`。

`.upstream/` 的作用类似 vendored upstream checkout，但由 git submodule 管理：父仓库只追踪 submodule 的提交指针（gitlink），真实文件内容由对应上游仓库管理。因此不要把 `.upstream/` 整体加入 `.gitignore`，否则容易让新 submodule、gitlink 或必要的上游路径变得不直观。若后续需要忽略临时内容，应只忽略明确的临时目录或生成文件，不要忽略 `.upstream/ppt-master` 和 `.upstream/azure-skills` 这两个 submodule 路径。

`azure-skills` 中有少量技能目录本身不以 `azure-` 开头，例如 `airunway-aks-setup`、`appinsights-instrumentation`、`entra-agent-id`、`entra-app-registration`、`microsoft-foundry`。这些目录在本仓库中保留上游原名，因为 `SKILL.md` frontmatter 的 `name` 通常需要和技能目录名一致；强行改成 `azure-...` 会引入包装目录或本地补丁，增加维护复杂度，也削弱和上游更新的对应关系。

技能发现依赖固定目录结构：`.agents/skills/<skill-name>/SKILL.md`、`.github/skills/<skill-name>/SKILL.md` 或 `.claude/skills/<skill-name>/SKILL.md`。因此不要把多个技能统一嵌套在根目录 `/azure` 或 `.agents/skills/azure/<skill-name>` 下；这类嵌套目录通常不会被自动发现。若要分组，建议保留 `.agents/skills/` 下的直接子目录入口，并通过命名或文档说明来源。

首次克隆后初始化上游依赖：

```bash
./update_submodule.sh
```

更新上游技能到配置分支的最新版本：

```bash
./update_submodule.sh
```

更新后提交 `.upstream/*` 的 gitlink 变化和必要的软链接变化。

导出全部可发现技能为 zip 包：

```bash
./pack_skills.sh
```

默认输出 `exported_skills.zip`，压缩包内路径为 `skills/<skill-name>/...`，并会解引用软链接，把上游 skill 的真实文件内容打包进去，方便拷贝到其他环境使用。

1. 在 `.agents/skills/<skill-name>/SKILL.md` 新增或更新技能。
2. 在 `.github/agents/` 中维护对应 agent 的定义文件。
3. 保持 `SKILL.md` frontmatter 字段合法，常用支持字段包括：
   - `name`
   - `description`
   - `argument-hint`
   - `compatibility`
   - `disable-model-invocation`
   - `license`
   - `metadata`
   - `user-invocable`
4. 避免使用不支持字段（例如 `allowed-tools`）。
5. 若技能依赖外部工具，建议先做工具可用性检查；缺失时给出安装/配置提示与 fallback 路径。

## 编写建议

- 步骤化、可执行，避免空泛描述。
- 在真正执行前先做依赖检查（工具、权限、认证状态）。
- 对运行时耦合较强的能力，采用条件化指令：
  - 在特定环境下执行专有步骤
  - 在通用环境下提供替代方案
- 如需强调主场景，可明确写明主要适配环境，并补一句兼容说明（例如：also works with other assistants）。

## Git

初始化仓库：

```bash
git init
```

按需重命名分支：

```bash
git branch -m main
```
