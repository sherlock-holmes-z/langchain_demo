# LangChain Demo

这是一个独立的 LangChain 学习仓库。项目固定使用 Python 3.12 和 LangChain 1.4.0，实验代码先在
Notebook 中验证，可复用逻辑再沉淀到 `src/langchain_demo`，测试统一放入 `tests`。

## 环境职责

- Conda：创建并管理完整的 Python 3.12 项目环境。
- `environment.yml`：固定运行依赖和开发工具版本。
- `pyproject.toml`：声明项目的直接依赖和开发工具。
- `.env`：仅保存本机密钥，不进入 Git。
- `.env.example`：记录团队需要配置的变量名称和非敏感默认值。

详细说明见 [环境与配置说明](docs/environment.md)。

## 首次初始化

需要提前安装 Miniconda 或 Anaconda，并保证 PowerShell 中可以执行 `conda`。

```powershell
Set-Location langchain_demo
Copy-Item .env.example .env
.\scripts\bootstrap.ps1
conda activate langchain-demo
```

随后在 `.env` 中填写自己的 `DEEPSEEK_API_KEY`。初始化脚本会：

1. 创建或更新 `langchain-demo` Conda 环境；
2. 按照 `environment.yml` 安装项目和开发依赖；
3. 注册名为 `langchain-demo` 的 Jupyter Kernel。

## 日常验证

```powershell
conda activate langchain-demo
ruff format --check .
ruff check .
mypy
pytest
```

这些检查不会调用真实模型 API，也不会产生模型费用。

## 项目结构

```text
langchain_demo/
├── docs/                       # 环境说明和重要设计决策
├── notebooks/                  # 按学习主题组织的交互式实验
├── scripts/                    # 环境初始化脚本
├── src/langchain_demo/         # 可复用的正式 Python 代码
├── tests/                      # 不依赖真实外部服务的自动化测试
├── .env.example               # 环境变量模板
├── environment.yml            # Conda 环境与依赖定义
└── pyproject.toml             # 项目元数据和工具配置
```

## 学习代码约定

1. Notebook 只承担探索和讲解，不存放真实密钥。
2. 成熟逻辑迁移到 `src/langchain_demo` 后补充测试。
3. 默认不提交 Notebook 执行输出，避免错误日志、机器路径和大对象污染 Git。
4. 测试默认禁止真实 API 调用；需要在线测试时必须显式执行并控制费用。
