# reuseable-agents-and-skills

一个用于沉淀可复用 `skill` 与 `custom agent` 资产的仓库，适用于 VS Code / Copilot / Codex 等智能体工作流。

## 项目目标

集中管理可复用的智能体能力定义，便于跨项目复用、迭代和规范化维护，主要包括：
- `SKILL.md`（技能）
- 自定义 Agent 配置（custom agent）

## 目录结构

- `.agents/skills/`: 技能目录
- `.agents/skills/<skill-name>/SKILL.md`: 技能主定义和执行说明
- `.agents/skills/<skill-name>/references/`（可选）: 技能引用文档
- `.agents/skills/<skill-name>/scripts/`（可选）: 技能辅助脚本
- `.agents/agents/`（如存在）: custom agent 定义目录
- `.agents/agents/<agent-name>/`（如存在）: 单个 custom agent 的配置与提示词

## Skill 列表（当前仓库）

| 序号 | Skill | 简要说明 |
|---|---|---|
| 1 | `algorithmic-art` | 基于 p5.js 的算法艺术生成与交互参数探索。 |
| 2 | `az-cost-optimize` | 分析 Azure 资源成本并生成优化建议与跟踪事项。 |
| 3 | `azure-deployment-preflight` | Azure Bicep 部署前校验（语法、what-if、权限）。 |
| 4 | `azure-pricing` | 查询 Azure 实时零售价格并做成本估算。 |
| 5 | `azure-role-selector` | 基于最小权限原则选择 Azure 角色并生成赋权方案。 |
| 6 | `canvas-design` | 生成视觉设计产物（如 PNG/PDF）与设计哲学。 |
| 7 | `doc-coauthoring` | 文档共创流程（上下文收集、迭代、读者测试）。 |
| 8 | `docx` | Word 文档创建、编辑与内容处理。 |
| 9 | `frontend-design` | 高质量前端界面设计与实现。 |
| 10 | `jupyter-notebook` | Jupyter Notebook 脚手架、重构与结构化编写。 |
| 11 | `mcp-builder` | MCP Server 设计与实现指导。 |
| 12 | `pdf` | PDF 读写、拆分合并、OCR、水印与表单处理。 |
| 13 | `playwright` | 基于 CLI 的浏览器自动化与页面交互。 |
| 14 | `playwright-interactive` | 通过持久会话进行交互式 UI 调试。 |
| 15 | `pptx` | 幻灯片创建、编辑、解析与重组。 |
| 16 | `sql-code-review` | SQL 安全性、可维护性与质量审查。 |
| 17 | `sql-optimization` | SQL 性能优化与索引/查询调优。 |
| 18 | `theme-factory` | 为文档/页面/演示应用主题与视觉风格。 |
| 19 | `web-artifacts-builder` | 构建复杂 HTML 前端 artifacts（React/Tailwind/shadcn）。 |
| 20 | `xlsx` | 电子表格文件（xlsx/csv/tsv）处理与生成。 |

## Custom Agent 列表（当前仓库）

当前仓库中的 custom agent 位于 `.github/agents/`：

| 序号 | Agent | 简要说明 |
|---|---|---|
| 1 | `code-review-and-planning` | 仓库只读审查与规划，输出中文审查报告和待办清单。 |
| 2 | `high-risk-secret-scan` | 高危 secrets 静态扫描，输出脱敏风险报告。 |

## 使用方式

1. 在 `.agents/skills/<skill-name>/SKILL.md` 新增或更新技能。
2. 在 custom agent 目录中维护对应 agent 的定义文件（按你的实际规范放置）。
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
